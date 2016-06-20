unit testUnit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TMSPageControl, FMX.TMSCustomControl, FMX.TMSTabSet;

type
  TForm1 = class(TForm)
    TMSFMXPageControl1: TTMSFMXPageControl;
    TMSFMXPageControl1Page0: TTMSFMXPageControlContainer;
    TMSFMXPageControl1Page1: TTMSFMXPageControlContainer;
    TMSFMXPageControl1Page2: TTMSFMXPageControlContainer;
    Text1: TText;
    Text2: TText;
    Text3: TText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

end.
