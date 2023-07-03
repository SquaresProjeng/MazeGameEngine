unit GUIunit;

interface
 uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DglOpenGL, DGLUT, Textures, Mesh, Resurce, ExtCtrls,Command,GFonts,math,
  Mechanic,Controller,Scripter,Phisics,MGEFBO;

Type
  PTLPlayer = record
    pos,size,Dir,Gravitation:MGEPoint2D;
    Health,State:integer;
    Living:boolean;
  end;
type
  Myfon = record
    x,dx:real;
    texture:byte;
  end;
 type
  PTLMoney = record
    x,y,r:real;
  end;

var
  M3M:MGE3DCursor;
  FPS,FP,k:integer;
  P,view,redview:MGEPlayer;
  Weel:array[0..3] of MGEPlayer;
  CarP:array[0..2] of MGEPlayer;

  CamRad:real;
  glLightPos: array[0..3] of glFloat = (200,100,100,0.1);
  glLightPos1: array[0..3] of glFloat = (-300.0, -1000.0, -500.0, 1);
   light0_diffuse:array[0..3] of glFloat = (1.0, 1.0, 1.0, 1.0);
   light1_diffuse:array[0..3] of glFloat = (-1.0, -1.0, 1.0, 1.0);
   FogColor:array[0..3] of glFloat;

   ambient:array[0..3] of glFloat =  ( 0.99, 0.99, 0.99, 0.8 );
   mat_shininess:glFloat = 200.1;

   Cursor1,W,S,D,FontF: TGLUint;
   Commande:boolean;
   provrka,WX,WY:integer;

   Ttextobj : array[0..256] of TGLUint;
   Men:array[0..5] of GLUint;

   bclick,lmb,rmb, GAMESTARTED,Intext:boolean;
   StFon:MGEFont;
   GUICursor:MGECursor;
   Keys:MGEKeyboard;
   LO,MenuMap,World:MGE2DSprite;
   MenuStay,FMW,FMH:integer;
   MenP:MGEPoint2D;

   FPST:String;
   MenuN:array[0..10] of MGEText;
   MyText:MGEText;
   MenuS:array[0..20] of MGEButton;
   MyBut:array[0..30] of MGEButton;

   PhBox:MGEPBBox;

   Fir,Smo:MGEFire2D;
   FrameF,SmoF:Array of GLUint;
   mode1s:array[0..6] of TGLMultyMesh;
   ResModel:array[0..7] of TGLMultyMesh;
   MIRX,Sk,INL,SunDay,MGEV,VistrX,VistrY,MyYC:real;
   minmap:MGEminiMap;
   dan,FSN,bigtext:string;
   PutCost,DiCost:integer;
   NameWin:MGE2DForm;
   skelZnach:Char;
   bull,PGosha:MGEPSphere;
   test3d:MGE3DSprite;
   My3dFire,Fire001:MGEFire3D;    TREST:real;
   Flying:boolean;
   FFons:array[1..3] of Myfon;
   Gen:boolean;
   sdvig:real;
   MyPointPut:MGEpoint3D;

procedure LoadSettings(Put:String);
procedure CreateMenu();
procedure CreateRedactor();
procedure StartSetWindow();
procedure UpdatePhisicsG();
procedure Check_test();
procedure FreeModelSkel();
procedure LoadModelSkel();


implementation
uses GUI;

procedure LoadModelSkel();
begin
  ResModel[0] := TGLMultyMesh.Create;
  ResModel[0].LoadFromFile(MGELocation+'\resource\MGEModels\Robot\foot.gms');
  ResModel[0].Extent := true;
  ResModel[0].fSmooth := false; // Установить в фасеты

  ResModel[1] := TGLMultyMesh.Create;
  ResModel[1].LoadFromFile(MGELocation+'\resource\MGEModels\Robot\t1.gms');
  ResModel[1].Extent := true;
  ResModel[1].fSmooth := false; // Установить в фасеты

  ResModel[2] := TGLMultyMesh.Create;
  ResModel[2].LoadFromFile(MGELocation+'\resource\MGEModels\Robot\h1.gms');
  ResModel[2].Extent := true;
  ResModel[2].fSmooth := false; // Установить в фасеты

  ResModel[3] := TGLMultyMesh.Create;
  ResModel[3].LoadFromFile(MGELocation+'\resource\MGEModels\Robot\h2.gms');
  ResModel[3].Extent := true;
  ResModel[3].fSmooth := false; // Установить в фасеты

  ResModel[4] := TGLMultyMesh.Create;
  ResModel[4].LoadFromFile(MGELocation+'\resource\MGEModels\Robot\head.gms');
  ResModel[4].Extent := true;
  ResModel[4].fSmooth := true; // Установить в фасеты

  ResModel[5] := TGLMultyMesh.Create;
  ResModel[5].LoadFromFile(MGELocation+'\resource\MGEModels\Robot\sh1.gms');
  ResModel[5].Extent := true;
  ResModel[5].fSmooth := false; // Установить в фасеты

  ResModel[6] := TGLMultyMesh.Create;
  ResModel[6].LoadFromFile(MGELocation+'\resource\MGEModels\Robot\sh2.gms');
  ResModel[6].Extent := true;
  ResModel[6].fSmooth := false; // Установить в фасеты
