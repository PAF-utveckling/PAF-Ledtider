unit TabUnit;

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
    TextDVT: TText;
    TextRem1: TText;
    TextRem2: TText;
    NumberDVT: TText;
    NumberRem1: TText;
    NumberRem2: TText;
    StyleBook1: TStyleBook;
    Chart1: TTMSFMXChart;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormAppearance;
    procedure Button1Click(Sender: TObject);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
FormAppearance;
Chart1.Width := TabUnit.ScreenW;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
ShowMessage('Test');
end;

procedure TForm1.FormAppearance;
var
i, w, h : Integer;
begin
Tabs.ActiveTab := Start;
Form1.Top := 0;
Form1.Left := 0;
TabUnit.ScreenW := Screen.Width;
TabUnit.ScreenH := Screen.Height;

// Så fönstret och tabsen hamnar på rätt ställe oavsätt screen
// På bredden
w := TabUnit.ScreenW;
Form1.Width := w;
Tabs.Width := w;
for i := 0 to 2 do Tabs.Tabs[i].Width := w/3;
// På höjden
h := TabUnit.ScreenH;
Form1.Height := h;
Tabs.Height := h;

// Så texten på sida 1 (Allmänt) hamnar på rätt ställe.
// Anpassat just för en andriod-telefon, inte Windows.
TextDVT.Position.X := 0.15*w;
TextRem1.Position.X := 0.15*w;
TextRem2.Position.X := 0.15*w;
NumberDVT.Position.X := 0.65*w;
NumberRem1.Position.X := 0.65*w;
NumberRem2.Position.X := 0.65*w;

TextDVT.Position.Y := 0.12*w;
NumberDVT.Position.Y := 0.12*w;
TextRem1.Position.Y := 0.3*h;
NumberRem1.Position.Y := 0.3*h;
TextRem2.Position.Y := 0.52*h;
NumberRem2.Position.Y := 0.52*h;
end;

end.
