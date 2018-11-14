unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TfmStopWatch }

  TfmStopWatch = class(TForm)
    btStart: TButton;
    btLap: TButton;
    btReset: TButton;
    lbTotalTime: TLabel;
    LBlAPtIME: TLabel;
    mmLapTime: TMemo;
    mmTotalTime: TMemo;
    Timer1: TTimer;
    procedure btLapClick(Sender: TObject);
    procedure btResetClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    TickCounter: Longint;
    LapCounter: Longint;
  public
    { public declarations }
  end;

var
  fmStopWatch: TfmStopWatch;

implementation

{$R *.lfm}

{ TfmStopWatch }

procedure TfmStopWatch.Timer1Timer(Sender: TObject);
var
S:string;
Seconds:real;
begin
  TickCounter:= TickCounter+1;
  Seconds:=TickCounter /10;
  Str(Seconds:10:1,S);
  mmTotalTime.Lines.Text:=S;
end;

procedure TfmStopWatch.btStartClick(Sender: TObject);
begin
  If Timer1.Enabled then
begin
Timer1.Enabled:=False;
btStart.Caption:='Начало';
end
Else
begin
Timer1.Enabled:=True;
btStart.Caption:='Конец'
end;
end;

procedure TfmStopWatch.btLapClick(Sender: TObject);
var
S : string;
Temp: Longint;
begin
         Temp:=TickCounter - LapCounter;
         LapCounter:=TickCounter;
         Str((Temp / 10) : 0: 1, S);
         		mmLapTime.Lines.Text:=S;
end;

procedure TfmStopWatch.btResetClick(Sender: TObject);
begin
   TickCounter:=0;
   LapCounter:=0;
   		mmTotalTime.Lines.Text:='0.0';
                		mmLapTime.Lines.Text:='0.0';

end;

end.

