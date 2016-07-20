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

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  GenerateValues;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : Integer;
  ScreenService: IFMXScreenService;
  OrientSet: TScreenOrientations;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.soLandscape];
    ScreenService.SetScreenOrientation(OrientSet);
  end;

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
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Button2.Position.X := Form1.Width-Button2.Width;
  Button2.Position.Y := 0;
  Chart.Width := Screen.Width;
  Chart.Height := Screen.Height;
end;

procedure TForm1.GenerateValues;
var
  i, j, count : Integer; hour, min : String; MaxTime, MinTime : TTime;
begin
  count := Chart.Series[0].Points.Count;
  for j := 0 to 1 do for i := 0 to count-1 do Chart.Series[j].Points[i div count].Free;

  MaxTime := StrToTime('0:00');
  MinTime := StrToTime('23:00');
  count := Random(5)+10;

  for i := 0 to count do
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
  for i := 0 to 1 do
  begin
    Chart.Series[i].MaxX := MaxTime + StrToTime('2:00');
    Chart.Series[i].MinX := MinTime - StrToTime('2:00');
  end;
end;

end.
