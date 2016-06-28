unit Behavior3.Actions.Succeeder;

interface

uses
  Behavior3, Behavior3.Core.Action, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
 (**
   * This action node returns `SUCCESS` always.
   *
   * @module b3
   * @class Error
   * @extends Action
  **)
  TB3Succeeder = class(TB3Action)
  private
  protected
  public
    constructor Create; override;
    (**
     * Tick method.
     * @method tick
     * @param {Tick} tick A tick instance.
     * @return {Constant} Always return `b3.SUCCESS`.
     **)
    function Tick(Tick: TB3Tick): TB3Status; override;
  end;

implementation

{ TB3Succeeder }

uses
  Behavior3.NodeTypes;

constructor TB3Succeeder.Create;
begin
  inherited;
  (**
     * Node name. Default to `Succeeder`.
     * @property {String} name
     * @readonly
    **)
  Name := 'Succeeder';
end;

function TB3Succeeder.Tick(Tick: TB3Tick): TB3Status;
begin
  Result := Behavior3.SUCCESS;
end;

initialization
  Behavior3NodeTypes.Add(TB3Succeeder);
end.
