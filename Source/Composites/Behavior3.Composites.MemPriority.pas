unit Behavior3.Composites.MemPriority;

interface

uses
  Behavior3, Behavior3.Core.Composite, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
 (**
   * MemPriority is similar to Priority node, but when a child returns a
   * `RUNNING` state, its index is recorded and in the next tick the,
   * MemPriority calls the child recorded directly, without calling previous
   * children again.
   *
   * @module b3
   * @class MemPriority
   * @extends Composite
  **)
  TB3MemPriority = class(TB3Composite)
  private
  protected
  public
    constructor Create; override;
    (**
     * Open method.
     * @method open
     * @param {b3.Tick} tick A tick instance.
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

{ TB3MemPriority }

uses
  Behavior3.NodeTypes, Behavior3.Helper;

constructor TB3MemPriority.Create;
begin
  inherited;
  (**
     * Node name. Default to `MemPriority`.
     * @property {String} name
     * @readonly
    **)
  Name := 'MemPriority';
end;

procedure TB3MemPriority.Open(Tick: TB3Tick);
begin
  Tick.Blackboard.&Set('runningChild', 0, Tick.Tree.Id, Id);
end;

function TB3MemPriority.Tick(Tick: TB3Tick): TB3Status;
var
  Child: Integer;
  I: Integer;
  Status: TB3Status;
begin
  Child := Tick.Blackboard.Get('runningChild', Tick.Tree.id, Id).AsInteger;
  for I := Child to Children.Count - 1 do
  begin
    Status := Children[I]._Execute(Tick);
    if Status <> Behavior3.Failure then
    begin
      if Status = Behavior3.Running then
        Tick.Blackboard.&Set('runningChild', I, Tick.Tree.id, Id);

      Result := Status;
      Exit;
    end;
  end;

  Result := Behavior3.Failure;
end;

initialization
  Behavior3NodeTypes.Add(TB3MemPriority);
end.
