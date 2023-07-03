//// MG_ENGINE
///  Created by Squares Projeng  ©
///
unit GUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DglOpenGL, DGLUT, mmSystem, Textures, Mesh, Resurce, ExtCtrls,Command,GFonts,math,
  Mechanic,Controller,Scripter,Phisics,GUIUnit,MGEFBO,
  Bass,MGEAudioEngine,Animation,MGEAIController,Neural;


type
  TForm1 = class(TForm)
      Timer1: TTimer;
      DrawGrGL: TTimer;
      PhisicsTimer: TTimer;
      Timer2: TTimer;
      Timer3: TTimer;
    Timer4: TTimer;
    Timer5: TTimer;
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Timer3Timer(Sender: TObject);
    procedure PhizProcessTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



Type
  Mapfon=record
    x,y,sx,sy:real;
    Z:Byte;
    public
      //procedure
  end;
  Type
    VrTem3D=array[0..2] of integer;

 const
  Msize = 20;

var
  Form1: TForm1;
  DC, RC : HGLRC;
  Audio:MGEAudio;
  mainflore,myfirstplane,plZT,myftplane:MGEPPlane;
  MyTextKlav:String;
  PhizPlane:array of MGEPPlane;
  PhizFence:array of MGEPPlane;
  Polg:array of MGEPTriangle;
  Polig:MGEPTriangle;

  RayCast:Controller.MGEPoint3D;
  NPlanes:integer;
  SkyR,SkyG,SkyB:Byte;

  TGATex:array of GLUint;
  TGAName:array of String;

  GMSmode1:array of TGLMultyMesh;
  GMSName:array of String;



  TGAN,MnoP,PPN,PFN,Timemouse,NPlG:integer;
  TR,Kolver,PlaneLift:real;
  GOSHA:MGESkelet;
  Anim1:array[1..120] of MGESkelet;

  Frp,frm,frf,TPR,SuperInt,TTR,SI,TecModID,TecTexID,OLS,FrameA:integer;
  CRX,CRY,DayT,TecSizeXID,TecSizeYID,TecSizeZID,TecRotID,AnUp,UnT:real;
  Phantom, BossCar:MGEVehicle;

  CheckPoint:MGE3DSprite;

  MyOList:MGE3DObjectList;
  GameMode:Byte;
  drive:boolean;

  Charact:array[0..1] of MGEСharacter;
  Bot1:MGEBot;
  Boss:MGEDriver;
  StarButton:MGEButton;

  MassP:array of MGEPoint3D;


  Mass:array[0..65,0..65] of Byte;
  Race1,Race2:MGERace;




procedure glBindTexture(target: TGLenum; texture: TGLuint); stdcall; external opengl32;


implementation

{$R *.dfm}



procedure LoadFizTer();
  var
    fi:textfile;
    TempVert:array of MGEPoint3D;
    TempF:array of VrTem3D;
    I,NV,NF,Upi:integer;
begin
  Upi:=200;
  assignfile(fi,MGELocation+'\resource\MGEModels\Terrain.gms'); reset(fi);
  readln(fi); readln(fi); readln(fi);
  read(fi, NV); readln(fi, NF); readln(fi);
  SetLength(TempVert,NV+1);
  SetLength(TempF,NF+1);
  for I := 1 to NV do  begin
     readln(fi, TempVert[I].x, TempVert[I].y,TempVert[I].z);
  end;
   readln(fi); readln(fi);
  for I := 1 to NF do  begin
     readln(fi, TempF[I][0], TempF[I][1],TempF[I][2]);
  end;
  closefile(fi);
        for I := 1 to NF do  begin
              NPlG:=NPlG+1;
              SetLength(Polg,NPlG);
              Polg[NPlG-1].SetTriangle(TempVert[TempF[I][0]].x,TempVert[TempF[I][0]].z+Upi,TempVert[TempF[I][0]].y,
                                        TempVert[TempF[I][2]].x,TempVert[TempF[I][2]].z+Upi,TempVert[TempF[I][2]].y,
                                        TempVert[TempF[I][1]].x,TempVert[TempF[I][1]].z+Upi,TempVert[TempF[I][1]].y);
            end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 EXEFILE:String;
 MP,MS:MGEPoint2D;
 I,j,x,y,OX,OY,G,K,MSZ,HeighM:integer;
 fi,fom:Textfile;
 tppo1,tppo2:MGEPoint3D;
 U:TBitmap; R:byte;
 Color:TColor;
