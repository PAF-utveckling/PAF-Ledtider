unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, Data.Bind.EngExt, Fmx.Bind.DBEngExt, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FMX.TMSGridDataBinding, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, FMX.TMSBaseControl,
  FMX.TMSGridCell, FMX.TMSGridOptions, FMX.TMSGridData, FMX.TMSCustomGrid,
  FMX.TMSGrid, Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TMSCustomButton, FMX.TMSBarButton, FMX.TMSChart,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Tabs: TTabControl;
    Start: TTabItem;
    DVT: TTabItem;
    TabItem3: TTabItem;
    StyleBook1: TStyleBook;
    Chart1: TTMSFMXChart;
    Label1: TLabel;
    Button2: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure GenerateValuesWeek;
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ScreenW, ScreenH : Integer;
  date : TDateTime;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  GenerateValuesWeek;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  Tabs.ActiveTab := DVT;
  Chart1.Position.X := 0;
  GenerateValuesWeek;
end;

procedure TForm1.FormResize(Sender: TObject);
var
  i : Integer;
begin
  if Screen.Height>Screen.Width then
  begin
    Chart1.Visible := True;
    Label1.Visible := False;
    Button2.Visible := True;
    //Chart1.Height := Screen.Height-DVT.Height;   // Dator
    Chart1.Height := Screen.Height;              // Mobil
    Chart1.Width := Form1.Width;
    Tabs.Height := Screen.Height+DVT.Height;
    Tabs.Width := Screen.Width;
  end
  else
  begin
    Button2.Visible := False;
    Label1.Visible := True;
    Chart1.Visible := False;
    with Label1.Position do
    begin
      X := (Screen.Width-Label1.Width+DVT.Height)/2;
      Y := (Screen.Height-Label1.Height)/2-DVT.Height;
    end;
    Tabs.Width := Screen.Width+DVT.Height;
    Tabs.Height := Screen.Height;
  end;

  Chart1.Position.Y := 0;
  Button1.Position.Y := 0;
  Button2.Position.Y := Button1.Height;;
  Button1.Position.X := 0;
  Button2.Position.X := 0;

  Form1.FullScreen := True;
  for i := 0 to 2 do Tabs.Tabs[i].Width := Screen.Width/3;
end;

procedure TForm1.GenerateValuesWeek;
var
  i : Integer; MaxL, MaxG : Double;
begin
  MaxG := 0;
  for i := 0 to 6 do
  begin
    Chart1.Series[0].Points[i].YValue := 1+Random(4);
    Chart1.Series[1].Points[i].YValue := 1+Random(4);
    MaxL := Chart1.Series[0].Points[i].YValue + Chart1.Series[1].Points[i].YValue;
    if MaxL>MaxG then MaxG := MaxL;
  end;
  Chart1.Series[0].MaxY := MaxG+3;
  Chart1.Series[1].MaxY := MaxG+3;
end;

end.
