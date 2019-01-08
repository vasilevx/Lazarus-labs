unit syncunit;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, ComCtrls, treeunit, nodeunit;
type
  TSynchronizer = class(TObject)
    public
      procedure Add(tree: TFileTree; node: TFileNode; index: Integer);
      procedure Edit(tree: TFileTree; index: Integer; s: String);
      procedure Delete(tree: TFileTree; node: TTreeNode);
  end;
implementation
  procedure TSynchronizer.Add(tree: TFileTree; node: TFileNode; index: Integer);
  begin
    tree.addByIndex(index, node.PName, node.PParent);
  end;
procedure TSynchronizer.Edit(tree: TFileTree; index: Integer; s: String);
begin
    tree.PItems[index].PName:=s;
end;
procedure TSynchronizer.Delete(tree: TFileTree; node: TTreeNode);
var
    i, ilast: Integer;
begin
    i:=node.AbsoluteIndex;
    ilast:=tree.IndexOfLastNode(node);
    while ilast>=i do
    begin
      tree.Delete(ilast);
      dec(ilast);
    end;
end;
end.

