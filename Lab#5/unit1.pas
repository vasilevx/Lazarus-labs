unit Unit1;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus, treeunit, syncunit, nodeunit, LazFileUtils, LCLIntf ;
type
  { TForm1 }
  TForm1 = class(TForm)
    ClearBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    SaveH: TButton;
    SaveL: TButton;
    RestorH: TButton;
    RestorL: TButton;
    openFolderButton: TButton;
    SelectDirectory: TSelectDirectoryDialog;
    TreeView1: TTreeView;
    procedure ClearBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure openFolderButtonClick(Sender: TObject);
    procedure RestorHClick(Sender: TObject);
    procedure RestorLClick(Sender: TObject);
    procedure SaveHClick(Sender: TObject);
    procedure SaveLClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  public
    procedure GetDir(ParentNode: TTreeNode);
    function GetPathRec(Node: TTreeNode):string;
  end;
var
  Form1: TForm1;
  StreamT, StreamBL, StreamBH: TStream;
  Node: TFileNode;
  Tree: TFileTree;
  Sync: TSynchronizer;
  ser_count: Integer;
  startFolder: String;
implementation
{$R *.lfm}
{ TForm1 }
procedure TForm1.openFolderButtonClick(Sender: TObject);
var node: TFileNode;
    TreeTNode: TTreeNode;
begin
  if SelectDirectory.Execute then
    begin
      Tree.Clear;
      node:= TFileNode.Create;
      TreeView1.Items.Clear;
      startFolder := SelectDirectory.FileName;
      TreeTNode := TreeView1.Items.AddChild(nil, startFolder);
      node.PName:=startFolder;
      node.PParent:=-1;
      Sync.Add(Tree, node, TreeTNode.AbsoluteIndex);
      GetDir(TreeTNode);
    end;
end;
procedure TForm1.RestorHClick(Sender: TObject);
var MemStream: TMemoryStream;
begin
  Tree.Clear;
  StreamBH:=TFileStream.Create(extractfilepath(Application.ExeName) + 'fileH.dat', fmOpenRead);
  MemStream:=TMemoryStream.Create;
  RegisterClass(TFileTree);
  RegisterClass(TCollection);
  RegisterClass(TFileNode);
  ObjectTextToBinary(StreamBH, MemStream);
  MemStream.Position:=0;
  MemStream.ReadComponent(Tree);
  Tree.syncNodesWithTreeView;
  StartFolder:=Tree.StartFolder1;
  MemStream.Free;
  StreamBH.Free;
end;
procedure TForm1.RestorLClick(Sender: TObject);
begin
     Tree.Clear;
     StreamBL:=TFileStream.Create(extractfilepath(Application.ExeName)+'fileL.dat', fmOpenRead);
     Tree.ReadFromStream(StreamBL);
     StreamBL.Free;
end;
procedure TForm1.SaveHClick(Sender: TObject);
var MemStream: TMemoryStream;
begin
  if TreeView1.Items.Count<>0 then
     begin
          Tree.Sync();
          Tree.StartFolder1:=StartFolder;
          StreamBH:=TFileStream.Create(extractfilepath(Application.ExeName)+'fileH.dat', fmCreate);
          MemStream:=TMemoryStream.Create;
          MemStream.WriteComponent(Tree);
          MemStream.Position:=0;
          ObjectBinaryToText(MemStream, StreamBH);
          StreamBH.Free;
          MemStream.Free;
     end;
end;
procedure TForm1.SaveLClick(Sender: TObject);
begin
if TreeView1.Selected <> nil then
  begin
    if TreeView1.Items.Count<>0 then
      begin
          Tree.StartFolder1:=StartFolder;
          Tree.Sync();
          StreamBL:=TFileStream.Create(extractfilepath(Application.ExeName)+'fileL.dat', fmCreate);
          StreamBL.Seek(0,0);
          Tree.CountOfNodes(TreeView1.Items[0]);
          Tree.SaveToStream(StreamBL);
          StreamBL.Free;
      end;
  end;
end;
procedure TForm1.TreeView1DblClick(Sender: TObject);
var
  temp: string;
begin
  temp:='';
  if TreeView1.Selected <> nil then
  begin
    temp:=TreeView1.Selected.Text;
    if((Pos('jpg',temp) <> 0) or (Pos('bmp',temp) <> 0) or (Pos('JPG',temp) <> 0) or (Pos('BMP',temp) <> 0))then
    begin
    OpenDocument(GetPathRec(TreeView1.Selected));
    end;
  end;
  temp:='';
