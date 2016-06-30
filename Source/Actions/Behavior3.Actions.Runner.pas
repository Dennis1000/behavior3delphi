{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Actions.Runner;

interface

uses
  Behavior3, Behavior3.Core.Action, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
 (**
   * This action node returns RUNNING always.
   *
   * @module b3
   * @class Error
   * @extends Action
  **)
  TB3Runner = class(TB3Action)
  public
    constructor Create; override;
    (**
     * Tick method.
     * @method tick
     * @param {Tick} tick A tick instance.
     * @return {Constant} Always return `b3.RUNNING`.
     **)
    function Tick(Tick: TB3Tick): TB3Status; override;
  end;

implementation

{ TB3Runner }

constructor TB3Runner.Create;
begin
  inherited;
  (**
     * Node name. Default to `Runner`.
     * @property {String} name
     * @readonly
    **)
  Name := 'Runner';
end;

function TB3Runner.Tick(Tick: TB3Tick): TB3Status;
begin
  Result := Behavior3.Running;
end;

end.
