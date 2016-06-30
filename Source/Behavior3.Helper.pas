{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
unit Behavior3.Helper;

interface

uses
  Behavior3.Core.BehaviorTree, Behavior3.Core.BaseNode, Behavior3.Core.Tick;

type
  TB3BehaviorTreeHelper = class helper for TB3BehaviorTree
  protected
    function GetRoot: TB3BaseNode; inline;
    procedure SetRoot(const Value: TB3BaseNode); inline;
    procedure SetNodes(const Value: TB3BaseNodeDictionary); inline;
    function GetNodes: TB3BaseNodeDictionary; inline;
  public
    property Root: TB3BaseNode read GetRoot write SetRoot;
    property Nodes: TB3BaseNodeDictionary read GetNodes write SetNodes;
  end;

  TB3TickHelper = class helper for TB3Tick
  protected
    function GetTree: TB3BehaviorTree; inline;
    procedure SetTree(const Value: TB3BehaviorTree); inline;
    function GetOpenNodes: TB3BaseNodeList; inline;
  public
    property Tree: TB3BehaviorTree read GetTree write SetTree;
    property _OpenNodes: TB3BaseNodeList read GetOpenNodes;
  end;

implementation

{ TB3BehaviorTreeHelper }

function TB3BehaviorTreeHelper.GetNodes: TB3BaseNodeDictionary;
begin
  Result := TB3BaseNodeDictionary(FNodes);
end;

function TB3BehaviorTreeHelper.GetRoot: TB3BaseNode;
begin
  Result := TB3BaseNode(FRoot);
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
  Result := TB3BaseNodeList(F_OpenNodes);
end;

function TB3TickHelper.GetTree: TB3BehaviorTree;
begin
  Result := TB3BehaviorTree(FTree);
end;

procedure TB3TickHelper.SetTree(const Value: TB3BehaviorTree);
begin
  FTree := Value;
end;

end.
