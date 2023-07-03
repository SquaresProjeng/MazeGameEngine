unit Resurce;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DglOpenGL, DGLUT, Textures,Mesh, command,GFonts,Controller;


const
  sWidth =512; // размеры вспомогательного массива
  sHeight = 512;
var
  SkyBlue:GLUint;
  SBK:boolean;
  DayHour:real;


   blm : Array [0..sHeight - 1, 0..sWidth - 1, 0..3] of GLubyte;
   blm2 : Array [0..sHeight - 1, 0..sWidth - 1, 0..3] of GLubyte;
   blm3 : Array [0..sHeight - 1, 0..sWidth - 1, 0..3] of GLubyte;

   blm4 : Array [0..sHeight - 1, 0..sWidth - 1, 0..3] of GLubyte;
   blm5 : Array [0..sHeight - 1, 0..sWidth - 1, 0..3] of GLubyte;

   PIXEL:array[0..3] of Byte;
   PIX: Cardinal;


  Sky0:array[0..23] of byte = (
  13,14,28,
  18,19,54,
  135,100,85,
  135,206,235,
  111,183,246,
  111,183,246,
  30,77,117,
  30,42,92
  );





procedure Load_First_Tex_settings();
procedure Load_Game_Textures();
procedure Load_Game_Models();
procedure Load_Game_Settings();
Procedure RenderBox();
procedure RenderSprite(PX,PY,SX,SY,Rot:real;Pict:Uint);
function SpriteButton(PX,PY,SX,SY:real;Pict:Uint; SN,SP,Key:integer):integer;
procedure RenderFlore(x,y,size:integer; Texture:Uint);
procedure SkyCrea();
procedure SkyNew();
procedure SkyTime();
procedure SkyColor(R,G,B:byte);
function CreateMGETexture(Width, Height, Format : Word; pData : Pointer) : Integer;
procedure ClosefileModels();

implementation
uses GUI,GUIUnit;

procedure SkyTime();
begin

if SkyR<Sky0[0+3*round(DayHour)] then SkyR:=SkyR+1;
if SkyG<Sky0[1+3*round(DayHour)] then SkyG:=SkyG+1;
if SkyB<Sky0[2+3*round(DayHour)] then SkyB:=SkyB+1;

if SkyR>Sky0[0+3*round(DayHour)] then SkyR:=SkyR-1;
if SkyG>Sky0[1+3*round(DayHour)] then SkyG:=SkyG-1;
if SkyB>Sky0[2+3*round(DayHour)] then SkyB:=SkyB-1;

{ SkyColor(Sky0[0+3*round(DayHour)],
 Sky0[1+3*round(DayHour)],
 Sky0[2+3*round(DayHour)]); }

end;

procedure SkyColor(R,G,B:byte);
begin
SkyR:=R; SkyG:=G; SkyB:=B;
end;
function CreateMGETexture(Width, Height, Format : Word; pData : Pointer) : Integer;
var
  Texture : GLuint;
begin
  glGenTextures(1, @Texture);
  glBindTexture(GL_TEXTURE_2D, Texture);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);  {Texture blends with object background}
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); { only first two can be used }
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); { all of the above can be used }
  if Format = GL_RGBA then
    gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, Width, Height, GL_RGBA, GL_UNSIGNED_BYTE, pData)
  else
    gluBuild2DMipmaps(GL_TEXTURE_2D, 3, Width, Height, GL_RGB, GL_UNSIGNED_BYTE, pData);
  result :=Texture;
end;


procedure SkyNew();
var
  O,P:integer;
