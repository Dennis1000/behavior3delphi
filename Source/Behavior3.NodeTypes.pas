unit Behavior3.NodeTypes;

interface

uses
  System.Generics.Collections, System.Generics.Defaults,
  Behavior3.Core.BaseNode;

type
  TBehavior3NodeTypes = class(TDictionary<String, TB3BaseNodeClass>)
  public
    procedure Add(const Value: TB3BaseNodeClass); overload;
  end;

var
  Behavior3NodeTypes: TBehavior3NodeTypes;

implementation

{ TBehavior3NodeTypes }

procedure TBehavior3NodeTypes.Add(const Value: TB3BaseNodeClass);
var
  Instance: TB3BaseNode;
begin
  // Create an instance to retrieve the name
  Instance := Value.Create;
  Add(Instance.Name, Value);
  Instance.Free;
end;

initialization
  Behavior3NodeTypes := TBehavior3NodeTypes.Create;

finalization
  Behavior3NodeTypes.Free;
end.
