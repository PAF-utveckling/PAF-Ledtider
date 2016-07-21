unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TMSChart,
  FMX.Controls.Presentation, FMX.Platform, FMX.StdCtrls, FMX.TMSToolBar;

type
  TForm1 = class(TForm)
    Chart: TTMSFMXChart;
    Button1: TButton;
    Button2: TButton;
    TMSFMXToolBar1: TTMSFMXToolBar;
    procedure FormCreate(Sender: TObject);
    procedure GenerateValues;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  count : Integer;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  try
    GenerateValues;
  except
    ShowMessage('Button1Click');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  try
    Form1.Close;
  except
    ShowMessage('Button2Click');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  try
    Unit1.count := 10;

    // Justera X axeln så att deb visar hela timmar
    for i := 0 to 1 do
    begin
      with Chart.Series[i] do
      begin
        YValues.MajorUnit := StrToTime('1:00');
        XValues.MajorUnit := StrToTime('1:00');
        MaxY := StrToTime('5:00');
      end;
    end;
    //Form1.FullScreen := True;
    //Chart.Width := Screen.Width;
    //Chart.Height := Screen.Height;
    //Chart.Position.X := 0;
    //Chart.Position.Y := 0;
    Button2.Position.X := Form1.Height-Button2.Width + 2;
    Button2.Position.Y := 2;
    Button1.Position.X := 2;
    Button1.Position.Y := 2;
    GenerateValues;
    Chart.Title.Text := 'DVT ledtider: ' + DateToStr(Now);
  except
    ShowMessage('FormCreate error');
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Chart.BeginUpdate;
  try
    Button2.Position.X := Form1.Width-Button2.Width;
    Button2.Position.Y := 0;
    //Chart.Width := Screen.Width;
    //Chart.Height := Screen.Height;
    //if Screen.Width<Screen.Height then Chart.Visible := False
    //else Chart.Visible := True;
  except
    ShowMessage('FormResize');
  end;
  Chart.EndUpdate;
end;

procedure TForm1.GenerateValues;
var
  i, j, a : Integer; hour, min : String; MaxTime, MinTime : TTime;
begin
  Chart.BeginUpdate;
  //try
    for j := 0 to 1 do
    begin
      try
        //for i := a to Unit1.count do Chart.Series[j].Points[i div 16].Destroy;
        for i := 0 to Unit1.count-1 do Chart.Series[j].Points[i].Free;
        //Chart.Clear;

      except
        ShowMessage('Serie '+IntToStr(j)+', punkt '+IntToStr(i));
        ShowMessage('1')
      end;
    end;
  //except


  try
    MaxTime := StrToTime('0:00');
    MinTime := StrToTime('23:00');
    Unit1.count := Random(5)+10;
  except
    ShowMessage('2*');
  end;

  try
    for i := a to Unit1.count do
    begin
      hour := IntToStr(random(4));
      min := IntToStr(random(60));
      if length(min)=1 then min := '0'+min;

      if StrToTime(hour+':'+min)<StrToTime('2:01') then
      begin
        Chart.Series[0].AddPoint(StrToTime(hour+':'+min),0,'');
        Chart.Series[1].AddPoint(StrToTime('0:00'),0,'');
      end
      else
      begin
        hour := IntToStr(StrToInt(hour)-2);
        Chart.Series[0].AddPoint(StrToTime('2:00'),0,'');
        Chart.Series[1].AddPoint(StrToTime(hour+':'+min),0,'');
      end;

      hour := IntToStr(6+random(12));
      min := IntToStr(random(60));
      if length(min)=1 then min := '0'+min;
      if StrToTime(hour+':'+min)<MinTime then MinTime := StrToTime(hour+':'+min);
      if StrToTime(hour+':'+min)>MaxTime then MaxTime := StrToTime(hour+':'+min);

      Chart.Series[0].Points[i].XValue := StrToTime(hour+':'+min);
      Chart.Series[1].Points[i].XValue := StrToTime(hour+':'+min);
    end;

  except
    ShowMessage('3');
  end;

  try
    for i := 0 to 1 do
    begin
      try
        Chart.Series[i].MaxX := MaxTime + StrToTime('2:00');
      except
        ShowMessage('4a');
      end;

      try
        Chart.Series[i].MinX := MinTime - StrToTime('2:00:00');
      except
        ShowMessage('4b');
      end;
    end;
  except
    ShowMessage('4');
  end;
  Chart.EndUpdate;
end;

end.
