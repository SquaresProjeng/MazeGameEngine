//// MAZE GAME ENGINE
///  Created by Squares Projeng  ©
///
unit GUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OpenGL, DGLUT, Textures, Mesh, Resurce, ExtCtrls,Command,GFonts,math,
  GameLavels,Mechanic;

 const
 Pi =3.14;
  size = 20;
  MSIZE = 1024;
type
   TVector = record  //¬ектор
   X,Y,Z:GLfloat;
   end;


   TCamera = record
   Pos: Tvector;         //ѕозици€ камеры
   PhiY: single;         //вертикальный улол поворота камеры
   PhiX: single;         //горизонтальный
   Speed: glFloat;       //—корость камеры
   end;


  TForm1 = class(TForm)
    Timer1: TTimer;
    DrawGrGL: TTimer;
    PhizProcess: TTimer;
    procedure PhizProcessTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  //  procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

tnew = class(tthread)
private
{ private declarations }
protected
procedure execute; override;
end;



var
  Form1: TForm1;
  HRC : HGLRC;
  MouseMove1: boolean;
  glLightPos: array[0..3] of glFloat = (100,100,100,1);
  glLightPos1: array[0..3] of glFloat = (300.0, 1000.0, 500.0, 0);
  glLightPos2: array[0..3] of glFloat = (-300.0, -1000.0, -500.0, 0);

   light0_diffuse:array[0..3] of glFloat = (1.0, 1.0, 0.4, 1.0);

   dir:array[0..2] of glFloat = (-1.0, 1.0, -1.0);
   dir2:array[0..2] of glFloat = (1.0, -1.0, 1.0);


  TempX1,TempY1,SingX,SingY,TempX2,TempY2,k : integer;
  Point: Tpoint;
  FPS,FP:integer;
  P,view:FPlayer;
  TObj,TObj2 : TGLMultyMesh;
   Cursor1,W,S,D,FontF: Uint;

   provrka,WX,WY:integer;
   cetest:byte;
   Sky,Grass,board:BBoxT;
   Blocks:array[0..255] of BBoxT;
   Ttextobj : array[0..256] of Uint;
   pistol:Uint;
   Blocs:integer;
   bclick,lmb,rmb, GAMESTARTED:boolean;
   MyBlock:byte;
   Mass:array[0..2047,0..127,0..2047] of Byte;
   pospis:real;
   ffps,fpsu,put:integer;
   MenuStay:integer;
   Graph:tnew;


procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;
function Summae(a,b:real):real;  external  'MIZEENG';



implementation

{$R *.dfm}



procedure tnew.execute;
var
 I,J,Y,G,K:integer;
 U:TBitmap;
 Color:TColor;
 R:byte;
 br,dr,td,btd:byte;
 DE,DTX,DTY,DTZ: Integer;
begin
{ place thread code here }
//  од, который будет выполн€тьс€ в отдельном потоке
    if GAMESTARTED=FALSE then
      begin
        U:= TBitmap.Create;
        U.LoadFromFile('Data\Map2.bmp');
        sleep(100);
          for I := 0 to MSIZE-1 do
            for J := 0 to 127 do
              for Y := 0 to MSIZE-1 do
                begin
                    Mass[I,J,Y]:=0;
                end;
        for G := 0 to MSIZE-1 do
          for K := 0 to MSIZE-1 do
            begin
              Color:=U.Canvas.Pixels[K,G];
              R:=GetBValue(Color);
                for I := 0 to Round(R/4)-1 do
                  begin
                    If I<Round(R/4)-1 then Mass[K,I,G] := 9 ;
                    If I<3 then Mass[K,I,G] := 5 ;
                    If I=Round(R/4)-1 then Mass[K,I,G] := 1 ;

                  end;

            end;
            sleep(10);
        U.Free;
        randomize;
          for G := 3 to MSIZE-9 do
            for K := 3 to MSIZE-9 do
              for I := 3 to 120 do
                begin
                  if (Mass[K,I+1,G]=0) and  (Mass[K,I,G]=1)  then
                    begin
                      br:=random(400);
                        If br=25 then
                          begin
                            dr:=3+random(5);
                              for DE := 0 to dr do
                                begin
                                  Mass[K,I+DE,G] := 6 ;
                                end;
                            td:=1+random(3);
                              for DTX := -td to td do
                                for DTz := -td to td do
                                  for DTY := 0 to td+td do
                                    begin
                                      btd:=random(2);
                                      if btd=1 then   Mass[K+DTX,I+DR+DTY,G+DTZ] := 7 ;
                                    end;
                          end;
                    end;
                  if (Mass[K,I+1,G]=0) and  (Mass[K,I,G]=1)  then
                    begin
                      br:=random(25);
                        If br=10 then
                          begin
                            Mass[K,I+1,G] := 21 ;
                          end;
                    end;

                end;
          GAMESTARTED:=true;
      END;
      P.create(2000,1000,2000);
  Form1.PhizProcess.Enabled:=true;

  sleep(10000);
  terminate;
