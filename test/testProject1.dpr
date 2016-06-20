program testProject1;

uses
  System.StartUpCopy,
  FMX.Forms,
  testUnit1 in 'testUnit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
