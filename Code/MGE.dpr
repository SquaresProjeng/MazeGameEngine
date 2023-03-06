program MGE;

uses
  Forms,
  GUI in 'GUI.pas' {Form1},
  Resurce in 'Resurce.pas',
  Command in 'Command.pas',
  GFonts in 'GFonts.pas',
  Gamelavels in 'Gamelavels.pas',
  Mechanic in 'Mechanic.pas',
  Controller in 'Controller.pas',
  ResCon in 'ResCon.pas',
  Scripter in 'Scripter.pas',
  Phisics in 'Phisics.pas',
  GUIunit in 'GUIunit.pas',
  MGEFBO in 'MGEFBO.pas',
  EnScene in 'EnScene.pas',
  MGEAudioEngine in 'MGEAudioEngine.pas',
  MGEAIController in 'MGEAIController.pas';


{$R *.res}

begin
  Application.Initialize;

  Application.CreateForm(TForm1, Form1);

  Application.Run;
end.
