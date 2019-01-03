unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, task_unit, memoryBlock_unit, Contnrs, Math, Unit2, Unit3;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnMemory: TButton;
    btnAddTask: TButton;
    btnChart: TButton;
    btnCanvas: TButton;
    editName: TEdit;
    editSize: TEdit;
    editMemory: TEdit;
    editDuration: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    TimeLabel: TLabel;
    Label4: TLabel;
    ListView1: TListView;
    Memo1: TMemo;
    StartButton: TButton;
    Switcher: TRadioGroup;
    Timer1: TTimer;

    procedure btnAddTaskClick(Sender: TObject);
    procedure btnCanvasClick(Sender: TObject);
    procedure btnChartClick(Sender: TObject);
    procedure btnMemoryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure SwitcherClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    function isNum(str: string): boolean;
    procedure printMemory(Place: TStrings);
    procedure printTasks(status: string);
    procedure updateTasks;

  private
    sw: string;
    Queue: TObjectList;
    Memory: MemoryBlock;
    tChartGr: TForm2;
    tCanvasGr: TForm3;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.isNum(str: string): boolean;
var num: integer;
begin
  try
    num := StrToInt(str);
  except
    On EConvertError do begin
    ShowMessage('Введите число!');
    Result := False;
    Exit(Result);
    end;
  end;
  if (num > 0) then
    Result := True
  else begin
    ShowMessage('Введите число больше нуля!');
    Result := False;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i: integer;
begin
  ListView1.Columns.Add.Caption:='Задача';
  ListView1.Columns.Add.Caption:='Размер';
  ListView1.Columns.Add.Caption:='Время';
  ListView1.Columns.Add.Caption:='Старт';
  ListView1.Columns.Add.Caption:='Статус';

  Queue := TObjectList.Create;
  sw := 'all';

  for i:=0 to ListView1.ColumnCount-1 do
      ListView1.Columns[i].Width:=Floor(Form1.Width/(ListView1.ColumnCount));

end;

procedure TForm1.FormResize(Sender: TObject);
var i: integer;
begin
  for i:=0 to ListView1.ColumnCount-1 do
        ListView1.Columns[i].Width:=Floor(Form1.Width/(ListView1.ColumnCount));
end;

procedure TForm1.printMemory(Place: TStrings);
begin
    Place[0] := MemoryBlock(Memory).ByteLine;
end;

procedure TForm1.btnMemoryClick(Sender: TObject);
begin
  if (isNum(editMemory.Text) = True) then begin
     Memory := MemoryBlock.Create(StrToInt(editMemory.Text));
     printMemory(Memo1.Lines);
     btnAddTask.Enabled := True;
     btnMemory.Enabled := False;
     editMemory.Enabled := False;
     btnMemory.Caption := 'Память выделена';
     StartButton.Enabled := True;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Queue.Free;
  Memory.Free;
  tChartGr.Free;
  tCanvasGr.Free;

end;

procedure TForm1.btnAddTaskClick(Sender: TObject);
var addedTask: Task;
begin
  if ((isNum(editSize.Text) = True) and (isNum(editDuration.Text)) = True) then begin
     if (editName.Text = '') then
       ShowMessage('Введите имя задачи!')
     else begin
       Queue.Add(Task.Create(editName.Text, StrToInt(editSize.Text), StrToInt(editDuration.Text)));
       if StartButton.Enabled = False then
          Task(Queue[Queue.Count - 1]).TaskStart(StrToInt(TimeLabel.Caption), Memory);
       printTasks(sw);
     end;
     printMemory(Memo1.Lines);
  end;
end;

procedure TForm1.btnCanvasClick(Sender: TObject);
begin
  tCanvasGr.Show;
end;

procedure TForm1.btnChartClick(Sender: TObject);
begin
  tChartGr.Show;
end;

procedure TForm1.printTasks(status: string);
var i: integer;
ListItem:TListItem;
begin
  ListView1.Clear;
  if status = 'all' then begin
    for i:= 0 to Queue.Count-1 do begin
      ListItem := ListView1.Items.Add;
      ListItem.Caption:=Task(Queue[i]).TaskName;
      ListItem.SubItems.Add(inttostr(Task(Queue[i]).TaskSize));
      ListItem.SubItems.Add(inttostr(Task(Queue[i]).TaskTotalTime));
      ListItem.SubItems.Add(Task(Queue[i]).TaskStartTime);
      ListItem.SubItems.Add(Task(Queue[i]).TaskStatus);
    end;
  end
  else begin
      for i:=0 to Queue.Count-1 do
    begin
      if((Task(Queue[i]).TaskStatus = status) and (status = sw)) then
      begin
       ListItem := ListView1.Items.Add;
       ListItem.Caption:=Task(Queue[i]).TaskName;
       ListItem.SubItems.Add(inttostr(Task(Queue[i]).TaskSize));
       ListItem.SubItems.Add(inttostr(Task(Queue[i]).TaskTotalTime));
       ListItem.SubItems.Add(Task(Queue[i]).TaskStartTime);
       ListItem.SubItems.Add(Task(Queue[i]).TaskStatus);
       end;
    end;
  end;
end;


procedure TForm1.UpdateTasks;
var i: integer;
    ListItem: TListItem;
begin
  for i:=0 to Queue.Count-1 do begin
    ListItem := ListView1.Items[i];
    if ListItem <> nil then begin
     ListItem.SubItems[1] := inttostr(Task(Queue[i]).TaskTotalTime);
     ListItem.SubItems[3] := Task(Queue[i]).TaskStatus;
     if(Task(Queue[i]).isComplete()) then
       begin
         Task(Queue[i]).FreeMemoryBlock(Memory);
       end;
    end;
    if Task(Queue[i]).isInQueue() then
      Task(Queue[i]).TaskStart(StrToInt(TimeLabel.Caption), Memory);
  end;
  printTasks(sw);
  printMemory(Memo1.Lines);
end;

procedure TForm1.StartButtonClick(Sender: TObject);
var i: integer;
begin
  if Queue.Count = 0 then begin
     ShowMessage('Введите задачу!');
     Exit;
  end;
  Timer1.Enabled := True;
  StartButton.Enabled := False;
  if Queue <> nil then
     for i := 0 to Queue.Count-1 do
         Task(Queue[i]).TaskStart(StrToInt(TimeLabel.Caption), Memory);
  tChartGr:=TForm2.Create(Self);
  tCanvasGr:= TForm3.Create(Self);
  tChartGr.SetStartSet;
  tCanvasGr.setStartSet;
  btnChart.Enabled := True;
  btnCanvas.Enabled := True;
  StartButton.Caption := 'Процесс запущен';
end;

procedure TForm1.SwitcherClick(Sender: TObject);
begin
  case Switcher.ItemIndex of
  0 : sw := 'all';
  1 : sw := 'Выполняется';
  2 : sw := 'В очереди';
  3 : sw := 'Завершена';
  end;
  printTasks(sw);
  printMemory(Memo1.Lines);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i, usedMemory: integer;
begin
  Memo1.Lines.Clear;
  printMemory(Memo1.Lines);
  updateTasks;
  usedMemory := 0;
  for i:=1 to Memory.MbTotal do
      if Memory.MbBytes[i] = '1' then
        usedMemory := usedMemory + 1;
  TimeLabel.Caption := IntToStr(StrToInt(TimeLabel.Caption) + 1);
    tChartGr.addPoint(usedMemory);
    tCanvasGr.addPoint(usedMemory);
end;





end.

