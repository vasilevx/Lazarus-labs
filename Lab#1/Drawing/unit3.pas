unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    procedure Shape1ChangeBounds(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.Shape1ChangeBounds(Sender: TObject);
begin

end;

end.

