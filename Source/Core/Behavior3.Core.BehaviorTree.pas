unit Behavior3.Core.BehaviorTree;

interface

uses
  System.Generics.Collections, System.Generics.Defaults, System.JSON,
  Behavior3, Behavior3.Core.Tick, Behavior3.Core.Blackboard;

type
(**
   * The BehaviorTree class, as the name implies, represents the Behavior Tree
   * structure.
   *
   * There are two ways to construct a Behavior Tree: by manually setting the
   * root node, or by loading it from a data structure (which can be loaded
   * from a JSON). Both methods are shown in the examples below and better
   * explained in the user guide.
   *
   * The tick method must be called periodically, in order to send the tick
   * signal to all nodes in the tree, starting from the root. The method
   * `BehaviorTree.tick` receives a target object and a blackboard as
   * parameters. The target object can be anything: a game agent, a system, a
   * DOM object, etc. This target is not used by any piece of Behavior3JS,
   * i.e., the target object will only be used by custom nodes.
   *
   * The blackboard is obligatory and must be an instance of `Blackboard`. This
   * requirement is necessary due to the fact that neither `BehaviorTree` or
   * any node will store the execution variables in its own object (e.g., the
   * BT does not store the target, information about opened nodes or number of
   * times the tree was called). But because of this, you only need a single
   * tree instance to control multiple (maybe hundreds) objects.
   *
   * Manual construction of a Behavior Tree
   * --------------------------------------
   *
   *     var tree = new b3.BehaviorTree();
   *
   *     tree.root = new b3.Sequence({children:[
   *       new b3.Priority({children:[
   *         new MyCustomNode(),
   *         new MyCustomNode()
   *       ]}),
   *       ...
   *     ]});
   *
   *
   * Loading a Behavior Tree from data structure
   * -------------------------------------------
   *
   *     var tree = new b3.BehaviorTree();
   *
   *     tree.load({
   *       'title'       : 'Behavior Tree title'
   *       'description' : 'My description'
   *       'root'        : 'node-id-1'
   *       'nodes'       : {
   *         'node-id-1' : {
   *           'name'        : 'Priority', // this is the node type
   *           'title'       : 'Root Node',
   *           'description' : 'Description',
   *           'children'    : ['node-id-2', 'node-id-3'],
   *         },
   *         ...
   *       }
   *     })
   *
   *
   * @module b3
   * @class BehaviorTree
  **)
  TB3BehaviorTree = class(TObject)
  public
    (**
     * The tree id, must be unique. By default, created with `b3.createUUID`.
     * @property {String} id
     * @readOnly
    **)
    Id: String;

    (**
     * The tree title.
     * @property {String} title
     * @readonly
    **)
    Title: String;

    (**
     * Description of the tree.
     * @property {String} description
     * @readonly
    **)
    Description: String;

    (**
     * A dictionary with (key-value) properties. Useful to define custom
     * variables in the visual editor.
     *
     * @property {Object} properties
     * @readonly
    **)
    Properties: TDictionary<String, String>;

    (**
     * The reference to the root node. Must be an instance of `b3.BaseNode`.
     * @property {BaseNode} root
    **)
    FRoot: TObject; // Use Behavior3.Helper for accessing Root: TB3BaseNode;

    (**
     * The reference to the debug instance.
     * @property {Object} debug
    **)
    Debug: TObject;

    (**
     * A dictionary with nodes. Useful to during loading
     *
     * @property {Object} fnodes
     * @readonly
    **)
    FNodes: TObject; // Use Behavior3.Helper for accessing Nodes: TB3BaseNodeDictionary;

    (**
     * Initialization method.
     * @method initialize
     * @constructor
    **)
    constructor Create; virtual;
    destructor Destroy; override;

    (**
     * This method loads a Behavior Tree from a data structure, populating this
     * object with the provided data. Notice that, the data structure must
     * follow the format specified by Behavior3JS. Consult the guide to know
     * more about this format.
     *
     * You probably want to use custom nodes in your BTs, thus, you need to
     * provide the `names` object, in which this method can find the nodes by
     * `names[NODE_NAME]`. This variable can be a namespace or a dictionary,
     * as long as this method can find the node by its name, for example:
     *
     *     //json
     *     ...
     *     'node1': {
     *       'name': MyCustomNode,
     *       'title': ...
     *     }
     *     ...
     *
     *     //code
     *     var bt = new b3.BehaviorTree();
     *     bt.load(data, {'MyCustomNode':MyCustomNode})
     *
     *
     * @method load
     * @param {Object} data The data structure representing a Behavior Tree.
     * @param {Object} [names] A namespace or dict containing custom nodes.
    **)
    procedure Load (Data: String; NodeTypes: TObject);

    (**
     * This method dump the current BT into a data structure.
     *
     * Note: This method does not record the current node parameters. Thus,
     * it may not be compatible with load for now.
     *
     * @method dump
     * @return {Object} A data object representing this tree.
    **)
    function Dump: TObject;

    (**
     * Propagates the tick signal through the tree, starting from the root.
     *
     * This method receives a target object of any type (Object, Array,
     * DOMElement, whatever) and a `Blackboard` instance. The target object has
     * no use at all for all Behavior3JS components, but surely is important
     * for custom nodes. The blackboard instance is used by the tree and nodes
     * to store execution variables (e.g., last node running) and is obligatory
     * to be a `Blackboard` instance (or an object with the same interface).
     *
     * Internally, this method creates a Tick object, which will store the
     * target and the blackboard objects.
     *
     * Note: BehaviorTree stores a list of open nodes from last tick, if these
     * nodes weren't called after the current tick, this method will close them
     * automatically.
     *
     * @method tick
     * @param {Object} target A target object.
     * @param {Blackboard} blackboard An instance of blackboard object.
     * @return {Constant} The tick signal state.
    **)
    function Tick(Target: TObject; Blackboard: TB3Blackboard): TB3Status;
  end;

