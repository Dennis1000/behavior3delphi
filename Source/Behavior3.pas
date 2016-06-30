unit Behavior3;

interface

{
 Notes:

 B3 => Behavior3 in order to avoid name clash
 BaseNode: as "parameter" is deprecated, it is not included, any reference changed to properties
 BaseNode: properties completely removed
 Exit() changed to Exit_()

 Register Node types
 Added Load/Save via JSON in BaseNode
 Nodes as Dictionary in Tree
 Tree Reference in BaseNode

 Nodes use Fixed var instead of properties
 removed properties from behaviortree

}

uses
  System.SysUtils;

const
  TB3Version = '0.2.0';

type
  TB3Category = (Composite, Decorator, Action, Condition);
  TB3Status = (Success = 1, Failure, Running, Error);

  EB3ParameterMissingException = class(Exception);
  EB3RootMissingException = class(Exception);
  EB3NodeclassMissingException = class(Exception);

implementation

end.
