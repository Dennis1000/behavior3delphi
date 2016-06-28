unit Behavior3.Helper;

interface

uses
  Behavior3.Core.BehaviorTree, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
  TB3BehaviorTreeHelper = class helper for TB3BehaviorTree
  protected
    function GetRoot: TB3BaseNode;
    procedure SetRoot(const Value: TB3BaseNode);
    procedure SetNodes(const Value: TB3BaseNodeDictionary);
    function GetNodes: TB3BaseNodeDictionary;
  public
    property Root: TB3BaseNode read GetRoot write SetRoot;
    property Nodes: TB3BaseNodeDictionary read GetNodes write SetNodes;
  end;

  TB3TickHelper = class helper for TB3Tick
  protected
    function GetTree: TB3BehaviorTree;
    procedure SetTree(const Value: TB3BehaviorTree);
    function GetOpenNodes: TB3BaseNodeList;
  public
    property Tree: TB3BehaviorTree read GetTree write SetTree;
    property _OpenNodes: TB3BaseNodeList read GetOpenNodes;
  end;

implementation

{ TB3BehaviorTreeHelper }

function TB3BehaviorTreeHelper.GetNodes: TB3BaseNodeDictionary;
begin
  Result := FNodes as TB3BaseNodeDictionary;
end;

function TB3BehaviorTreeHelper.GetRoot: TB3BaseNode;
begin
  Result := FRoot as TB3BaseNode;
end;

procedure TB3BehaviorTreeHelper.SetNodes(const Value: TB3BaseNodeDictionary);
begin
  FNodes := Value;
end;

procedure TB3BehaviorTreeHelper.SetRoot(const Value: TB3BaseNode);
begin
  FRoot := Value;
end;

{ TB3TickHelper }

function TB3TickHelper.GetOpenNodes: TB3BaseNodeList;
begin
  Result := F_OpenNodes as TB3BaseNodeList;
end;

function TB3TickHelper.GetTree: TB3BehaviorTree;
begin
  Result := FTree as TB3BehaviorTree;
end;

procedure TB3TickHelper.SetTree(const Value: TB3BehaviorTree);
begin
  FTree := Value;
end;

end.
