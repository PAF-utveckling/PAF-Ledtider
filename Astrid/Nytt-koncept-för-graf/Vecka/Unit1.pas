unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TMSChart,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Chart: TTMSFMXChart;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure GenerateValues;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  GenerateValues;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Chart.Position.X := 0;
  Chart.Position.Y := 0;
  Form1.FullScreen := True;
  Button1.Position.Y := 0;
  Button1.Position.X := Form1.Width-Button1.Width;
  Button2.Position.Y := 0;
  Button2.Position.X := Form1.Width-Button1.Width-Button2.Width;
  Chart.Width := Form1.Width;
  Chart.Height := Form1.Height;
  GenerateValues;
end;

procedure TForm1.GenerateValues;
var
  i : Integer; MaxL, MaxG : Double;
begin
  MaxG := 0;
  for i := 0 to 6 do
  begin
    Chart.Series[0].Points[i].YValue := 1+Random(4);
    Chart.Series[1].Points[i].YValue := 1+Random(4);
    MaxL := Chart.Series[0].Points[i].YValue + Chart.Series[1].Points[i].YValue;
    if MaxL>MaxG then MaxG := MaxL;
  end;
  Chart.Series[0].MaxY := MaxG+3;
  Chart.Series[1].MaxY := MaxG+3;
end;

end.
