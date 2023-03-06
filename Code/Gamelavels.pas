unit Gamelavels;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DglOpenGL, DGLUT, Textures,Mesh, command,GFonts,resurce,Mechanic,Controller;


  var
   Alphat,Loading:real;
   ImageM:integer;

procedure MainGameLoad(ClientWidth, ClientHeight:integer);
procedure SettingsGame(ClientWidth, ClientHeight:integer);

implementation
uses GUI,GUIUnit;


procedure MainGameLoad(ClientWidth, ClientHeight:integer);
var I,J:integer;
begin

  glClearColor(0.1, 0.1, 0.1, 0.0); // цвет фона
  //glClearColor(0.0, 0.48, 0.93, 0.0); // цвет фона
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); // очистка буфера цвета
 {  RenderFlore(10,10,10,Brick);
   RenderFlore(10,30,10,water);
   RenderGMSModel(0,0,0,10,TObj,s);  }
glPopMatrix;

R3D_To_2D(ClientWidth, ClientHeight);
    glpushmatrix();
    R3D_To_2D(ClientWidth, ClientHeight);
    //Disable_Atest();
 //////*******-------------2D MUP ----------------------------------

    GUICursor.draw;
{
if MenuStay=1 then
begin
    Symvol_Button('Меню',ClientHeight/30,ClientWidth/20,ClientHeight/10,1,1,255,100,100, 1, 5);
    if Symvol_Button('Играть',   ClientHeight/30,ClientWidth/20,ClientHeight/4,1,1,255,255,255, 1,0)=0 then MenuStay:=0;
    if Symvol_Button('Настройки',ClientHeight/30,ClientWidth/20,ClientHeight/3,1,1,255,255,255, 1,2)=2 then MenuStay:=2;
    if Symvol_Button('Выход',    ClientHeight/30,ClientWidth/20,ClientHeight/2,1,1,255,255,255, 1, 100)=100 then Form1.Close;
end;
if MenuStay=2 then
begin
    Symvol_Button('Настройки',ClientHeight/30,ClientWidth/20,ClientHeight/10,1,1,255,100,100, 2, 5);
    if Symvol_Button('Графика',   ClientHeight/30,ClientWidth/20,ClientHeight/4,1,1,255,255,255, 2,3)=3 then MenuStay:=3;
    if Symvol_Button('Экран',    ClientHeight/30,ClientWidth/20,ClientHeight/3,1,1,255,255,255, 2,5)=5 then MenuStay:=5;
    if Symvol_Button('назад',    ClientHeight/30,ClientWidth/20,ClientHeight/2,1,1,255,255,255, 2, 1)=1 then MenuStay:=1;
end;
if MenuStay=5 then
begin
    Symvol_Button('Экран',ClientHeight/30,ClientWidth/20,ClientHeight/10,1,1,255,100,100, 5, 5);
    if Symvol_Button('640х480',   ClientHeight/30,ClientWidth/20,ClientHeight/4,1,1,255,255,255, 5,31)=31 then MenuStay:=31;
    if Symvol_Button('1280х720',   ClientHeight/30,ClientWidth/20,ClientHeight/3,1,1,255,255,255, 5,32)=32 then MenuStay:=32;
    if Symvol_Button('1920х1080',   ClientHeight/30,ClientWidth/20,ClientHeight/2.5,1,1,255,255,255, 5,33)=33 then MenuStay:=33;
    if Symvol_Button('назад',    ClientHeight/30,ClientWidth/20,ClientHeight/2,1,1,255,255,255, 5, 2)=2 then MenuStay:=2;
end;
if MenuStay=3 then
begin
    Symvol_Button('Настройки графики',ClientHeight/30,ClientWidth/20,ClientHeight/10,1,1,255,100,100, 3, 5);
    Render_Symvol('дальность '+inttoStr(DISTANTION),ClientHeight/40,ClientWidth/20,ClientHeight/4,1,1,255,255,255);
    if Symvol_Button('+ ',                ClientHeight/30,ClientWidth/20,ClientHeight/3,1,1,255,255,255, 3, 11)=11 then MenuStay:=11;
    if Symvol_Button('- ',                ClientHeight/30,ClientWidth/10,ClientHeight/3,1,1,255,255,255, 3, 12)=12 then MenuStay:=12;
    if Symvol_Button('в окне',            ClientHeight/30,ClientWidth/10,ClientHeight/2,1,1,255,255,255, 3, 25)=25 then MenuStay:=25;
    if Symvol_Button('полноэкранный',     ClientHeight/30,ClientWidth/10,ClientHeight/1.5,1,1,255,255,255, 3, 24)=24 then MenuStay:=24;
    if Symvol_Button('назад',             ClientHeight/30,ClientWidth/20,ClientHeight/1.2,1,1,255,255,255, 3, 2)=2 then MenuStay:=2;

end;
if MenuStay=11 then
begin
  DISTANTION:=DISTANTION+10;
  MenuStay:=3;
end;
if MenuStay=12 then
begin
  DISTANTION:=DISTANTION-10;
  MenuStay:=3;
end;
if MenuStay=24 then
begin
  Form1.BorderStyle:=bsNone;
  Form1.WindowState:=wsMaximized;
  MenuStay:=3;
end;
if MenuStay=25 then
begin
  Form1.BorderStyle:=bsSizeable;
  Form1.WindowState:=wsNormal;
  MenuStay:=3;
end;

if MenuStay=31 then
begin
  Form1.Height:=480;
  Form1.Width:=640;
  MenuStay:=5;
end;

if MenuStay=32 then
begin
  Form1.Height:=720;
  Form1.Width:=1280;
  MenuStay:=5;
end;

if MenuStay=33 then
begin
  Form1.Height:=1080;
  Form1.Width:=1920;
  MenuStay:=5;
end;
    RenderSprite(ClientWidth/2,ClientHeight/2,ClientWidth/1.9,ClientHeight/1.9,0,Men[1]);
    RenderSprite(ClientWidth/1.5+Loading,ClientHeight/2,ClientWidth/1.5,ClientHeight/2,0,Men[2+ImageM]);

    Symvol_Button('fps= '+inttostr(fps),15,20,ClientHeight-60,1,1,255,255,255, 0, 5);
glPushMatrix;
    R2D_To_3D();
    glpopmatrix();
    //Disable_Atest();
  glPopMatrix;
 {      R2D_To_3D();
    glpopmatrix();
    //Disable_Atest();
  glPopMatrix;
 {  RenderFlore(10,10,10,Brick);
   RenderFlore(10,30,10,water);
   RenderGMSModel(0,0,0,10,TObj,s);  }


glPopMatrix;

R3D_To_2D(ClientWidth, ClientHeight);

  Loading:=Loading+0.4;
  if Loading>200 then begin
    ImageM:=ImageM+1;
    Loading:=-40;
  end;
  if ImageM>2 then  ImageM:=0;
end;


procedure SettingsGame(ClientWidth, ClientHeight:integer);
var I,J:integer;
begin
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); // очистка буфера цвета
glPopMatrix;

R3D_To_2D(ClientWidth, ClientHeight);
    glpushmatrix();
    R3D_To_2D(ClientWidth, ClientHeight);
 //////*******-------------2D MUP ----------------------------------
    GetCursorPos(M3M.Point);
    RenderSprite(M3M.Point.X, M3M.Point.y,ClientWidth/60, ClientHeight/60,0,Cursor1);

  {  Symvol_Button('Настройки',40,40,50,1,1,255,100,100, 2, 5);
    if Symvol_Button('Графика',   40,40,250,1,1,255,255,255, 2,3)=3 then MenuStay:=3;
   // if Symvol_Button('Звук',40,40,450,1,1,255,255,255, 2,4)=4 then MenuStay:=4;
    if Symvol_Button('назад',    40,40,650,1,1,255,255,255, 2, 1)=1 then MenuStay:=1;  }


    RenderSprite(ClientWidth/2,ClientHeight/2,ClientWidth/1.9,ClientHeight/1.9,0,Men[1]);
    RenderSprite(ClientWidth/1.5+Loading,ClientHeight/2,ClientWidth/1.5,ClientHeight/2,0,Men[2+ImageM]);
glPushMatrix;
    R2D_To_3D();
    glpopmatrix();
  glPopMatrix;
glPopMatrix;

R3D_To_2D(ClientWidth, ClientHeight);

  Loading:=Loading+0.4;
  if Loading>200 then begin
    ImageM:=ImageM+1;
    Loading:=-40;
  end;
  if ImageM>2 then  ImageM:=0;
end;
end.
