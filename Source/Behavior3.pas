{ behavior3delphi v1.0 - a Behavior3 client library (Behavior Trees)
  based on behavior3js <https://github.com/behavior3/behavior3js/>
  for Delphi 10.1 Berlin+ by Dennis D. Spreen
  http://blog.spreendigital.de/2016/07/01/behavior3delphi/

  (c) Copyrights 2016 Dennis D. Spreen <dennis@spreendigital.de>

  The MIT License (MIT)

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
}
unit Behavior3;

interface

{
  This code was translated from behavior3js with these modifications:

  - Used "Behavoir3" as the unit namespace
  - Used Delphi-like capitalization on variables, procedure, unit and object names
  - Prefixed any objects with TB3
  - BaseNode: as "parameter" is deprecated, it is not included, thus any reference is not included
  - BaseNode: properties completely removed, as this was only useful for the behavior3editor
  - BaseNode: Exit() changed to Exit_()
  - BaseNode: added load/save via JSON object
  - BaseNode: added a BehaviorTree reference (as Tree: TB3BehaviorTree)
  - BehaviorTree: added all linked nodes as a node dictionary (Nodes: TB3BaseNodeDictionary)
  - BehaviorTree: removed properties
  - Node types are either given during the loading of the behavior tree or managed globally (in Behavior3.NodeTypes.pas)
  - Register your custom node types in the B3NodeTypes dictionary
  - used Behavior3.Helper.pas to prevent circular unit reference
  - added BehaviorTreeDictionary
  - added Behavior3.Project with behavior3editor support
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
