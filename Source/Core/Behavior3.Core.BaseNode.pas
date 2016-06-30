{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Core.BaseNode;

interface

uses
  System.Rtti, System.JSON, System.Generics.Collections, System.Generics.Defaults,
  Behavior3, Behavior3.Core.Tick, Behavior3.Core.BehaviorTree;

type
  (**
   * The BaseNode class is used as super class to all nodes in BehaviorJS. It
   * comprises all common variables and methods that a node must have to
   * execute.
   *
   * **IMPORTANT:** Do not inherit from this class, use `b3.Composite`,
   * `b3.Decorator`, `b3.Action` or `b3.Condition`, instead.
   *
   * The attributes are specially designed to serialization of the node in a
   * JSON format. In special, the `parameters` attribute can be set into the
   * visual editor (thus, in the JSON file), and it will be used as parameter
   * on the node initialization at `BehaviorTree.load`.
   *
   * BaseNode also provide 5 callback methods, which the node implementations
   * can override. They are `enter`, `open`, `tick`, `close` and `exit`. See
   * their documentation to know more. These callbacks are called inside the
   * `_execute` method, which is called in the tree traversal.
   *
   * @module b3
   * @class BaseNode
  **)
  TB3BaseNode = class abstract (TObject)
  protected
    function LoadProperty<T>(JsonNode: TJSONValue; const Key: String; Default: T): T;
    procedure SaveProperty<T>(JsonNode: TJSONValue; const Key: String; Value: T);
  public
    (**
     * This is the main method to propagate the tick signal to this node. This
     * method calls all callbacks: `enter`, `open`, `tick`, `close`, and
     * `exit`. It only opens a node if it is not already open. In the same
     * way, this method only close a node if the node  returned a status
     * different of `b3.RUNNING`.
     *
     * @method _execute
     * @param {Tick} tick A tick instance.
     * @return {Constant} The tick state.
     * @protected
    **)
    function _Execute(Tick: TB3Tick): TB3Status; virtual;

    (**
     * Wrapper for enter method.
     * @method _enter
     * @param {Tick} tick A tick instance.
     * @protected
    **)
    procedure _Enter(Tick: TB3Tick); virtual;

    (**
     * Wrapper for open method.
     * @method _open
     * @param {Tick} tick A tick instance.
     * @protected
    **)
    procedure _Open(Tick: TB3Tick); virtual;

    (**
     * Wrapper for tick method.
     * @method _tick
     * @param {Tick} tick A tick instance.
     * @return {Constant} A state constant.
     * @protected
    **)
    function _Tick(Tick: TB3Tick): TB3Status; virtual;

    (**
     * Wrapper for close method.
     * @method _close
     * @param {Tick} tick A tick instance.
     * @protected
    **)
    procedure _Close(Tick: TB3Tick); virtual;

    (**
     * Wrapper for exit method.
     * @method _exit
     * @param {Tick} tick A tick instance.
     * @protected
    **)
    procedure _Exit(Tick: TB3Tick); virtual;

  public
  (**
     * Node ID.
     * @property {string} id
     * @readonly
    **)
    Id: String;

    (**
     * Node name. Must be a unique identifier, preferable the same name of the
     * class. You have to set the node name in the prototype.
     *
     * @property {String} name
     * @readonly
    **)
    Name: String;

    (**
     * Node category. Must be `b3.COMPOSITE`, `b3.DECORATOR`, `b3.ACTION` or
     * `b3.CONDITION`. This is defined automatically be inheriting the
     * correspondent class.
     *
     * @property {CONSTANT} category
     * @readonly
    **)
    Category: TB3Category;

    (**
     * Node title.
     * @property {String} title
     * @optional
     * @readonly
    **)
    Title: String;

    (**
     * Node description.
     * @property {String} description
     * @optional
     * @readonly
    **)
    Description: String;

    (**
     * Tree reference
     * @property {BehaviorTree} Tree
     * @readonly
    **)
    Tree: TB3BehaviorTree;

    (**
     * Initialization method.
     * @method initialize
     * @constructor
    **)
    constructor Create; overload; virtual;

    (**
     * Enter method, override this to use. It is called every time a node is
     * asked to execute, before the tick itself.
     *
     * @method enter
     * @param {Tick} tick A tick instance.
    **)
    procedure Enter(Tick: TB3Tick); virtual;

    (**
     * Open method, override this to use. It is called only before the tick
     * callback and only if the not isn't closed.
     *
     * Note: a node will be closed if it returned `b3.RUNNING` in the tick.
     *
     * @method open
     * @param {Tick} tick A tick instance.
    **)
    procedure Open(Tick: TB3Tick); virtual;

    (**
     * Tick method, override this to use. This method must contain the real
     * execution of node (perform a task, call children, etc.). It is called
     * every time a node is asked to execute.
     *
     * @method tick
     * @param {Tick} tick A tick instance.
    **)
    function Tick(Tick: TB3Tick): TB3Status; virtual;

    (**
     * Close method, override this to use. This method is called after the tick
     * callback, and only if the tick return a state different from
     * `b3.RUNNING`.
     *
     * @method close
     * @param {Tick} tick A tick instance.
    **)
    procedure Close(Tick: TB3Tick); virtual;

    (**
     * Exit method, override this to use. Called every time in the end of the
     * execution.
     *
     * @method exit
     * @param {Tick} tick A tick instance.
    **)
    procedure Exit_(Tick: TB3Tick); virtual;

    procedure Load(JsonNode: TJSONValue); overload; virtual;
    procedure Save(JsonObject: TJSONObject); overload; virtual;
  end;

  TB3BaseNodeClass = class of TB3BaseNode;
  TB3BaseNodeList = TObjectList<TB3BaseNode>;
  TB3BaseNodeDictionary = TObjectDictionary<String, TB3BaseNode>;
  TB3BaseNodeDictionaryItem = TPair<String, TB3BaseNode>;

implementation

{ TB3BaseNode }

uses
  System.SysUtils,
  Behavior3.Helper;

constructor TB3BaseNode.Create;
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  Id := GUID.ToString;
end;

function TB3BaseNode._Execute(Tick: TB3Tick): TB3Status;
var
  Status: TB3Status;
begin
  // ENTER
  _Enter(Tick);

  // OPEN
  if Tick.Blackboard.Get('isOpen', Tick.Tree.Id, Id).IsEmpty then
    _Open(Tick);

  // TICK
  Status := _Tick(Tick);

  // CLOSE
  if Status <> Behavior3.Running then
    _Close(Tick);

  // EXIT
  _Exit(Tick);

  Result := Status;
end;

procedure TB3BaseNode._Enter(Tick: TB3Tick);
begin
  Tick._EnterNode(Self);
  Enter(Tick);
end;

procedure TB3BaseNode._Open(Tick: TB3Tick);
begin
  Tick._OpenNode(Self);
  Tick.Blackboard.&Set('isOpen', True, Tick.Tree.Id, Id);
  Open(Tick);
end;

function TB3BaseNode._Tick(Tick: TB3Tick): TB3Status;
begin
  Tick._TickNode(self);
  Result := Self.Tick(Tick);
end;

procedure TB3BaseNode._Close(Tick: TB3Tick);
begin
  Tick._CloseNode(Self);
  Tick.Blackboard.&Set('isOpen', False, Tick.Tree.Id, Id);
  Close(Tick);
end;

procedure TB3BaseNode._Exit(Tick: TB3Tick);
begin
  Tick._ExitNode(Self);
  Exit_(Tick);
end;

procedure TB3BaseNode.Enter(Tick: TB3Tick);
begin
  // Enter method, override this to use. It is called every time a node is
  // asked to execute, before the tick itself.
end;

procedure TB3BaseNode.Open(Tick: TB3Tick);
begin
  // Open method, override this to use. It is called only before the tick
  // callback and only if the not isn't closed.
  // Note: a node will be closed if it returned `b3.RUNNING` in the tick.
end;


function TB3BaseNode.Tick(Tick: TB3Tick): TB3Status;
begin
  // Tick method, override this to use. This method must contain the real
  // execution of node (perform a task, call children, etc.). It is called
  // every time a node is asked to execute.
  Result := Behavior3.Error;
end;

procedure TB3BaseNode.Close(Tick: TB3Tick);
begin
  // Close method, override this to use. This method is called after the tick
  // callback, and only if the tick return a state different from
  // `b3.RUNNING`.
end;

procedure TB3BaseNode.Exit_(Tick: TB3Tick);
begin
  // Exit method, override this to use. Called every time in the end of the
  // execution.
end;


function TB3BaseNode.LoadProperty<T>(JsonNode: TJSONValue; const Key: String; Default: T): T;
var
  JsonObj: TJSONObject;
begin
  JsonObj := TJSONObject(JsonNode).Get('properties').JsonValue as TJSONObject;
  Result := JsonObj.GetValue(Key, Default);
end;

procedure TB3BaseNode.SaveProperty<T>(JsonNode: TJSONValue; const Key: String; Value: T);
var
  JsonObj: TJSONObject;
begin
  JsonObj := TJSONObject(JsonNode).Get('properties').JsonValue as TJSONObject;
//  JsonObj.AddPair(Key, Default);
end;

procedure TB3BaseNode.Load(JsonNode: TJSONValue);
begin
  Name := JsonNode.GetValue('name', Name);
  Id := JsonNode.GetValue('id', Id);
  Description := JsonNode.GetValue('description', Description);
  Title := JsonNode.GetValue('title', Title);
end;

procedure TB3BaseNode.Save(JsonObject: TJSONObject);
begin
  JsonObject.AddPair('name', Name);
  JsonObject.AddPair('id', Id);
  JsonObject.AddPair('description', Description);
  JsonObject.AddPair('title', Title);
end;


end.