end;



procedure ViewTest();
  var x,y,z:real;
    dist, VX,VY,VZ,oldX,oldY,oldZ:integer;
begin
  x:=p.X-size/2;
  y:=p.Y+p.h/2-size/2;
  z:=p.Z-size/2;
  dist:=500;

    if abs(tan(p.AngleY/180*Pi))>1 then
    begin
      x:=x-(sin(p.angleX/180*pi)/abs(tan(p.AngleY/180*Pi))*dist); VX:=round(x);
      y:=y+(tan(p.AngleY/180*Pi)/abs(tan(p.AngleY/180*Pi))*dist); VY:=round(y);
      z:=z-(cos(p.angleX/180*pi)/abs(tan(p.AngleY/180*Pi))*dist); VZ:=round(z);
    end
    else
    begin
      x:=x-(sin(p.angleX/180*pi)*dist); VX:=round(x);
      y:=y+(tan(p.AngleY/180*Pi)*dist); VY:=round(y);
      z:=z-(cos(p.angleX/180*pi)*dist); VZ:=round(z);
    end;

  view.X:=VX;
  view.Y:=VY;
  view.Z:=VZ;
end;

procedure BoxManager();
  var x,y,z:real;
    dist, VX,VY,VZ,oldX,oldY,oldZ:integer;
begin
  if (lmb=true) or (rmb=true) then
  begin
    x:=p.X-size/2;
    y:=p.Y+p.h/2-size/2;
    z:=p.Z-size/2;
    dist:=0;
  while dist<100 do
    begin
      dist:=dist+1;
        if abs(tan(p.AngleY/180*Pi))>1 then
          begin
            x:=x-sin(p.angleX/180*pi)/abs(tan(p.AngleY/180*Pi)); VX:=round(x/size);
            y:=y+tan(p.AngleY/180*Pi)/abs(tan(p.AngleY/180*Pi)); VY:=round(y/size);
            z:=z-cos(p.angleX/180*pi)/abs(tan(p.AngleY/180*Pi)); VZ:=round(z/size);
          end
            else
          begin
            x:=x-sin(p.angleX/180*pi); VX:=round(x/size);
            y:=y+tan(p.AngleY/180*Pi); VY:=round(y/size);
            z:=z-cos(p.angleX/180*pi); VZ:=round(z/size);
          end;
        if (Check(VX,VY,VZ)<>0) and (VY>1) then
          begin
            if lmb=true then mass[VX,VY,VZ]:=0;
              if (rmb=true) and (Check(oldX,oldY,oldZ)=0) then
                begin
                  if (dist>60) and ((tan(p.AngleY/180*Pi)<-8)
                    or (tan(p.AngleY/180*Pi)>4)) then mass[oldX,oldY,oldZ]:=MyBlock;
                      if (dist>25) and (tan(p.AngleY/180*Pi)>=-8) and (tan(p.AngleY/180*Pi)<=4) then mass[oldX,oldY,oldZ]:=MyBlock;
                end;
            lmb:=false;
            rmb:=false;
            dist:=100;
          end;
      oldX:=VX; oldY:=VY; oldZ:=VZ;
    end;
  end;
end;

procedure SetDCPixelFormat ( hdc : HDC );
var
  pfd : TPixelFormatDescriptor;
  nPixelFormat : Integer;
