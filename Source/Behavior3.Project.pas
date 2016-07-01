unit Behavior3.Project;

interface

uses
  System.Classes, System.Generics.Collections, System.Generics.Defaults, System.JSON,
  Behavior3.Core.BehaviorTree, Behavior3.NodeTypes;

type
  TB3Project = class(TObject)
  private
  protected
  public
    Name: String;
    Description: String;
    Path: String;
    Trees: TB3BehaviorTreeDictionary;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Load(Data: String; NodeTypes: TB3NodeTypes = NIL); overload; virtual;
    procedure Load(JsonTree: TJSONObject; NodeTypes: TB3NodeTypes = NIL); overload; virtual;
    procedure LoadFromStream(Stream: TStream; NodeTypes: TB3NodeTypes = NIL); overload; virtual;
    procedure LoadFromFile(Filename: String; NodeTypes: TB3NodeTypes = NIL);
  end;

implementation

{ TB3Project }

uses
  System.SysUtils;

constructor TB3Project.Create;
begin
  inherited;
  Trees := TB3BehaviorTreeDictionary.Create([doOwnsValues]);
end;

destructor TB3Project.Destroy;
begin
  Trees.Free;
  inherited;
end;

procedure TB3Project.Load(Data: String; NodeTypes: TB3NodeTypes);
var
  JsonTree: TJSONObject;
begin
  JsonTree := TJSONObject.ParseJSONValue(Data, False) as TJSONObject;
  try
    Load(JsonTree, NodeTypes);
  finally
    JsonTree.Free;
  end;
end;

procedure TB3Project.Load(JsonTree: TJSONObject; NodeTypes: TB3NodeTypes);
var
  JsonNode: TJSONObject;
  ClassNodeTypes: TB3NodeTypes;
begin
  // If not yet assigned NodeTypes (or wrong class type) then create and use global B3NodeTypes
  if Assigned(NodeTypes) then
    ClassNodeTypes := TB3NodeTypes(NodeTypes)
  else
  begin
    if not Assigned(B3NodeTypes) then
      B3NodeTypes := TB3NodeTypes.Create;
    ClassNodeTypes := B3NodeTypes;
  end;

  Name := JsonTree.GetValue('name', Name);
  Description := JsonTree.GetValue('description', Description);
  Path := JsonTree.GetValue('path', Path);

  // Load all trees
  JsonNode := JsonTree.Get('data').JsonValue as TJSONObject;
  Trees.Load(JsonNode, ClassNodeTypes);
end;

procedure TB3Project.LoadFromStream(Stream: TStream; NodeTypes: TB3NodeTypes);
var
  StreamReader: TStreamReader;
  Data: String;
begin
  StreamReader := TStreamReader.Create(Stream);
  try
    Data := StreamReader.ReadToEnd;
    Load(Data, NodeTypes);
  finally
    StreamReader.Free;
  end;
end;

procedure TB3Project.LoadFromFile(Filename: String; NodeTypes: TB3NodeTypes);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead + fmShareDenyWrite);
  try
    LoadFromStream(Stream, NodeTypes);
  finally
    Stream.Free;
  end;
end;

end.
