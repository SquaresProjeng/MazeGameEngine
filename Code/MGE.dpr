program MGE;

uses
  Forms,
  GUI in 'GUI\GUI.pas' {Form1},
  GFonts in 'GUI\GFonts.pas',
  GUIunit in 'GUI\GUIunit.pas',
  MGEFBO in 'Mesh\MGEFBO.pas',
  MGEAudioEngine in 'Audio\MGEAudioEngine.pas',
  MGEAIController in 'AI\MGEAIController.pas',
  Neural in 'AI\Neural.pas',
  dglOpenGL in 'GUI\dglOpenGL.pas',
  DGLUT in 'GUI\DGLUT.pas',
  Tex in 'GUI\Tex.pas',
  Textures in 'GUI\Textures.pas',
  Animation in 'Mesh\Animation.pas',
  Mesh in 'Mesh\Mesh.pas',
  MeshObj in 'Mesh\MeshObj.pas',
  Command in 'Res\Command.pas',
  Controller in 'Res\Controller.pas',
  Mechanic in 'Res\Mechanic.pas',
  Phisics in 'Res\Phisics.pas',
  ResCon in 'Res\ResCon.pas',
  Resurce in 'Res\Resurce.pas',
  Scripter in 'Res\Scripter.pas',
  bass in 'Audio\bass.pas',
  openal in 'Audio\openal.pas';

{$R *.res}

begin
  Application.Initialize;

  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
