unit DesignTimeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ShellApi;

type

  { TDesignTimeForm }

  TDesignTimeForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    procedure ButtonClick(Sender: TObject);
    procedure ListClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure SpacePress(Sender: TObject; var Key: Word; Shift: TShiftState);

  private

  public

  end;

var
  DesignTimeForm: TDesignTimeForm;

implementation

{$R *.lfm}

{ TDesignTimeForm }

procedure TDesignTimeForm.ButtonClick(Sender: TObject);
begin
     if Sender = Button1 then
        ShellExecute(0, 'open', 'mspaint', nil, nil, 1)
     else if Sender = Button2 then
        ShellExecute(0, 'open', 'notepad', nil, nil, 1)
     else if Sender = Button3 then
        ShellExecute(0, 'open', 'msconfig', nil, nil, 1);
end;

procedure TDesignTimeForm.ListClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  Point: TPoint;
  Index: Integer;
begin
     if (Button <> mbleft) or not(ssDouble in Shift) then
        Exit;

       Point.X := X;
       Point.Y := Y;
       Index := ListBox1.ItemAtPos(Point, True);
       Case Index of
       0: ShellExecute(0, 'open', 'mspaint', nil, nil, 1);
       1: ShellExecute(0, 'open', 'notepad', nil, nil, 1);
       2: ShellExecute(0, 'open', 'msconfig', nil, nil, 1);
       end;

end;

procedure TDesignTimeForm.SpacePress(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 32) or (Key = 13) then begin
    Case ListBox1.ItemIndex of
    0: ShellExecute(0, 'open', 'mspaint', nil, nil, 1);
    1: ShellExecute(0, 'open', 'notepad', nil, nil, 1);
    2: ShellExecute(0, 'open', 'msconfig', nil, nil, 1);
    end;
  end;
end;



end.