begin
  for O := 0 to sHeight-1 do
    for P := 0 to sWidth-1 do
    begin
      blm[O][P][0]:=255;
      blm[O][P][1]:=255;
      blm[O][P][2]:=255;

      if blm2[O][P][3]>blm[O][P][3] then blm[O][P][3]:=blm[O][P][3]+2;
      if blm2[O][P][3]<blm[O][P][3] then blm[O][P][3]:=blm[O][P][3]-1;

      blm4[O][P][0]:=255;
      blm4[O][P][1]:=255;
      blm4[O][P][2]:=255;

      blm3[O][P][0]:=SkyR;
      blm3[O][P][1]:=SkyG;
      blm3[O][P][2]:=SkyB;
      blm3[O][P][3]:=255;

      if blm5[O][P][3]>blm4[O][P][3] then blm4[O][P][3]:=blm4[O][P][3]+2;
      if blm5[O][P][3]<blm4[O][P][3] then blm4[O][P][3]:=blm4[O][P][3]-1;
    end;




   glBindTexture(GL_TEXTURE_2D, Ttextobj[52]);
   gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, sWidth,sHeight, GL_RGBA, GL_UNSIGNED_BYTE, @blm);

   glBindTexture(GL_TEXTURE_2D, Ttextobj[57]);
   gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, sWidth,sHeight, GL_RGBA, GL_UNSIGNED_BYTE, @blm4);

   glBindTexture(GL_TEXTURE_2D, Ttextobj[51]);
   gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, sWidth,sHeight, GL_RGBA, GL_UNSIGNED_BYTE, @blm3);
end;



procedure SkyCrea();
var O,P,E,L,K,J,Y,I:integer;
begin
    E:=0;
    randomize;


  for O := 0 to sHeight-1 do
    for P := 0 to sWidth-1 do
    begin
      blm2[O][P][0]:=255;
      blm2[O][P][1]:=255;
      blm2[O][P][2]:=255;
      blm2[O][P][3]:=0;

      blm5[O][P][0]:=255;
      blm5[O][P][1]:=255;
      blm5[O][P][2]:=255;
      blm5[O][P][3]:=0;

     // E:=Round(O/5);

      //blm3[O][P][0]:=34*+round(E);
      //blm3[O][P][1]:=91*+round(E);



   if SBK=false then begin

      blm[O][P][0]:=255;
      blm[O][P][1]:=255;
      blm[O][P][2]:=255;
      blm[O][P][3]:=0;
       SBK:=true;
      end;


    end;



  for O := 0 to sHeight-1 do
    for P := 0 to sWidth-1 do
    begin
      E:=random(2000);
      L:=random(10);
      K:=random(50);
      J:=random(2);
      if (O>sHeight/5)  and (O<sHeight/1.2) and (P<sWidth/1.02) and (P>8) then begin
        case E of
          1: begin
            for I := 0 to K-1 do
                begin
                  blm2[O-5+random(10)][P-5+random(10)][3]:=150+random(100);
                  blm2[O-5+random(10)][P-5+random(10)][3]:=150+random(100);
                end;
          end;
          5: begin
            for I := 0 to K-1 do
                begin
                  blm2[O-7+random(14)][P-5+random(10)][3]:=150+random(100);
                  blm2[O-7+random(14)][P-5+random(10)][3]:=150+random(100);
                end;
          end;
          2: begin
            for I := 0 to K-1 do
                begin
                  blm2[O-2+random(4)][P-5+random(10)][3]:=150+random(100);
                  blm2[O-2+random(4)][P-5+random(10)][3]:=150+random(100);
                end;
          end;
        end;
      end;
    end;


  for O := 0 to sHeight-1 do
    for P := 0 to sWidth-1 do
    begin
      E:=random(1000);
      L:=random(10);
      K:=random(25);
      J:=random(2);
      if (O>sHeight/5)  and (O<sHeight/1.2) and (P<sWidth/1.02) and (P>8) then begin
        case E of
          1: begin
            for I := 0 to K-1 do
                begin
                  blm5[O-2+random(5)][P-5+random(10)][3]:=150+random(100);
                  blm5[O-2+random(5)][P-5+random(10)][3]:=150+random(100);
                end;
          end;
          5: begin
            for I := 0 to K-1 do
                begin
                  blm5[O-3+random(6)][P-5+random(10)][3]:=150+random(100);
                  blm5[O-3+random(6)][P-5+random(10)][3]:=150+random(100);
                end;
          end;
          2: begin
            for I := 0 to K-1 do
                begin
                  blm5[O-2+random(4)][P-10+random(20)][3]:=150+random(100);
                  blm5[O-2+random(4)][P-10+random(20)][3]:=150+random(100);
                end;
          end;
        end;
      end;
    end;