begin
    FillChar (pfd, SizeOf (pfd), 0);
    pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
    nPixelFormat := ChoosePixelFormat (hdc, @pfd);
    SetPixelFormat (hdc, nPixelFormat, @pfd);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetDCPixelFormat(Canvas.Handle);
  hrc := wglCreateContext(Canvas.Handle);
  wglMakeCurrent(Canvas.Handle, hrc);
///////////////загрузка ресурсов движка и игры /////////////////////
  MassivTexta();
  Load_First_Tex_settings();
  Load_Game_Textures();
  Load_Game_Models();
  Load_Game_Settings();
/////////////// создание класса персонажа и настроек игры////////////
  GAMESTARTED:=FALSE;

  MyBlock:=1;
  provrka:=2;
  MenuStay:=0;
  put:=1;
  Graph:=tnew.Create(true);
  Graph.freeonterminate := true;
  Graph.priority := tphighest  ;
  Graph.resume;



end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  IdenTifiWindow(ClientWidth, ClientHeight);
  Active_UnActive_system();      ///////// консоль
    if (GetAsyncKeyState(VK_ESCAPE)<>0) then
      begin
        Close;
      end;
    if (GetAsyncKeyState(VK_LButton)=0) and (GetAsyncKeyState(VK_RButton)=0) and (bclick=true) then
      begin
        bclick:=false;
      end;
/////////////////////ставим камеру персонажа ////////////////////////
  GluLookAt(P.X,P.Y+P.h/2,P.Z,   P.X-sin(P.angleX/180*Pi),  P.Y+P.h/2+tan(P.AngleY/180*Pi),P.Z-cos(P.angleX/180*Pi),0,1,0);
/////// делаем проверку активности меню и загрузки ресурсов и выводим нужную сцену
  if GAMESTARTED=true then MainGame(ClientWidth, ClientHeight);
  if GAMESTARTED=false then MainGameLoad(ClientWidth, ClientHeight);
//////////////// счетчик fps и буфер кадра
  FP:=FP+1;
  SwapBuffers(Canvas.Handle);
end;

procedure TForm1.PhizProcessTimer(Sender: TObject);
var I,J,Y:integer;
  dir:real;
  RX,RY,RZ:integer;
begin
  if GAMESTARTED=true then
    begin
     if (Commande=false) then
       begin
         Mouse_Move();
       end;
      P:=Key_Move(P);
      P.dy:=P.Dy-0.2;
        if P.dy<-3 then P.dy:=-3;
      RX:=round(P.X/size);
      RY:=round(p.Y/size);
      RZ:=round(P.Z/Size);
        for I := RX-5 to RX+5 do
          for J := RY-5 to RY+5 do
            for Y := RZ-5 to RZ+5 do
              begin
                if Check(I,J,Y)=0 then
                  Continue;
                  dir:=sqrt(
                  sqr(p.X-size*i+size/2)+
                  sqr(p.Y-size*j+size/2)+
                  sqr(p.z-size*y+size/2));
                If ((Mass[I,J,Y]<>0) and (Mass[I,J,Y]<>21)
                  and (Mass[I,J,Y]<>33)) and (abs(dir)<80) then
                    begin
                      P:=NueThon(size*i+size/1.9, size*j+size/1.9, size*y+size/1.9,
                      size/2,size/2,size/2,P);
                    end;
              end;
      if P.Colizt>0 then begin
        P.onGround:=true;
      end else begin
        P.onGround:=false;
      end;
    p.Colizt:=0;
    P.X:=P.X+P.dx;
    P.Y:=P.Y+P.dy;
    P.Z:=P.Z+P.dz;
    ViewTest();
    BoxManager();
    P.dx:=0;
    P.dz:=0;
    if (pospis>10) or (pospis<-10) then put:=Put*(-1);
      pospis:=pospis+put*0.5;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
 I,J,Y,G,K:integer;
 U:TBitmap;
 Color:TColor;
 R:byte;
 br,dr,td,btd:byte;
 DE,DTX,DTY,DTZ: Integer;
begin
  FPS:=FP;
  FP:=0;
  //synchronize(tnew.execute);

end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  Form1.Handle;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  showCursor(true);
end;

end.
