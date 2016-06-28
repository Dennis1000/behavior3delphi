unit Behavior3.Core.Action;

interface

uses
  Behavior3, Behavior3.Core.BaseNode;

type
  (**
   * Action is the base class for all action nodes. Thus, if you want to create
   * new custom action nodes, you need to inherit from this class. For example,
   * take a look at the Runner action:
   *
   *     var Runner = b3.Class(b3.Action, {
   *       name: 'Runner',
   *
   *       tick: function(tick) {
   *         return b3.RUNNING;
   *       }
   *     });
   *
   * @module b3
   * @class Action
   * @extends BaseNode
  **)
  TB3Action = class abstract (TB3BaseNode)
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

{ TB3Action }

constructor TB3Action.Create;
begin
  inherited;
  (**
     * Node category. Default to `b3.ACTION`.
     * @property {String} category
     * @readonly
    **)
  Category := Behavior3.Action;
end;


end.
