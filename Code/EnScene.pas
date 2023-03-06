unit EnScene;

interface
  uses Variants, windows, Classes, Graphics, Controls,Forms, Dialogs, DglOpenGL, Textures,
  mesh, Math, ResCon, Scripter, Controller,Phisics;

Type
  MGEScene = record
///////////Visual///////////////////////
    SFires:Array of MGEFire3D;
    Nfire:integer;
    SSprites:array of MGE3DSprite;
    NSprite:integer;
    SModels:array of TGLMultyMesh;
    NModel:integer;
    STextures:array of GLUint;
    STexName:array of String;
    NTexture:integer;
///////////Phisical/////////////////////
    SPSpheres:array of MGEPSphere;
    NPSphere:integer;
    SPBoxZone:array of MGEPBBox;
    NPBZone:integer;
    Sploscost:array of MGEPPlane;
    NPloskost:integer;

    public
      procedure Draw;
      procedure LoadfromOpenFile(put:string);
  end;

implementation

procedure MGEScene.Draw;
begin

end;
procedure MGEScene.LoadfromOpenFile(put: string);
var fi:textfile;
begin
  Assignfile(fi,put); reset(fi);
  



end;

end.
