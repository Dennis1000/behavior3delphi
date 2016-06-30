{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Core.Tick;

interface

uses
  Behavior3.Core.Blackboard;

type
(**
 * A new Tick object is instantiated every tick by BehaviorTree. It is passed
 * as parameter to the nodes through the tree during the traversal.
 *
 * The role of the Tick class is to store the instances of tree, debug,
 * target and blackboard. So, all nodes can access these informations.
 *
 * For internal uses, the Tick also is useful to store the open node after
 * the tick signal, in order to let `BehaviorTree` to keep track and close
 * them when necessary.
 *
 * This class also makes a bridge between nodes and the debug, passing the
 * node state to the debug if the last is provided.
 *
 * @module b3
 * @class Tick
**)
  TB3Tick = class(TObject)
  public
    (**
     * The tree reference.
     * @property {b3.BehaviorTree} tree
     * @readOnly
    **)
    FTree: TObject; //use Behavior3.Helper to access Tree as TB3BehaviorTree

    (**
     * The debug reference.
     * @property {Object} debug
     * @readOnly
     **)
    Debug: TObject;

    (**
     * The target object reference.
     * @property {Object} target
     * @readOnly
    **)
    Target: TObject;

    (**
     * The blackboard reference.
     * @property {b3.Blackboard} blackboard
     * @readOnly
    **)
    Blackboard: TB3Blackboard;

    (**
     * The list of open nodes. Update during the tree traversal.
     * @property {Array} _openNodes
     * @protected
     * @readOnly
    **)
    F_OpenNodes: TObject; //use Behavior3.Helper to access _OpenNodesas TB3BaseNodeList

    (**
     * The number of nodes entered during the tick. Update during the tree
     * traversal.
     *
     * @property {Integer} _nodeCount
     * @protected
     * @readOnly
    **)
    _NodeCount: Integer;

    (**
     * Initialization method.
     * @method initialize
     * @constructor
    **)
    constructor Create; virtual;
    destructor Destroy; override;

    (**
     * Called when entering a node (called by BaseNode).
     * @method _enterNode
     * @param {Object} node The node that called this method.
     * @protected
    **)
    procedure _EnterNode(Node: TObject);

    (**
     * Callback when opening a node (called by BaseNode).
     * @method _openNode
     * @param {Object} node The node that called this method.
     * @protected
    **)
    procedure _OpenNode(Node: TObject);

    (**
     * Callback when ticking a node (called by BaseNode).
     * @method _tickNode
     * @param {Object} node The node that called this method.
     * @protected
    **)
    procedure _TickNode(Node: TObject);

    (**
     * Callback when closing a node (called by BaseNode).
     * @method _closeNode
     * @param {Object} node The node that called this method.
     * @protected
    **)
    procedure _CloseNode(Node: TObject);

    (**
     * Callback when exiting a node (called by BaseNode).
     * @method _exitNode
     * @param {Object} node The node that called this method.
     * @protected
    **)
    procedure _ExitNode(Node: TObject);
  end;

implementation

{ TB3Tick }

uses
  Behavior3.Helper, Behavior3.Core.BaseNode;

constructor TB3Tick.Create;
begin
  inherited;
  F_OpenNodes := TB3BaseNodeList.Create(False);
end;

destructor TB3Tick.Destroy;
begin
  _OpenNodes.Free;
  inherited;
end;


procedure TB3Tick._EnterNode(Node: TObject);
begin
  Inc(_NodeCount);
  _OpenNodes.Add(Node as TB3BaseNode);
  // TODO: call debug here
end;

procedure TB3Tick._OpenNode(Node: TObject);
begin
 // TODO: call debug here
end;

procedure TB3Tick._TickNode(Node: TObject);
begin
 // TODO: call debug here
end;


procedure TB3Tick._CloseNode(Node: TObject);
begin
  // TODO: call debug here
  _OpenNodes.Delete(_OpenNodes.Count - 1);
end;

procedure TB3Tick._ExitNode(Node: TObject);
begin
 // TODO: call debug here
end;



end.