end;
procedure TForm1.FormCreate(Sender: TObject);
begin
  Tree:=TFileTree.Create;
  Sync:=TSynchronizer.Create;
  Tree.PTreeView:=TreeView1;
end;
procedure TForm1.ClearBtnClick(Sender: TObject);
begin
  Tree.Clear;
end;
procedure TForm1.GetDir(ParentNode: TTreeNode);
var
  sr: TSearchRec;
  GetDirNode: TTreeNode;
  node: TFileNode;
  path: string;
  i: integer;
begin
  node:=TFileNode.Create;
  GetDirNode := ParentNode;
  path := '';
  i:=1;
  repeat
    path := IncludeTrailingPathDelimiter(GetDirNode.Text) + path;
    GetDirNode := GetDirNode.Parent;
  until GetDirNode = nil;
  if FindFirstUTF8(path + '*.*', faDirectory, sr) = 0 then
  try
    repeat
      if (sr.Name = '.') or (sr.Name = '..') or (sr.Attr and faDirectory <> faDirectory) then Continue;
      GetDirNode := TreeView1.Items.AddChild(ParentNode, sr.Name);
      if i=1 then
      begin
          node.PName:=sr.Name;
          node.PParent:=ParentNode.AbsoluteIndex;
          Sync.Add(Tree, node, GetDirNode.AbsoluteIndex);
      end
      else
      begin
          node.PName:=sr.Name;
          node.PParent:=ParentNode.AbsoluteIndex;
          Sync.Add(Tree, node, GetDirNode.AbsoluteIndex);
      end;
      GetDir(GetDirNode);
      inc(i);
    until FindNextUTF8(sr) <> 0;
  finally
    FindCloseUTF8(sr);
  end;
  if (FindFirstUTF8(path + '*.jpg', faAnyFile, sr) = 0) then
  try
    repeat
      if (sr.Name = '.') or (sr.Name = '..') or (sr.Attr and faDirectory = faDirectory) then Continue;
      node.PName:=sr.Name;
      node.PParent:=ParentNode.AbsoluteIndex;
      Sync.Add(Tree, node, Form1.TreeView1.Items.AddChild(ParentNode, sr.Name).AbsoluteIndex);
      inc(i);
    until FindNextUTF8(sr) <> 0;
  finally
    FindCloseUTF8(sr);
  end;
  if (FindFirstUTF8(path + '*.JPG', faAnyFile, sr) = 0) then
  try
    repeat
      if (sr.Name = '.') or (sr.Name = '..') or (sr.Attr and faDirectory = faDirectory) then Continue;
      node.PName:=sr.Name;
      node.PParent:=ParentNode.AbsoluteIndex;
      Sync.Add(Tree, node, Form1.TreeView1.Items.AddChild(ParentNode, sr.Name).AbsoluteIndex);
      inc(i);
    until FindNextUTF8(sr) <> 0;
  finally
    FindCloseUTF8(sr);
  end;
    if (FindFirstUTF8(path + '*.bmp', faAnyFile, sr) = 0) then
  try
    repeat
      if (sr.Name = '.') or (sr.Name = '..') or (sr.Attr and faDirectory = faDirectory) then Continue;
      node.PName:=sr.Name;
      node.PParent:=ParentNode.AbsoluteIndex;
      Sync.Add(Tree, node, Form1.TreeView1.Items.AddChild(ParentNode, sr.Name).AbsoluteIndex);
      inc(i);
    until FindNextUTF8(sr) <> 0;
  finally
    FindCloseUTF8(sr);
  end;
  if (FindFirstUTF8(path + '*.BMP', faAnyFile, sr) = 0) then
  try
    repeat
      if (sr.Name = '.') or (sr.Name = '..') or (sr.Attr and faDirectory = faDirectory) then Continue;
      node.PName:=sr.Name;
      node.PParent:=ParentNode.AbsoluteIndex;
      Sync.Add(Tree, node, Form1.TreeView1.Items.AddChild(ParentNode, sr.Name).AbsoluteIndex);
      inc(i);
    until FindNextUTF8(sr) <> 0;
  finally
    FindCloseUTF8(sr);
  end;
end;
function TForm1.GetPathRec(Node: TTreeNode): string;
var str:string;
begin
  if Node.Parent.Text = StartFolder then
  begin
    GetPathRec:=(Node.Parent.Text+'\'+Node.Text);
  end
  else
  begin
    str:=GetPathRec(Node.Parent);
    GetPathRec:=(str+'\'+Node.Text);
  end;
end;
end.

