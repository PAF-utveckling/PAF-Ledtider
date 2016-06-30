unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSBaseControl, FMX.TMSGridCell, FMX.TMSGridOptions, FMX.TMSGridData,
  FMX.TMSCustomGrid, FMX.TMSGrid, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, System.Actions, FMX.ActnList, FMX.TMSChart, Math;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Grid: TTMSFMXGrid;
    TabControl2: TTabControl;
    TabItem5: TTabItem;
    ToolBar1: TToolBar;
    lblTitle1: TLabel;
    btnNext: TSpeedButton;
    TabItem6: TTabItem;
    ToolBar2: TToolBar;
    lblTitle2: TLabel;
    btnBack: TSpeedButton;
    ActionList1: TActionList;
    PreviousTabAction1: TPreviousTabAction;
    NextTabAction1: TNextTabAction;
    Chart1: TTMSFMXChart;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure SlumpaStarttid;
    procedure SlumpaSluttid;
    procedure InsertToGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormatChart;
    procedure InsertToChart(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    function TimeExt(Time : TTime): Extended;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Time1, Time2, TotTime : Array[1..10] of string;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  SlumpaStarttid;
  SlumpaSluttid;
  InsertToGrid;
end;

procedure TForm1.SlumpaStarttid;
var
i : Integer; hour, minute, Tid : string;
begin
  for i := 1 to 10 do
  begin
    hour := IntToStr(6 + random(14));
    minute := IntToStr(random(59));
    if length(hour) = 1 then hour := '0'+hour;
    if length(minute) = 1 then minute := '0'+minute;
    Unit1.Time1[i] := hour+':'+minute;
  end;
end;

procedure TForm1.SlumpaSluttid;
var
i : Integer; hour, minute : String;
begin
  for i := 1 to 10 do
  begin
    hour := IntToStr(random(3)+StrToInt(copy(Unit1.Time1[i],1,2)));
    minute := IntToStr(random(59)+StrToInt(copy(Unit1.Time1[i],4,2)));
    if StrToInt(minute) > 59 then
    begin
      minute := IntToStr(StrToInt(minute)-60);
      hour := IntToStr(StrToInt(hour)+1);
    end;
    if length(hour) = 1 then hour := '0'+hour;
    if length(minute) = 1 then minute := '0'+minute;
    Unit1.Time2[i] := hour+':'+minute;
    Unit1.TotTime[i] := copy(TimeToStr(StrToTime(Unit1.Time2[i]) - StrToTime(Unit1.Time1[i])),1,5);

    if (random(10)>4) AND (StrToInt(hour)>15) then
    begin
      Unit1.Time2[i] := '-';
      Unit1.TotTime[i] := copy(TimeToStr(StrToTime('23:59') - StrToTime(Unit1.Time1[i])),1,5);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
FormatChart;
end;

procedure TForm1.InsertToGrid;
var
i : Integer; Time : TTIme;
begin
  Grid.Cells[1,0] := 'Starttid';
  Grid.Cells[2,0] := 'Sluttid';
  Grid.Cells[3,0] := 'Beräknad tid';
  Grid.Columns[3].Width := 86;

  Grid.RowCount := 11;
  for i := 1 to 10 do
  begin
    Grid.Cells[1,i] := Unit1.Time1[i];
    Grid.Cells[2,i] := Unit1.Time2[i];
    Grid.Cells[3,i] := Unit1.TotTime[i];
  end;
end;

procedure TForm1.InsertToChart(Sender: TObject);
var
i, j : Integer; Bool : Boolean;
begin
  if Grid.Cells[1,1] = '' then
  begin
    ShowMessage('Börja med att generera värden');
    Exit;
  end;

  with Chart1 do
  begin
    BeginUpdate;
    for i := 0 to 9 do
    begin
      if Grid.Cells[2,i+1] = '-' then
      begin
        Series[0].Points[i].Color := TAlphaColorRec.LtGray;
        Series[1].Points[i].Color := TAlphaColorRec.Red;
      end;

      if StrToTime(Grid.Cells[3,i+1])>StrToTime('02:00') then
      begin
        Series[1].Points[i].YValue := TimeExt(StrToTime(Grid.Cells[3,i+1]));
        Series[0].Points[i].YValue := 2;
        Chart1.Series[1].Points[i].XValue := Chart1.Series[0].Points[i].XValue;      // DEN FLYTTAS INTE TILL RÄTT STÄLLE
      end
      else
      begin
        Series[0].Points[i].YValue := TimeExt(StrToTime(Grid.Cells[3,i+1]));
        Series[1].Points[i].YValue := 0;
        Chart1.Series[1].Points[i].XValue := 0;
      end;
      Series[0].Points[i].XValue := TimeExt(StrToTime(Grid.Cells[1,i+1]));
    end;
    EndUpdate;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
Time : array[1..10] of Extended; i, j : Integer;
begin
  if Grid.Cells[1,1] = '' then
  begin
    ShowMessage('Börja med att generera värden');
    Exit;
  end;

  for i := 1 to 10 do Time[i] := TimeExt(StrToTime(Unit1.TotTime[i]));

  for j := 0 to 1 do
  begin
  with Chart1.Series[j] do
    begin
      MinX := 5.5;
      MaxX := 24;
      MaxY := MaxValue(Time)+1;
    end;
  end;
end;

procedure TForm1.FormatChart;
var
i, j : Integer;
begin
  with Chart1 do
  begin
    BeginUpdate;
    RotationAngle := 90;
    Width := (Form1.Height-ToolBar1.Height)*0.8;
    Title.Visible := False;

    for j := 0 to 1 do
    begin
      with Series[j] do
      begin
        Visible := True;
        Labels.Visible := True;
        LegendText := '';
        Markers.Visible := False;
        Bar.Width := 15;
        Xvalues.Angle := 270;
      end;
    end;

    Series[0].Fill.Color := TAlphaColorRec.DkGray;
    Series[1].Fill.Color := TAlphaColorRec.DarkRed;

    EndUpdate;
  end;
end;

function TForm1.TimeExt(Time : TTime): Extended;
var
hour, minute : Integer;
begin
  hour := StrToInt(copy(TimeToStr(Time),1,2));
  minute := StrToInt(copy(TimeToStr(Time),4,2));
  Result := hour + 0.01*Round(10 * minute div 6);
end;

end.
