unit TabbedTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Gestures, FMX.TMSChart, FMX.Controls.Presentation,
  FMX.TMSButton, UIConsts;

type
  TTabbedForm = class(TForm)
    HeaderToolBar: TToolBar;
    ToolBarLabel: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    GestureManager1: TGestureManager;
    ChartDVT: TTMSFMXChart;
    ButtonClear: TTMSFMXButton;
    ButtonNya: TTMSFMXButton;
    procedure FormCreate(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure ButtonNyaClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
  private
    { Private declarations }
    procedure  GenerateValues;
    procedure SetUpGraph;
    procedure ClearValues;

  public
    { Public declarations }
  end;

var
  TabbedForm: TTabbedForm;

implementation

{$R *.fmx}
{$R *.Surface.fmx MSWINDOWS}

procedure TTabbedForm.GenerateValues;
var
  AntPunkter, i, j, a, AntSerier : Integer;
  hour, min : String;
  MaxTime, MinTime : TTime;
  s: array [0..1] of TTMSFMXChartSerie;
begin

  MaxTime := StrToTime('0:00');
  MinTime := StrToTime('23:00');
  AntPunkter := Random(5)+10;
  AntSerier := 2;
  ChartDVT.BeginUpdate;

  ChartDVT.Series.Clear;

  // Justera X axeln så att den visar hela timmar
  for i := 0 to AntSerier - 1 do
  begin
    s[i] := ChartDVT.Series.Add;

    //s[i].YValues.MajorUnitFormatType := vftDateTime;

    //s[i].XValues.MajorUnit := StrToTime('1:00');
    //s[i].MaxY := StrToTime('5:00');
  end;
  //s[0].YValues.MajorUnitFormat := 'hhmm';
  //s[0].YValues.MajorUnit := 1; //StrToTime('1:00');
  //s[1].YScale := nil;

  for i := 0 to AntPunkter - 1 do
  begin
    hour := IntToStr(random(4));
    min := IntToStr(random(60));

    if length(min)=1 then
      min := '0' + min;

    if StrToTime(hour+':'+min) < StrToTime('2:01') then
      begin
        s[0].AddPoint(StrToTime(hour+':'+min),0,'');
        s[1].AddPoint(StrToTime('0:00'),0,'');
      end
    else
      begin
        hour := IntToStr(StrToInt(hour)-2);
        s[0].AddPoint(StrToTime('2:00'),0,'');
        s[1].AddPoint(StrToTime(hour+':'+min),0,'');
      end;

    case i of
     0 : begin
           s[i].Fill.Color := claLavender;
           s[i].Fill.Kind := TBrushKind.Solid;
          end;
     1 : begin
           s[i].Fill.Color := claRed;
           s[i].Fill.Kind := TBrushKind.Solid;
         end;
    end;
    (*
    hour := IntToStr(6+random(12));
    min := IntToStr(random(60)); *)
    if length(min)=1 then min := '0'+min;
    if StrToTime(hour+':'+min) < MinTime then MinTime := StrToTime(hour+':'+min);
    if StrToTime(hour+':'+min) > MaxTime then MaxTime := StrToTime(hour+':'+min);
  end;

  for i := 0 to ChartDVT.Series.Count -1 do
  begin
    with s[i] do
    begin
      AutoYrange := arEnabled;
      AutoXRange:= arEnabled;
      Points[i].XValue := StrToTime(hour+':'+min);
      //MaxX := MaxTime + StrToTime('2:00:00');
      MaxX := StrToTime('20:00');
      MinX := StrToTime('06:00');
      //MinX := MinTime - StrToTime('2:00:00');
      ChartType := ctStackedBar;
      YValues.MajorUnit := StrToTime('01:00');
      XValues.MajorUnit := StrToTime('01:00');
      MaxY := StrToTime('5:00');
    end;
  end;

  ChartDVT.EndUpdate;
end;

procedure TTabbedForm.SetUpGraph;
var
  i: Integer;
begin

  ChartDVT.BeginUpdate;
  ChartDVT.Title.Text := 'DVT ledtider: ' + DateToStr(Now);
  ChartDVT.Title.Height := 30;
  // Justera X axeln så att den visar hela timmar

  ChartDVT.EndUpdate;
end;

procedure TTabbedForm.ButtonClearClick(Sender: TObject);
begin
  ClearValues;
end;

procedure TTabbedForm.ButtonNyaClick(Sender: TObject);
begin
  ClearValues;
  GenerateValues;
end;

procedure TTabbedForm.ClearValues;
var j: Integer;
begin
   //ChartDVT.Series.Clear;
  for j := 0 to ChartDVT.series.Count - 1 do
     ChartDVT.Series[j].Points.Clear;
end;

procedure TTabbedForm.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl1.ActiveTab := TabItem1;
  ClearValues;
  SetUpGraph;
  GenerateValues;
end;

procedure TTabbedForm.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
{$IFDEF ANDROID}
  case EventInfo.GestureID of
    sgiLeft:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount-1] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex+1];
      Handled := True;
    end;

    sgiRight:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex-1];
      Handled := True;
    end;
  end;
{$ENDIF}
end;

end.