begin
  EXEFILE := ExtractFileDir(ParamStr(0));
  MGELocation := ExtractFileDir(EXEFILE);
  LoadSettings(MGELocation+'\resource\MGEScripts\Setings.mges');

  InitOpenGL;//инициализируем все необходимые параметры и расширения
  DC := GetDC(Form1.Handle); //получаем адрес формы
  RC := CreateRenderingContextVersion(DC, [opDoubleBuffered], 2, 0, false, 32, 24, 8, 0, 0, 0);
  ActivateRenderingContext(DC, RC); //Активируем созданный контекст
///////////////загрузка ресурсов движка и игры /////////////////////

/////////////////////////////////////////////////////////////

LoadFizTer();


  SBK:=false;
  LoadMainResource();
  Load_First_Tex_settings();
  Load_Game_Textures();
  Load_Game_Models();
  LoadModelSkel();
  Load_Game_Settings();
  InitFBO;

  SkyCrea();

  GOSHA.LoadSkelet(MGELocation+'\resource\MGESkelets\Gosha.mges');
        for i:=1 to 120 do begin
        Anim1[i].LoadSkelet(MGELocation+'\resource\MGESkelets\Anim1\A'+IntTostr(i)+'.mgaf');
      end;    FrameA:=1;
  Charact[0].Create(SetP3D(-66,30,1514),SetP3D(0.10,0.10,0.10),SetP3D(0.1,0.1,0.1),180,10);
  test3d.Create(1000,100,100,30,30,90,Ttextobj[100]);

  STFon.Load_Font(MGELocation+'\resource\MGEFonts\MainFont.abc');
  minmap.Create(TGATex[0],MGEW/2,MGEH/2,MGEW/2,MGEH/2);

  CheckPoint.Create(100,100,1000,50,-600,0,TGATex[10]);


  MS.x:=100;
  MP.x:=0;
  MP.y:=0;
  MS.x:=1000;
  MS.x:=1000;
  World.Create(0,0,1000,1000,0,Ttextobj[1]);
  PPN:=4;
  PFN:=24;
  SetLength(PhizPlane,PPN);
  SetLength(PhizFence,PFN);
  PhizPlane[0].SetPlane(-10000,10000,-2001,-2003,-10000,10000,1);
  PhizPlane[1].SetPlane(400,2500,-1000,-1000,100,400,1);
  PhizPlane[2].SetPlane(100,400,-1300,-1000,100,400,1);
  PhizPlane[3].SetPlane(200,400,-1000,-900,400,700,0);


  PhizFence[0].SetPlane(-41,249,-10,40,2072,2065,2);
  PhizFence[1].SetPlane(249,478,-10,40,2065,1894,2);
  PhizFence[2].SetPlane(478,479,-10,40,1894,1062,2);
  PhizFence[3].SetPlane(479,323,-10,40,1062,775,2);
  PhizFence[4].SetPlane(323,87,-10,40,775,765,2);
  PhizFence[5].SetPlane(87,-185,-10,40,765,775,2);
  PhizFence[6].SetPlane(-185,-359,-10,40,775,947,2);
  PhizFence[7].SetPlane(-359,-357,-10,40,947,1189,2);
  PhizFence[8].SetPlane(-359,-363,-10,40,1189,1349,2);
  PhizFence[9].SetPlane(-363,-641,-10,40,1349,1560,2);
  PhizFence[10].SetPlane(-641,-419,-10,40,1560,2052,2);
  PhizFence[11].SetPlane(-419,-41,-10,40,2052,2072,2);

  PhizFence[12].SetPlane(-46,-46,-10,40,1276,1478,2);
  PhizFence[13].SetPlane(-46,9,-10,40,1478,1478,2);
  PhizFence[14].SetPlane(9,9,-10,40,1478,1276,2);
  PhizFence[15].SetPlane(-46,9,-10,40,1276,1276,2);

  PhizFence[16].SetPlane(22,22,-10,40,1117,1073,2);
  PhizFence[17].SetPlane(22,143,-10,40,1073,1073,2);
  PhizFence[18].SetPlane(143,143,-10,40,1073,1320,2);
  PhizFence[19].SetPlane(143,22,-10,40,1320,1320,2);
  PhizFence[20].SetPlane(22,22,-10,40,1320,1277,2);
  PhizFence[21].SetPlane(22,77,-10,40,1277,1277,2);
  PhizFence[22].SetPlane(77,77,-10,40,1277,1117,2);
  PhizFence[23].SetPlane(77,22,-10,40,1117,1117,2);




  Polig.SetTriangle(-400,0,0,-200,0,500,-900,500,100);


 ////////////////Наша машинка
  Phantom.Create(SetP3D(386,294,-2),SetP3D(5,5,5),SetP3D(0.1,0.1,0.1),
  7,2.5,3,3,1.30,9.25,-2.5,1.455,210);

  BossCar.Create(SetP3D(386,274,-2),SetP3D(5,5,5),SetP3D(0.1,0.1,0.1),
  7,2.5,3,3,1.30,9.25,-2.5,1.462,210);

