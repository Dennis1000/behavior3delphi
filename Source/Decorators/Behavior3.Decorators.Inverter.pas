unit Behavior3.Decorators.Inverter;

interface

uses
  Behavior3, Behavior3.Core.Decorator, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
  TB3Inverter = class(TB3Decorator)
  public
    constructor Create; override;
    (**
     * Tick method.
     * @method tick
     * @param {Tick} tick A tick instance.
     * @return {Constant} A state constant.
    **)
    function Tick(Tick: TB3Tick): TB3Status; override;
  end;

implementation

{ TB3Inverter }

constructor TB3Inverter.Create;
begin
  inherited;
  (**
     * Node name. Default to `Inverter`.
     * @property {String} name
     * @readonly
    **)
  Name := 'Inverter';
end;


function TB3Inverter.Tick(Tick: TB3Tick): TB3Status;
var
  Status: TB3Status;
begin
  if not Assigned(Child) then
  begin
    Result := Behavior3.Error;
    Exit;
  end;

  Status := Child._Execute(Tick);

  if Status = Behavior3.Success then
    Status := Behavior3.Failure
  else
  if Status = Behavior3.Failure then
    Status := Behavior3.Success;

  Result := Status;
end;

end.
