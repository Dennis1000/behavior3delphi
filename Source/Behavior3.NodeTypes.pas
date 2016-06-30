unit Behavior3.NodeTypes;

interface

uses
  System.Generics.Collections, System.Generics.Defaults,
  Behavior3.Core.BaseNode;

type
  TB3NodeTypes = class(TDictionary<String, TB3BaseNodeClass>)
  public
    procedure Add(const Value: TB3BaseNodeClass); overload;
    function CreateNode(const NodeName: String): TB3BaseNode; virtual;
  end;

var
  Behavior3NodeTypes: TB3NodeTypes;

implementation

{ TBehavior3NodeTypes }

uses
  Behavior3;

procedure TB3NodeTypes.Add(const Value: TB3BaseNodeClass);
var
  Instance: TB3BaseNode;
begin
  // Create an instance to retrieve the name
  Instance := Value.Create;
  try
    Add(Instance.Name, Value);
  finally
    Instance.Free;
  end;
end;

function TB3NodeTypes.CreateNode(const NodeName: String): TB3BaseNode;
var
  NodeClass: TB3BaseNodeClass;
begin
  if not Behavior3NodeTypes.TryGetValue(NodeName, NodeClass) then
    raise EB3NodeclassMissingException.CreateFmt('Invalid node class %s', [NodeName]);

  Result := NodeClass.Create;
end;

initialization
  Behavior3NodeTypes := TB3NodeTypes.Create;

finalization
  Behavior3NodeTypes.Free;
end.
