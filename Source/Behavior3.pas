unit Behavior3;

interface

{
 Notes:

 B3 => Behavior3 in order to avoid name clash
 BaseNode: as "parameter" is deprecated, it is not included, any reference changed to properties
 Exit() changed to Exit_()

 Register Node types
 Added Load/Save via JSON in BaseNode
 Nodes as Dictionary in Tree
 Tree Reference in BaseNode

 Nodes use Fixed var instead of properties
}

uses
  System.SysUtils;

const
  TB3Version = '0.2.0';

type
  TB3Category = (Composite, Decorator, Action, Condition);
  TB3Status = (Success = 1, Failure, Running, Error);

  EParameterMissingException = class(Exception);
  ERootMissingException = class(Exception);

implementation

uses
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

end.
