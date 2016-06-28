unit Behavior3.Decorators.Limiter;

interface

uses
  Behavior3, Behavior3.Core.Decorator, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
 (**
   * This decorator limit the number of times its child can be called. After a
   * certain number of times, the Limiter decorator returns `FAILURE` without
   * executing the child.
   *
   * @module b3
   * @class Limiter
   * @extends Decorator
  **)
  TB3Limiter = class(TB3Decorator)
  private
  protected
  public
    MaxLoop: Integer;
    constructor Create; override;
    (**
     * Open method.
     * @method open
     * @param {Tick} tick A tick instance.
    **)
    procedure Open(Tick: TB3Tick); override;
   (**
     * Tick method.
     * @method tick
     * @param {Tick} tick A tick instance.
     * @return {Constant} A state constant.
    **)
    function Tick(Tick: TB3Tick): TB3Status; override;
  end;

implementation

{ TB3Limiter }

uses
  Behavior3.NodeTypes,Behavior3.Helper;

constructor TB3Limiter.Create;
begin
  inherited;
  (**
     * Node name. Default to `Limiter`.
     * @property {String} name
     * @readonly
    **)
  Name := 'Limiter';

   (**
     * Node title. Default to `Limit X Activations`. Used in Editor.
     * @property {String} title
     * @readonly
    **)
  Title := 'Limit <maxLoop> Activations';

   (**
     * Node parameters.
     * @property {String} parameters
     * @readonly
    **)
  Properties.Add('maxLoop', 1);
  MaxLoop := 1;
end;

procedure TB3Limiter.Open(Tick: TB3Tick);
begin
  Tick.Blackboard.&Set('i', 0, Tick.Tree.Id, Id);
end;

function TB3Limiter.Tick(Tick: TB3Tick): TB3Status;
var
  I: Integer;
  Status: TB3Status;
begin
  if not Assigned(Child) then
  begin
    Result := Behavior3.Error;
    Exit;
  end;

  I := Tick.Blackboard.Get('i', Tick.tree.id, Id).AsInteger;

  if I < MaxLoop then
  begin
    Status := Child._Execute(Tick);
    if (Status = Behavior3.Success) or (Status = Behavior3.Failure) then
      Tick.Blackboard.&Set('i', I + 1, Tick.Tree.Id, Id);
    Result := Status;
  end
  else
    Result := Behavior3.Failure;
end;

initialization
  Behavior3NodeTypes.Add(TB3Limiter);
end.
