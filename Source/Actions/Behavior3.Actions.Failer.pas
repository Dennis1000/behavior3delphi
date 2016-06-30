{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Actions.Failer;

interface

uses
  Behavior3, Behavior3.Core.Action, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
 (**
   * This action node returns `FAILURE` always.
   *
   * @module b3
   * @class Failer
   * @extends Action
  **)
  TB3Failer = class(TB3Action)
  public
    constructor Create; override;
    (**
     * Tick method.
     * @method tick
     * @param {Tick} tick A tick instance.
     * @return {Constant} Always return `b3.FAILURE`.
       **)
    function Tick(Tick: TB3Tick): TB3Status; override;
  end;

implementation

{ TB3Failer }

constructor TB3Failer.Create;
begin
  inherited;
  (**
     * Node name. Default to `Failer`.
     * @property {String} name
     * @readonly
    **)
  Name := 'Failer';
end;

function TB3Failer.Tick(Tick: TB3Tick): TB3Status;
begin
  Result := Behavior3.Failure;
end;

end.
