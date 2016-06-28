unit Behavior3.Core.Blackboard;

interface

uses
  System.Rtti, System.Generics.Collections, System.Generics.Defaults;

type
  TB3BlackboardMemory = class(TObjectDictionary<String, TValue>)
  public
    destructor Destroy; override;
  end;

(**
   * The Blackboard is the memory structure required by `BehaviorTree` and its
   * nodes. It only have 2 public methods: `set` and `get`. These methods works
   * in 3 different contexts: global, per tree, and per node per tree.
   *
   * Suppose you have two different trees controlling a single object with a
   * single blackboard, then:
   *
   * - In the global context, all nodes will access the stored information.
   * - In per tree context, only nodes sharing the same tree share the stored
   *   information.
   * - In per node per tree context, the information stored in the blackboard
   *   can only be accessed by the same node that wrote the data.
   *
   * The context is selected indirectly by the parameters provided to these
   * methods, for example:
   *
   *     // getting/setting variable in global context
   *     blackboard.set('testKey', 'value');
   *     var value = blackboard.get('testKey');
   *
   *     // getting/setting variable in per tree context
   *     blackboard.set('testKey', 'value', tree.id);
   *     var value = blackboard.get('testKey', tree.id);
   *
   *     // getting/setting variable in per node per tree context
   *     blackboard.set('testKey', 'value', tree.id, node.id);
   *     var value = blackboard.get('testKey', tree.id, node.id);
   *
   * Note: Internally, the blackboard store these memories in different
   * objects, being the global on `_baseMemory`, the per tree on `_treeMemory`
   * and the per node per tree dynamically create inside the per tree memory
   * (it is accessed via `_treeMemory[id].nodeMemory`). Avoid to use these
   * variables manually, use `get` and `set` instead.
   *
   * @module b3
   * @class Blackboard
  **)
  TB3Blackboard = class(TObject)
  private
  protected
    _BaseMemory: TB3BlackboardMemory;
    _TreeMemory: TB3BlackboardMemory;

    (**
     * Internal method to retrieve the tree context memory. If the memory does
     * not exist, this method creates it.
     *
     * @method _getTreeMemory
     * @param {string} treeScope The id of the tree in scope.
     * @return {Object} The tree memory.
     * @protected
    **)
    function _getTreeMemory(const TreeScope: String): TB3BlackboardMemory;

    (**
     * Internal method to retrieve the node context memory, given the tree
     * memory. If the memory does not exist, this method creates is.
     *
     * @method _getNodeMemory
     * @param {String} treeMemory the tree memory.
     * @param {String} nodeScope The id of the node in scope.
     * @return {Object} The node memory.
     * @protected
    **)
    function _getNodeMemory(const TreeMemory: TB3BlackboardMemory; const NodeScope: String): TB3BlackboardMemory;

    (**
     * Internal method to retrieve the context memory. If treeScope and
     * nodeScope are provided, this method returns the per node per tree
     * memory. If only the treeScope is provided, it returns the per tree
     * memory. If no parameter is provided, it returns the global memory.
     * Notice that, if only nodeScope is provided, this method will still
     * return the global memory.
     *
     * @method _getMemory
     * @param {String} treeScope The id of the tree scope.
     * @param {String} nodeScope The id of the node scope.
     * @return {Object} A memory object.
     * @protected
    **)
    function _getMemory(const TreeScope, NodeScope: String): TB3BlackboardMemory;
  public
    (**
     * Initialization method.
     * @method initialize
     * @constructor
    **)
    constructor Create; virtual;
    destructor Destroy; override;

    (**
     * Stores a value in the blackboard. If treeScope and nodeScope are
     * provided, this method will save the value into the per node per tree
     * memory. If only the treeScope is provided, it will save the value into
     * the per tree memory. If no parameter is provided, this method will save
     * the value into the global memory. Notice that, if only nodeScope is
     * provided (but treeScope not), this method will still save the value into
     * the global memory.
     *
     * @method set
     * @param {String} key The key to be stored.
     * @param {String} value The value to be stored.
     * @param {String} treeScope The tree id if accessing the tree or node
     *                           memory.
     * @param {String} nodeScope The node id if accessing the node memory.
    **)
    procedure &Set(const Key: String; Value: TValue; TreeScope: String = ''; NodeScope: String = '');

    (**
     * Retrieves a value in the blackboard. If treeScope and nodeScope are
     * provided, this method will retrieve the value from the per node per tree
     * memory. If only the treeScope is provided, it will retrieve the value
     * from the per tree memory. If no parameter is provided, this method will
     * retrieve from the global memory. If only nodeScope is provided (but
     * treeScope not), this method will still try to retrieve from the global
     * memory.
     *
     * @method get
     * @param {String} key The key to be retrieved.
     * @param {String} treeScope The tree id if accessing the tree or node
     *                           memory.
     * @param {String} nodeScope The node id if accessing the node memory.
     * @return {Object} The value stored or undefined.
    **)
    function Get(const Key: String; TreeScope: String = ''; NodeScope: String =''): TValue;
  end;

