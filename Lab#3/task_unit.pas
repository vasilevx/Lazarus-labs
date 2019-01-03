unit task_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Contnrs, memoryBlock_unit, Dialogs;

type Task = class
  TaskName: string;
  TaskSize: integer;
  TaskStartTime: string;
  TaskTotalTime: integer;
  TaskStatus: string;
  TaskTimer: TTimer;
  TaskUsedMemoryBlock: integer;

  constructor Create(Name: string; Size: integer; TotalTime: integer);
  destructor Free;
  function isInQueue(): boolean;
  function isComplete(): boolean;
  procedure onTimerTick(Sender: TObject);
  procedure TaskStart(fromTimer: integer; MemBlock: MemoryBlock);
  procedure FreeMemoryBlock(MemBlock: MemoryBlock);

end;

implementation

constructor Task.Create(Name: string; Size: integer; TotalTime: integer);
begin
  TaskName := Name;
  TaskSize := Size;
  TaskStartTime := '-';
  TaskTotalTime := TotalTime;
  TaskStatus := 'В очереди';
  TaskTimer := TTimer.Create(nil);
  TaskTimer.Interval := 1000;
  TaskTimer.OnTimer := @OnTimerTick;
  TaskTimer.Enabled := False;
end;

destructor Task.Free;
var i: integer;
begin
  TaskTimer.Free;
end;

procedure Task.onTimerTick(Sender: TObject);
begin
  if TaskStatus = 'Завершена' then Exit;
  dec(TaskTotalTime);
  if (TaskTotalTime = 0) then
  begin
    TaskTimer.Enabled := False;
    TaskStatus := 'Завершена';
  end;
end;

procedure Task.TaskStart(fromTimer: integer; MemBlock: MemoryBlock);
var i, place: integer;
begin
  place := MemBlock.findPlace(TaskSize);
  if place <> -1 then begin
    TaskUsedMemoryBlock := place;
    i := 0;
    while (i < TaskSize) do begin
      MemBlock.MbBytes[place + i] := '1';
      i := i + 1;
    end;
    TaskTimer.Enabled := True;
    TaskStartTime := IntToStr(fromTimer);
    TaskStatus := 'Выполняется';

  end;



end;

function Task.isInQueue(): boolean;
begin
  if TaskStatus = 'В очереди' then
    isInQueue := True
  else
    isInQueue := False;
end;

function Task.isComplete(): boolean;
begin
   if TaskStatus='Завершена' then
     isComplete := True
   else
     isComplete := False;
end;

procedure  Task.FreeMemoryBlock(MemBlock: MemoryBlock);
var i:integer;
begin
    if TaskUsedMemoryBlock = -1 then Exit;
    i := 0;
    while (i < TaskSize) do begin
      MemBlock.MbBytes[TaskUsedMemoryBlock + i] := '0';
      i := i + 1;
    end;
    TaskUsedMemoryBlock := -1;
end;


end.

