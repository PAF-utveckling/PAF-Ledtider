unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Platform,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSChart;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Chart: TTMSFMXChart;
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


procedure TForm1.FormCreate(Sender: TObject);
var
  ScreenService: IFMXScreenService;
  OrientSet: TScreenOrientations;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.soLandscape];
    //OrientSet := [TScreenOrientation.soPortrait];
    ScreenService.SetScreenOrientation(OrientSet);
  end;
end;

end.
