unit nodeunit;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils;
type
TFileNode = class(TCollectionItem)
  private
    fileName: string;
    parent: integer;
  public
    constructor Create;
  published
    property Pname: string read fileName write fileName;
    property Pparent: integer read parent write parent;
end;
implementation
constructor TFileNode.Create;
begin
end;
end.

