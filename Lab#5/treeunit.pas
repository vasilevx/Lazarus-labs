unit treeunit;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, nodeunit, Dialogs, ComCtrls;
type
   TFileTree = class(TComponent)
     private
       files: TCollection;
       treeView: TTreeView;
       Ckk: integer;
       startFolder: string;
       function GetCount: Integer;
       function Get(index: Integer): TFileNode;
     public
       constructor Create;
       destructor Destroy; override;
       procedure Add(nodeName: String; Parent: Integer);
       procedure addByIndex(index: Integer; nodeName: String; Parent: Integer);
       procedure InsertNode(index: Integer; nodeName: String; Parent: Integer);
       procedure syncNodesWithTreeView();
       procedure Delete(index: Integer);
       function CountOfNodes(node: TTreeNode): Integer;
       function IndexOfLastNode(node: TTreeNode): Integer;
       procedure SaveToStream(stream: TStream);
       procedure ReadFromStream(stream: TStream);
       procedure Sync();
       procedure Clear();
       procedure Link(newnode: TTreeNode; number: Integer);
       property PItems[index: Integer]: TFileNode read Get;
       property PCount: Integer read GetCount;
       property PTreeView: TTreeView write treeView;
       property StartFolder1: String read StartFolder write StartFolder;
       property CkkItem1: Integer read Ckk write Ckk;
   published
       property Items: TCollection read files write files;
       property StartFolderString: String read startFolder write startFolder;
       property CkkItem: Integer read Ckk write Ckk;
     end;
implementation
procedure TFileTree.Clear();
begin
    files.Clear;
    treeView.Items.Clear;
end;
procedure TFileTree.addByIndex(index:Integer; nodeName:String;Parent:Integer);
begin
    if index < files.Count then
         InsertNode(index, nodeName, Parent)
    else
         Add(nodeName, Parent);
end;
procedure TFileTree.Add(nodeName: String; Parent: Integer);
begin
    files.Add;
    TFileNode(files.Items[files.Count-1]).PName:=nodeName;
    TFileNode(files.Items[files.Count-1]).PParent:=Parent;
end;
procedure TFileTree.InsertNode(index: Integer; nodeName: String; Parent: Integer);
begin
    files.Insert(index);
    TFileNode(files.Items[Index]).PName:=nodeName;
    TFileNode(files.Items[Index]).PParent:=Parent;
end;
function TFileTree.Get(index: Integer): TFileNode;
begin
    Result:=TFileNode(files.Items[index]);
end;
constructor TFileTree.Create;
begin
    files:=TCollection.Create(TFileNode);
end;
destructor TFileTree.Destroy;
begin
    files.Destroy;
end;
procedure TFileTree.Sync();
var i, ilast: Integer;
begin
    i:=0;
    ilast:=files.Count;
    while i < ilast do
    begin
         PItems[i].PName:=treeView.Items[i].Text;
         inc(i);
    end;
end;
procedure TFileTree.syncNodesWithTreeView();
var i, j: Integer;
begin
    i:=0;
    while i < files.Count do
    begin
      with TFileNode(files.Items[i]), treeView do
      if PParent = -1 then
              Items.AddChild(nil, PName)
      else
      Items.AddChild(Items[PParent], PName);
      inc(i);
      inc(j);
    end;
end;
procedure TFileTree.Delete(index: Integer);
begin
    files.Delete(index);
end;
function TFileTree.GetCount:Integer;
begin
    Result:=files.Count;
end;
function TFileTree.CountOfNodes(node: TTreeNode): Integer;
begin
    Result:=IndexOfLastNode(node)-(node.AbsoluteIndex)+1;
    Ckk:=Result;
end;
function TFileTree.IndexOfLastNode(node: TTreeNode): Integer;
var
    i, level: Integer;
begin
    i:=node.AbsoluteIndex;
    level:=node.Level;
    repeat
         inc(i);
         if i=treeView.Items.Count then
              break;
    until
         TreeView.Items[i].Level<=level;
    Result:=i-1;
end;
procedure TFileTree.SaveToStream(stream: TStream);
var
    i, j, l: Integer;
    node: TFileNode;
begin
    i:=0;
    j:=TreeView.Items[0].AbsoluteIndex;
    while i<Ckk do
    begin
         node:=TFileNode(files.Items[j]);
         l:=Length(node.PName);
         stream.Write(l, sizeof(integer));
         stream.WriteBuffer(node.PName[1], l);
         stream.Write(node.PParent, sizeof(Integer));
         inc(j);
         inc(i);
    end;
end;
procedure TFileTree.Link(newnode: TTreeNode; number: Integer);
var
    i, d, p: Integer;
begin
    with newnode do
    begin
         i:=AbsoluteIndex;
         if number=1 then
         begin
              if Level>0 then
                   TFileNode(files.Items[i]).PParent:=Parent.AbsoluteIndex
              else
                   TFileNode(files.Items[i]).PParent:=-1;
         end else
         if number>1 then
         begin
              p:=TFileNode(files.Items[i+1]).PParent;
              if Level>0 then
                   TFileNode(files.Items[i]).PParent:=Parent.AbsoluteIndex
              else
                   TFileNode(files.Items[i]).PParent:=-1;
              TFileNode(files.Items[i+1]).PParent:=i;
              inc(i,2);
              dec(number,2);
              while number>0 do
              begin
                   d:=TFileNode(files.Items[i]).PParent-p;
                   p:=TFileNode(files.Items[i]).PParent;
                   TFileNode(files.Items[i]).PParent:=TFileNode(files.Items[i-1]).PParent+d;
                   inc(i,1);
                   dec(number,1);
              end;
         end;
    end;
end;
procedure TFileTree.ReadFromStream(stream: TStream);
var
    l, i, j, c, parent: Integer;
    name1: String;
    node: TFileNode;
begin
    if Ckk>0 then
    begin
         c:=Ckk;
         node:=TFileNode.Create;
         stream.Read(l, sizeof(Integer));
         setlength(name1, l);
         stream.ReadBuffer(name1[1], l);
         node.PName:=name1;
         stream.Read(parent, sizeof(Integer));
         node.PParent:=parent;
         with TreeView do
              i:=Items.AddChild(Selected, node.PName).AbsoluteIndex;
         if i=files.Count then
         begin
              Add(node.PName, node.PParent);
              dec(Ckk);
              while Ckk>0 do
              begin
                   node:=TFileNode.Create;
                   stream.Read(l, sizeof(Integer));
                   setlength(name1, l);
                   stream.ReadBuffer(name1[1], l);
                   node.PName:=name1;
                   stream.Read(parent, sizeof(Integer));
                   node.PParent:=parent;
                   Add(node.PName, node.PParent);
                   dec(Ckk);
              end;
         end else
         begin
              InsertNode(i, node.PName, node.PParent);
              dec(Ckk);
              j:=i+1;
              while Ckk>0 do
              begin
                   node:=TFileNode.Create;
                   stream.Read(l, sizeof(Integer));
                   setlength(name1, l);
                   stream.ReadBuffer(name1[1], l);
                   node.PName:=name1;
                   stream.Read(parent, sizeof(Integer));
                   node.PParent:=parent;
                   InsertNode(j, node.PName, node.PParent);
                   inc(j);
                   dec(Ckk);
              end;
         end;
         Link(TreeView.Items[i], c);
         j:=1;
         inc(i);
         while j<c do
         begin
              with TFileNode(files.Items[i]),TreeView do
                   Items.AddChild(Items[PParent], PName);
              inc(i);
              inc(j);
         end;
    end;
end;
end.

