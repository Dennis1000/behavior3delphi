{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Actions.Wait;

interface

uses
  System.JSON,
  Behavior3, Behavior3.Core.Action, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
 (**
   * Wait a few seconds.
   *
   * @module b3
   * @class Wait
   * @extends Action
  **)
  TB3Wait = class(TB3Action)
  private
  protected
  public
     //* - **milliseconds** (*Integer*) Maximum time, in milliseconds, a child
     //*                                can execute.
    Milliseconds: Integer;

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
     * @return {Constant} Always return `b3.SUCCESS`.
     **)
    function Tick(Tick: TB3Tick): TB3Status; override;

    procedure Load(JsonNode: TJSONValue); override;
  end;

implementation

{ TB3Wait }

uses
  System.SysUtils, System.Diagnostics, System.TimeSpan,
  Behavior3.Helper, Behavior3.Core.BehaviorTree;

constructor TB3Wait.Create;
begin
  inherited;
  (**
   * Node name. Default to `Wait`.
   * @property {String} name
   * @readonly
  **)
  Name := 'Wait';

  (**
   * Node title. Default to `Wait XXms`. Used in Editor.
   * @property {String} title
   * @readonly
  **)
  Title := 'Wait <milliseconds>ms';
  Milliseconds := 0;
end;


procedure TB3Wait.Open(Tick: TB3Tick);
begin
  Tick.Blackboard.&Set('startTime', TStopWatch.GetTimeStamp, Tick.Tree.Id, Id);
end;

function TB3Wait.Tick(Tick: TB3Tick): TB3Status;
var
  ElapsedTime, CurrTime, StartTime: Int64;
begin
  CurrTime := TStopWatch.GetTimeStamp;
  StartTime := Tick.Blackboard.Get('startTime', Tick.Tree.Id, Id).AsInt64;
  ElapsedTime := (CurrTime - StartTime) div TTimeSpan.TicksPerMillisecond;

  if ElapsedTime > Milliseconds then
    Result := Behavior3.Success
  else
    Result := Behavior3.Running;
end;

procedure TB3Wait.Load(JsonNode: TJSONValue);
begin
  inherited;
  Milliseconds := LoadProperty(JsonNode, 'milliseconds', Milliseconds);
end;

end.
