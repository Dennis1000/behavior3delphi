unit Behavior3.Actions.Error;

interface

uses
  Behavior3, Behavior3.Core.Action, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
 (**
   * This action node returns `ERROR` always.
   *
   * @module b3
   * @class Error
   * @extends Action
  **)
  TB3Error = class(TB3Action)
  public
    constructor Create; override;
    (**
     * Tick method.
     * @method tick
     * @param {Tick} tick A tick instance.
     * @return {Constant} Always return `b3.ERROR`.
     **)
    function Tick(Tick: TB3Tick): TB3Status; override;
  end;

implementation

{ TB3Error }

constructor TB3Error.Create;
begin
  inherited;
  (**
     * Node name. Default to `Error`.
     * @property {String} name
     * @readonly
    **)
  Name := 'Error';
end;

function TB3Error.Tick(Tick: TB3Tick): TB3Status;
begin
  Result := Behavior3.Error;
end;

end.
