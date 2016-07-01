program Example1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Behavior3.Helper in '..\..\Source\Behavior3.Helper.pas',
  Behavior3.NodeTypes in '..\..\Source\Behavior3.NodeTypes.pas',
  Behavior3 in '..\..\Source\Behavior3.pas',
  Behavior3.Actions.Error in '..\..\Source\Actions\Behavior3.Actions.Error.pas',
  Behavior3.Actions.Failer in '..\..\Source\Actions\Behavior3.Actions.Failer.pas',
  Behavior3.Actions.Runner in '..\..\Source\Actions\Behavior3.Actions.Runner.pas',
  Behavior3.Actions.Succeeder in '..\..\Source\Actions\Behavior3.Actions.Succeeder.pas',
  Behavior3.Actions.Wait in '..\..\Source\Actions\Behavior3.Actions.Wait.pas',
  Behavior3.Composites.MemPriority in '..\..\Source\Composites\Behavior3.Composites.MemPriority.pas',
  Behavior3.Composites.MemSequence in '..\..\Source\Composites\Behavior3.Composites.MemSequence.pas',
  Behavior3.Composites.Priority in '..\..\Source\Composites\Behavior3.Composites.Priority.pas',
  Behavior3.Composites.Sequence in '..\..\Source\Composites\Behavior3.Composites.Sequence.pas',
  Behavior3.Core.Action in '..\..\Source\Core\Behavior3.Core.Action.pas',
  Behavior3.Core.BaseNode in '..\..\Source\Core\Behavior3.Core.BaseNode.pas',
  Behavior3.Core.BehaviorTree in '..\..\Source\Core\Behavior3.Core.BehaviorTree.pas',
  Behavior3.Core.Blackboard in '..\..\Source\Core\Behavior3.Core.Blackboard.pas',
  Behavior3.Core.Composite in '..\..\Source\Core\Behavior3.Core.Composite.pas',
  Behavior3.Core.Condition in '..\..\Source\Core\Behavior3.Core.Condition.pas',
  Behavior3.Core.Decorator in '..\..\Source\Core\Behavior3.Core.Decorator.pas',
  Behavior3.Core.Tick in '..\..\Source\Core\Behavior3.Core.Tick.pas',
  Behavior3.Decorators.Inverter in '..\..\Source\Decorators\Behavior3.Decorators.Inverter.pas',
  Behavior3.Decorators.Limiter in '..\..\Source\Decorators\Behavior3.Decorators.Limiter.pas',
  Behavior3.Decorators.MaxTime in '..\..\Source\Decorators\Behavior3.Decorators.MaxTime.pas',
  Behavior3.Decorators.Repeater in '..\..\Source\Decorators\Behavior3.Decorators.Repeater.pas',
  Behavior3.Decorators.RepeatUntilFailure in '..\..\Source\Decorators\Behavior3.Decorators.RepeatUntilFailure.pas',
  Behavior3.Decorators.RepeatUntilSuccess in '..\..\Source\Decorators\Behavior3.Decorators.RepeatUntilSuccess.pas',
  Behavior3.Project in '..\..\Source\Behavior3.Project.pas',
  ExampleBehaviorNodes in 'ExampleBehaviorNodes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
