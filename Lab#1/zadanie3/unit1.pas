unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ExtDlgs;

type

  { TfmDialog }

  TfmDialog = class(TForm)
    BitBtn1: TBitBtn;
    btDraw: TButton;
    btSaveText: TButton;
    btLoadText: TButton;
    imDraw: TImage;
    odText: TOpenDialog;
    opdDraw: TOpenPictureDialog;
    reText: TMemo;
    pnDraw: TPanel;
    pnText: TPanel;
    sdText: TSaveDialog;
    procedure btDrawClick(Sender: TObject);
    procedure btLoadTextClick(Sender: TObject);
    procedure btSaveTextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fmDialog: TfmDialog;

implementation

{$R *.lfm}

{ TfmDialog }

procedure TfmDialog.btSaveTextClick(Sender: TObject);
var fname:string;
begin
  sdText.FileName:=fname;
if sdText.Execute then
begin
fname:=sdText.Filename;
reText.Lines.SaveToFile(fname);
end;
end;

procedure TfmDialog.FormCreate(Sender: TObject);
begin

end;

procedure TfmDialog.btDrawClick(Sender: TObject);
var fname:string;
begin
             if opdDraw.Execute then
	begin
	fname:=opdDraw.FileName;
imDraw.Picture.LoadFromFile(fname);
	end;
end;

procedure TfmDialog.btLoadTextClick(Sender: TObject);
var fname: string;
begin
     if odText.Execute then
	begin
fname:=odText.FileName;
reText.Lines.LoadFromFile(fname);
	end;
end;

end.

