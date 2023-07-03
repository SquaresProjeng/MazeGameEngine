unit Command;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DglOpenGL, DGLUT, Textures, mesh,controller;

const
  GL_CLAMP_TO_EDGE =$812F;
  GL_POLYGON_OFFSET_FILL  = $8037;

  VK_W = $57;   VK_1 = $31;
  VK_S = $53;   VK_2 = $32;
  VK_D = $44;   VK_3 = $33;
  VK_A = $41;   VK_4 = $34;
  VK_B = $42;   VK_F = $46;

  VK_G = $47;   VK_I = $49;
  VK_H = $48;   VK_L = $4C;
  VK_M = $4D;   VK_N = $4E;
  VK_O = $4F;   VK_P = $50;
  VK_T = $54;   VK_V = $56;
  VK_Y = $59;   VK_K = $4B;

  VK_X = $58;   VK_Q = $51;
  VK_E = $45;   VK_C = $43;
  VK_U = $55;   VK_Z = $5A;
  VK_J = $4A;   VK_R = $52;

  VK_5 = $35;   VK_6 = $36;
  VK_7 = $37;   VK_8 = $38;
  VK_9 = $39;   VK_0 = $30;

  VK_F1 = $70;
  VK_F2 = $71;
  VK_F3 = $72;
  VK_F4 = $73;
  VK_F5 = $74;
  VK_F6 = $75;
  VK_F7 = $76;
  VK_F8 = $77;
  VK_F9 = $78;
  VK_F10 = $79;

  VK_YO     =  $C0;   VK_PLUS     = $BB;
  VK_MIN    =  $BD;   VK_RX       = $DB;
  VK_RTZ    =  $DD;   VK_RG       = $BA;
  VK_R3     =  $DE;   VK_RB       = $BC;
  VK_RIO    =  $BE;   VK_RTOCHKA  = $BF;
  VK_PALKA  =  $DC;

VK_SHIFT = $10;
VK_SPACE = $20;



type
  RObject = record
    x,y,sx,sy:integer;
    cls:byte;
    model:TGLMultyMesh;
    texture:TGLUint;
  end;
Type
  BBoxT =record
     Texture:array[0..5] of TGLUint;
  end;


//////----------------****************************************************---------------------------////

Type
  FPlayer = record
    X,Y,Z:Real;
    dx,dy,dz:real;
    w,h,d:real;
    Colizt:integer;
    angleX,AngleY: Single;
    onGround:boolean;
    Speed:real;
    public
    procedure create(X0,Y0,Z0:real);
  end;
var
 mbl:boolean;
 MouseMove1: boolean;
   Button:array[0..11] of TGLUint;
   SkyBox:array[0..5] of TGLUint;
   Commande, KeyClick:boolean;
   fogColor : array[0..3] of GLfloat = (0.8, 0.8, 0.9, 0.001); //цвет тумана
procedure IdenTifiWindow(ClientWidth, ClientHeight:integer);
procedure Mouse_Move();
function Key_Move(G:MGEPlayer):MGEPlayer;
function NueThon(fx,fy,fz,fsx,fsy,fsz:real;D:FPlayer):FPlayer;
procedure DrawBox(X,Y,Z,Size:real; Texture:BBoxT);
procedure Active_UnActive_system();
 procedure Fog();
procedure ModelDraw(PX,PZ,PY,MSize:real; TT:Uint; Model:TGLMultyMesh);
function Cam_Move(G:MGEplayer):MGEplayer;

implementation
uses GUI,GUIUnit;


procedure ModelDraw(PX,PZ,PY,MSize:real; TT:Uint; Model:TGLMultyMesh);
begin
    GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST); //Параметры наложения текстуры
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST_MIPMAP_NEAREST); //Параметры наложения текстуры
      glBindTexture(GL_TEXTURE_2D,TT);
          GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST); //Параметры наложения текстуры
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST_MIPMAP_NEAREST); //Параметры наложения текстуры
        glTranslatef(PX,PZ,PY);
          glRotatef(-90,1,0,0);
          glPushMatrix;
            glScalef(MSize,MSize,MSize);
            Model.Draw;
          glPopMatrix;
          glRotatef(90,1,0,0);
        glTranslatef(-PX,-PZ,-PY);
end;



