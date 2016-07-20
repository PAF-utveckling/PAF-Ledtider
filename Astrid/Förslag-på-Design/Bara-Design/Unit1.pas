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
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormAppearance;
    procedure Button1Click(Sender: TObject);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.FullScreen := True;
  Tabs.ActiveTab := Start;
  FormAppearance;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  FormAppearance;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.FormAppearance;
var
  i : Integer;
begin
  if Screen.Height<Screen.Width then Tabs.Width := Screen.Width+DVT.Height
  else Tabs.Width := Screen.Width;
  for i := 0 to 2 do Tabs.Tabs[i].Width := Screen.Width/3;
  Tabs.Height := Screen.Height;
end;

end.