end;
procedure RenderSprite(PX,PY,SX,SY,Rot:real;Pict:Uint);
begin

  glTranslatef(PX,PY,0);
  glRotatef(Rot,0,0,1);
  glPushMatrix;
  Disable_sun();
     //  glColor(255,255,255);
  glBindTexture(GL_TEXTURE_2D, Pict);
    glBegin(GL_Quads);
      glTexCoord2d(0.0, 1.0);  glVertex2d(-sx,-sy);
      glTexCoord2d(0.0, 0.0);  glVertex2d(-sx,+sy);
      glTexCoord2d(1.0, 0.0);  glVertex2d(+sx,+sy);
      glTexCoord2d(1.0, 1.0);  glVertex2d(+sx,-sy);
    glEnd;
       // glColor(255,255,255);
  Enable_sun();
  GLpOPmATRIX;
  glRotatef(-Rot,0,0,1);
  glTranslatef(-PX,-PY,0);
end;
function SpriteButton(PX,PY,SX,SY:real;Pict:Uint; SN,SP,Key:integer):integer;
var X,Y:integer;
begin
  GetCursorPos(M3M.Point);
  X:=-Form1.Left +M3M.Point.X;
  Y:=-Form1.Top-15  +M3M.point.Y;
  RenderSprite(PX,PY,SX,SY,0,Pict);
  if (M3M.Point.X>Form1.Left) and (M3M.Point.X<Form1.Left+Form1.Width) and
      (M3M.point.Y>Form1.Top-15) and (M3M.point.Y<Form1.Top+Form1.Height) and
       (X<px+sx) and (X>px-sx) and
       (Y<py+sy) and (Y>py-sy) then begin
       if(GetAsyncKeyState(VK_LBUTTON)<>0) and (MBL=false) then
          begin
            result:=Key;
            MBL:=true;
          end else   begin
            result:=SP;
          end;
      end else begin
        result:=SN;

      end;


end;
procedure Load_First_Tex_settings();
begin
  glEnable(GL_DEPTH_TEST); // включаем проверку разрешения фигур (впереди стоящая закрывает фигуру за ней)
  glDepthFunc(GL_LEQUAL);  //тип проверки
  //glDepthFunc(GL_LESS);  //тип проверки
  //glDepthFunc(GL_NEVER);
  glEnable(GL_TEXTURE_2D);   //Включаем режим наложения текстур
  glEnable(GL_ALPHA_TEST);     //Разрешаем альфа тест (прозрачность текстур)
  glAlphaFunc(GL_GREATER,0.005);
  glEnable (GL_BLEND);         //Включаем режим смешивания цветов
  glDepthMask(GL_True);

  glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE );
  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA) ; //Тип смешивания
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); //Параметры наложения текстуры
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); //Параметры наложения текстуры
end;

procedure LoadFfileTextures(Put:String);
var I,TNN:integer;
    fi:textfile;
    PP:String;
    PN:String;
begin
TGAN:=0;
    Assignfile(fi,put); reset(fi);
    readln(fi,TNN);
      TGAN:=TNN;
      SetLength(TGATex,TGAN);
      SetLength(TGAName,TGAN);
      if TGAN>0 then   begin
      for I := 0 to TNN - 1 do
      begin
          readln(fi,PN);
          readln(fi,PP);
          TGAName[i]:=PN;
          if FileExists(MGELocation+PP)=true then
            LoadTexture(MGELocation+PP,TGATex[i],false) else
            ShowMessage('Файл по пути: '+MGELocation+PP+' не найден или закрыт для чтения');
        end;
      end;
    Closefile(fi);
end;

