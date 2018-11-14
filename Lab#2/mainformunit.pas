unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, DesignTimeUnit, RunTimeUnit;

type

  { TMainForm }

  TMainForm = class(TForm)
    Design_button: TButton;
    Runtime_button: TButton;
    procedure designClick(Sender: TObject);
    procedure runtimeClick(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.designClick(Sender: TObject);
begin
     DesignTimeForm.Show;
end;

procedure TMainForm.runtimeClick(Sender: TObject);
begin
     RunTimeForm.Show;
end;



end.

