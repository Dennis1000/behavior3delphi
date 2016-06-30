{ behavior3delphi - a Behavior3 client library (Behavior Trees) for Delphi
  by Dennis D. Spreen <dennis@spreendigital.de>
  see Behavior3.pas header for full license information }
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
    constructor Create(ACapacity: Integer = 0; WithDefaultTypes: Boolean = True); overload;virtual;
  end;

var
  B3NodeTypes: TB3NodeTypes;

implementation

{ TBehavior3NodeTypes }

uses
  Behavior3,
  // add all node types
  Behavior3.Actions.Error,
  Behavior3.Actions.Failer,
  Behavior3.Actions.Runner,
  Behavior3.Actions.Succeeder,
  Behavior3.Actions.Wait,
  Behavior3.Composites.MemPriority,
  Behavior3.Composites.MemSequence,
  Behavior3.Composites.Priority,
  Behavior3.Composites.Sequence,
  Behavior3.Decorators.Inverter,
  Behavior3.Decorators.Limiter,
  Behavior3.Decorators.MaxTime,
  Behavior3.Decorators.Repeater,
  Behavior3.Decorators.RepeatUntilFailure,
  Behavior3.Decorators.RepeatUntilSuccess;

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

constructor TB3NodeTypes.Create(ACapacity: Integer = 0; WithDefaultTypes: Boolean = True);
begin
  // Set default capacity to 15 before adding the 15 default node types
  if (WithDefaultTypes) and (ACapacity < 15) then
    ACapacity := 15;

  inherited Create(ACapacity);

  if WithDefaultTypes then
  begin
    Add(TB3RepeatUntilSuccess);
    Add(TB3RepeatUntilFailure);
    Add(TB3Repeater);
    Add(TB3MaxTime);
    Add(TB3Limiter);
    Add(TB3Inverter);
    Add(TB3Sequence);
    Add(TB3Priority);
    Add(TB3MemSequence);
    Add(TB3MemPriority);
    Add(TB3Wait);
    Add(TB3Succeeder);
    Add(TB3Runner);
    Add(TB3Failer);
    Add(TB3Error);
  end;
end;

function TB3NodeTypes.CreateNode(const NodeName: String): TB3BaseNode;
var
  NodeClass: TB3BaseNodeClass;
begin
  if not B3NodeTypes.TryGetValue(NodeName, NodeClass) then
    raise EB3NodeclassMissingException.CreateFmt('Invalid node class %s', [NodeName]);

  Result := NodeClass.Create;
end;

initialization
  B3NodeTypes := NIL;

finalization
  if Assigned(B3NodeTypes) then
    B3NodeTypes.Free;
end.