procedure Load_Game_Textures();
var I:integer;
begin
   LoadTexture(MGELocation+'\resource\MGEIMG\maincursor.tga',Ttextobj[100],false);
   LoadTexture(MGELocation+'\resource\MGEIMG\Sun.tga',Ttextobj[53],false);
   LoadTexture(MGELocation+'\resource\MGEIMG\MGEMaterials\Stars.tga',Ttextobj[24],false);
   LoadTexture(MGELocation+'\resource\MGEIMG\MGEMaterials\ObjBox.tga',Ttextobj[25],false);
   LoadTexture(MGELocation+'\resource\MGEIMG\Menu.tga',Ttextobj[5],false);
   LoadTexture(MGELocation+'\resource\MGEIMG\Menu2.tga',Ttextobj[6],false);
   LoadTexture(MGELocation+'\resource\MGEIMG\botAlphaA1t.tga',Ttextobj[23],false);
   LoadTexture(MGELocation+'\resource\MGEIMG\MiniMap.tga',Ttextobj[27],false);

  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   LoadFfileTextures(MGELocation+'\resource\MGEScripts\LoadTextures.mges');
      
SetLength(FrameF,1);
  for I:=0 to 0 do  LoadTexture(MGELocation+'\resource\MGEIMG\MGEMaterials\'+inttostr(3)+'.tga',FrameF[I],false);
SetLength(SmoF,14);
  for I:=0 to 13 do  LoadTexture(MGELocation+'\resource\MGEIMG\MGEMaterials\Smoke\d-'+inttostr(I)+'.tga',SmoF[I],false);


end;
procedure LoadFfileModels(Put:String);
var I,TNN,sgl:integer;
    fi:textfile;
    PP:String;
    PN:String;
begin
TGAN:=0;
    Assignfile(fi,put); reset(fi);
    readln(fi,TNN);
      TGAN:=TNN;
      SetLength(GMSmode1,TGAN);
      SetLength(GMSName,TGAN);
      if TGAN>0 then   begin
      for I := 0 to TNN - 1 do
      begin
          readln(fi,PN);
          readln(fi,PP);
          readln(fi,sgl);
          GMSName[i]:=PN;

          GMSmode1[i] := TGLMultyMesh.Create;
          GMSmode1[i].LoadFromFile(MGELocation+PP);
          GMSmode1[i].Extent := true;
          if sgl=1 then GMSmode1[i].fSmooth := true
          else GMSmode1[i].fSmooth := false;
        end;
      end;
    Closefile(fi);
end;
procedure ClosefileModels();
var I,TN:integer;
begin
    TN:=Length(GMSmode1);
    if TN>0 then begin
      for I:=0 to TN-1 do GMSmode1[i].Free;
    end;
end;


procedure Load_Game_Models();
begin
  LoadFfileModels(MGELocation+'\resource\MGEScripts\LoadModels.mges');

  mode1s[0] := TGLMultyMesh.Create;
  mode1s[0].LoadFromFile(MGELocation+'\resource\MGEModels\C.gms');
  mode1s[0].Extent := true;
  mode1s[0].fSmooth := false; // Установить в фасеты

  mode1s[1] := TGLMultyMesh.Create;
  mode1s[1].LoadFromFile(MGELocation+'\resource\MGEModels\sphere.gms');
  mode1s[1].Extent := true;
  mode1s[1].fSmooth := true; // Установить в фасеты

  mode1s[2] := TGLMultyMesh.Create;
  mode1s[2].LoadFromFile(MGELocation+'\resource\MGEModels\box.gms');
  mode1s[2].Extent := true;
  mode1s[2].fSmooth := true; // Установить в фасеты

  mode1s[3] := TGLMultyMesh.Create;
  mode1s[3].LoadFromFile(MGELocation+'\resource\MGEModels\W.gms');
  mode1s[3].Extent := true;
  mode1s[3].fSmooth := true; // Установить в фасеты

  mode1s[4] := TGLMultyMesh.Create;
  mode1s[4].LoadFromFile(MGELocation+'\resource\MGEModels\Car2.gms');
  mode1s[4].Extent := true;
  mode1s[4].fSmooth := true; // Установить в фасеты

  mode1s[5] := TGLMultyMesh.Create;
  mode1s[5].LoadFromFile(MGELocation+'\resource\MGEModels\Terrain.gms');
  mode1s[5].Extent := false;
  mode1s[5].fSmooth := false; // Установить в фасеты

  mode1s[6] := TGLMultyMesh.Create;
  mode1s[6].LoadFromFile(MGELocation+'\resource\MGEModels\bmw.gms');
  mode1s[6].Extent := true;
  mode1s[6].fSmooth := false; // Установить в фасеты
end;
procedure Load_Game_Settings();
begin
  showCursor(false);
end;
Procedure RenderBox();
begin
glPushMatrix;
glBegin(GL_QUADS);
    glNormal3f( 0.0, 0.0, 1.0);
    glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0,  1.0);
    glTexCoord2f(1.0, 0.0); glVertex3f( 1.0, -1.0,  1.0);
    glTexCoord2f(1.0, 1.0); glVertex3f( 1.0,  1.0,  1.0);
    glTexCoord2f(0.0, 1.0); glVertex3f(-1.0,  1.0,  1.0);
   glEnd; glPopMatrix;  glPushMatrix;
   glBegin(GL_QUADS);
    glNormal3f( 0.0, 0.0,-1.0);
    glTexCoord2f(1.0, 0.0); glVertex3f(-1.0, -1.0, -1.0);
    glTexCoord2f(1.0, 1.0); glVertex3f(-1.0,  1.0, -1.0);
    glTexCoord2f(0.0, 1.0); glVertex3f( 1.0,  1.0, -1.0);
    glTexCoord2f(0.0, 0.0); glVertex3f( 1.0, -1.0, -1.0);
   glEnd;    glPopMatrix;  glPushMatrix;
   glBegin(GL_QUADS);
    glNormal3f( 0.0, 1.0, 0.0);
    glTexCoord2f(0.0, 1.0); glVertex3f(-1.0,  1.0, -1.0);
    glTexCoord2f(0.0, 0.0); glVertex3f(-1.0,  1.0,  1.0);
    glTexCoord2f(1.0, 0.0); glVertex3f( 1.0,  1.0,  1.0);
    glTexCoord2f(1.0, 1.0); glVertex3f( 1.0,  1.0, -1.0);
   glEnd();  glPopMatrix;  glPushMatrix;
   glBegin(GL_QUADS);
    glNormal3f( 0.0,-1.0, 0.0);
    glTexCoord2f(1.0, 1.0); glVertex3f(-1.0, -1.0, -1.0);
    glTexCoord2f(0.0, 1.0); glVertex3f( 1.0, -1.0, -1.0);
    glTexCoord2f(0.0, 0.0); glVertex3f( 1.0, -1.0,  1.0);
    glTexCoord2f(1.0, 0.0); glVertex3f(-1.0, -1.0,  1.0);
   glEnd();  glPopMatrix;
                 glPushMatrix;
   glBegin(GL_QUADS);
    glNormal3f( 1.0, 0.0, 0.0);
    glTexCoord2f(1.0, 0.0); glVertex3f( 1.0, -1.0, -1.0);
    glTexCoord2f(1.0, 1.0); glVertex3f( 1.0,  1.0, -1.0);
    glTexCoord2f(0.0, 1.0); glVertex3f( 1.0,  1.0,  1.0);
    glTexCoord2f(0.0, 0.0); glVertex3f( 1.0, -1.0,  1.0);
   glEnd();  glPopMatrix;

   glBegin(GL_QUADS);  glPushMatrix;
    glNormal3f(-1.0, 0.0, 0.0);
    glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, -1.0);
    glTexCoord2f(1.0, 0.0); glVertex3f(-1.0, -1.0,  1.0);
    glTexCoord2f(1.0, 1.0); glVertex3f(-1.0,  1.0,  1.0);
    glTexCoord2f(0.0, 1.0); glVertex3f(-1.0,  1.0, -1.0);
  glEnd(); glPopMatrix;
