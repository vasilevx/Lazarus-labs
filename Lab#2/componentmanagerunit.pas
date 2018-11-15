unit ComponentManagerUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls,  FileUtil, Forms, Controls, Graphics, Dialogs, IniFiles, ShellApi;

type
  TComponentManager = class
    private
      buttonsList: array of TButton;
      myListbox: TListBox;
      Ini: Tinifile;
      NAMES, CMD_LINES: array of string;
      size: integer;
      procedure useButtons();
      procedure useListbox();
      procedure ListClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
      procedure SpacePress(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure ButtonClick(Sender: TObject);
    public
      constructor Create();
      destructor Destroy(); override;
end;

implementation
uses RunTimeUnit;
//Клик по кнопке
procedure TComponentManager.ButtonClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar(CMD_LINES[TButton(Sender).Tag]), nil, nil, 1);
end;
//Пробел или Enter по списку
procedure TComponentManager.SpacePress(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = 32) or (Key = 13) then
      ShellExecute(0, 'open', PChar(CMD_LINES[myListbox.ItemIndex]), nil, nil, 1);
end;
//Клик по списку
procedure TComponentManager.ListClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
   Point: TPoint;
   Index: Integer;
begin
     if (Button <> mbleft) or not(ssDouble in Shift) then
        Exit;

       Point.X := X;
       Point.Y := Y;
       Index := myListbox.ItemAtPos(Point, True);
       if index > -1 then
          ShellExecute(0, 'open', PChar(CMD_LINES[Index]), nil, nil, 1);
end;
//Используем кнопки
procedure TComponentManager.useButtons();
var i: integer;
begin
     setlength(buttonsList, size);
     for i:= 0 to size-1 do begin
       buttonsList[i] := TButton.Create(RunTimeForm);
       buttonsList[i].Parent := RunTimeForm;
       buttonsList[i].Width := 304;
       buttonsList[i].Height := 30;
       buttonsList[i].Left := 8;
       buttonsList[i].Tag := i;
       buttonsList[i].Top :=  8 + i * 30;
       buttonsList[i].Caption := NAMES[i];
       buttonsList[i].OnCLick := @ButtonClick;
     end;
end;
//Используем список
procedure TComponentManager.useListbox();
var i: integer;
begin
  myListbox := TListBox.Create(RunTimeForm);
  myListbox.Parent := RunTimeForm;
  myListbox.Width := 304;
  myListbox.Top := 8;
  myListbox.Left := 8;
  myListbox.Height := 200;

  for i:=0 to size-1 do
      myListBox.Items.Add(NAMES[i]);
  myListbox.OnMouseUp := @ListClick;
  myListbox.OnKeyUp := @SpacePress;
end;
//конструктор
constructor TComponentManager.Create;
var OUTPUT_TYPE: byte;
begin
  Ini := TiniFile.Create(extractfilepath(Application.ExeName)+'myinifile.ini');
  OUTPUT_TYPE := Ini.ReadInteger('OUTPUT', 'OUTPUT_TYPE', 1);

  size := 0;
  repeat
        setlength(NAMES, size + 1);
        setlength(CMD_LINES, size + 1);
        NAMES[size] := Ini.ReadString('NAMES', 'NAME_'+IntToStr(size), 'null');
        CMD_LINES[size] :=  Ini.ReadString('CMD_LINES', 'LINE_'+IntToStr(size), 'null');
        size := size + 1;
  until (NAMES[size-1] = 'null') or (CMD_LINES[size-1] = 'null');
  size := size - 1;
  setlength(NAMES, size);
  setlength(CMD_LINES, size);

  if OUTPUT_TYPE = 2 then
      useButtons()
  else
      useListbox();
end;
//деструктор
destructor TComponentManager.Destroy;
var i: integer;
begin
     for i := 0 to size-1 do
         buttonsList[i].Free;
     myListbox.Free;
     Ini.Free;
end;

end.

