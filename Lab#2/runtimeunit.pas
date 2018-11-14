unit RunTimeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComponentManagerUnit;

type

  { TRunTimeForm }

  TRunTimeForm = class(TForm)
      procedure ShowForm(Sender: TObject);
      procedure CloseForm(Sender: TObject);
  private
      ComponentManager: TComponentManager;
  public

  end;

var
  RunTimeForm: TRunTimeForm;

implementation

{$R *.lfm}

procedure TRunTimeForm.ShowForm(Sender: TObject);
begin
  ComponentManager := TComponentManager.Create;
end;

procedure TRunTimeForm.CloseForm(Sender: TObject);
begin
  ComponentManager.Destroy;
end;

end.