procedure Fog();
begin


 glFogi(GL_FOG_MODE, GL_LINEAR); // задаем закон смешения тумана
  glFogf(GL_FOG_START , 100); // начало тумана
  glFogf(GL_FOG_END , 800); // конец тумана
  glFogfv(GL_FOG_COLOR, @fogColor); // цвет дымки
  glFogf(GL_FOG_DENSITY, 0.8); // плотность тумана


{   glFogi(GL_FOG_MODE, GL_NEAREST ); // задаем закон смешения тумана
  glHint(GL_FOG_HINT, GL_NEAREST);
  glFogf(GL_FOG_START , 10); // начало тумана
  glFogf(GL_FOG_END , 1000); // конец тумана
  glFogfv(GL_FOG_COLOR, @fogColor); // цвет дымки6
  glFogf(GL_FOG_DENSITY, 0.8); // плотность тумана   }
end;




procedure Fplayer.create(X0: Real; Y0: Real; Z0: Real);
begin
  x:=X0;  y:=y0;  z:=Z0;
  dx:=0;  dy:=0; dz:=0;
  w:=5; h:=20; d:=5; speed:=2;
  onGround:=false;
end;

procedure Active_UnActive_system();
begin
if (GetAsyncKeyState(VK_YO)<>0) then
  begin
    //Menustay:=1;
  end;
if (GetAsyncKeyState(VK_R)<>0) then
  begin
    //SetCursorPos(screen.Width div 2,screen.Height div 2);
   // MenuStay:=0;
  end;
end;

function NueThon(fx,fy,fz,fsx,fsy,fsz:real;D:FPlayer):FPlayer;
  var
    DX,DY,DZ:real;
    RX,RY,RZ:boolean;
    YAY:real;
begin
DX:=D.X-fx;
DZ:=D.Z-fz;
DY:=D.Y-fy;
  if (abs(DX)<fsx+D.w) and (abs(DZ)<fsz+d.d) and (abs(DY)<fsy+d.h) then
    begin
      if (DX>0) then  RX:=true;
      if (DX<0) then  RX:=false;
      if (DZ>0) then  RZ:=true;
      if (DZ<0) then  RZ:=false;
      if (DY>0) then  RY:=true;
      if (DY<0) then  RY:=false;

          if (RY=true) or (RY=false) then begin
            if DY-D.h>fsy*0.7 then begin
               if D.dy<0 then begin
                d.dy:=0;
                D.Colizt:=D.Colizt+1;
                D.Y:=fy+D.H+fsy*0.95;
               end;
              end else
              begin
              if Rx=true then begin
                if (DZ-D.d<fsz*0.8) and (DZ+d.d>-fsz*0.8) and (DX-d.w>fsx*0.7) then
                  begin
                    D.X:=fx+d.d+fsx;
                  end;
                end;
                if Rx=false then begin
                if (DZ-D.d<fsz*0.8) and (DZ+d.d>-fsz*0.8) and (DX+d.w<-fsx*0.7) then
                  begin
                    D.X:=fx-d.d-fsx;
                  end;
                end;
                if Rz=true then begin
                  if (DX-D.w<fsx*0.8) and (DX+D.d>-fsx*0.8) and (Dz-d.d>fsz*0.7) then
                    begin
                      D.Z:=fz+d.w+fsz;
                    end;
                end;
                if Rz=false then begin
                  if (Dx-D.w<fsx*0.8) and (Dx+D.w>-fsx*0.8) and (Dz+d.d<-fsz*0.7)  then
                    begin
                      D.z:=fz-d.w-fsz;
                    end;
                end;
                if DY+D.h<-fsy*0.7 then begin
                  if D.dy>0 then begin
                    d.dy:=0;
                    D.Y:=fy-D.H-fsy*0.95;
                  end;
end; end; end; end;
result:=D;
end;


function Cam_Move(G:MGEplayer):MGEplayer;
var Gamer:MGEplayer;
begin
  Gamer:=G;
    if Gamer.AngleY  >60 then Gamer.AngleY  :=80;
    if Gamer.AngleY  <-60 then Gamer.AngleY  :=-80;

    //if Gamer.AngleX  >359 then Gamer.AngleX  :=0;
   // if Gamer.AngleX  <0 then Gamer.AngleX  :=359;
  if Gamer.Speed<=0 then Gamer.Speed:=1;
  if (K_D(VK_LSHIFT)<>false)then Gamer.Speed:=5;
  if (K_D(VK_LControl)<>false)then Gamer.Speed:=0.1;

  if (K_D(VK_W)<>false) then begin
      Gamer.d.x:= -Sin(Gamer.angleX/180*Pi)*Gamer.Speed;
      Gamer.d.z:= -cos(Gamer.angleX/180*Pi)*Gamer.Speed; end;
  if (K_D(VK_S)<>false) then begin
      Gamer.d.x:= Sin(Gamer.angleX/180*Pi)*Gamer.Speed;
      Gamer.d.z:= cos(Gamer.angleX/180*Pi)*Gamer.Speed;  end;
  if (K_D(VK_D)<>false) then  begin
      Gamer.d.x:=sin((Gamer.angleX+90)/180*Pi)*Gamer.Speed;
      Gamer.d.z:=cos((Gamer.angleX+90)/180*Pi)*Gamer.Speed; end;
  if (K_D(VK_A)<>false) then  begin
      Gamer.d.x:=sin((Gamer.angleX-90)/180*Pi)*Gamer.Speed;
      Gamer.d.z:=cos((Gamer.angleX-90)/180*Pi)*Gamer.Speed; end;

  if (K_D(VK_D)<>false) and (K_D(VK_W)<>false)  then  begin
      Gamer.d.x:=sin((Gamer.angleX+135)/180*Pi)*Gamer.Speed;
      Gamer.d.z:=cos((Gamer.angleX+135)/180*Pi)*Gamer.Speed; end;
  if (K_D(VK_A)<>false) and (K_D(VK_W)<>false)  then  begin
      Gamer.d.x:=sin((Gamer.angleX-135)/180*Pi)*Gamer.Speed;
      Gamer.d.z:=cos((Gamer.angleX-135)/180*Pi)*Gamer.Speed; end;
  if (K_D(VK_D)<>false) and (K_D(VK_S)<>false) then  begin
      Gamer.d.x:=sin((Gamer.angleX+45)/180*Pi)*Gamer.Speed;
      Gamer.d.z:=cos((Gamer.angleX+45)/180*Pi)*Gamer.Speed; end;
  if (K_D(VK_A)<>false) and (K_D(VK_S)<>false) then  begin
      Gamer.d.x:=sin((Gamer.angleX-45)/180*Pi)*Gamer.Speed;
      Gamer.d.z:=cos((Gamer.angleX-45)/180*Pi)*Gamer.Speed; end;


  if (K_D(VK_Q)<>false) then Gamer.p.y:=Gamer.p.y-Gamer.Speed;
  if (K_D(VK_E)<>false) then Gamer.p.y:=Gamer.p.y+Gamer.Speed;

  Gamer.p.x:=Gamer.p.x+Gamer.d.x;
  Gamer.p.z:=Gamer.p.z+Gamer.d.z;


  //if (K_D(VK_LSHIFT)<>false)then Gamer.Speed:=Gamer.Speed*1.1;
 // if (K_D(VK_LSHIFT)<>true)then Gamer.Speed:=Gamer.Speed*0.5;




   if (K_D(VK_Plus)<>false) then CamRad:=CamRad+2;
   if (K_D(VK_Min)<>false) then CamRad:=CamRad-2;

  result:=Gamer;
end;


function Key_Move(G:MGEplayer):MGEplayer;
var Gamer:MGEplayer;
begin
  Gamer:=G;
    if Gamer.AngleY  >60 then Gamer.AngleY  :=60;
    if Gamer.AngleY  <-60 then Gamer.AngleY  :=-60;

   // if Gamer.AngleX  >359 then Gamer.AngleX  :=0;
   // if Gamer.AngleX  <0 then Gamer.AngleX  :=359;

    if abs(Gamer.Speed)>0.02 then Gamer.Speed:=Gamer.Speed*0.995;
    if abs(Gamer.Speed)<=0.02 then Gamer.Speed:=0;

  if (K_D(VK_W)<>false) then
  begin
    if Gamer.Speed<0.02 then Gamer.Speed:=0.04;
    if Gamer.Speed<2.0 then Gamer.Speed:=Gamer.Speed+0.01;
  end;

  if (K_D(VK_S)<>false)  then
  begin
    if Gamer.Speed>-0.2 then Gamer.Speed:=Gamer.Speed-0.04;
  end;

  if (K_D(VK_SPACE)<>false)  then
  begin
    if abs(Gamer.Speed)>0.02 then Gamer.Speed:=Gamer.Speed*0.95;
    if Gamer.Speed>0 then Gamer.AngleX:=Gamer.AngleX+(TR*4)*((Gamer.Speed)/2);
  end;


      Gamer.d.x:= -Sin(Gamer.angleX/180*Pi)*Gamer.Speed;
      Gamer.d.z:= -cos(Gamer.angleX/180*Pi)*Gamer.Speed; //end;

  if abs(TR)>1 then Gamer.Speed:=Gamer.Speed*(abs(TR)/abs(TR*1.005));
  if abs(TR)>0.04 then begin TR:=TR*(0.96/(1/1+abs(Gamer.Speed)*0.11)); end;
  if abs(TR)<=0.04 then TR:=0;

  if (K_D(VK_D)<>false)  then  begin
      TR:=TR-0.2;
  end;
  if (K_D(VK_A)<>false)  then  begin
      TR:=TR+0.2;
      end;


  Gamer.AngleX:=Gamer.AngleX+(TR*2)*((Gamer.Speed)/2);




  result:=Gamer;
end;



procedure Check_test();
var T:real;
begin
  begin
    try                                                               //
      if MouseMove1=false then                                        //
        begin                                                         //
          GetCursorPos(M3M.Point);                                        //
          M3M.TempX1:=M3M.point.X;                                            //
          M3M.TempY1:=M3M.point.Y;                                            //
          MouseMove1:=true;                                           //
        end;                                                          //
    finally                                                           //                                        //
        if MouseMove1=true then                                       //
          begin                                                       //
            M3M.TempX2:=screen.Width div 2;                                          //
            M3M.TempY2:=screen.Height div 2;                                          //
            M3M.SingX:=M3M.TempX1-M3M.TempX2;                             //
            M3M.SingY:=M3M.TempY1-M3M.TempY2;                             //
            T:=(M3M.SingY/(16));
            VistrY:=T;                        //
            VistrX:=p.angleX+180+(-M3M.SingX/25);                            //
            M3M.TempX1:=0;                                                //
            M3M.TempY1:=0;                                                //
            M3M.TempX2:=0;                                                //
            M3M.TempY2:=0;                                                //
            M3M.SingX:=0;                                                 //
            M3M.SingY:=0;                                                 //
            MouseMove1:=false;                                        //
          end;                                                        //
      end;
  end;
end;

//////----------------****************************************************---------------------------////

procedure Mouse_Move();
begin
  begin
    try                                                               //
      if MouseMove1=false then                                        //
        begin                                                         //
          GetCursorPos(M3M.Point);                                        //
          M3M.TempX1:=M3M.point.X;                                            //
          M3M.TempY1:=M3M.point.Y;                                            //
          MouseMove1:=true;                                           //
        end;                                                          //
    finally                                                           //
      SetCursorPos(screen.Width div 2,screen.Height div 2);           //
      GetCursorPos(M3M.Point) ;                                           //
        if MouseMove1=true then                                       //
          begin                                                       //
            M3M.TempX2:=M3M.point.X;                                          //
            M3M.TempY2:=M3M.point.Y;                                          //
            M3M.SingX:=M3M.TempX1-M3M.TempX2;                             //
            M3M.SingY:=M3M.TempY1-M3M.TempY2;                             //
            view.AngleY  :=view.AngleY  +(-M3M.SingY/8);                        //
            view.angleX:=view.angleX+(-M3M.SingX/4);                            //
            M3M.TempX1:=0;                                                //
            M3M.TempY1:=0;                                                //
            M3M.TempX2:=0;                                                //
            M3M.TempY2:=0;                                                //
            M3M.SingX:=0;                                                 //
            M3M.SingY:=0;                                                 //
            MouseMove1:=false;                                        //
          end;                                                        //
      end;
  end;
end;

//////----------------****************************************************---------------------------////


procedure IdenTifiWindow(ClientWidth, ClientHeight:integer);
begin
  glViewport(0, 0, ClientWidth, ClientHeight); //выделяем область куда будет выводиться наш буфер
  glMatrixMode ( GL_PROJECTION ); //переходим в матрицу проекции
  glLoadIdentity;  //сбрасываем текущую матрицу
  gluPerspective(60,ClientWidth/ClientHeight,1,10000); //Область видимости
  glMatrixMode ( GL_MODELVIEW ); //переходим в модельную матрицу
  glLoadIdentity;//сбрасываем текущую матрицу
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






end.
