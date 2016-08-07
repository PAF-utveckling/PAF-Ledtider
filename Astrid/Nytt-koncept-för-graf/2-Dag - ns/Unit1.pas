unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TMSChart,
  FMX.Controls.Presentation, FMX.Platform, FMX.StdCtrls, FMX.TMSToolBar,   UIConsts,
  FMX.TMSButton;

type
  TForm1 = class(TForm)
    Chart: TTMSFMXChart;
    Button1: TButton;
    Button2: TButton;
    TMSFMXToolBar1: TTMSFMXToolBar;
    ClearButton: TTMSFMXButton;
    procedure FormCreate(Sender: TObject);
    procedure ClearValues;
    procedure GenerateValues;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
  private
    { Private declarations }
    // Antal serier.
    AntalSerier: Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  //count : Integer;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.SmXhdpiPh.fmx ANDROID}

procedure TForm1.Button1Click(Sender: TObject);
begin
  GenerateValues;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.ClearButtonClick(Sender: TObject);
begin
  ClearValues;
end;

procedure TForm1.ClearValues;
var j: Integer;
begin
    for j := 0 to Chart.series.Count - 1 do
        Chart.Series[j].Points.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  //Chart.Clear;

  Chart.BeginUpdate;
  //Chart.Clear;
  Chart.Title.Text := 'DVT ledtider: ' + DateToStr(Now);
  Chart.Title.Height := 30;
  {$if compilerversion > 26}
  Chart.Title.TextHorizontalAlignment := TTextAlign.Leading;
  {$else}
  Chart.Title.TextHorizontalAlignment := TTextAlign.taLeading;
  {$endif}
  Chart.Title.FontColor := claDarkslategray;
  Chart.Title.Stroke.Color := claDarkslategray;
  Chart.Title.Font.Size := 16;
  Chart.Title.Font.Style := Chart.Title.Font.Style + [TFontStyle.fsBold];
  Chart.Legend.Position := lpTopRight;
  Chart.Legend.Left := -3;
  Chart.Legend.Top := 3;
  Chart.Legend.Font.Size := 10;
  Chart.Legend.Visible := True;
  Chart.Legend.FontColor := claDarkslategray;
  Chart.Legend.Stroke.Color := claDarkslategray;
  Chart.YAxis.Stroke.Color := claDarkslategray;
  Chart.XAxis.Stroke.Color := claDarkslategray;
  Chart.YAxis.Positions := [ypLeft];
  Chart.XAxis.Positions := [xpBottom];
  Chart.Stroke.Color := claDarkslategray;
  Chart.Fill.Color := claWhite;

  Chart.SeriesMargins.Left := 0;
  Chart.SeriesMargins.Top := 0;
  Chart.SeriesMargins.Right := 0;
  Chart.SeriesMargins.Bottom := 0;


  AntalSerier := 2;
  Chart.Series.Clear;
  for i:=0 to AntalSerier -1 do
    Chart.Series.Add.ChartType:=ctStackedBar;;

  // Justera X axeln så att deb visar hela timmar
  for i := 0 to Chart.series.Count - 1 do
  begin
    with Chart.Series[i] do
    begin

      YValues.MajorUnit := StrToTime('1:00');
      XValues.MajorUnit := StrToTime('1:00');
      MaxY := StrToTime('5:00');
    end;
  end;
  Button2.Position.X := Form1.Height-Button2.Width + 2;
  Button2.Position.Y := 2;
  Button1.Position.X := 2;
  Button1.Position.Y := 2;
  GenerateValues;
  Chart.EndUpdate;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Chart.BeginUpdate;
  Button2.Position.X := Form1.Width-Button2.Width;
  Button2.Position.Y := 2;
end;

procedure TForm1.GenerateValues;
var
  AntPunkter, i, j, a : Integer; hour, min : String;
  MaxTime, MinTime : TTime;
  Brush: TBrush;
begin
  Chart.BeginUpdate;
  Brush:=TBrush.Create(TBrushKind.Solid,TAlphaColorRec.darkblue);
  //Chart.clear;
  //Brush:=Tbrush.Create;
  // Här en mer generell hantering av rensning av diagrammen
  // Det som är bra med det är att den fungerar oavsett hur många serier
  // det finns 0 - n. (Även om inge serie finns :) )
  // 2016-07-25 /NS
  //for j := 0 to Chart.series.Count - 1 do
  //      Chart.Series[j].Points.Clear;
  AntPunkter:= 10 + Random(5);
  Chart.BeginUpdate;
  MaxTime := StrToTime('0:00');
  MinTime := StrToTime('23:00');
  AntPunkter := Random(5)+10;
  //Brush.Color:=TAlphaColor($00008B);
  for i := 0 to AntPunkter - 1 do
  begin
    hour := IntToStr(random(4));
    min := IntToStr(random(60));
    if length(min)=1 then min := '0'+min;
    //Chart.Series[0].Fill:=Brush;
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
    Chart.Series[i].MinX := MinTime - StrToTime('2:00:00');
    //ShowMessage('4b');
  end;
  Chart.EndUpdate;
  Brush.Destroy
end;

end.
