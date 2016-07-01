unit ExampleBehaviorNodes;

interface

uses
  System.JSON, Vcl.Graphics,
  Behavior3.Project, Behavior3.Core.Condition,Behavior3.Core.Action, Behavior3.Core.Tick, Behavior3;

type
  TB3IsMouseOver = class(TB3Condition)
  public
    constructor Create; override;
    function Tick(Tick: TB3Tick): TB3Status; override;
  end;

  TB3ChangeColor = class(TB3Action)
  public
    Color: TColor;
    constructor Create; override;
    procedure Load(JsonNode: TJSONValue); override;
    function Tick(Tick: TB3Tick): TB3Status; override;
  end;

  TB3ChangePosition = class(TB3Action)
  public
    constructor Create; override;
    function Tick(Tick: TB3Tick): TB3Status; override;
  end;

implementation

{ TB3IsMouseOver }

uses
  System.Types, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms;

constructor TB3IsMouseOver.Create;
begin
  inherited;
  Name := 'IsMouseOver';
end;

function TB3IsMouseOver.Tick(Tick: TB3Tick): TB3Status;
var
  Shape: TShape;
  ParentForm: TForm;
  Point: TPoint;
begin
  Shape := Tick.Target as TShape;
  ParentForm := Shape.Parent as TForm;
  Point := ParentForm.ScreenToClient(Mouse.CursorPos);
  if Shape.BoundsRect.Contains(Point) then
    Result := Behavior3.Success
  else
    Result := Behavior3.Failure;
end;


{ TB3ChangeColor }

constructor TB3ChangeColor.Create;
begin
  inherited;
  Name := 'ChangeColor';
end;

procedure TB3ChangeColor.Load(JsonNode: TJSONValue);
var
  ColorName: String;
begin
  inherited;
  ColorName := LoadProperty(JsonNode, 'color', 'purple');
  Color := StringToColor('cl' + ColorName);
end;

function TB3ChangeColor.Tick(Tick: TB3Tick): TB3Status;
var
  Shape: TShape;
begin
  Shape := Tick.Target as TShape;
  Shape.Brush.Color := Color;
  Result := Behavior3.Success;
end;

{ TB3ChangePosition }

constructor TB3ChangePosition.Create;
begin
  inherited;
  Name := 'ChangePosition';
end;

function TB3ChangePosition.Tick(Tick: TB3Tick): TB3Status;
var
  Shape: TShape;
  ParentForm: TForm;
begin
  Shape := Tick.Target as TShape;
  ParentForm := Shape.Parent as TForm;

  Shape.Left := Random(ParentForm.ClientWidth - Shape.Width);
  Shape.Top := Random(ParentForm.ClientHeight - Shape.Height);

  Result := Behavior3.Success;
end;

end.