end;
procedure FreeModelSkel();
var I:integer;
begin
 for I := 0 to 6 do ResModel[I].Free;
end;
procedure RayCastUpdate();
var I,J,H:integer;
  Dirrect:MGEPoint3D;
  MGEB:real;
begin
MGEB:=cos(-(P.AngleY+(GUICursor.p.Y-(MGEH/2))/8)/180*Pi);

  if K_D(VK_LButton)=true then begin
     if (GUICursor.p.X<(MGEW/2+MGEW/2.5)-MGEW/10) and (GUICursor.p.Y<MGEH-MGEH/10) then
      begin
        RayCast.SetP(P.p.x,p.p.y,p.p.z);
        Dirrect.SetP((P.p.X+sin((P.angleX+(GUICursor.p.X-(MGEW/2))/4)/180*Pi)*MGEB)-P.p.x,
                          (P.p.Y+sin(-(P.angleY+(GUICursor.p.Y-(MGEH/2))/8)/180*Pi))-P.p.y,
                        (P.p.Z+cos((P.angleX+(GUICursor.p.X-(MGEW/2))/4)/180*Pi)*MGEB)-P.p.z);

      end;

  end;
end;
procedure LoadSettings(Put:String);
var fi:textfile;
begin
  Assignfile(fi,Put); reset(fi);
  readln(fi);
  readln(fi);
  readln(fi,FSN);
  readln(fi);
  readln(fi,FMW,FMH);
  readln(fi); readln(fi); readln(fi);
  Closefile(fi);
end;
procedure CreateRedactor();
begin
  MyBut[0].Create(40,40,500,200,MGEFR[4],True,'Режим: езды');
  MyBut[1].Create(40,40,500,200,MGEFR[4],True,'Режим: редактора');
//////////////// Сам редактор /////////////////////////
  MyBut[2].Create(40,40,500,200,MGEFR[4],True,'<');  /////ID Модели
  MyBut[3].Create(40,40,500,200,MGEFR[4],True,'>');

  MyBut[4].Create(40,40,500,200,MGEFR[4],True,'<');  /////ID Текстуры
  MyBut[5].Create(40,40,500,200,MGEFR[4],True,'>');

  MyBut[7].Create(40,40,500,200,MGEFR[4],True,'<');  /////SizeX
  MyBut[8].Create(40,40,500,200,MGEFR[4],True,'>');

  MyBut[9].Create(40,40,500,200,MGEFR[4],True,'<');  /////Поворот
  MyBut[10].Create(40,40,500,200,MGEFR[4],True,'>');

  MyBut[11].Create(40,40,500,200,MGEFR[4],True,'<');  /////SizeY
  MyBut[12].Create(40,40,500,200,MGEFR[4],True,'>');

  MyBut[13].Create(40,40,500,200,MGEFR[4],True,'<');
  MyBut[14].Create(40,40,500,200,MGEFR[4],True,'>');  /////SyzeZ



  MyBut[15].Create(40,40,500,200,MGEFR[4],True,'>');

  MyBut[16].Create(40,40,500,200,MGEFR[4],True,'<');  /////Y
  MyBut[17].Create(40,40,500,200,MGEFR[4],True,'>');

  MyBut[18].Create(40,40,500,200,MGEFR[4],True,'<');  /////z
  MyBut[19].Create(40,40,500,200,MGEFR[4],True,'>');

  MyBut[6].Create(40,40,500,200,MGEFR[4],True,'Поставить');


/////////---------Окно переименовывания кости------------------
///
  NameWin.Create(FMW/2,FMH/2,600,300,'GUI',true);
 NameWin.CreateBut(0,5,100,95,'  ',true);
 NameWin.FButton[0].Bpict:=tex3;

 {  NameWin.CreateBut(5,80,20,15,'Сохранить',true);
  NameWin.CreateBut(70,80,20,15,'Отмена',true);
  NameWin.CreateBut(50,80,10,15,'Eng',true);
  NameWin.CreateText('Текущее:  ',3,22,2,5.5,10,StFon,SetColor(0,0,0,255));  }
  //NameWin.CreateText('Новое: ',3,55,2,5.5,10,StFon,SetColor(0,0,0,255));

