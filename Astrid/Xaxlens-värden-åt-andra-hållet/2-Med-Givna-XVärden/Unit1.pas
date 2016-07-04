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
    Chart2: TTMSFMXChart;
    procedure InsertToChart;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  InsertToChart;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Chart.BeginUpdate;
  Chart2.BeginUpdate;
  Chart.Series[0].MaxX := -0.5;
  Chart.Series[0].MinX := -15;
  Chart2.Series[0].MaxY := -Chart.Series[0].MinX/1.095; // Eftersom den automatiskt lägger till 9,5% till det värde man väljer
  Chart2.Series[0].MinY := -Chart.Series[0].MaxX-1;
  Chart2.Height := Chart.Width;
  Chart.EndUpdate;
  Chart2.EndUpdate;
end;

procedure Tform1.InsertToChart;
var
  i : Integer;
begin
  Chart.BeginUpdate;
  for i := 0 to 14 do Chart.Series[0].Points[i].YValue := 2+random(8);
  Chart.EndUpdate;
end;

end.
