unit Behavior3.Decorators.MaxTime;

interface

uses
  System.JSON,
  Behavior3, Behavior3.Core.Decorator, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
 (**
   * The MaxTime decorator limits the maximum time the node child can execute.
   * Notice that it does not interrupt the execution itself (i.e., the child
   * must be non-preemptive), it only interrupts the node after a `RUNNING`
   * status.
   *
   * @module b3
   * @class MaxTime
   * @extends Decorator
  **)
  TB3MaxTime = class(TB3Decorator)
  private
  protected
  public
    MaxTime: Integer;
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

{ TB3MaxTime }

uses
  System.SysUtils, System.Diagnostics, System.TimeSpan,
  Behavior3.Helper, Behavior3.Core.BehaviorTree;

constructor TB3MaxTime.Create;
begin
  inherited;
  (**
     * Node name. Default to `MaxTime`.
     * @property {String} name
     * @readonly
    **)
  Name := 'MaxTime';

   (**
     * Node title. Default to `Max XXms`. Used in Editor.
     * @property {String} title
     * @readonly
    **)
  Title := 'Max <maxTime>ms';
end;


procedure TB3MaxTime.Open(Tick: TB3Tick);
begin
  Tick.Blackboard.&Set('startTime', TStopWatch.GetTimeStamp, Tick.Tree.Id, Id);
end;

function TB3MaxTime.Tick(Tick: TB3Tick): TB3Status;
var
  ElapsedTime, CurrTime, StartTime: Int64;
  Status: TB3Status;
begin
  if not Assigned(Child) then
  begin
    Result := Behavior3.Error;
    Exit;
  end;

  StartTime := Tick.Blackboard.Get('startTime', Tick.Tree.Id, Id).AsInt64;
  CurrTime := TStopWatch.GetTimeStamp;
  ElapsedTime := (CurrTime - StartTime) div TTimeSpan.TicksPerMillisecond;

  Status := Child._Execute(Tick);
  if ElapsedTime > MaxTime then
    Result := Behavior3.Failure
  else
    Result := Status;
end;

procedure TB3MaxTime.Load(JsonNode: TJSONValue);
begin
  inherited;
  MaxTime := LoadProperty(JsonNode, 'maxTime', MaxTime);
end;

end.
