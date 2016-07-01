unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Behavior3.Project, Behavior3.NodeTypes, Behavior3.Core.Blackboard, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Shape1: TShape;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    NodeTypes: TB3NodeTypes;
    BlackBoard: TB3Blackboard;
  public
    { Public declarations }
    Project: TB3Project;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  ExampleBehaviorNodes;

procedure TForm1.FormCreate(Sender: TObject);
begin
  NodeTypes := TB3NodeTypes.Create;

  // add custom nodes
  NodeTypes.Add(TB3IsMouseOver);
  NodeTypes.Add(TB3ChangeColor);
  NodeTypes.Add(TB3ChangePosition);

  Project := TB3Project.Create;
  Project.LoadFromFile('example_1.b3', NodeTypes);

  BlackBoard := TB3Blackboard.Create;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  BlackBoard.Free;
  Project.Free;
  NodeTypes.Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Project.Trees.SelectedTree.Tick(Shape1, Blackboard);
end;

end.