implementation

{ TB3Blackboard }

uses
  System.SysUtils,
  Behavior3.Core.BaseNode;


constructor TB3Blackboard.Create;
begin
  inherited;
  _BaseMemory := TB3BlackboardMemory.Create;
  _TreeMemory := TB3BlackboardMemory.Create;
end;

destructor TB3Blackboard.Destroy;
begin
  _TreeMemory.Free;
  _BaseMemory.Free;
  inherited;
end;

function TB3Blackboard._GetTreeMemory(const TreeScope: String): TB3BlackboardMemory;
var
  Memory: TB3BlackboardMemory;
  Value: TValue;
begin
  if not _TreeMemory.TryGetValue(TreeScope, Value) then
  begin
    Memory := TB3BlackboardMemory.Create;
    Memory.Add('openNodes', TB3BaseNodeList.Create(False));
    Memory.Add('nodeMemory', TB3BlackboardMemory.Create);
    _TreeMemory.Add(TreeScope, Memory);
  end
  else
    Memory := Value.AsObject as TB3BlackboardMemory;

  Result := Memory;
end;

function TB3Blackboard._GetNodeMemory(const TreeMemory: TB3BlackboardMemory; const NodeScope: String): TB3BlackboardMemory;
var
  NodeMemory, Memory: TB3BlackboardMemory;
  Value: TValue;
begin
  NodeMemory := TreeMemory['nodeMemory'].AsObject as TB3BlackboardMemory;
  if not NodeMemory.TryGetValue(NodeScope, Value) then
  begin
    Memory := TB3BlackboardMemory.Create;
    NodeMemory.Add(NodeScope, Memory);
  end
  else
    Memory := Value.AsObject as TB3BlackboardMemory;

  Result := Memory;
end;

function TB3Blackboard._GetMemory(const TreeScope, NodeScope: String): TB3BlackboardMemory;
var
  Memory: TB3BlackboardMemory;
begin
  Memory := _BaseMemory;

  if not TreeScope.IsEmpty then
  begin
    Memory := _GetTreeMemory(TreeScope);

    if not NodeScope.IsEmpty then
      Memory := _GetNodememory(Memory, NodeScope);
  end;

  Result := Memory;
end;

procedure TB3Blackboard.&Set(const Key: String; Value: TValue; TreeScope: String = ''; NodeScope: String = '');
var
  Memory: TB3BlackboardMemory;
begin
  Memory := _GetMemory(TreeScope, NodeScope);
  Memory.AddOrSetValue(Key, Value);
end;

function TB3Blackboard.Get(const Key: String; TreeScope: String = ''; NodeScope: String = ''): TValue;
var
  Memory: TB3BlackboardMemory;
begin
  Memory := _GetMemory(TreeScope, NodeScope);
  Memory.TryGetValue(Key, Result);
end;

{ TB3BlackboardMemory }

destructor TB3BlackboardMemory.Destroy;
var
  Item: TPair<String, TValue>;
begin
  for Item in Self do
    if (Item.Value.IsObject) and (Item.Value.AsObject.InheritsFrom(TB3BlackboardMemory)) then
      Item.Value.AsObject.Free;

  inherited;
end;

end.