implementation

{ TB3BehaviorTree }

uses
  Behavior3.NodeTypes, Behavior3.Helper, Behavior3.Core.BaseNode,
  System.Math, System.SysUtils;

constructor TB3BehaviorTree.Create;
begin
  inherited;
  Nodes := TB3BaseNodeDictionary.Create([doOwnsValues]);
end;

destructor TB3BehaviorTree.Destroy;
begin
  Nodes.Free;
  inherited;
end;

function TB3BehaviorTree.Dump: TObject;
begin
   Result := NIL;
end;

procedure TB3BehaviorTree.Load(Data: String; NodeTypes: TObject);
var
  JsonTree: TJSONObject;
  JsonNodes: TJSONArray;
  JsonNode: TJSONValue;
  JsonNodeObj: TJSONValue;
  NodeName: String;
  Node: TB3BaseNode;
  NodeId: String;
begin
  Nodes.Clear;

  JsonTree := TJSONObject.ParseJSONValue(Data, False) as TJSONObject;
  try
    Id := JsonTree.GetValue('id', Id);
    Title := JsonTree.GetValue('title', Title);
    Description := JsonTree.GetValue('description', Description);

    // Create all nodes
    JsonNodes := TJSONArray(JsonTree.Get('nodes').JsonValue);
    for JsonNodeObj in JsonNodes do
    begin
      JsonNode := TJSONPair(JSonNodeObj).JsonValue;

      NodeName := JsonNode.GetValue('name', '');
      Node := Behavior3NodeTypes.CreateNode(NodeName);
      Node.Id := JsonNode.GetValue('id', '');
      Node.Tree := Self;
      Nodes.Add(Node.Id, Node);
    end;

    // Load and link nodes
    for JsonNodeObj in JsonNodes do
    begin
      JsonNode := TJSONPair(JSonNodeObj).JsonValue;
      NodeId := JsonNode.GetValue('id', '');
      Node := Nodes[NodeId];
      Node.Load(JsonNode);
    end;

    // Set root node
    Root := Nodes[JsonTree.GetValue('root', '')];

  finally
    JsonTree.Free;
  end;
end;

function TB3BehaviorTree.Tick(Target: TObject; Blackboard: TB3Blackboard): TB3Status;
var
  Tick: TB3Tick;
  State: TB3Status;
  CurrOpenNodes, LastOpenNodes: TB3BaseNodeList;
  Start, I: Integer;
begin
  if not Assigned(Blackboard) then
    raise EB3ParameterMissingException.Create('The blackboard parameter is obligatory and must be an ' +
      'instance of b3.Blackboard');

  if not Assigned(Root) then
    raise EB3RootMissingException.Create('Node root not defined');

  //* CREATE A TICK OBJECT */
  Tick := TB3Tick.Create;
  Tick.Debug := Self;
  Tick.Target := Target;
  Tick.Blackboard := Blackboard;
  Tick.Tree := Self;

  //* TICK NODE */
  State := Root._Execute(Tick);

  //* CLOSE NODES FROM LAST TICK, IF NEEDED */
  LastOpenNodes := TB3Blackboard(blackboard).Get('openNodes', Id).AsObject as TB3BaseNodeList;
  CurrOpenNodes := Tick._OpenNodes;

  // process only of there are LastOpenNodes
  if Assigned(LastOpenNodes) then
  begin
    // does not close if it is still open in this tick
    Start := 0;
    for I := 0 to Min(LastOpenNodes.Count, CurrOpenNodes.Count) - 1 do
    begin
      Start := I + 1;
      if LastOpenNodes[I] <> CurrOpenNodes[I] then
        break
    end;

    // close the nodes
    // for (i=lastOpenNodes.length-1; i>=start; i--) {
    for I := LastOpenNodes.Count - 1 downto Start do
      LastOpenNodes[I]._Close(Tick);

    // LastOpenNodes will be overwritten in the Blackboard by CurrOpenNodes
    LastOpenNodes.Free;
  end;

  //* POPULATE BLACKBOARD */
  TB3Blackboard(blackboard).&Set('openNodes', CurrOpenNodes, Id);
  TB3Blackboard(blackboard).&Set('nodeCount', Tick._NodeCount, Id);

  Result := State;
end;

end.

