unit GFonts;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DglOpenGL, DGLUT, Textures,command;


type
  FFont = record
    x,y,sim,Leg,a: integer;
 end;

//////----------------****************************************************---------------------------////

var
  cis:integer;
  Sim:array[1..196] of string;
  FontI:array[1..196] of FFont;

//////----------------****************************************************---------------------------////

procedure Smart_Symvol(a:char);
procedure MassivTexta();
procedure Enable_sun();
procedure Disable_sun();
procedure Render_Symvol(Simvol:string; Size,X,Y,D,S:real;  R,G,B:Byte);
function Symvol_Button(Simvol:string; Size,X,Y,D,S:real;  R,G,B:Byte; KeyN,KeyB:integer):integer;
procedure R3D_To_2D(ClientWidth, ClientHeight:integer);
procedure R2D_To_3D();


implementation
uses GUI,GUIUnit,Resurce;


procedure Enable_sun();
begin
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  //glEnable(GL_LIGHT1);
end;

//////----------------****************************************************---------------------------////

procedure Disable_sun();
begin
  glDisable(GL_LIGHTING);
  glDisable(GL_LIGHT0);
  //glDisable(GL_LIGHT1);
end;

//////----------------****************************************************---------------------------////

procedure Enable_Atest();
begin
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_NORMALIZE);
  glEnable(GL_COLOR_MATERIAL);
  glShadeModel(GL_SMOOTH);
end;

//////----------------****************************************************---------------------------////

procedure Disable_Atest();
begin
  glDisable(GL_NORMALIZE);
  glDisable(GL_COLOR_MATERIAL);
  glDisable(GL_DEPTH_TEST);
end;

//////----------------****************************************************---------------------------////

procedure SpriteButton(PX,PY,SX,SY:real;Pict:Uint; Key:integer);
var X,Y:integer;
begin
  GetCursorPos(M3M.Point);
  X:=-Form1.Left +M3M.Point.X;
  Y:=-Form1.Top-15  +M3M.point.Y;

  RenderSprite(PX,PY,SX,SY,0,Pict);
    if (X<px+sx) and (X>px-sx) then
      if (Y<py+sy) and (Y>py-sy) then
        if (GetAsyncKeyState(VK_LBUTTON)<>0) and (MBL=false) then
          begin
          if Key=10 then
            begin
              // RayCast();
            end;
          if Key<>10 then
            begin
             // MenuG.Stay:=Key;
            end;
            MBL:=true;
      end;
end;

//////----------------****************************************************---------------------------////


procedure MassivTexta();
  var I,Y,B,J:integer;
  Fi:textfile;
begin
assignfile(fi,'GRE\Scripts\symvols.abc');  reset(fi);
readln(fi,Y);
for I := 1 to Y do
begin
  readln(fi, Sim[I]);
end;
 Closefile(fi);
Sim[196]:= ' ';

B:=196;
  for Y := 1 to 14 do
      for I := -14 to -1 do
        begin
          FontI[B].x:=I*(-1);
          FontI[B].y:=Y;
          B:=B-1;
        end;

end;

//////----------------****************************************************---------------------------////   

procedure Smart_Symvol(a:char);
  var I:integer;
begin
  for I := 1 to 196 do
    begin
      if a = Sim[I] then
        begin
          cis:=I;
        end;
    end;
end;

//////----------------****************************************************---------------------------////

procedure Render_Symvol(Simvol:string; Size,X,Y,D,S:real; R,G,B:Byte);
  var BB,I:Integer;
      Text:FFont;
begin
  Text.Leg:=Length(Simvol);
  glPushMatrix;
  Disable_sun();
  glBindTexture(GL_TEXTURE_2D, FontF);
  glColor3f(R,G,B);
    for I := 1 to Text.Leg do
      begin
        Smart_Symvol(Simvol[I]);
        BB:=cis;
          glBegin(GL_Quads);
            glTexCoord2f((FontI[BB].x-1)/14, (FontI[BB].y)/14);   glVertex2f((-1*Size)+x+((Size*1.5)*I), (-1*Size)+Y);
            glTexCoord2f((FontI[BB].x-1)/14, (FontI[BB].y-1)/14); glVertex2f((-1*Size)+X+((Size*1.5)*I), (1*Size)+Y);
            glTexCoord2f((FontI[BB].x)/14,   (FontI[BB].y-1)/14); glVertex2f((1*Size)+X+((Size*1.5)*I),  (1*Size)+Y);
            glTexCoord2f((FontI[BB].x)/14,   (FontI[BB].y)/14);   glVertex2f((1*Size)+X+((Size*1.5)*I),  (-1*Size)+Y);
          glEnd;
      end;
  glColor3f(255,255,255);
  GLpOPmATRIX;
end;

//////----------------****************************************************---------------------------////

function Symvol_Button(Simvol:string; Size,X,Y,D,S:real; R,G,B:Byte; KeyN,KeyB:integer):integer;
  var BB,I:Integer;
      Text:FFont;
      MX,MY,H:integer;
begin

  GetCursorPos(M3M.Point);
  MX:=-Form1.Left +M3M.Point.X;
  MY:=-Form1.Top-15  +M3M.point.Y;
  Text.Leg:=Length(Simvol);
    glPushMatrix;
        if (MX<(-1*Size)+x+((Size*1.5)*(Text.Leg+1))) and (MX>(-1*Size)+x+((Size*1.5)*1)) then
          if (MY<(1*Size)+Y) and (MY>(-1*Size)+Y) then
            begin
              R:=255;
              G:=255;
              B:=0;
            end;
          Render_Symvol(Simvol,round(Size),round(X),round(Y),round(D),Round(S),R,G,B);
    GLpOPmATRIX;
      if (MX<(-1*Size)+x+((Size*1.5)*(Text.Leg+1))) and (MX>(-1*Size)+x+((Size*1.5)*1)) then
        if (MY<(1*Size)+Y) and (MY>(-1*Size)+Y) then
          if (GetAsyncKeyState(VK_LBUTTON)<>0) and (bclick=false) then
            begin
            H:=KeyB;
            bclick:=true;
            end
            else
            begin
              H:=KeyN;
            end;
            result:=H;
end;

//////----------------****************************************************---------------------------////

procedure R3D_To_2D(ClientWidth, ClientHeight:integer);
begin
  glPushMatrix;
  glLoadIdentity;
  glMatrixMode(GL_PROJECTION);
  glPushMatrix;
  glLoadIdentity;
  gluOrtho2D(0,ClientWidth, ClientHeight,0);
  glMatrixMode(GL_MODELVIEW);
end;

//////----------------****************************************************---------------------------////

procedure R2D_To_3D();
begin
  glMatrixMode(GL_PROJECTION);
  glPopMatrix;
  glMatrixMode(GL_MODELVIEW);
  glPopMatrix;
end;

end.
