program TP_Triangulation;

uses
  Forms,
  La_Triangulation in 'La_Triangulation.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
