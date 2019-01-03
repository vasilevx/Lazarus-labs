unit memoryBlock_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type
  MemoryBlock = class
       MbTotal: integer;
       MbBytes: string;
       constructor Create(n:integer);
       function ByteLine(): string;
       function findPlace(n: integer): integer;
  end;




implementation
  constructor MemoryBlock.Create(n:integer);
  var i: integer;
  begin
       MbTotal := n;
       MbBytes := StringOfChar('0', MbTotal);
  end;

  function MemoryBlock.ByteLine(): string;
  begin
       Result := MbBytes;
  end;

  function MemoryBlock.findPlace(n: integer): integer;
  var i, j, bestPlace, currentBlockStart, bestSize, currentBlockSize: integer;
    c, curType: char;
  begin
       bestPlace := -1;
       bestSize := -1;
       currentBlockSize := 0;

       i := 1;
       while (i <= MbTotal) do begin
         if (MbBytes[i] = '0') then begin
           c := '0';
           j := i;
           currentBlockSize := 0;
           currentBlockStart := i;
           while ((MbBytes[j] = '0') and (j <= MbTotal)) do begin
             currentBlockSize := currentBlockSize + 1;
             j := j + 1;
           end;
           if ((currentBlockSize < bestSize) or (bestSize = -1)) and (currentBlockSize >= n) then begin
             bestPlace := currentBlockStart;
             bestSize := currentBlockSize;
           end;
           i := currentBlockStart + currentBlockSize + 1;
         end
         else
         i := i + 1;
       end;
       Result := bestPlace;
  end;

end.

