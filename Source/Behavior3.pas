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


end.
