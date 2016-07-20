unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TMSChart,
  FMX.Controls.Presentation, FMX.Platform, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Chart: TTMSFMXChart;
    Button1: TButton;
    Button2: TButton;
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

    for i := 0 to 1 do
    begin
      with Chart.Series[i] do
      begin
        YValues.MajorUnit := StrToTime('1:00');
        XValues.MajorUnit := StrToTime('1:00');
        MaxY := StrToTime('5:00');
      end;
    end;
    Form1.FullScreen := True;
    Chart.Width := Screen.Width;
    Chart.Height := Screen.Height;
    Chart.Position.X := 0;
    Chart.Position.Y := 0;
    Button2.Position.X := Form1.Height-Button2.Width;
    Button2.Position.Y := 0;
    Button1.Position.X := 0;
    Button1.Position.Y := 0;
    GenerateValues;
    Chart.Title.Text := DateToStr(Now);
  except
    ShowMessage('FormCreate');
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  try
    Button2.Position.X := Form1.Width-Button2.Width;
    Button2.Position.Y := 0;
    Chart.Width := Screen.Width;
    Chart.Height := Screen.Height;
    if Screen.Width<Screen.Height then Chart.Visible := False
    else Chart.Visible := True;
  except
    ShowMessage('FormResize');
  end;
end;

procedure TForm1.GenerateValues;
var
  i, j, a : Integer; hour, min : String; MaxTime, MinTime : TTime;
begin
  a := 0;
  try
    for j := 0 to 1 do
    begin
      try
        for i := a to Unit1.count do Chart.Series[j].Points[i div 16].Destroy;
      except
        ShowMessage('Serie '+IntToStr(j)+', punkt '+IntToStr(i));
      end;
    end;
  except
    ShowMessage('1');
  end;

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

end;

end.