////////////////////////////////


  Race1.Create([SetP3D(-50,195,-553),
SetP3D(-32,195,-1739),
SetP3D(-188,195,-2182),
SetP3D(-599,195,-2313),
SetP3D(-1097,195,-2398),
SetP3D(-1478,195,-2362),
SetP3D(-1677,175,-1875),
SetP3D(-1396,215,-1787),
SetP3D(-887,235,-1848),
SetP3D(-701,330,-1659),
SetP3D(-772,330,-1340),
SetP3D(-1259,255,-1240),
SetP3D(-1668,240,-1213),
SetP3D(-1550,220,-845),
SetP3D(-1089,235,-810),
SetP3D(-726,220,-954),
SetP3D(-477,220,-826),
SetP3D(-481,220,-428),
SetP3D(-827,220,-173),
SetP3D(-1307,220,-276),
SetP3D(-3037,220,-306),
SetP3D(-3332,242,-592),
SetP3D(-3302,242,-940),
SetP3D(-2776,242,-1147),
SetP3D(-2341,242,-1034),
SetP3D(-2080,242,-1268),
SetP3D(-2113,217,-1777),
SetP3D(-2405,187,-1996),
SetP3D(-2823,192,-2221),
SetP3D(-2979,222,-2524),
SetP3D(-3203,204,-2766),
SetP3D(-2808,179,-3085),
SetP3D(-2229,194,-3005),
SetP3D(-1513,194,-3121),
SetP3D(-1133,222,-3029),
SetP3D(-412,187,-3053),
SetP3D(430,187,-2542),
SetP3D(644,229,-1614),
SetP3D(643,199,-319),
SetP3D(344,189,-92),
SetP3D(22,189,-221),
SetP3D(-48,189,-470)]);
  Race2:=Race1;
  

  MenuMap.Create(600,600,2000,2000,0,Ttextobj[5]);
  LO.Create(MGEW/2,MGEH/2,MGEW/20,MGEW/100,0,Ttextobj[0]);
/////////////// создание класса персонажа и настроек игры////////////
  My3dFire.Create(100,40,-100,10,20,40,40,-1.0,-0.7,0,2,SmoF,SmoF);

  Fire001.Create(-240,20,1157,12,30,60,120,-0.2,-0.8,0,2,FrameF,SmoF);

  Fir.Create(-100,-100,30,30,20,80,30,-0.1,0.4,2,FrameF,SmoF);


  Ttextobj[52]:=CreateMGETexture(sWidth,sHeight, GL_RGBA,@blm);
  Ttextobj[51]:=CreateMGETexture(sWidth,sHeight, GL_RGBA,@blm3);
  Ttextobj[57]:=CreateMGETexture(sWidth,sHeight, GL_RGBA,@blm4);

  CreateMenu();
  StarButton.Create(40,40,30,30,MGEFR[4],True,'Начать гонку');

  MenuStay:=0;  //////////// =0 - меню
  P.create(0,10,0,20,60,20);
  TecSizeXID:=10;
  TecSizeYID:=10;
  TecSizeZID:=10;

  GUICursor.create;
  GUICursor.skin:=Ttextobj[100];
  CamRad:=20;

  TranScripts();
  Frp:=1;
  Frm:=1;
//////////////////////////////////////////////////////////////
///  /////////////////////////Звук
 { CheckAudioEngine();
  if not BASS_Init(-1,44100,0,Application.Handle,nil) then Showmessage('Can''t initialize device');
  Audio.LoadAB(MGELocation+'\resource\Car.mp3');      }


  MnoP:=1;
  UnT:=0.025;
  Gen:=false;
  //if FSN<>'True' then
  StartSetWindow();
  PhBox.SetBox(100,-200,20,20,20,20);


  MyOList.Add(SetP3D(-255,392,2421),SetP3D(2500,2500,2500),SetP3D(-90,0,180),24,15); ///////////Mountain

  CreateRedactor();
  GameMode:=0;
  ClientWidth:=FMW;
  ClientHeight:=FMH;  //ReadScript('MyMap.txt');
