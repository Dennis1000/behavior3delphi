{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Core.Condition;

interface

uses
  Behavior3, Behavior3.Core.BaseNode;

type
(**
   * Condition is the base class for all condition nodes. Thus, if you want to
   * create new custom condition nodes, you need to inherit from this class.
   *
   * @class Condition
   * @extends BaseNode
  **)
  TB3Condition = class(TB3BaseNode)
  private
  protected
  public
    (**
     * Initialization method.
     * @method initialize
     * @constructor
    **)
    constructor Create; override;
  end;

implementation

{ TB3Condition }

constructor TB3Condition.Create;
begin
  inherited;
    (**
     * Node category. Default to `b3.CONDITION`.
     * @property {String} category
     * @readonly
    **)
  Category := Behavior3.Condition;
end;

end.


