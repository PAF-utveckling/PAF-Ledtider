unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSBaseControl, FMX.TMSGridCell, FMX.TMSGridOptions, FMX.TMSGridData,
  FMX.TMSCustomGrid, FMX.TMSGrid, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TMSChart, Math;

type
  TForm1 = class(TForm)
    Grid: TTMSFMXGrid;
    FyllGrid: TButton;
    Chart: TTMSFMXChart;
    FyllChart: TButton;
    function TimeExt(Time : String): Extended;
    procedure InsertToGrid;
    procedure FormatGrid;
    procedure FyllGridClick(Sender: TObject);
    procedure FyllChartClick(Sender: TObject);
    procedure SlumpaStarttid;
    procedure SlumpaSkillnad;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  StartTid, Skillnad : array[0..9] of String;
  StartTidH, SkillnadH : array[0..9] of Extended;
  OmAvslutad : array[0..9] of Boolean;

implementation

{$R *.fmx}

procedure TForm1.SlumpaStarttid;
var
i : Integer; hour, minute, Tid : string;
begin
  for i := 0 to 9 do
  begin
    hour := IntToStr(6 + random(13));
    minute := IntToStr(random(59));
    if length(hour) = 1 then hour := '0'+hour;
    if length(minute) = 1 then minute := '0'+minute;
    Unit1.StartTid[i] := hour+':'+minute;
    Unit1.StartTidH[i] := TimeExt(Unit1.StartTid[i]);
    if (Unit1.StartTidH[i]>15) AND (random(2)=1) then OmAvslutad[i] := False
    else OmAvslutad[i] := True;
  end;
end;

procedure TForm1.SlumpaSkillnad;
var
i, minut, timme : Integer; hour, min : String;
begin
  for i := 0 to 9 do
  begin
    if OmAvslutad[i] then
    begin
      hour := IntToStr(random(4));
      min := IntToStr(random(59));
      if length(hour)=1 then hour := '0'+hour;
      if length(min)=1 then min := '0'+min;
      Unit1.Skillnad[i] := hour+':'+min;
      Unit1.SkillnadH[i] := TimeExt(Unit1.Skillnad[i]);
    end
    else
    begin
      minut := 60-StrToInt(copy(Unit1.StartTid[i],4,2));
      if minut = 0 then timme := 21-StrToInt(copy(Unit1.StartTid[i],1,2))
      else timme := 20-StrToInt(copy(Unit1.StartTid[i],1,2));
      hour := IntToStr(timme);
      min := IntToStr(minut);
      if length(hour)=1 then hour := '0'+hour;
      if length(min)=1 then min := '0'+min;
      Unit1.Skillnad[i] := hour+':'+min;
      Unit1.SkillnadH[i] := TimeExt(Unit1.Skillnad[i]);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i, k : Integer;
begin
  for i := 0 to 9 do
  begin
    for k := 0 to 1 do Chart.Series[k].Points[i].XValue := 20;
    Chart.Series[0].Points[i].Color := TAlphaColorRec.Gray;
    Chart.Series[1].Points[i].Color := TAlphaColorRec.DarkRed;
  end;
  FormatGrid;
end;

procedure TForm1.FyllChartClick(Sender: TObject);
var
  i, j : Integer;
begin
  if Grid.Cells[1,1] = '' then
  begin
    ShowMessage('Generera värden först');
    Exit;
  end;
  with Chart do
  begin
    for i := 0 to 9 do
    begin
      if NOT OmAvslutad[i] then
      begin
        Series[1].Points[i].Color := TAlphaColorRec.Red;
        Series[0].Points[i].Color := TAlphaColorRec.LtGray;
      end
      else
      begin
        Series[1].Points[i].Color := TAlphaColorRec.DarkRed;
        Series[0].Points[i].Color := TAlphaColorRec.Gray;
      end;
      with Series[0].Points[i] do
      begin
        XValue := StartTidH[i];
        if SkillnadH[i]>2 then YValue := 2
        else YValue := SkillnadH[i];
      end;
      for j := 0 to 1 do
      begin
        Series[j].MaxX := MaxValue(StartTidH)+0.5;
        Series[j].MinX := MinValue(StartTidH)-0.5;
        Series[j].MaxY := MaxValue(SkillnadH)+0.5;
      end;
      with Series[1].Points[i] do
      begin
        XValue := StartTidH[i];
        if SkillnadH[i]>2 then YValue := SkillnadH[i]-2
        else YValue := 0;
      end;
    end;
  end;
end;

procedure TForm1.FyllGridClick(Sender: TObject);
begin
  SlumpaStarttid;
  SlumpaSkillnad;
  InsertToGrid;
end;

procedure TForm1.FormatGrid;
var
  i : Integer;
begin
  Grid.Cells[1,0] := 'Starttid';
  Grid.Cells[2,0] := 'Skillnad';
  Grid.Cells[3,0] := '(H) Starttid';
  Grid.Cells[4,0] := '(H) Skillnad';
  Grid.Cells[5,0] := 'Om Avslutad';

  Grid.Columns[4].Width := 80;
  Grid.Columns[3].Width := 75;
  Grid.Columns[5].Width := 80;
  Grid.Columns[0].Width := 0;

  Grid.ColumnCount := 6;
  Grid.RowCount := 11;

  Grid.Width := 18;
  for i := 1 to 5 do Grid.Width := Grid.Width+Grid.Columns[i].Width;
  Grid.Height := Grid.DefaultRowHeight*Grid.RowCount;
end;

procedure TForm1.InsertToGrid;
var
  i: Integer;
begin
  for i := 0 to 9 do
  begin
    Grid.Cells[1,i+1] := Unit1.StartTid[i];
    Grid.Cells[2,i+1] := Unit1.Skillnad[i];
    Grid.Cells[3,i+1] := FloatToStr(Unit1.StartTidH[i])+' h';
    Grid.Cells[4,i+1] := FloatToStr(Unit1.SkillnadH[i])+' h';
    if Unit1.OmAvslutad[i] then Grid.Cells[5,i+1] := 'Ja'
    else Grid.Cells[5,i+1] := 'Nej';
  end;
end;

function TForm1.TimeExt(Time : String): Extended;
var
  hour, min : Integer;
begin
  hour := StrToInt(copy(Time,1,2));
  min := StrToInt(copy(Time,4,2));
  Result := hour + 0.01*Round(10 * min div 6);
end;

end.