end;
procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
CamRad:=CamRad+2;
if K_D(VK_LShift)=true then CamRad:=CamRad+8;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
CamRad:=CamRad-2;
if K_D(VK_LShift)=true then CamRad:=CamRad-8;
end;

procedure TForm1.FormPaint(Sender: TObject);
var Mx:boolean;
begin
  IdenTifiWindow(ClientWidth, ClientHeight);
  if (Form1.WindowState=wsMaximized) and (Form1.BorderStyle=bsNone) then Mx:=true else Mx:=false;
  LoadMGEWinSet(ClientWidth, ClientHeight, Form1.Left, Form1.Top, Mx);
  Active_UnActive_system();      ///////// консоль
    if (K_D(VK_ESCAPE)<>false) then  MenuStay:=1;
    if (K_D(VK_LButton)=false) and (K_D(VK_RButton)=false) and (bclick=true) then bclick:=false;
    if (K_D(VK_LButton)=true) then flying:=true;
    if (K_D(VK_LButton)=false) then flying:=false;

     if (bclick=true) then begin
       Race1.StartRace(BossCar);
       Race2.StartRace(Phantom);
    end;

    if MenuStay=100 then Form1.Close;

/////////////////////ставим камеру персонажа ////////////////////////

  DrawFrameScene(ClientWidth, ClientHeight);
  if MenuStay=0 then begin
    EndRender();
    FrameTest();
  end
  else
  begin
    //DrawFrameLoad(ClientWidth, ClientHeight);
    FrameTest();
  end;

//////////////// счетчик fps и буфер кадра
  FP:=FP+1;
  SwapBuffers(Canvas.Handle);
  DayHour:=DayHour+0.001;
if DayHour>7 then DayHour:=0;

  if (FrameA<120) then FrameA:=FrameA+1;
  if (FrameA=120) and (Bot1.KW=true) then FrameA:=1;
  if abs(Charact[0].Speed)>0 then AnUp:=AnUp+UnT;
  If (AnUp>0.7) or (AnUp<=0) then UnT:=-UnT;

end;
procedure TForm1.PhizProcessTimer(Sender: TObject);
begin
  UpdatePhisicsG();
 // if (K_D(VK_W)=true) or (K_D(VK_S)=true) then Audio.Play(0,False,0,0,0) else Audio.Stop(0); Для звука
end;
procedure TForm1.Timer1Timer(Sender: TObject);
begin


  //if (K_D(VK_W)<>false){ and (drive=false) }then Audio.Play(0,false,Phantom.MCP[1].p.x,Phantom.MCP[1].p.y,Phantom.MCP[1].p.z);
  if (K_D(VK_G)=true) then begin Race1.StartRace(Phantom);
  end;


  FPS:=FP;
  FPST:=inttostr(FPS);
  FP:=0;
  if (FPS>=80)  then  DrawGrGL.Interval:=4;
  if (FPS>=50) and (FPS<80)  then  DrawGrGL.Interval:=8;
  if (FPS>=25) and (FPS<50)  then  DrawGrGL.Interval:=15;
  if (FPS>=10) and (FPS<25)  then  DrawGrGL.Interval:=30;
  if (FPS>=5) and (FPS<10)  then  DrawGrGL.Interval:=80;
  if (FPS>=2) and (FPS<5)  then  DrawGrGL.Interval:=170;

  //if (K_D(VK_W)<>false) then drive:=true;
  //if (K_D(VK_W)<>true) then drive:=false;
end;
procedure TForm1.Timer2Timer(Sender: TObject);
begin
  SkyCrea();
end;
procedure TForm1.Timer3Timer(Sender: TObject);
begin
   SkyNew(); SkyTime();
end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i: ShortInt;
begin
  glDeleteFramebuffersEXT ( 1 ,  @ fbo ) ;
  glDeleteRenderbuffersEXT ( 1 ,  @ depthbuffer ) ;
  glDeleteTextures ( 1 ,  @ tex ) ;

  ClosefileModels();

  mode1s[0].Free;
  mode1s[1].Free;
  mode1s[2].Free;
  mode1s[3].Free;
  mode1s[4].Free;
  mode1s[5].Free;
  mode1s[6].Free;


  showCursor(true);
end;

end.
