unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSChart;

type
  TForm1 = class(TForm)
    Chart1: TTMSFMXChart;
    Button2: TButton;
    Button1: TButton;
    Label1: TLabel;
    procedure GenerateValuesWeek;
    procedure FormCreate(Sender: TObject);
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
  // Chart1
  Chart1.Position.X := 0;
  Chart1.Position.Y := 0;
  Form1.FullScreen := True;
  Form1.Height := Screen.Height;
  Chart1.Width := Screen.Width;
  Chart1.Height := Screen.Height;
  GenerateValuesWeek;

  Form1.FullScreen := True;

  // Buttons
  Button2.Position.X := 0;
  Button2.Position.Y := 0;
  Button1.Position.X := Screen.Width-Button1.Width;
  Button1.Position.Y := 0;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if Screen.Height>Screen.Width then
  begin
    Chart1.Visible := True;
    Label1.Visible := False;
    Chart1.Width := Form1.Width;
    Chart1.Height := Form1.Height;
  end
  else
  begin
    Label1.Visible := True;
    Chart1.Visible := False;
    with Label1.Position do
    begin
      X := (Screen.Width-Label1.Width)/2;
      Y := (Screen.Height-Label1.Height)/2;
    end;
  end;
  Button1.Position.X := Form1.Width-Button1.Width;
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
