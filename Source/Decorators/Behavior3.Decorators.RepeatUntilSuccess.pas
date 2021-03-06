{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Decorators.RepeatUntilSuccess;

interface

uses
  System.JSON,
  Behavior3, Behavior3.Core.Decorator, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
  (**
   * RepeatUntilSuccess is a decorator that repeats the tick signal until the
   * node child returns `SUCCESS`, `RUNNING` or `ERROR`. Optionally, a maximum
   * number of repetitions can be defined.
   *
   * @module b3
   * @class RepeatUntilSuccess
   * @extends Decorator
  **)
  TB3RepeatUntilSuccess = class(TB3Decorator)
  private
  protected
  public
    // maxLoop** (*Integer*) Maximum number of repetitions. Default to -1 (infinite)
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

    procedure Load(JsonNode: TJSONValue); override;
  end;


implementation

{ TB3RepeatUntilSuccess }

uses
  Behavior3.Helper, Behavior3.Core.BehaviorTree;

constructor TB3RepeatUntilSuccess.Create;
begin
  inherited;
   (**
     * Node name. Default to `RepeatUntilSuccess`.
     * @property {String} name
     * @readonly
    **)
  Name := 'RepeatUntilSuccess';

   (**
     * Node title. Default to `Repeat Until Success`.
     * @property {String} title
     * @readonly
    **)
  Title := 'Repeat Until Success';

    (**
     * Node parameters.
     * @property {String} parameters
     * @readonly
    **)
  MaxLoop := -1;
end;

procedure TB3RepeatUntilSuccess.Open(Tick: TB3Tick);
begin
  Tick.Blackboard.&Set('i', 0, Tick.Tree.Id, Id);
end;

function TB3RepeatUntilSuccess.Tick(Tick: TB3Tick): TB3Status;
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
  Status := Behavior3.Error;

  while (MaxLoop < 0) or (I < MaxLoop)  do
  begin
    Status := Child._Execute(Tick);

    if Status = Behavior3.Failure then
      Inc(I)
    else
      Break;
  end;

  Tick.Blackboard.&Set('i', I, Tick.Tree.Id, Id);
  Result := Status;
end;

procedure TB3RepeatUntilSuccess.Load(JsonNode: TJSONValue);
begin
  inherited;
  MaxLoop := LoadProperty(JsonNode, 'maxLoop', MaxLoop);
end;


end.