end;
procedure DrawBox(X,Y,Z,Size:real; Texture:BBoxT);
begin
   glTranslatef(X,Y,Z);
      glPushMatrix;
  	    glBindTexture(GL_TEXTURE_2D, Texture.Texture[0]);
	    glBegin(GL_QUADS);
      glNormal3f( 0.0, 0.0, -1.0);
		    //front
            glTexCoord2f(0, 0);   glVertex3f(-size, -size, -size);
            glTexCoord2f(1, 0);   glVertex3f(size,  -size, -size);
            glTexCoord2f(1, 1);   glVertex3f( size,  size, -size);
            glTexCoord2f(0, 1);   glVertex3f( -size, size, -size);
        glEnd();
    glPopmatrix;
      glPushMatrix;
	    glBindTexture(GL_TEXTURE_2D, Texture.Texture[1]);
	    glBegin(GL_QUADS);
			//back
            glNormal3f( 0.0, -0.5,-1.0);
            glTexCoord2f(0, 0); glVertex3f(size, -size, size);
            glTexCoord2f(1, 0); glVertex3f(-size,  -size, size);
            glTexCoord2f(1, 1); glVertex3f( -size,  size, size);
            glTexCoord2f(0, 1); glVertex3f( size, size, size);
        glEnd();
    glPopmatrix;
      glPushMatrix;
		glBindTexture(GL_TEXTURE_2D, Texture.Texture[2]);
	    glBegin(GL_QUADS);
			//left
            glNormal3f( 0.0, -1.0, 0.5);
            glTexCoord2f(0, 0); glVertex3f(-size, -size,  size);
            glTexCoord2f(1, 0); glVertex3f(-size, -size, -size);
            glTexCoord2f(1, 1); glVertex3f(-size,  size, -size);
            glTexCoord2f(0, 1); glVertex3f(-size,  size,  size);
        glEnd();
    glPopmatrix;
      glPushMatrix;
		glBindTexture(GL_TEXTURE_2D, Texture.Texture[3]);
	    glBegin(GL_QUADS);
			//right
            glNormal3f( 0.0,-0.5, -0.5);
            glTexCoord2f(0, 0); glVertex3f(size, -size, -size);
            glTexCoord2f(1, 0); glVertex3f(size,  -size, size);
            glTexCoord2f(1, 1); glVertex3f(size,  size,  size);
            glTexCoord2f(0, 1); glVertex3f(size, size,  -size);
        glEnd();
    glPopmatrix;
      glPushMatrix;
		glBindTexture(GL_TEXTURE_2D, Texture.Texture[4]);
	    glBegin(GL_QUADS);
			//bottom
            glNormal3f( 1.0, 0.0, 0.0);
            glTexCoord2f(0, 0); glVertex3f(-size, -size,  size);
            glTexCoord2f(1, 0); glVertex3f(size, -size, size);
            glTexCoord2f(1, 1); glVertex3f( size, -size, -size);
            glTexCoord2f(0, 1); glVertex3f( -size, -size,  -size);
        glEnd();
    glPopmatrix;
      glPushMatrix;
	    glBindTexture(GL_TEXTURE_2D, Texture.Texture[5]);
	    glBegin(GL_QUADS);
			//top
            glNormal3f(-1.0, 0.0, 0.0);
            glTexCoord2f(0, 0); glVertex3f(-size, size,  -size);
            glTexCoord2f(1, 0); glVertex3f(size, size, -size);
            glTexCoord2f(1, 1); glVertex3f( size, size, size);
            glTexCoord2f(0, 1); glVertex3f( -size, size,  size);
        glEnd();
    glPopmatrix;
   glTranslatef(-X,-Y,-Z);
end;
procedure RenderFlore(x,y,size:integer; Texture:Uint);
begin
glTranslatef(x,y,-10);
glPushMatrix;
glBindTexture(GL_TEXTURE_2D,Texture);
glBegin(GL_QUADS);
    //glNormal3f( 0.0, 0.0, 1.0);
    glTexCoord2f(0.0, 0.0); glVertex3f(-1.0*size, -1.0*size,  1.0);
    glTexCoord2f(1.0, 0.0); glVertex3f( 1.0*size, -1.0*size,  1.0);
    glTexCoord2f(1.0, 1.0); glVertex3f( 1.0*size,  1.0*size,  1.0);
    glTexCoord2f(0.0, 1.0); glVertex3f(-1.0*size,  1.0*size,  1.0);
   glEnd;
glPopMatrix;
glTranslatef(-x,-y,+10);
end;




end.
 