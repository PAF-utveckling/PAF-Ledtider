program TabsV3;

uses
  System.StartUpCopy,
  FMX.Forms,
  TabUnit in 'TabUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
