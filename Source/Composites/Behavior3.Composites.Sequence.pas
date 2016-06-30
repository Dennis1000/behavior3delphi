{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Composites.Sequence;

interface

uses
  Behavior3, Behavior3.Core.Composite, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
  (**
   * The Sequence node ticks its children sequentially until one of them
   * returns `FAILURE`, `RUNNING` or `ERROR`. If all children return the
   * success state, the sequence also returns `SUCCESS`.
   *
   * @module b3
   * @class Sequence
   * @extends Composite
  **)
  TB3Sequence = class(TB3Composite)
  private
  protected
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

{ TB3Sequence }


uses
  Behavior3.Helper;

constructor TB3Sequence.Create;
begin
  inherited;
    (**
     * Node name. Default to `Sequence`.
     * @property {String} name
     * @readonly
    **)
    Name := 'Sequence';
end;


function TB3Sequence.Tick(Tick: TB3Tick): TB3Status;
var
  Child: TB3BaseNode;
  Status: TB3Status;
begin
  for Child in Children do
  begin
    Status := Child._Execute(Tick);

    if Status <> Behavior3.Success then
    begin
      Result := Status;
      Exit;
    end;
  end;

  Result := Behavior3.Success;
end;

end.

