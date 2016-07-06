unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TMSChart,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Chart2: TTMSFMXChart;
    Chart: TTMSFMXChart;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormatChart;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  From, Till : TTime;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Det ska gå från
  Unit1.From := StrToTime('00:00');
  // Till
  Unit1.Till := StrToTime('11:00');
  FormatChart;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.FormatChart;
var
  i, j, AxisWidth : Integer; Charts : Array[1..2] of TTMSFMXChart;
begin
  Charts[1] := Chart;
  Charts[2] := Chart2;

  //for j := 1 to 2 do Charts[j].Series[0].YValues.MajorUnit := StrToTime('01:00');

  with Chart.Series[0] do
  begin
    XValues.MajorUnit := StrToTime('01:00');
    MinX := Unit1.From;
    MaxX := Unit1.Till;
    MaxY := StrToTime('13:00');
  end;
  with Chart2.Series[0] do
  begin
    YValues.MajorUnit := StrToTime('01:00');
    MinY := Unit1.From;
    MaxY := Unit1.Till-StrToTime('01:00');
  end;

  for i := 0 to 9 do Chart.Series[0].Points[i].XValue := Unit1.Till - StrToTime('0'+IntToStr(i+2)+':00');
  for i := 0 to 9 do Chart.Series[0].Points[i].YValue := StrToTime('0'+IntToStr(i+2)+':00');

  // Storlekar
  Form1.FullScreen := True;
  AxisWidth := 48;
  with Chart2 do
  begin
    Width := Screen.Width;
    Height := Screen.Height - Button1.Height;
    Position.X := 0;
    Position.Y := Button1.Height;
  end;
  with Chart do
  begin
    Height := Screen.Width-AxisWidth;
    Width := Screen.Height - Button1.Height;
    //Position.X := (Screen.Width-Screen.Height+Button1.Height+AxisWidth)/2;
    Position.X := (Chart.Height-Chart.Width)/2+AxisWidth;
    Position.Y := (Chart.Width-Chart.Height)/2+Button1.Height
  end;
end;

end.