end;
procedure CreateMenu();
begin
MenuN[0].fullprop(' ',40,50,20,20,1,STFon,SetColor(36,23,9,255));
MenuS[0].Create(40,40,500,200,MGEFR[4],True,'Играть');
MenuS[1].Create(40,40,500,200,MGEFR[4],True,'Настройки');
MenuS[2].Create(40,40,500,200,MGEFR[4],True,'О Создателях');
MenuS[3].Create(40,40,500,200,MGEFR[4],True,'Выход');

MenuN[1].fullprop('Играть',20,20,20,20,1,STFon,SetColor(36,23,9,0));
MenuS[4].Create(40,40,500,200,MGEFR[4],True,'Новая игра');
MenuS[5].Create(40,40,500,200,MGEFR[4],True,'Продолжить игру');

MenuN[2].fullprop('Настройки',20,20,20,20,1,STFon,SetColor(36,23,9,0));
MenuS[6].Create(40,40,500,200,MGEFR[4],True,'Во весь экран');
MenuS[7].Create(40,40,500,200,MGEFR[4],True,'В окне');
MenuS[8].Create(40,40,500,200,MGEFR[4],True,'Назад');
MenuS[9].Create(40,40,500,200,MGEFR[4],True,'Назад');

MenuN[3].fullprop('О создателях',20,20,20,20,1,STFon,SetColor(36,23,9,0));

MenuN[10].fullprop('test',40,40,40,40,1,STFon,SetColor(36,23,9,0));
end;
procedure StartSetWindow();
begin
      Form1.Top:=50;
      Form1.Left:=50;
      Form1.BorderStyle:=bsSizeable;
      Form1.WindowState:=wsNormal;
      Form1.Width:=FMW;
      Form1.Height:=FMH;
end;
procedure UpdatePhisicsG();
var DB:boolean;
  MSPL:MGEPSphere;
  I,Y,FRRR:integer;
begin

if (K_D(VK_I)<>false) then begin
  Phantom.Create(SetP3D(redview.p.x,redview.p.y,redview.p.z),SetP3D(5,5,5),SetP3D(0.1,0.1,0.1),
  7,2.5,3,3,1.30,9.25,-2.5,2,120);
    Phantom.AngleY:=0;
    Phantom.Speed:=0;
    Phantom.weel[0].speed:=0;
    Phantom.weel[1].speed:=0;
    Phantom.weel[2].speed:=0;
    Phantom.weel[3].speed:=0;

    Phantom.MCP[0].speed:=0;
    Phantom.MCP[1].speed:=0;
    Phantom.MCP[2].speed:=0;
   // View.AngleX:=RotX+180;
end;

     if (Commande=false) then
       begin

  If GameMode=0 then begin
      Phantom.UpdateP([BossCar.MCP[0],BossCar.MCP[1],BossCar.MCP[2]],PhizPlane,PhizFence,Polg,
        K_D(VK_W),K_D(VK_A),K_D(VK_S),K_D(VK_D),K_D(VK_Space));

      BossCar.UpdateP([Phantom.MCP[0],Phantom.MCP[1],Phantom.MCP[2]],PhizPlane,PhizFence,Polg,
        Boss.KW,Boss.KA,Boss.KS,Boss.KD,Boss.Ksp);

      Charact[0].UpdateP([],PhizPlane,PhizFence,Polg,10,
        Bot1.KW,Bot1.KA,Bot1.KS,Bot1.KD,false);
        

  end else begin
      Phantom.UpdateP([],PhizPlane,PhizFence,Polg,
        false,false,false,false,false);

      BossCar.UpdateP([],PhizPlane,PhizFence,Polg,
        false,false,false,false,false);

    redview:=Cam_Move(view);
  end;
  end;

        if K_D(VK_RButton)=true then begin
          Mouse_Move();
          MyYC:=P.AngleY;
        end;
        
    If K_D(VK_L)=true then MyPointPut:=redview.p;


   Bot1.update(Charact[0], MyPointPut);
   Boss.update(BossCar,Race1.RacePoint[TPR]);


end;

procedure Check_test();
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
            VistrY  :=-p.AngleY  +(-M3M.SingY/16);                        //
            VistrX:=p.angleX+(-M3M.SingX/12);                            //
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



end.
