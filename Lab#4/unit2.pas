unit Unit2;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs;

type
  { TForm2 }
  TForm2 = class(TForm)
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    procedure addPoint(y:integer);
    procedure SetStartSet;
  private
    x:integer;
  public
  end;
var
  Form2: TForm2;
implementation
procedure TForm2.SetStartSet;
begin
x:=0;
Chart1LineSeries1.SeriesColor:=clRed;
end;

procedure TForm2.addPoint(y:integer);
begin
inc(x);
Chart1LineSeries1.AddXY(x,y,'');
end;

{$R *.lfm}
end.

