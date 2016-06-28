unit Behavior3.Core.Decorator;

interface

uses
  System.JSON,
  Behavior3, Behavior3.Core.BaseNode;

type
  (**
   * Decorator is the base class for all decorator nodes. Thus, if you want to
   * create new custom decorator nodes, you need to inherit from this class.
   *
   * When creating decorator nodes, you will need to propagate the tick signal
   * to the child node manually, just like the composite nodes. To do that,
   * override the `tick` method and call the `_execute` method on the child
   * node. For instance, take a look at how the Inverter node inherit this
   * class and how it call its children:
   *
   *     // Inherit from Decorator, using the util function Class.
   *     var Inverter = b3.Class(b3.Decorator, {
   *       name: 'Inverter',
   *
   *       tick: function(tick) {
   *         if (!this.child) {
   *           return b3.ERROR;
   *         }
   *
   *         // Propagate the tick
   *         var status = this.child._execute(tick);
   *
   *         if (status == b3.SUCCESS) {
   *           status = b3.FAILURE;
   *         } else if (status == b3.FAILURE) {
   *           status = b3.SUCCESS;
   *         }
   *
   *         return status;
   *       }
   *     });
   *
   * @module b3
   * @class Decorator
   * @extends BaseNode
  **)
  TB3Decorator = class(TB3BaseNode)
  private
  protected
    Child: TB3BaseNode;
  public
    constructor Create; override;
    constructor Create(ChildNode: TB3BaseNode); overload;
    procedure Load(JsonNode: TJSONValue); override;
  end;

implementation

{ TB3Decorator }

uses
  Behavior3.Helper;

constructor TB3Decorator.Create;
begin
  inherited Create;
    (**
     * Node category. Default to b3.DECORATOR.
     * @property {String} category
     * @readonly
    **)
  Category := Behavior3.Decorator;

    (**
     * Initialization method.
     * @method initialize
     * @constructor
    **)
end;

constructor TB3Decorator.Create(ChildNode: TB3BaseNode);
begin
  Child := ChildNode;
  Create;
{
//    initialize: function(params) {
      b3.BaseNode.prototype.initialize.call(this);
      this.child = params.child || null;
    }
end;


procedure TB3Decorator.Load(JsonNode: TJSONValue);
var
  ChildNode: String;
begin
  inherited;
  ChildNode := JsonNode.GetValue('child', '');
  if ChildNode = '' then
    Child := NIL
  else
    Child := Tree.Nodes[ChildNode];
end;

end.

