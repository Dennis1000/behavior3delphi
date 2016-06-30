unit Behavior3.Composites.MemSequence;

interface


uses
  Behavior3, Behavior3.Core.Composite, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
  TB3MemSequence = class(TB3Composite)
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

{ TB3MemSequence }


uses
  Behavior3.Helper, Behavior3.Core.BehaviorTree;

constructor TB3MemSequence.Create;
begin
  inherited;
    (**
     * Node name. Default to `MemSequence`.
     * @property {String} name
     * @readonly
    **)
    Name := 'MemSequence';
end;


procedure TB3MemSequence.Open(Tick: TB3Tick);
begin
  Tick.Blackboard.&Set('runningChild', 0, Tick.Tree.Id, Id);
end;

function TB3MemSequence.Tick(Tick: TB3Tick): TB3Status;
var
  Child: Integer;
  I: Integer;
  Status: TB3Status;
begin
  Child := Tick.Blackboard.Get('runningChild', Tick.Tree.id, Id).AsInteger;
  for I := Child to Children.Count - 1 do
  begin
    Status := Children[I]._Execute(Tick);
    if Status <> Behavior3.Success then
    begin
      if (Status = Behavior3.Running) then
        Tick.Blackboard.&Set('runningChild', I, Tick.Tree.id, Id);

      Result := Status;
      Exit;
    end;
  end;

  Result := Behavior3.Success;
end;

end.
