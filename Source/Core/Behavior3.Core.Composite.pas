{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Core.Composite;

interface

uses
  System.JSON,
  Behavior3, Behavior3.Core.BaseNode;

type
(**
   * Composite is the base class for all composite nodes. Thus, if you want to
   * create new custom composite nodes, you need to inherit from this class.
   *
   * When creating composite nodes, you will need to propagate the tick signal
   * to the children nodes manually. To do that, override the `tick` method and
   * call the `_execute` method on all nodes. For instance, take a look at how
   * the Sequence node inherit this class and how it call its children:
   *
   *     // Inherit from Composite, using the util function Class.
   *     var Sequence = b3.Class(b3.Composite, {
   *
   *       // Remember to set the name of the node.
   *       name: 'Sequence',
   *
   *       // Override the tick function
   *       tick: function(tick) {
   *
   *         // Iterates over the children
   *         for (var i=0; i<this.children.length; i++) {
   *
   *           // Propagate the tick
   *           var status = this.children[i]._execute(tick);
   *
   *           if (status !== b3.SUCCESS) {
   *               return status;
   *           }
   *         }
   *
   *         return b3.SUCCESS;
   *       }
   *     });
   *
   * @module b3
   * @class Composite
   * @extends BaseNode
  **)
  TB3Composite = class(TB3BaseNode)
  private
  protected
  public
    Children: TB3BaseNodeList;

    (**
     * Initialization method.
     *
     * @method initialize
     * @constructor
    **)
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(JsonNode: TJSONValue); override;
  end;

implementation

{ TB3Composite }

uses
  Behavior3.Helper, Behavior3.Core.BehaviorTree;

constructor TB3Composite.Create;
begin
  inherited;
  (**
     * Node category. Default to `b3.COMPOSITE`.
     *
     * @property category
     * @type {String}
     * @readonly
    **)
  Category := Behavior3.Composite;
  Children := TB3BaseNodeList.Create(False);
end;


destructor TB3Composite.Destroy;
begin
  Children.Free;
  inherited;
end;

procedure TB3Composite.Load(JsonNode: TJSONValue);
var
  JsonNodes: TJSONArray;
  JsonNodeObj: TJSONValue;
  Child: String;
begin
  inherited;
  JsonNodes := TJSONArray(TJSONObject(JsonNode).Get('children').JsonValue);
  for JsonNodeObj in JsonNodes do
  begin
    Child := JsonNodeObj.Value;
    Children.Add(Tree.Nodes[Child]);
  end;
end;

end.


