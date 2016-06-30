{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Composites.Priority;

interface

uses
  Behavior3, Behavior3.Core.Composite, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type

  (**
   * Priority ticks its children sequentially until one of them returns
   * `SUCCESS`, `RUNNING` or `ERROR`. If all children return the failure state,
   * the priority also returns `FAILURE`.
   *
   * @module b3
   * @class Priority
   * @extends Composite
  **)
  TB3Priority = class(TB3Composite)
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

{ TB3Priority }


uses
  Behavior3.Helper;

constructor TB3Priority.Create;
begin
  inherited;
    (**
     * Node name. Default to `Priority`.
     * @property {String} name
     * @readonly
    **)
    Name := 'Priority';
end;


function TB3Priority.Tick(Tick: TB3Tick): TB3Status;
var
  Child: TB3BaseNode;
  Status: TB3Status;
begin
  for Child in Children do
  begin
    Status := Child._Execute(Tick);

    if Status <> Behavior3.Failure then
    begin
      Result := Status;
      Exit;
    end;
  end;

  Result := Behavior3.Failure;
end;

end.

