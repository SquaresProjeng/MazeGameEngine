unit Controller;

interface
uses
  Variants, windows, Classes, Graphics, Controls,Forms, Dialogs, DglOpenGL, Textures,
  mesh, Math, ResCon,SysUtils, Scripter, MGEFBO, MGEAudioEngine;

Var
  MGELocation,ME:String;
  MGEW,MGEH,MGEFX,MGEFY,MGEViewX,MGEViewY:integer;
  MGEFullScreen:boolean;
  MGEFR:array[0..10] of GLUint;



Type
  MGEPoryadok = record
    p:array[0..256] of integer;
  end;
  MGE3DCursor = record
     TempX1,TempY1,SingX,SingY,TempX2,TempY2 : integer;
     Point: Tpoint;
  end;     
  MGEpoint3D = record
    x,y,z:real;
    public
      procedure SetP(px,py,pz:real);
  end;
  MGEpoint2D = record
    x,y:GLFloat;
  end;
  MGEColor = record
    R,G,B,A:Byte;
      public
        procedure L(zR,zG,zB,zA:Byte);
  end;
  MGEBBox = record
    t:array[0..5] of GLUint;
  end;
  MGECursor = record
    p:Tpoint;
    s,dp:MGEpoint2D;
    skin:GLUint;
    Time:integer;
    MState:Byte;
    LKM,RKM,NLKM,NRKM:boolean;
    public
    function state():Byte;
    procedure Draw;
    procedure create;
  end;
  MGEKey = record
    state:Boolean;
    znak:Char;
    Time:Smallint;
  end;
  MGEKeyboard = record
    SKey:array[1..128] of MGEKey;
    SDKey:array[1..128] of MGEKey;
    public
      procedure Update();
      function DKey:String;
  end;
  MGEFont = record
    X,Y,Size: integer;
    Name,loc:String;
    Simvol:array[1..256] of string;
    PSim:array[1..256] of MGEpoint2D;
    FontTex:GLUint;
    public
      procedure Load_Font(Nfile:String);
  end;
  MGEText = record
    posx,posy,height,width,pdx,pdy:real;
    Lin:Byte;
    TMFont:MGEFont;
    TMColor:MGEColor;
    text:string;
    Leg:integer;
    public
      procedure fullprop(mtext:string; x,y,w,h:real; line:Byte; mfont:MGEFont; mcolor:MGEColor);
      procedure lowprop(mtext:string; x,y:real);
      procedure Draw();
      procedure SetDraw(mtext:string; x,y,w,h:real; mfont:MGEFont; mcolor:MGEColor);
      function OutSize():MGEPoint2D;
  end;
  MGEButton = record
    p,pd,s,sd,c:MGEpoint2D;
    BShowing,dvig:boolean;
    BCaption:MGEText;
    Bpict:GLUint;
    State:Byte;
      public
        function Aktivate(UMouse:MGECursor):Byte;
        procedure PutBut(sizex,sizey,posx,posy:real);
        procedure Create(px,py,sx,sy:real;pic:GLUint;Showi:boolean;Btext:string);
  end;
  MGE2DForm = record
    Pos,S:MGEpoint2D;
    MShow:boolean;
    UpCur,ex:MGEButton;
    MCaption:MGEText;
    Time,Nbut,Ntex,DT:integer;
    FButton:array of MGEButton;
    FText:array of MGEText;
    //FPict:array of GLUint;
    public
      procedure Create(MX,MY,MW,MH:real; FoName: String; Sh:boolean);
      procedure CreateBut(pfx,pfy,sfx,sfy:real; btext:String; BShow:boolean);
      procedure CreateText(Text:String; pfx,pfy,sfx,sfy,size:real; mfont:MGEFont; mcolor:MGEColor);
      procedure Draw(UMouse:MGECursor);
  end;
  MGECamera = record
    P,R,V,L: MGEpoint3D;
    CType:GLByte;
    public
      procedure Create(Pos,Rot,Vec,Look:MGEpoint3D;TType:Byte {Режим работы игровой камеры от 0 до 2});
      Procedure Update(Pos,Rot,Vec,Look:MGEpoint3D);
      Procedure Plant();
  end;
  MGEmaterial = record
    Tex:GLUint;
    Name:String;
    Color:MGEColor;
    materia:Byte; //////Byte коды материала
  end;
  MGEBox = record
    P:array[0..7] of MGEpoint3D;
  end;
  MGELandscape  = record
    P:array of MGEpoint3D;
  end;
  MGEeffect = class
    pos,size,rotate:MGEpoint3D;
    R1,R2,R3,intensive:Byte;
    animate:boolean;
    Vector:MGEpoint3D;
    Name:String;
    Material:MGEmaterial;
  end;

  MGE2DMap = record
    private
      nx,ny,nsloy:integer;
      s,p:MGEPoint2D;
      nbiom:integer;
      pic:array of GLUint;
      Map:array of array of array of byte;
    public
      procedure LoadMap(put:string);
      procedure DrawMap(px,py,sx,sy:real);
  end;
  MGEInterface = record
    IButton:array of MGEButton;
    IForm:array of MGE2DForm;
    Itext:array of MGEText;
    B,F,T:integer;
  end;
  MGESkyBox = record
    s:MGEPoint2D;
    t:MGEBBox;
    public
    procedure create(sx,sy:real; Btex:MGEBBox);
    procedure Draw(p:MGECamera);
  end;
  MGEPixel = array[0..3] of GLBYTE;
  MGESkyProced = record
    SC1,SC2,Sk1,Sk2:MGEColor;
    Sky1,Cloud1:integer;
    SPTex:GLUint;
    Skying,SAnim:boolean;
    Sintensiv:Byte;
    Ssky:array[0..2] of GLUint;
    public
    procedure Create(Color1,Color2,CSky1,CSky2:MGEColor; SkuShow,Anim:boolean; Intens:Byte);
    procedure Draw(P:MGECamera);
    procedure Update;
  end;
  MGESkyPhiz = record
   ///////
  end;
  MGE3DPix = record
    p:MGEPoint3D;
    s:MGEPoint2D;
    PTex:GLUint;
    FramePos:integer;
    public
    procedure LoadAll(pos:MGEPoint3D; size:MGEPoint2D; Textur:GLUint);
    procedure DrawD(pos:MGEPoint3D; Size:MGEPoint2D; C:MGECamera);
    procedure DrawS(C:MGECamera);
  end;
  MGE2DSprite = record
    p,s:MGEPoint2D;
    Ang:real;
    STex:GLUint;
    C:MGEColor;
    public
    procedure Create(px,py,sx,sy,r:real;Texture:GLUint);
    procedure Update(pos,size:MGEPoint2D);
    procedure Ubdate(pos:MGEPoint2D);
    procedure Draw();
  end;

  MGE3DSprite = record
    p,s,Look:MGEPoint3D;
    Ang,AX,AY:real;
    STex:GLUint;
    C:MGEColor;
    public
    procedure Create(px,py,pz,sx,sy,r:real;Texture:GLUint);
    procedure Update(plook,pos,size:MGEPoint3D);
    procedure Ubdate(plook,pos:MGEPoint3D);
    procedure Draw();
  end;

  MGEFrame = record
     F:array of GLUint;
  end;
  MGEAnimation = record
     FrPos:integer;
     States:array of MGEFrame;
  end;
  MGEPlayer = record
    p,s,d:MGEPoint3D;
    Health:integer;
    AngleX,AngleY,Speed:real;
    Live:boolean;
    public
    procedure Create(px,py,pz,sx,sy,sz:real);
  end;
  MGEParticle2D = record
     p:MGE2DSprite;
     pos,s:MGEPoint2D;
     L,frame:integer;
     Living:real;
  end;

  MGEParticle3D = record
     p:MGE3DSprite;
     pos,s:MGEPoint3D;
     L,frame:integer;
     Living:real;
  end;

  MGEMinimap = record
     p,s:MGEPoint2D;
     mpp:MGEPoint2D;
     Angle:real;
     texture:GLUint;
     public
     procedure Create(t:GLUint; px,py,sx,sy:real);
     procedure Draw(plx,ply,size,ang,radius:real);
  end;

  MGEFire2D = record
     p,s,n:MGEPoint2D;
     Mat:array of GLUint;
     MatD:array of GLUint;
     Variants,MN,MDN:integer;
     Col,LivS:integer;
     FMode:Byte;
     particle:array of MGEParticle2D;
     public
      procedure Create(px,py,sx,sy:real; V,LS,C:integer; NX,NY:real; Mode:Byte; M,MD:array of GLUint);
      procedure Update(V,LS,C:integer);
      procedure FDraw(px,py,sx,sy:real);
      procedure Draw();
  end;

  MGEFire3D = record
     p,s,n:MGEPoint3D;
     Mat:array of GLUint;
     MatD:array of GLUint;
     Variants,MN,MDN:integer;
     Col,LivS:integer;
     FMode:Byte;
     particle:array of MGEParticle3D;
     public
      procedure Create(px,py,pz,R:real; V,LS,C:integer; NX,NY,NZ:real; Mode:Byte; M,MD:array of GLUint);
      procedure FDraw(lok,FCamera:MGEPoint3D;px,py,pz,r,Sc:real);
      procedure Draw();
  end;

  MGEObject = record
     p,s,r:MGEPoint3D;
     TexID,ModelID:integer;
     procedure Create(pos,size,rot:MGEPoint3D; TID,MID:integer);
  end;
  MGE3DObjectList = record
     Model:array of MGEObject;
     ModelName:array of String;
     N:integer;
     public
      Procedure Add(np,ns,nr:MGEPoint3D; TexID,ModID:integer);
      Procedure Edit(ID:integer; np,ns,nr:MGEPoint3D; TexID,ModID:integer);
  end;





Procedure MGECamAt(CPosX,CPosY,CPosZ:real;CPX,CPY,CPZ:real; vx,vy,vz:real; CThrid:boolean);
function Check_Sim(Mfont:MGEFont; a:char):byte;
function K_D(Key:Integer):boolean;
function SiCor(x,y:Single):MGEPoint2D;
function FuCor(x,y:Single):MGEPoint2D;
function SetColor(R,G,B,A:byte):MGEColor;
function SetP3D(x,y,z:real):MGEPoint3D;
Procedure Start_Controller();
procedure ELight();
procedure DLight();
procedure LoadMGEWinSet(W,H,FX,FY:integer;FTest:boolean);
procedure DrawFrameLoad(W,H:Integer);
procedure DrawFrameScene(W,H:Integer);
procedure LoadMainResource();
procedure DrawBox(X,Y,Z,Size:real; Texture:MGEBBox);
procedure MGEModel_Draw(x,y,z,rx,ry,rz,sizeX,sizeY,sizeZ:real; model:TGLMultyMesh; Texture:GLUint);
procedure FloreDraw(x,y,z,size:real; Texture,T2:GLUint);
procedure M3Point(sdx,sdy,sdz,px,py,pz,size:real; cr,cg,cb:byte);
procedure M2Point(px,py,size:real; cr,cg,cb:byte);
procedure M3Line(sdx,sdy,sdz,px,py,pz,dx,dy,dz:real; size:real; cr,cg,cb:byte);
procedure M2Line(px,py,dx,dy:real; size:real);
procedure BigFloreDraw(x,y,z,size,SizeT:real; Texture:GLUint);
procedure EndRender();
procedure FrameTest();
procedure RenderSprite(PX,PY,SX,SY,Rot:real;Pict:Uint);
procedure Mirror(x,y,z,size:real; Texture:GLUint);
procedure RenderText(text:String;px,py,sx,sy:real; MFont:MGEFont);
procedure MGEBoneModel(x,y,z,rnx,rny,rnz,rx,ry,rz,sx,sy,sz:real; model:TGLMultyMesh; Texture:GLUint);

implementation
uses GUI,GUIUnit, Phisics;


procedure MGEBoneModel(x,y,z,rnx,rny,rnz,rx,ry,rz,sx,sy,sz:real; model:TGLMultyMesh; Texture:GLUint);
begin
         glBindTexture(GL_TEXTURE_2D,Texture);
        glTranslatef(x,y,z);
//////////////////поворот модели////////////////////////
          glRotatef(rx,0,1,0);
          glRotatef(ry,1,0,0);
          glRotatef(rz,0,0,1);
///////////////основная подстройка /////////////////////
              glRotatef(rnx,0,1,0);
              glRotatef(rny,1,0,0);
              glRotatef(rnz,0,0,1);
                glPushMatrix;
                  glScalef(sx,sy,sz);
                  model.Draw;
                glPopMatrix;
              glRotatef(-rnz,0,0,1);
              glRotatef(-rny,1,0,0);
              glRotatef(-rnx,0,1,0);
/////////////////////////////////////////////////////////
          glRotatef(-rz,0,0,1);
          glRotatef(-ry,1,0,0);
          glRotatef(-rx,0,1,0);
/////////////////////////////////////////////////////////
        glTranslatef(-x,-y,-z);
end;

procedure MGEObject.Create(pos: MGEpoint3D; size: MGEpoint3D; rot: MGEpoint3D; TID: Integer; MID: Integer);
begin
  p:=pos; s:=size; r:=rot;TexID:=TID; ModelID:=MID;
end;

procedure MGE3DObjectList.Add(np,ns,nr:MGEPoint3D; TexID,ModID:integer);
begin
  inc(N);
  SetLength(Model,N);
  Model[N-1].Create(np,ns,nr, TexID,ModID);
end;
procedure MGE3DObjectList.Edit(ID: Integer; np: MGEpoint3D; ns: MGEpoint3D; nr: MGEpoint3D; TexID: Integer; ModID: Integer);
begin
  IF (ID<N) and (ID>=0) then Model[ID].Create(np,ns,nr, TexID,ModID);
end;



procedure MGEFire3D.Create(px: Real; py: Real; pz: Real; R: Real; V: Integer; LS: Integer; C: Integer; NX: Real; NY: Real; NZ: Real; Mode: Byte; M: array of Cardinal; MD: array of Cardinal);
  var I,K:integer;
begin
  p.x:=px;  p.y:=py; p.z:=pz;
  s.x:=r; s.y:=r; s.z:=r;
  Variants:=V;
  Col:=C;   FMode:=Mode;
  n.x:=nx; n.y:=ny;  n.z:=nz;
  K:=Length(M);
  MN:=K;
  SetLength(Mat,K);
  for I := 0 to K - 1 do
    begin
      Mat[I]:=M[I];
    end;

  K:=Length(MD);
  MDN:=K;
  SetLength(MatD,K);
  for I := 0 to K - 1 do
    begin
      MatD[I]:=MD[I];
    end;

  If FMode=2 then LivS:=LS;
  If FMode=1 then LivS:=round(LS/2);
  SetLength(particle,Col);
  randomize;
  for I := 0 to Col-1 do
    begin
      particle[I].p.Create(px,py,pz,r,r,180,Mat[particle[I].frame]);
      particle[I].p.C.L(255,255,255,155);
      particle[I].pos:=p;
      particle[I].s:=s;
      particle[I].L:=LivS+Random(Variants*3);
      particle[I].Living:=Random(particle[I].L);
      particle[I].frame:=random(K);
    end;
end;
procedure swap(var x,y:real);
   var t: real;
 begin
    t := x;
    x := y;
    y := t;
 end;
procedure swapi(var x,y:integer);
   var t: integer;
 begin
    t := x;
    x := y;
    y := t;
 end;
procedure MGEFire3D.FDraw(lok,FCamera:MGEPoint3D; px: Real; py: Real; pz: Real; r,Sc: Real);
  var I,WE,TX,TZ:integer;
  G,GK:array of integer;
  Di:array of real;
begin
  p.SetP(px,py,pz);
  s.SetP(r,r,r);
  randomize;
  SetLength(G,Length(Particle));
  SetLength(GK,Length(Particle));
  SetLength(Di,Length(Particle));
  for I := 0 to Col-1 do  G[i]:=I;

  for I := 0 to Col-1 do
    begin
      particle[I].p.AX:=lok.x;
      particle[I].p.AY:=lok.y;
      
      TX:=round((-Variants/2)+random(Variants));
      TZ:=round((-Variants/2)+random(Variants));
      particle[I].Living:=particle[I].Living+0.5;
      particle[I].p.C.A:=255-round(255*(particle[I].Living/particle[I].L));
       If (FMode=1) then if random(5)=1 then inc(particle[I].frame);
       If (FMode=2) then
        begin
           if (particle[I].Living<particle[I].L/2) then
                    if random(5)=1 then inc(particle[I].frame);
           if (particle[I].Living>=particle[I].L/2) then
            particle[I].frame:=round(MDN*((particle[I].Living-particle[I].L/2)/particle[I].L));
        end;

          
          if particle[I].Living>particle[I].L then
            begin
              particle[I].p.p.x:=p.x{+TX}; ////убрано для огня из точки
              particle[I].p.p.z:=p.z{+TZ};
              particle[I].p.p.y:=p.y;
              particle[I].Living:=0;
              particle[I].p.s.x:=0;
              particle[I].p.s.y:=0;
            end;

       if FMode=2 then begin
        
        if (particle[I].Living<particle[I].L/4) then
        begin
          if particle[I].frame>MN-1 then particle[I].frame:=0;
          particle[I].p.s.x:=particle[I].p.s.x+1*Sc;
          particle[I].p.s.y:=particle[I].p.s.y+1*Sc;
          particle[I].p.p.x:=particle[I].p.p.x+n.x*Sc;
          particle[I].p.p.z:=particle[I].p.p.z+n.z*Sc;
          particle[I].p.p.y:=particle[I].p.p.y-(n.y-TX/50)*Sc;
        end else  begin
          if (particle[I].Living<particle[I].L/2) and (particle[I].Living>=particle[I].L/4) then  begin
          if particle[I].frame>MN-1 then particle[I].frame:=0;
          particle[I].p.s.x:=particle[I].p.s.x-1*Sc;
          particle[I].p.s.y:=particle[I].p.s.y-1*Sc;
          particle[I].p.p.x:=particle[I].p.p.x+n.x*Sc;
          particle[I].p.p.z:=particle[I].p.p.z+n.z*Sc;
          particle[I].p.p.y:=particle[I].p.p.y-(n.y-TX/50)*Sc;
          end;
          if (particle[I].Living>=particle[I].L/2) then  begin
          if particle[I].frame>MDN-1 then particle[I].frame:=0;
          particle[I].p.s.x:=particle[I].p.s.x+2*Sc;
          particle[I].p.s.y:=particle[I].p.s.y+2*Sc;
          particle[I].p.p.x:=particle[I].p.p.x+n.x*2*Sc;
          particle[I].p.p.z:=particle[I].p.p.z+n.z*2*Sc;
          particle[I].p.p.y:=particle[I].p.p.y-(n.y*2-TX/50)*Sc;
          end;
       end;
       end;
       if FMode=1 then begin
         if particle[I].frame>MN-1 then particle[I].frame:=0;
          particle[I].p.p.x:=particle[I].p.p.x+n.x*Sc;
          particle[I].p.p.z:=particle[I].p.p.z+n.z*Sc;
          particle[I].p.p.y:=particle[I].p.p.y-(n.y-TX/50)*Sc;
        if (particle[I].Living<particle[I].L/2) then
        begin
          particle[I].p.s.x:=particle[I].p.s.x+1*Sc;
          particle[I].p.s.y:=particle[I].p.s.y+1*Sc;
        end else  begin
          particle[I].p.s.x:=particle[I].p.s.x-1*Sc;
          particle[I].p.s.y:=particle[I].p.s.y-1*Sc;
       end;
       end;

    end;
////////////////////////////////////////
///  hpopucoBIdBaem
///
  for I := 0 to Col-1 do
  begin
    Di[I]:=Sqrt(sqr(fcamera.x-particle[I].pos.x)+sqr(fcamera.y-particle[I].pos.y)+sqr(fcamera.z-particle[I].pos.z));
  end;

  for I := 0 to Col-1 do
    for WE := 0 to Col-I do
      begin
        if Di[i] > Di[i+1] then
          begin
            swap(Di[i],Di[i+1]);
            swapi(G[i],G[i+1]);
          end;
      end;

  for I := 0 to Col-1 do  GK[Col-1-i]:=G[i];



  for I := 0 to Col-1 do
    begin
      if FMode=2 then begin
        if (particle[I].Living<particle[I].L/2) then particle[I].p.STex:=Mat[particle[I].frame];
        if (particle[I].Living>=particle[I].L/2) then particle[I].p.STex:=MatD[particle[I].frame];
      end;
      if FMode=1 then particle[I].p.STex:=Mat[particle[I].frame];

      particle[GK[i]].p.Draw;
    end;

end;
procedure MGEFire3D.Draw;
begin

end;

function SetP3D(x,y,z:real):MGEPoint3D;
var M:MGEPoint3D;
begin
   M.SetP(x,y,z);
   result:=M;
end;

procedure MGE3DSprite.Create(px: Real; py: Real; pz: Real; sx: Real; sy: Real; r: Real; Texture: Cardinal);
begin
  p.x:=px; p.y:=py; p.z:=pz;
  s.x:=sx; s.y:=sy; s.z:=0;
  Ang:=r;
  STex:=Texture;
  C.L(255,255,255,255);
end;
procedure MGE3DSprite.Update(plook: MGEpoint3D; pos: MGEpoint3D; size: MGEpoint3D);
begin
  p:=pos; s:=Size;
  AX:=plook.x;
  AY:=plook.y;
end;
procedure MGE3DSprite.Ubdate(plook: MGEpoint3D; pos: MGEpoint3D);
begin
  p:=pos;
  AX:=plook.x;
  AY:=plook.y;
end;
procedure MGE3DSprite.Draw;
begin
   glTranslatef(p.x,p.y,p.z);
          glRotatef(Ax,0,1,0);
          glRotatef(Ay,1,0,0);
          glRotatef(Ang,0,0,1);
      glPushMatrix;
      glColor4d(C.R/255,C.G/255,C.B/255,C.A/255);
  	    glBindTexture(GL_TEXTURE_2D, STex);

          glBegin(GL_Quads);

              glTexCoord2f(0.0, 1.0);  glVertex2d(-s.x,-s.y);
              glTexCoord2f(0.0, 0.0);  glVertex2d(-s.x,+s.y);
              glTexCoord2f(1.0, 0.0);  glVertex2d(+s.x,+s.y);
              glTexCoord2f(1.0, 1.0);  glVertex2d(+s.x,-s.y);
   //
          glEnd;
   glColor4d(255,255,255,255);
      glPopmatrix;
          glRotatef(-Ang,0,0,1);
          glRotatef(-Ay,1,0,0);
          glRotatef(-Ax,0,1,0);

  glTranslatef(-p.x,-p.y,-p.z);
end;
Procedure MGECamAt(CPosX,CPosY,CPosZ:real;CPX,CPY,CPZ:real; vx,vy,vz:real; CThrid:boolean);
begin
  if CThrid = false then GluLookAt(CPX,CPY,CPZ,      CPosX,CPosY,CPosZ,   vx,vy,vz);
  if CThrid = true then GluLookAt(CPosX,CPosY,CPosZ,     CPX,CPY,CPZ,   vx,vy,vz);
end;
procedure MGEpoint3D.SetP(px,py,pz:real);
begin
  x:=px; y:=py; z:=pz;
end;
procedure TextDraw(procx,procy,prsx,prsy:real; Text:String);
var
  MyTextRen:MGEText;
begin
    MyTextRen.fullprop(Text,(MGEW/100)*procx,(MGEH/100)*procy,
    (MGEH/100)*prsx,(MGEH/100)*prsy,1,StFon,SetColor(255,255,255,255));
    MyTextRen.Draw;
end;


function SetColor(R,G,B,A:byte):MGEColor;
var m:MGEColor;
begin
   m.L(R,G,B,A);
   result:=M;
end;
procedure MGEMinimap.Create(t:GLUint; px,py,sx,sy:real);
begin
  texture:=t;
  p.x:=px; p.y:=py;
  s.x:=sx; s.y:=sy;
end;
procedure MGEMinimap.Draw(plx,ply,size,ang,radius:real);
var x,y:array[0..4] of real;
    r,k:real;
begin
  angle:=ang;
  K:=135;
   mpp.x:=plx/size;
   mpp.y:=ply/size;
   x[0]:=mpp.x;
   y[0]:=mpp.y;
   x[1]:=(x[0]+radius*cos((angle-k)*pi/180));
   y[1]:=(y[0]+radius*sin((angle-k)*pi/180));
   x[2]:=(x[0]+(radius)*cos((angle+90-k)*pi/180));
   y[2]:=(y[0]+(radius)*sin((angle+90-k)*pi/180));
   x[3]:=(x[0]+(radius)*cos((angle+180-k)*pi/180));
   y[3]:=(y[0]+(radius)*sin((angle+180-k)*pi/180));
   x[4]:=(x[0]+radius*cos((angle+270-k)*pi/180));
   y[4]:=(y[0]+radius*sin((angle+270-k)*pi/180));



  glTranslatef(P.X,P.Y,0);
  glPushMatrix;
  DLIGHT();
  glBindTexture(GL_TEXTURE_2D, Texture);
    glBegin(GL_Quads);
      glTexCoord2d(x[1], y[1]);  glVertex2d(-s.x,-s.y);
      glTexCoord2d(x[2], y[2]);  glVertex2d(-s.x,+s.y);
      glTexCoord2d(x[3], y[3]);  glVertex2d(+s.x,+s.y);
      glTexCoord2d(x[4], y[4]);  glVertex2d(+s.x,-s.y);
    glEnd;
  ELIGHT();
  GLpOPmATRIX;
  glTranslatef(-P.X,-P.Y,0);


end;
procedure RenderSprite(PX,PY,SX,SY,Rot:real;Pict:Uint);
begin

  glTranslatef(PX,PY,0);
  glRotatef(Rot,0,0,1);
  glPushMatrix;
  DLIGHT();
     //  glColor(255,255,255);
  glBindTexture(GL_TEXTURE_2D, Pict);
  
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);

    glBegin(GL_Quads);
      glTexCoord2d(0.0, 1.0);  glVertex2d(-sx,-sy);
      glTexCoord2d(0.0, 0.0);  glVertex2d(-sx,+sy);
      glTexCoord2d(1.0, 0.0);  glVertex2d(+sx,+sy);
      glTexCoord2d(1.0, 1.0);  glVertex2d(+sx,-sy);
    glEnd;
       // glColor(255,255,255);
  ELIGHT();
  GLpOPmATRIX;
  glRotatef(-Rot,0,0,1);
  glTranslatef(-PX,-PY,0);
end;
procedure RenderText(text:String;px,py,sx,sy:real; MFont:MGEFont);
begin

end;
procedure BigFloreDraw(x,y,z,size,SizeT:real; Texture:GLUint);
begin
glTranslatef(x,y,z);
glPushMatrix;
glBindTexture(GL_TEXTURE_2D,Texture);
//glNormal3f( 0.0, 1.0, 0.0);
    GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
glBegin(GL_QUADS);
    glNormal3f( 0.0, 1.0, 0.0);
    glTexCoord2f(0.0, 0.0); glVertex3f(-1.0*size, 1.0,  -1.0*size);
    glTexCoord2f(-1.0*SizeT, 0.0); glVertex3f( 1.0*size, 1.0,  -1.0*size);
    glTexCoord2f(-1.0*SizeT, 1.0*SizeT); glVertex3f( 1.0*size,  1.0,  1.0*size);
    glTexCoord2f(0.0, 1.0*SizeT); glVertex3f(-1.0*size,  1.0,  1.0*size);
   glEnd;
glPopMatrix;
glTranslatef(-x,-y,-z);
end;
procedure FloreDraw(x,y,z,size:real; Texture,T2:GLUint);
begin
glTranslatef(x,y,z);
glPushMatrix;
glBindTexture(GL_TEXTURE_2D, texture);
glNormal3f( 0.0, 1.0, 0.0);
glBegin(GL_QUADS);
    //glNormal3f( 0.0, 0.0, 1.0);
    glTexCoord2f(0.0, 0.0); glVertex3f(-1.0*size, 1.0,  -1.0*size);
    glTexCoord2f(-1.0, 0.0); glVertex3f( 1.0*size, 1.0,  -1.0*size);
    glTexCoord2f(-1.0, 1.0); glVertex3f( 1.0*size,  1.0,  1.0*size);
    glTexCoord2f(0.0, 1.0); glVertex3f(-1.0*size,  1.0,  1.0*size);
   glEnd;
glPopMatrix;
glTranslatef(-x,-y,-z);
end;
procedure M3Point(sdx,sdy,sdz,px,py,pz,size:real; cr,cg,cb:byte);
begin
glTranslatef(sdx,sdy,sdz);
glPushMatrix;
glPointSize(size);
glEnable(GL_POINT_SMOOTH);
glBindTexture(GL_TEXTURE_2D, MGEFR[10]);
glBegin(GL_POINTS);
  glColor3f(cr/255,cg/255,cb/255); {раскрасим первую вершину}  glVertex3f(px,py,pz); //позиция первой вершины
  glColor3f(1,1,1);
glEnd;
glPopMatrix;
glTranslatef(-sdx,-sdy,-sdz);
end;

procedure M2Point(px,py,size:real; cr,cg,cb:byte);
begin

glPushMatrix;
DLIGHT;
glPointSize(size);
glEnable(GL_POINT_SMOOTH);
glBindTexture(GL_TEXTURE_2D, MGEFR[10]);
glBegin(GL_POINTS);
  glColor3f(cr/255,cg/255,cb/255);  {раскрасим первую вершину}  glVertex2f(px,py); //позиция первой вершины
glEnd;
glColor3f(1,1,1);
glPopMatrix;
end;
procedure M3Line(sdx,sdy,sdz,px,py,pz,dx,dy,dz:real; size:real; cr,cg,cb:byte);
begin
glTranslatef(sdx,sdy,sdz);
glPushMatrix;
glLineWidth(size);
glEnable(GL_LINE_SMOOTH);
glBindTexture(GL_TEXTURE_2D, MGEFR[10]);
glBegin(GL_LINES);

  glColor3f(cr/255,cg/255,cb/255); {раскрасим первую вершину}  glVertex3f(px,py,pz); //позиция первой вершины
  glColor3f(cr/255,cg/255,cb/255); {раскрасим вторую вершину}   glVertex3f(dx,dy,dz); //позиция второй вершины
  glColor3f(1,1,1);
glEnd;
glPopMatrix;
glTranslatef(-sdx,-sdy,-sdz);
end;
procedure M2Line(px,py,dx,dy:real; size:real);
begin

glPushMatrix;
DLIGHT;
glLineWidth(size);
glEnable(GL_LINE_SMOOTH);
glBindTexture(GL_TEXTURE_2D, MGEFR[10]);
glBegin(GL_LINES);
  glColor3f(1,1,1); {раскрасим первую вершину}  glVertex2f(px,py); //позиция первой вершины
  glColor3f(1,1,1); {раскрасим вторую вершину}   glVertex2f(dx,dy); //позиция второй вершины
glEnd;
glPopMatrix;
end;
procedure Mirror(x,y,z,size:real; Texture:GLUint);
begin
glTranslatef(x,y,z);
glPushMatrix;
glBindTexture(GL_TEXTURE_2D,Texture);
glNormal3f( 0.0, 0.0, 1.0);
glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0); glVertex3f(-FMW/ FMH*size,  -1.0*size, 1.0);
    glTexCoord2f(1.0, 0.0); glVertex3f( FMW/ FMH*size,  -1.0*size, 1.0);
    glTexCoord2f(1.0, 1.0); glVertex3f( FMW/ FMH*size,  1.0*size,  1.0);
    glTexCoord2f(0.0, 1.0); glVertex3f(-FMW/ FMH*size,  1.0*size,  1.0);
   glEnd;
glPopMatrix;
glTranslatef(-x,-y,-z);
end;
procedure MGEModel_Draw(x,y,z,rx,ry,rz,sizeX,sizeY,sizeZ:real; model:TGLMultyMesh; Texture:GLUint);
begin
         glBindTexture(GL_TEXTURE_2D,Texture);

    GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    GlTexParameterf (GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);

        glTranslatef(x,y,z);
        glRotatef(rx,1,0,0);
        glRotatef(ry,0,1,0);
        glRotatef(rz,0,0,1);
          glPushMatrix;
            glScalef(sizeX,sizeY,sizeZ);
            model.Draw;
          glPopMatrix;
        glRotatef(-rz,0,0,1);
        glRotatef(-ry,0,1,0);
        glRotatef(-rx,1,0,0);
        glTranslatef(-x,-y,-z);
end;
procedure MGE2DMap.LoadMap(put: string);
var I,Y,K:integer;
fi:textfile;
puti:String;
begin
  p.x:=0;
  p.y:=0;
  s.x:=30;
  s.y:=30;
  assignfile(fi,MGELocation+put); reset(fi);
  readln(fi,nbiom);
  SetLength(pic,nbiom+1);
    for I := 0 to nbiom - 1 do
      begin
        readln(fi,puti);
        LoadTexture(MGELocation+'\'+puti,pic[I],false);
      end;
  readln(fi,nsloy);
  readln(fi,nx,ny);
  SetLength(Map,nsloy,nx,ny);
  for K := 0 to nsloy-1 do
  begin
    for Y := 0 to ny-1 do
      for I := 0 to nx-1 do
        begin
          read(fi,Map[K,Y,I]);
          if (I>=nx-1) and (Y<ny-1) then readln(fi);
        end;
    readln(fi);
    readln(fi);
  end;
  closefile(fi);
end;
procedure MGE2DMap.DrawMap(px: Real; py: Real; sx: Real; sy: Real);
var I,J,K:integer;
begin
  p.x:=px; p.y:=py;
  s.x:=sx; s.y:=sy;
      glPushMatrix;
  for K := 0 to nsloy-1 do
    for I := 0 to ny-1 do
      for J := 0 to nx-1 do
       begin
       if Map[K,I,J]>0 then  begin

  	    glBindTexture(GL_TEXTURE_2D, Pic[Map[K,I,J]-1]);
          glBegin(GL_Quads);
              glTexCoord2f(0.0, 1.0);  glVertex2d(p.x-s.x+s.x*J*2,p.y-s.y+s.y*I*2);
              glTexCoord2f(0.0, 0.0);  glVertex2d(p.x-s.x+s.x*J*2,p.y+s.y+s.y*I*2);
              glTexCoord2f(1.0, 0.0);  glVertex2d(p.x+s.x+s.x*J*2,p.y+s.y+s.y*I*2);
              glTexCoord2f(1.0, 1.0);  glVertex2d(p.x+s.x+s.x*J*2,p.y-s.y+s.y*I*2);
   //
          glEnd;
        end;
       end;
      glPopmatrix;
end;
procedure MGEFire2D.Create(px,py,sx,sy:real; V,LS,C:integer; NX,NY:real; Mode:Byte; M,MD:array of GLUint);
  var I,K:integer;
begin
  p.x:=px;  p.y:=py;
  s.x:=sx; s.y:=sy;
  Variants:=V;
  Col:=C;   FMode:=Mode;
  n.x:=nx; n.y:=ny;
  K:=Length(M);
  MN:=K;
  SetLength(Mat,K);
  for I := 0 to K - 1 do
    begin
      Mat[I]:=M[I];
    end;

  K:=Length(MD);
  MDN:=K;
  SetLength(MatD,K);
  for I := 0 to K - 1 do
    begin
      MatD[I]:=MD[I];
    end;

  If FMode=2 then LivS:=LS;
  If FMode=1 then LivS:=round(LS/2);
  SetLength(particle,Col);
  randomize;
  for I := 0 to Col-1 do
    begin
      particle[I].p.Create(px,py,sx,sy,0,Mat[particle[I].frame]);
      particle[I].p.C.L(255,255,255,155);
      particle[I].pos:=p;
      particle[I].s:=s;
      particle[I].L:=LivS+Random(Variants*3);
      particle[I].Living:=Random(particle[I].L);
      particle[I].frame:=random(K);
    end;
end;
procedure MGEFire2D.Update(V,LS,C:integer);
begin
  Variants:=V;
  Col:=C;
  If FMode=2 then LivS:=LS;
  If FMode=1 then LivS:=round(LS/2);
  SetLength(particle,Col);
end;
procedure MGEFire2D.FDraw(px,py,sx,sy:real);
  var I,T:integer;
begin
  p.x:=px;  p.y:=py;
  s.x:=sx;  s.y:=sy;

////////////////////////////////////////
///  ObpabatIdbaem 4acTucId
///
  randomize;
  for I := 0 to Col-1 do
    begin
      T:=round(-Variants/2)+random(Variants);
      particle[I].Living:=particle[I].Living+1;
       If (FMode=1) then if random(5)=1 then inc(particle[I].frame);
       If (FMode=2) then
        begin
           if (particle[I].Living<particle[I].L/2) then
                    if random(5)=1 then inc(particle[I].frame);
           if (particle[I].Living>=particle[I].L/2) then
            particle[I].frame:=round(MDN*((particle[I].Living-particle[I].L/2)/particle[I].L));
        end;
          particle[I].p.C.A:=255-round(255*(particle[I].Living/particle[I].L));
          //particle[I].p.C.A:=255-round(255*(particle[I].L/particle[I].Living));
          if particle[I].Living>particle[I].L then
            begin
              particle[I].p.p.x:=p.x+T;
              particle[I].p.p.y:=p.y;
              particle[I].Living:=0;
              particle[I].p.s.x:=0;
              particle[I].p.s.y:=0;
            end;

       if FMode=2 then begin
        
        if (particle[I].Living<particle[I].L/4) then
        begin
          if particle[I].frame>MN-1 then particle[I].frame:=0;
          particle[I].p.s.x:=particle[I].p.s.x+1;
          particle[I].p.s.y:=particle[I].p.s.y+1;
          particle[I].p.p.x:=particle[I].p.p.x+n.x;
          particle[I].p.p.y:=particle[I].p.p.y-n.y-T/50;
        end else  begin
          if (particle[I].Living<particle[I].L/2) and (particle[I].Living>=particle[I].L/4) then  begin
          if particle[I].frame>MN-1 then particle[I].frame:=0;
          particle[I].p.s.x:=particle[I].p.s.x-1;
          particle[I].p.s.y:=particle[I].p.s.y-1;
          particle[I].p.p.x:=particle[I].p.p.x+n.x;
          particle[I].p.p.y:=particle[I].p.p.y-n.y-T/50;
          end;
          if (particle[I].Living>=particle[I].L/2) then  begin
          if particle[I].frame>MDN-1 then particle[I].frame:=0;
          particle[I].p.s.x:=particle[I].p.s.x+2;
          particle[I].p.s.y:=particle[I].p.s.y+2;
          particle[I].p.p.x:=particle[I].p.p.x+n.x*2;
          particle[I].p.p.y:=particle[I].p.p.y-n.y*2-T/50;
          end;
       end;
       end;
       if FMode=1 then begin
         if particle[I].frame>MN-1 then particle[I].frame:=0;
          particle[I].p.p.x:=particle[I].p.p.x+n.x;
          particle[I].p.p.y:=particle[I].p.p.y-n.y-T/50;
        if (particle[I].Living<particle[I].L/2) then
        begin
          particle[I].p.s.x:=particle[I].p.s.x+1;
          particle[I].p.s.y:=particle[I].p.s.y+1;
        end else  begin
          particle[I].p.s.x:=particle[I].p.s.x-1;
          particle[I].p.s.y:=particle[I].p.s.y-1;
       end;
       end;

    end;
////////////////////////////////////////
///  hpopucoBIdBaem
///
  for I := 0 to Col-1 do
    begin
      DLight();
      if FMode=2 then begin
      
        if (particle[I].Living<particle[I].L/2) then particle[I].p.STex:=Mat[particle[I].frame];
        if (particle[I].Living>=particle[I].L/2) then particle[I].p.STex:=MatD[particle[I].frame];

      end;
      if FMode=1 then particle[I].p.STex:=Mat[particle[I].frame];
      particle[I].p.Draw;
    end;

end;
procedure MGEFire2D.Draw();
  var I,T:integer;
begin
  randomize;
  for I := 0 to Col-1 do
    begin
      inc(particle[I].frame);
      T:=round(-Variants/2)+random(Variants);
      particle[I].p.p.x:=particle[I].p.p.x+n.x;
      particle[I].p.p.y:=particle[I].p.p.y-n.y-T/50;
      particle[I].Living:=particle[I].Living+1;
      particle[I].p.C.A:=255-round(particle[I].Living/2);
      if particle[I].Living>particle[I].L then
        begin
           particle[I].p.p.x:=p.x+T;
           particle[I].p.p.y:=p.y;
           particle[I].Living:=0;
        end;
        if particle[I].frame>MN-1 then particle[I].frame:=0;
    end;
  for I := 0 to Col-1 do
    begin
      particle[I].p.STex:=Mat[particle[I].frame];
      particle[I].p.Draw;
    end;
end;
procedure MGEPlayer.Create(px: Real; py: Real; pz: Real; sx: Real; sy: Real; sz: Real);
begin
  p.x:=px; p.y:=py; p.z:=pz;
  s.x:=sx; s.y:=sy; s.z:=sz;
  Health:=100;
  Speed:=0.1;
end;


procedure MGE2DSprite.Create(px,py,sx,sy,r:real; Texture: Cardinal);
begin
  p.x:=px; p.y:=py;
  s.x:=sx; s.y:=sy;
  Ang:=r;
 STex:=Texture;
 C.L(255,255,255,255);
end;
procedure MGE2DSprite.Update(pos: MGEpoint2D; size: MGEpoint2D);
begin
  p:=pos; s:=Size;
end;
procedure MGE2DSprite.Ubdate(pos: MGEpoint2D);
begin
  p:=pos;
end;
procedure MGE2DSprite.Draw;
begin
   
   glTranslatef(p.x,p.y,0);
   glRotatef(Ang,0,0,1);
      glPushMatrix;
      glColor4d(C.R/255,C.G/255,C.B/255,C.A/255);
  	    glBindTexture(GL_TEXTURE_2D, STex);

          glBegin(GL_Quads);

              glTexCoord2f(0.0, 1.0);  glVertex2d(-s.x,-s.y);
              glTexCoord2f(0.0, 0.0);  glVertex2d(-s.x,+s.y);
              glTexCoord2f(1.0, 0.0);  glVertex2d(+s.x,+s.y);
              glTexCoord2f(1.0, 1.0);  glVertex2d(+s.x,-s.y);
   //
          glEnd;
   glColor4f(255,255,255,255);
      glPopmatrix;
  glRotatef(-Ang,0,0,1);
  glTranslatef(-p.x,-p.y,0);
  
end;
procedure MGE3DPix.LoadAll(pos: MGEpoint3D; size: MGEpoint2D; Textur: Cardinal);
begin
  p:=pos;
  s:=size;
  PTex:=Textur;
end;
procedure MGE3DPix.DrawD(pos: MGEpoint3D; Size: MGEpoint2D; C:MGECamera);
begin
 /////
end;
procedure MGE3DPix.DrawS(C:MGECamera);
begin
 ////
end;
procedure MGESkyProced.Create(Color1: MGEColor; Color2: MGEColor; CSky1: MGEColor; CSky2: MGEColor; SkuShow: Boolean; Anim: Boolean; Intens: Byte);
begin
 ////
end;
procedure MGESkyProced.Draw(P: MGECamera);
begin
 ////
end;
procedure MGESkyProced.Update;
begin
  ////
end;
procedure DrawBox(X,Y,Z,Size:real; Texture:MGEBBox);
begin
   glTranslatef(X,Y,Z);
      glPushMatrix;
  	    glBindTexture(GL_TEXTURE_2D, Texture.T[0]);
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
	    glBindTexture(GL_TEXTURE_2D, Texture.T[1]);
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
		glBindTexture(GL_TEXTURE_2D, Texture.T[2]);
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
		glBindTexture(GL_TEXTURE_2D, Texture.T[3]);
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
		glBindTexture(GL_TEXTURE_2D, Texture.T[4]);
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
	    glBindTexture(GL_TEXTURE_2D, Texture.T[5]);
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
procedure MGESkyBox.create(sx: Real; sy: Real; Btex: MGEBBox);
begin
 s.x:=sx; s.y:=sy;
 t:=Btex;
end;
procedure MGESkyBox.Draw(p: MGECamera);
begin
  DrawBox(P.P.x,p.P.y,p.P.z,s.x,T);
end;
function SiCor(x,y:Single):MGEPoint2D;
var PE:MGEPoint2D;
begin
  PE.x:=(MGEW/2)*(x+1);
  PE.y:=(MGEH/2)*(y+1);
  result:=PE;
end;
function FuCor(x,y:Single):MGEPoint2D;
var PE:MGEPoint2D;
begin
  PE.x:=((x*2)/MGEW)-1;
  PE.y:=((x*2)/MGEH)-1;
  result:=PE;
end;
procedure MGEKeyboard.Update;
Var I:integer;
begin

  for I := 1 to 47 do SDKey[I].znak:=char(127);

  If K_D(VK_Shift)=false then for I := 1 to 26 do SDKey[I].znak:=char(I+96); 
  If K_D(VK_Shift)=true then  for I := 1 to 26 do SDKey[I].znak:=char(I+64);

  for I := 34 to 42 do SDKey[I].znak:=char(I+15);

  SDKey[43].znak:=char(48);
  SDKey[47].znak:=char(127);
  SDKey[46].znak:=char(126);

  if K_D(VK_A)=true then begin SKey[1].state:=true; end else begin SKey[1].state:=false; end;
  if K_D(VK_B)=true then begin SKey[2].state:=true; end else begin SKey[2].state:=false; end;
  if K_D(VK_C)=true then begin SKey[3].state:=true; end else begin SKey[3].state:=false; end;
  if K_D(VK_D)=true then begin SKey[4].state:=true; end else begin SKey[4].state:=false; end;
  if K_D(VK_E)=true then begin SKey[5].state:=true; end else begin SKey[5].state:=false; end;
  if K_D(VK_F)=true then begin SKey[6].state:=true; end else begin SKey[6].state:=false; end;
  if K_D(VK_G)=true then begin SKey[7].state:=true; end else begin SKey[7].state:=false; end;
  if K_D(VK_H)=true then begin SKey[8].state:=true; end else begin SKey[8].state:=false; end;
  if K_D(VK_I)=true then begin SKey[9].state:=true; end else begin SKey[9].state:=false; end;
  if K_D(VK_J)=true then begin SKey[10].state:=true; end else begin SKey[10].state:=false; end;
  if K_D(VK_K)=true then begin SKey[11].state:=true; end else begin SKey[11].state:=false; end;
  if K_D(VK_L)=true then begin SKey[12].state:=true; end else begin SKey[12].state:=false; end;
  if K_D(VK_M)=true then begin SKey[13].state:=true; end else begin SKey[13].state:=false; end;
  if K_D(VK_N)=true then begin SKey[14].state:=true; end else begin SKey[14].state:=false; end;
  if K_D(VK_O)=true then begin SKey[15].state:=true; end else begin SKey[15].state:=false; end;
  if K_D(VK_P)=true then begin SKey[16].state:=true; end else begin SKey[16].state:=false; end;
  if K_D(VK_Q)=true then begin SKey[17].state:=true; end else begin SKey[17].state:=false; end;
  if K_D(VK_R)=true then begin SKey[18].state:=true; end else begin SKey[18].state:=false; end;
  if K_D(VK_S)=true then begin SKey[19].state:=true; end else begin SKey[19].state:=false; end;
  if K_D(VK_T)=true then begin SKey[20].state:=true; end else begin SKey[20].state:=false; end;
  if K_D(VK_U)=true then begin SKey[21].state:=true; end else begin SKey[21].state:=false; end;
  if K_D(VK_V)=true then begin SKey[22].state:=true; end else begin SKey[22].state:=false; end;
  if K_D(VK_W)=true then begin SKey[23].state:=true; end else begin SKey[23].state:=false; end;
  if K_D(VK_X)=true then begin SKey[24].state:=true; end else begin SKey[24].state:=false; end;
  if K_D(VK_Y)=true then begin SKey[25].state:=true; end else begin SKey[25].state:=false; end;
  if K_D(VK_Z)=true then begin SKey[26].state:=true; end else begin SKey[26].state:=false; end;
  if K_D(VK_RX)=true then begin SKey[27].state:=true; end else begin SKey[27].state:=false; end;
  if K_D(VK_RB)=true then begin SKey[28].state:=true; end else begin SKey[28].state:=false; end;
  if K_D(VK_R3)=true then begin SKey[29].state:=true; end else begin SKey[29].state:=false; end;
  if K_D(VK_RIO)=true then begin SKey[30].state:=true; end else begin SKey[30].state:=false; end;
  if K_D(VK_RTZ)=true then begin SKey[31].state:=true; end else begin SKey[31].state:=false; end;
  if K_D(VK_RG)=true then begin SKey[32].state:=true; end else begin SKey[32].state:=false; end;
  if K_D(VK_RTOCHKA)=true then begin SKey[33].state:=true; end else begin SKey[33].state:=false; end;
  if K_D(VK_1)=true then begin SKey[34].state:=true; end else begin SKey[34].state:=false; end;
  if K_D(VK_2)=true then begin SKey[35].state:=true; end else begin SKey[35].state:=false; end;
  if K_D(VK_3)=true then begin SKey[36].state:=true; end else begin SKey[36].state:=false; end;
  if K_D(VK_4)=true then begin SKey[37].state:=true; end else begin SKey[37].state:=false; end;
  if K_D(VK_5)=true then begin SKey[38].state:=true; end else begin SKey[38].state:=false; end;
  if K_D(VK_6)=true then begin SKey[39].state:=true; end else begin SKey[39].state:=false; end;
  if K_D(VK_7)=true then begin SKey[40].state:=true; end else begin SKey[40].state:=false; end;
  if K_D(VK_8)=true then begin SKey[41].state:=true; end else begin SKey[41].state:=false; end;
  if K_D(VK_9)=true then begin SKey[42].state:=true; end else begin SKey[42].state:=false; end;
  if K_D(VK_0)=true then begin SKey[43].state:=true; end else begin SKey[43].state:=false; end;
  if K_D(VK_MIN)=true then begin SKey[44].state:=true; end else begin SKey[44].state:=false; end;
  if K_D(VK_PLUS)=true then begin SKey[45].state:=true; end else begin SKey[45].state:=false; end;
  if K_D(VK_BACK)=true then begin SKey[46].state:=true; end else begin SKey[46].state:=false; end;
  if K_D(VK_SPACE)=true then begin SKey[47].state:=true; end else begin SKey[47].state:=false; end;
  if K_D(VK_RETURN)=true then begin SKey[48].state:=true; end else begin SKey[48].state:=false; end;
  if K_D(VK_SHIFT)=true then begin SKey[49].state:=true; end else begin SKey[49].state:=false; end;
  if K_D(VK_ALT)=true then begin SKey[50].state:=true; end else begin SKey[50].state:=false; end;
  if K_D(VK_TAB)=true then begin SKey[51].state:=true; end else begin SKey[51].state:=false; end;
  if K_D(VK_CTRL)=true then begin SKey[52].state:=true; end else begin SKey[52].state:=false; end;
  if K_D(VK_DEL)=true then begin SKey[53].state:=true; end else begin SKey[53].state:=false; end;
  if K_D(VK_PU)=true then begin SKey[54].state:=true; end else begin SKey[54].state:=false; end;
  if K_D(VK_PD)=true then begin SKey[55].state:=true; end else begin SKey[55].state:=false; end;
  if K_D(VK_ESC)=true then begin SKey[56].state:=true; end else begin SKey[56].state:=false; end;
  if K_D(VK_PALKA)=true then begin SKey[57].state:=true; end else begin SKey[57].state:=false; end;
  if K_D(VK_F1)=true then begin SKey[58].state:=true; end else begin SKey[58].state:=false; end;
  if K_D(VK_F2)=true then begin SKey[59].state:=true; end else begin SKey[59].state:=false; end;
  if K_D(VK_F3)=true then begin SKey[60].state:=true; end else begin SKey[60].state:=false; end;
  if K_D(VK_F4)=true then begin SKey[61].state:=true; end else begin SKey[61].state:=false; end;
  if K_D(VK_F5)=true then begin SKey[62].state:=true; end else begin SKey[62].state:=false; end;
  if K_D(VK_F6)=true then begin SKey[63].state:=true; end else begin SKey[63].state:=false; end;
  if K_D(VK_F7)=true then begin SKey[64].state:=true; end else begin SKey[64].state:=false; end;
  if K_D(VK_F8)=true then begin SKey[65].state:=true; end else begin SKey[65].state:=false; end;
  if K_D(VK_F9)=true then begin SKey[66].state:=true; end else begin SKey[66].state:=false; end;
  if K_D(VK_F10)=true then begin SKey[67].state:=true; end else begin SKey[67].state:=false; end;

  for I := 1 to 67 do
    begin
      if SKey[I].State = true then
        begin
          SKey[I].Time:=SKey[I].Time+1;
            if SKey[I].Time=1 then
              begin
                SDKey[I].State:=True;
              end else begin
                SDKey[I].State:=false;
              end;
            if SKey[I].Time>10 then
              begin
                SKey[I].Time:=0;
              end;
        end;
      if SKey[I].State = false then
        begin
           SDKey[I].State:=false;
           SKey[I].Time:=0;
           SDKey[I].Time:=0;
        end;
    end;
end;
function MGEKeyboard.DKey;
  Var I,PRZ:integer;
  Si:String;
begin
   PRZ:=0;
  for I := 1 to 47 do
    begin
      if (SDKey[i].state= false) and (PRZ<=0) then SI:= '';
      if SDKey[i].state= true then begin SI:= SDkey[i].znak; inc(PRZ);  end;
    end;
  result:=si;
end;
procedure MGEButton.Create(px: real; py: real; sx: real; sy: real; pic: Cardinal; Showi: Boolean; Btext: string);
var C:MGEColor;
begin
  //p.x:=SiCor(px,py).x;
  //p.y:=SiCor(px,py).y;
  p.x:=px;  p.y:=py;
  s.x:=sx; s.y:=sy;
  BPict:=pic;
  BShowing:=Showi;
  C.L(0,0,0,255);
  BCaption.fullprop(BText,p.x+5,p.y+s.y/2,s.y/10,s.y/10,1,STFon,C);
end;
procedure MGEButton.PutBut(sizex: Real; sizey: Real; posx: Real; posy: Real);
begin
  p.x:=posx;
  p.y:=posy;
  s.x:=sizex;
  s.y:=sizey;
end;
function MGEButton.Aktivate(UMouse: MGECursor):Byte;
var MSDX,MSDY:integer;
begin
State:=0;
if MGEFullScreen=false then
begin
MSDX:=MGEFX;
MSDY:=MGEFY;
end else begin
MSDX:=0;
MSDY:=0;
end;
    if BCaption.OutSize.x>p.x+s.x then s.x:= BCaption.OutSize.x-p.x;

if (UMouse.dp.X>(p.x)+MSDX) and (UMouse.dp.y>p.y+MSDY) then
if (UMouse.dp.Y<p.y+s.y+MSDY) and (UMouse.dp.x<p.x+s.x+MSDX) then
begin
State:=1;

if Umouse.Mstate=1 then
 begin
  State:=2;
  c.x:=Umouse.p.X-p.x-MSDX;
  c.y:=Umouse.p.Y-p.y-MSDY;
  dvig:=true;
 end;
if Umouse.Mstate=2 then State:=3;
if Umouse.Mstate=3 then State:=4;
if Umouse.Mstate=4 then State:=5;
end else begin    dvig:=false;  end;
if BShowing=true then
  begin
    glPushMatrix;
    BCaption.fullprop(BCaption.text,p.x+5,p.y+s.y/2,s.y/2.5,s.y/2.5,1,BCaption.TMFont,BCaption.TMColor);
    DLight;
    glBindTexture(GL_TEXTURE_2D, Bpict);
      glBegin(GL_Quads);
        glTexCoord2d(0.0, 1.0);  glVertex2d(p.x,p.y);
        glTexCoord2d(0.0, 0.0);  glVertex2d(p.x,s.y+p.y);
        glTexCoord2d(1.0, 0.0);  glVertex2d(s.x+p.x,s.y+p.y);
        glTexCoord2d(1.0, 1.0);  glVertex2d(s.x+p.x,p.y);
      glEnd;
    BCaption.Draw;
    ELight;
    GLpOPmATRIX;
  end;
result:=State;
end;
function K_D(Key:Integer):boolean;
var D:boolean;
begin
  D:=false;
  if (GetAsyncKeyState(Key)<>0) then D:=true;
  result:=D;
end;
procedure MGE2DForm.Create(MX: real; MY: real; MW: real; MH: real; FoName: string; Sh: Boolean);
var CloForm:MGEColor;
begin
  pos.X:=MX;
  pos.Y:=MY;
  s.x:=MW;
  s.y:=MH;
  CloForm.L(255,255,255,255);
  UpCur.Create(pos.x,pos.y,s.x-40,20,MGEFR[5],false,' ');
  Ex.Create(s.x+pos.x-40,pos.y,40,20,MGEFR[2],false,' ');
  MCaption.fullprop(FoName,pos.X,pos.Y+8,11,11,1,STFon,CloForm);
  MShow:=Sh;
end;
procedure MGE2DForm.CreateBut(pfx: Real; pfy: Real; sfx: Real; sfy: Real; btext: string; BShow: Boolean);
begin
  inc(NBut);
  SetLength(FButton,NBut);
  FButton[NBut-1].pd.x:=pfx;
  FButton[NBut-1].pd.y:=pfy;
  FButton[NBut-1].sd.x:=(S.x/100)*sfx;
  FButton[NBut-1].sd.y:=(S.y/100)*sfy;
  FButton[NBut-1].Create((S.x/100)*pfx,(S.x/100)*pfy,(S.x/100)*sfx,(S.x/100)*sfy,MGEFR[4],BShow,btext);
end;
procedure MGE2DForm.CreateText(Text: string; pfx: Real; pfy: Real; sfx: Real; sfy: Real; size: Real; mfont: MGEFont; mcolor: MGEColor);
begin
  inc(NTex);
  SetLength(FText,NTex);
  FText[NTex-1].pdx:=pfx;
  FText[NTex-1].pdy:=pfy;
  FText[NTex-1].Width:=(S.y/100)*sfy;
  FText[NTex-1].Height:=(S.y/100)*sfy;
  FText[NTex-1].fullprop(Text,(S.x/100)*pfx,(S.x/100)*pfy,(S.x/100)*sfx,(S.y/100)*sfy,1,mfont,mcolor);
end;
procedure MGE2DForm.Draw(UMouse:MGECursor);
var T,T2,i:integer;
begin
if MShow=true then begin
  glPushMatrix;

  DLight;
     if (DT =4) and (UpCur.dvig=true) then begin
      pos.x:=UMouse.p.X-UpCur.c.x;
      pos.y:=UMouse.p.Y-UpCur.c.y;
      UpCur.p.x:=pos.x;
      UpCur.p.y:=pos.y;
      Ex.p.x:=s.x+pos.x-40;
      Ex.p.y:=pos.y;
    end;
  T:=UpCur.Aktivate(UMouse); DT:=T;
  T2:=Ex.Aktivate(UMouse);
    if (T2=2) and (Time=0)  then begin
      if MShow=true then begin MShow:=false; Time:=20;  end;
    end else begin if Time>0 then Time:=Time-1;   end;

  MCaption.lowprop(MCaption.text,pos.X,pos.Y+8);
  glBindTexture(GL_TEXTURE_2D, MGEFR[3]);////MGEFR[3]
    glBegin(GL_Quads);
      glTexCoord2d(0.0, 1.0);  glVertex2d(pos.x,pos.y+20);
      glTexCoord2d(0.0, 0.0);  glVertex2d(pos.x,s.y+pos.y);
      glTexCoord2d(1.0, 0.0);  glVertex2d(s.x+pos.x,s.y+pos.y);
      glTexCoord2d(1.0, 1.0);  glVertex2d(s.x+pos.x,pos.y+20);
    glEnd;
  glBindTexture(GL_TEXTURE_2D, MGEFR[5]);
    glBegin(GL_Quads);
      glTexCoord2d(0.0, 1.0);  glVertex2d(pos.x,pos.y);
      glTexCoord2d(0.0, 0.0);  glVertex2d(pos.x,20+pos.y);
      glTexCoord2d(1.0, 0.0);  glVertex2d(s.x+pos.x,20+pos.y);
      glTexCoord2d(1.0, 1.0);  glVertex2d(s.x+pos.x,pos.y);
    glEnd;
    MCaption.Draw;
  glBindTexture(GL_TEXTURE_2D, MGEFR[2]);
    glBegin(GL_Quads);
      glTexCoord2d(0.0, 1.0);  glVertex2d(s.x+pos.x-40,pos.y);
      glTexCoord2d(0.0, 0.0);  glVertex2d(s.x+pos.x-40,20+pos.y);
      glTexCoord2d(1.0, 0.0);  glVertex2d(s.x+pos.x,20+pos.y);
      glTexCoord2d(1.0, 1.0);  glVertex2d(s.x+pos.x,pos.y);
    glEnd;
  ELight;
  GLpOPmATRIX;
  if NBut>0 then begin
    for I := 0 to NBut - 1 do begin
      FButton[I].PutBut(FButton[I].sd.x,FButton[I].sd.y,
                        pos.x+(S.x/100)*FButton[I].pd.x,pos.y+(s.y/100)*FButton[I].pd.y);
      FButton[I].Aktivate(GUICursor);
    end;
  end;
  if NTex>0 then begin
    for I := 0 to NTex - 1 do begin
      FText[I].lowprop(FText[I].text,pos.x+(S.x/100)*FText[I].pdx,pos.y+(s.y/100)*FText[I].pdy);
      FText[I].Draw;
      //FButton[I].PutBut(FButton[I].pd.x+pos.x,FButton[I].pd.y+pos.y,FButton[I].sd.x,FButton[I].sd.y);
      //FButton[I].Aktivate(GUICursor);
    end;
  end;

  end;

end;
procedure LoadMainResource();
begin
  LoadTexture(MGELocation+'\resource\MGEIMG\maincursor.tga',MGEFR[0],false);
  LoadTexture(MGELocation+'\resource\MGEIMG\black.tga',     MGEFR[1],false);
  LoadTexture(MGELocation+'\resource\MGEIMG\Exit.tga',      MGEFR[2],false);
  LoadTexture(MGELocation+'\resource\MGEIMG\Inskreen.tga',  MGEFR[3],false);
  LoadTexture(MGELocation+'\resource\MGEIMG\objects.tga',   MGEFR[4],false);
  LoadTexture(MGELocation+'\resource\MGEIMG\UpLine.tga',    MGEFR[5],false);
  LoadTexture(MGELocation+'\resource\MGEIMG\point.tga',     MGEFR[6],false);
end;
procedure LoadMGEWinSet(W,H,FX,FY:integer;FTest:boolean);
begin
MGEW:=W;
MGEH:=H;
MGEFX:=FX;
MGEFY:=FY+15;
MGEFullScreen:=FTest;
end;
Procedure Start_Controller();
begin
  LoadMainScript(MGELocation);
end;
Procedure MGEColor.L(zR: Byte; zG: Byte; zB: Byte; zA: Byte);
begin
  R:=zR;
  G:=zG;
  B:=zB;
  A:=zA;
end;
Procedure MGEText.fullprop(mtext: string; x: Real; y: Real; w: Real; h: Real; line: Byte; mfont: MGEFont; mcolor: MGEColor);
begin
    posx:=x;
    posy:=y;
    height:=h;
    width:=w;
    Lin:=line;
    text:=mtext;
    TMFont:=mfont;
    TMColor:=mcolor;
end;
Procedure MGEText.lowprop(mtext: string; x: Real; y: Real);
begin
    posx:=x;
    posy:=y;
    text:=mtext;
end;
procedure MGETExt.SetDraw(mtext: string; x: Real; y: Real; w: Real; h: Real; mfont: MGEFont; mcolor: MGEColor);
begin
  fullprop(mtext,(MGEW/100)*x,(MGEH/100)*y,w,h,1,mfont,mcolor);
  draw();
end;
Procedure MGEText.Draw;
  var I,BB:integer;
begin
  Leg:=Length(text);
  glPushMatrix;
  DLight();
  glBindTexture(GL_TEXTURE_2D, TMFont.FontTex);
  glColor4f(TMColor.R,TMColor.G,TMColor.B,TMColor.A);
    for I := 1 to Leg do
      begin
        BB:=Check_Sim(TMFont,text[I]);
          glBegin(GL_Quads);
            glTexCoord2f((TMFont.PSim[BB].x-1)/TMFont.x, (TMFont.PSim[BB].y)/TMFont.y);
                  glVertex2f((-1*width)+posx+((width*1.5)*I), (-1*height)+posY);

            glTexCoord2f((TMFont.PSim[BB].x-1)/TMFont.x, (TMFont.PSim[BB].y-1)/TMFont.y);
                  glVertex2f((-1*width)+posX+((width*1.5)*I), ( 1*height)+posY);

            glTexCoord2f((TMFont.PSim[BB].x)/TMFont.x,   (TMFont.PSim[BB].y-1)/TMFont.y);
                  glVertex2f(( 1*width)+posX+((width*1.5)*I), ( 1*height)+posY);

            glTexCoord2f((TMFont.PSim[BB].x)/TMFont.x,   (TMFont.PSim[BB].y)/TMFont.y);
                  glVertex2f(( 1*width)+posX+((width*1.5)*I), (-1*height)+posY);
          glEnd;
      end;
  glColor4f(255,255,255,255);
  GLpOPmATRIX;
end;
function MGEText.OutSize;
var
  pt:MGEpoint2D;
begin
  Leg:=Length(text);
  pt.x:= (1*width)+posX+((width*1.5)*Leg);
  pt.y:=  (1*height)+posY;
  result:=pt;
end;
Procedure MGECamera.Create(Pos: MGEpoint3D; Rot: MGEpoint3D; Vec: MGEpoint3D; Look: MGEpoint3D; TType: Byte);
begin
  P:=Pos;
  R:=Rot;
  V:=Vec;
  L:=Look;
  CType:=TType;
end;
procedure MGECamera.Update(Pos: MGEpoint3D; Rot: MGEpoint3D; Vec: MGEpoint3D; Look: MGEpoint3D);
begin
  P:=Pos;
  R:=Rot;
  V:=Vec;
  L:=Look;
end;
Procedure MGECamera.Plant;
begin
////////////////// MGECamera имеет 3 режима работы /////////////////////////
///
///////////////////////////// 1 Режим Вид от первого лица //////////////////
  if CType=0 then begin end;
//////////////////////////// 2 Режим Вид от третьего лица //////////////////
  if CType=1 then begin end;
////////////////////////// 3 Слежение из позиции за точкой /////////////////
  if CType>1 then begin end;
end;
Procedure MGEFont.Load_Font(Nfile: string);
Var
  Put:String;
  fi:textfile;
  I,K,P,H:integer;
  MPut:string;
begin
   assignfile(fi,Nfile); reset(fi);
   readln(fi,Name);
   readln(fi,Loc);
   readln(fi,x,y);
   readln(fi,size);
   for I := 1 to size do
    begin
        readln(fi, Simvol[I]);
    end;
    closefile(fi);
   MPut:=Nfile;
   K:=Length(MPut);
   Delete(MPut,K-2,3);
   MPut:=MPut+'tga';
   LoadTexture(MPut,FontTex,false);
   P:=x*y;

  for H := 1 to y do
      for I := -x to -1 do
        begin
          PSim[P].x:=I*(-1);
          PSim[P].y:=H;
          P:=P-1;
        end;

end;
procedure ELight();
begin
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHT1);
end;
procedure DLight();
begin
  glDisable(GL_LIGHTING);
  glDisable(GL_LIGHT0);
  glDisable(GL_LIGHT1);
end;
function Check_Sim(Mfont:MGEFont; a:char):byte;
  var I:integer;
  C:byte;
begin
  C:=Mfont.X*Mfont.Y;
  for I := 1 to Mfont.Size do
    begin
      if a = Mfont.Simvol[I] then
        begin
          C:=I;
        end;
    end;
   result:=C;
end;
function MGECursor.state;
begin
    MState:=0;
    RKM:=K_D(VK_RButton); if RKM=true then MState:=2;
    LKM:=K_D(VK_LButton); if LKM=true then MState:=1;
    if (RKM=false) and (LKM=false) then MState:=0;
    if (LKM=NLKM) and (LKM=true) then MState:=3;
    if (RKM=NRKM) and (RKM=true) then MState:=4;
     NRKM:=RKM;
     NLKM:=LKM;
     dp.x:=p.X;
     dp.y:=p.Y;
     result:=MState;
end;
procedure MGECursor.create;
begin
  s.x:=1;
  s.y:=1;
end;
procedure MGECursor.Draw;
var MSX,MSY:real;
begin

  MSX:=MGEW/80*s.x;
  MSY:=MGEW/80*s.x;

  GetCursorPos(P);
  glPushMatrix;
  DLight;
  if  MGEFullScreen=true then begin
  glBindTexture(GL_TEXTURE_2D, Skin);
    glBegin(GL_Quads);
      glTexCoord2d(0.0, 1.0);  glVertex2d(p.x-MGEFX,p.y-MGEFY+15);
      glTexCoord2d(0.0, 0.0);  glVertex2d(p.x-MGEFX,+MSY*2+p.y-MGEFY+15);
      glTexCoord2d(1.0, 0.0);  glVertex2d(+MSX*2+p.x-MGEFX,+MSY*2+p.y-MGEFY+15);
      glTexCoord2d(1.0, 1.0);  glVertex2d(+MSX*2+p.x-MGEFX,p.y-MGEFY+15);
    glEnd;
  end else  begin
  glBindTexture(GL_TEXTURE_2D, Skin);
    glBegin(GL_Quads);
      glTexCoord2d(0.0, 1.0);  glVertex2d(p.x-MGEFX,p.y-MGEFY);
      glTexCoord2d(0.0, 0.0);  glVertex2d(p.x-MGEFX,+MSY*2+p.y-MGEFY);
      glTexCoord2d(1.0, 0.0);  glVertex2d(+MSX*2+p.x-MGEFX,+MSY*2+p.y-MGEFY);
      glTexCoord2d(1.0, 1.0);  glVertex2d(+MSX*2+p.x-MGEFX,p.y-MGEFY);
    glEnd;
  end;

  ELight;
  GLpOPmATRIX;
end;
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
procedure R2D_To_3D();
begin
  glMatrixMode(GL_PROJECTION);
  glPopMatrix;
  glMatrixMode(GL_MODELVIEW);
  glPopMatrix;
end;
procedure RenderVehicle(Veh:MGEVehicle; PRot,MWeel,MCar:integer;Tex1,Tex2:GLUint);
begin
 { MGEBoneModel(Veh.MCP[0].P.X,Veh.MCP[0].p.y,Veh.MCP[0].p.z,
    0,0,0,Veh.AngleX,0,0,Veh.MCP[0].PR,Veh.MCP[0].PR,Veh.MCP[0].PR, Mode1s[1], TGATex[6]);   }
  MGEBoneModel(Veh.P.X,Veh.p.y,Veh.p.z,
    Veh.AngleZ,180,PRot,Veh.AngleX,Veh.AngleY+90,0,Veh.CarS,Veh.CarS,Veh.CarS, Mode1s[MCar], Tex2);
{ MGEBoneModel(Veh.MCP[2].P.X,Veh.MCP[2].p.y,Veh.MCP[2].p.z,
    0,0,0,Veh.AngleX,0,0,Veh.MCP[2].PR,Veh.MCP[2].PR,Veh.MCP[2].PR, Mode1s[1], TGATex[6]);  }

  MGEBoneModel(Veh.weelg[0].P.X,Veh.weelg[0].p.y,Veh.weelg[0].p.z,
    Veh.WeelRot*10,Veh.WM[0]*5,0,Veh.AngleX+180,0,-Veh.AngleZ,Veh.WS,Veh.WS,Veh.WS, Mode1s[MWeel], Tex1);
  MGEBoneModel(Veh.weelg[1].P.X,Veh.weelg[1].p.y,Veh.weelg[1].p.z,
    Veh.WeelRot*10,-Veh.WM[1]*5,0,Veh.AngleX,0,Veh.AngleZ,Veh.WS,Veh.WS,Veh.WS, Mode1s[MWeel], Tex1);
  MGEBoneModel(Veh.weelg[2].P.X,Veh.weelg[2].p.y,Veh.weelg[2].p.z,
    0,Veh.WM[2]*5,0,Veh.AngleX+180,0,-Veh.AngleZ,Veh.WS,Veh.WS,Veh.WS, Mode1s[MWeel], Tex1);
  MGEBoneModel(Veh.weelg[3].P.X,Veh.weelg[3].p.y,Veh.weelg[3].p.z,
    0,-Veh.WM[3]*5,0,Veh.AngleX,0,Veh.AngleZ,Veh.WS,Veh.WS,Veh.WS, Mode1s[MWeel], Tex1);

end;


procedure DrawFrameLoad(W,H:Integer);
var
  PL,SL:MGEPoint2D;
begin

  glClearColor(0.0, 0.0, 0.0, 0.0); //// по умолчанию цвет фона черный
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glPushMatrix;
{    3d сцена     }

  R3D_To_2D(W, H);
  //glDepthFunc(GL_LEQUAL);
{    2d сцена     }
{ все объекты рисуются с заднего плана на передний  }
   {PL.x:=MGEW/2;
   PL.y:=MGEH/2;
   SL.x:=MGEW/3;
   SL.y:=MGEW/13;
   Lo.Update(PL,SL);
   LO.Draw;
                }
   RenderSprite(MGEW/2,MGEH/2,MGEW/2,MGEH/2,0,tex);

  R2D_To_3D();
{    3d сцена     }


  glPopMatrix;
end;



procedure EndRender();
var
  I,SNK,k,o,l,camr:integer;
  KV:real;
begin
  glViewport(0, 0,  MGEW, MGEH); //выделяем область куда будет выводиться наш буфер
  glMatrixMode ( GL_PROJECTION ); //переходим в матрицу проекции
  glLoadIdentity;  //сбрасываем текущую матрицу
  gluPerspective(50+((30/17)*Phantom.Speed*10), MGEW/ MGEH,1,80000); //Область видимости
  glMatrixMode ( GL_MODELVIEW ); //переходим в модельную матрицу
  glLoadIdentity;//сбрасываем текущую матрицу

  glBindFramebufferEXT ( GL_FRAMEBUFFER_EXT ,  fbo2 ) ;
  glPushAttrib ( GL_VIEWPORT_BIT ) ;
  glViewPort ( 0 ,  0 ,  FMW ,  FMH ) ;

  glClearColor(0.1, 0.1, 0.1, 0.0); // цвет фона
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); // очистка буфера цвета

  glmaterialfv( GL_FRONT, GL_DIFFUSE, @light0_diffuse);
  glMaterialfv(GL_FRONT, GL_SHININESS,  @mat_shininess );

{    3d сцена     }
glLightfv(GL_LIGHT0, GL_AMBIENT, @ambient);
glLightfv(GL_LIGHT0, GL_POSITION, @glLightPos);

glLightPos[0]:=3000;
glLightPos[1]:=3000;
glLightPos[2]:=500;



If Gamemode=0 then begin
  //view.p:=Phantom.p;
 view.p:=Phantom.CamIn;
end;
If Gamemode=1 then view.p:=redview.p;



if Gamemode=0 then  begin

if view.angleX>Phantom.angleX+180 then view.angleX:=view.angleX-360;
if view.angleX<Phantom.angleX-180 then view.angleX:=view.angleX+360;

  KV:=view.AngleX-(Phantom.AngleX);

if (view.AngleX>Phantom.AngleX) and (abs(Phantom.Speed)>0.02) And (K_D(VK_RButton)=false)  then begin
view.AngleX:=view.AngleX-0.1*KV;
end;

if (view.AngleX<Phantom.AngleX) and (abs(Phantom.Speed)>0.02) And (K_D(VK_RButton)=false)  then begin
  view.AngleX:=view.AngleX-0.1*KV;
end;
  if (K_D(VK_RButton)=false) and (abs(Phantom.Speed)>0.02) then begin
  if (view.AngleY>Phantom.AngleY-10) then view.AngleY:=view.AngleY-0.5;
  if (view.AngleY<Phantom.AngleY-10) then view.AngleY:=view.AngleY+0.5;
 end;

end;

If view.AngleY>80 then view.AngleY:=80;
If view.AngleY<-80 then view.AngleY:=-80;
MGEV:=cos(-view.AngleY/180*Pi);
camr:=round(CamRad);


/////////////////////////ВИд от третьего лица//////////////////////////
MGECamAt(view.p.X,view.p.Y,view.p.Z,view.p.X+sin(view.angleX/180*Pi)*camr*MGEV, view.p.Y+sin(-view.AngleY/180*Pi)*camr,
               view.p.Z+cos(view.angleX/180*Pi)*camr*MGEV,0,1,0,  false);
/////////////////////////Вид из салона////////////////////////////
//MGECamAt(view.p.X,view.p.Y,view.p.Z,view.p.X+sin(view.angleX/180*Pi)*camr*MGEV, view.p.Y+sin(-view.AngleY/180*Pi)*camr,
    //            view.p.Z+cos(view.angleX/180*Pi)*camr*MGEV, Phantom.Wn1.x,Phantom.Wn1.y,Phantom.Wn1.z, true);



   glEnable(GL_LIGHTING);
   glLightfv(GL_LIGHT0, GL_POSITION, @glLightPos);



  glPushMatrix;

{    3d сцена     }
  DLight();
      ////////////////   Небо /////////////////////////////////
      MGEModel_Draw(view.p.X,view.p.Y,view.p.Z,-90,0,0,50000,50000,50000,Mode1s[1],Ttextobj[51]);      ////фон


      MGEModel_Draw(view.p.X,view.p.Y,view.p.Z,0,0,40+SunDay/10,49000,49000,49000,Mode1s[1],Ttextobj[53]); //// солнце
      MGEModel_Draw(view.p.X,view.p.Y-65000,view.p.Z,0,0,Sk*0.1,75000,75000,75000,Mode1s[1],Ttextobj[52]); //// облака
      MGEModel_Draw(view.p.X,view.p.Y-6500,view.p.Z,0,0,Sk*0.1,75000,75000,75000,Mode1s[1],Ttextobj[52]); //// облака
      MGEModel_Draw(view.p.X,view.p.Y-6500,view.p.Z,0,0,Sk,75000,75000,75000,Mode1s[1],Ttextobj[57]); //// облака
      MGEModel_Draw(view.p.X,view.p.Y-7000,view.p.Z,0,0,Sk,75000,75000,75000,Mode1s[1],Ttextobj[57]); //// облака

   ELight();


 fogColor[0]:=SkyR/255;
 fogColor[1]:=SkyG/255;
 fogColor[2]:=SkyB/255;

glEnable(GL_FOG);
  
  glFogi(GL_FOG_MODE, GL_LINEAR); // задаем закон смешения тумана
  glFogf(GL_FOG_START , 200); // начало тумана
  glFogf(GL_FOG_END , 8000); // конец тумана
  glFogfv(GL_FOG_COLOR, @fogColor); // цвет дымки
  glFogf(GL_FOG_DENSITY, 0.5); // плотность тумана


  //BigFloreDraw(0,0,0,30000,20, TGATex[0]);
  //mode1s[0].Draw; PPN,PFN
  if PPN>1 then  begin
    for I := 1 to PPN - 1 do
      PhizPlane[i].DrawPlane();
 end;
  if PFN>0 then  begin
    for I := 0 to PFN- 1 do
      PhizFence[i].DrawPlane();
 end;

 {if NPlG>0 then  begin
    for I := 0 to NPlG- 1 do
      Polg[i].Draw(TGATex[0]);
 end;           }


  if MyOList.N>0  then begin
      for I:=0 to MyOList.N-1 do begin
         MGEModel_Draw(MyOList.Model[I].p.x,MyOList.Model[I].p.y,
            MyOList.Model[I].p.z,MyOList.Model[I].r.x,MyOList.Model[I].r.y,MyOList.Model[I].r.z,
            MyOList.Model[I].s.x,MyOList.Model[I].s.y,MyOList.Model[I].s.z, GMSmode1[MyOList.Model[I].ModelID], TGATex[MyOList.Model[I].TexID]);
      end;
  end;


     Anim1[FrameA].DrawSkelet(SetP3D(Charact[0].Pl1.p.x,Charact[0].Pl1.p.y+2+AnUp,Charact[0].Pl1.p.z),Charact[0].s,SetP3D(0,Charact[0].AngleX+180,0));


    //Polig.Draw(TGATex[0]);

  //GOSHA.DrawSkelet(PGosha.P.x,PGosha.P.y,PGosha.P.z);
  /////////////////Avtomobil//////////////////////

      MGEModel_Draw(0,200,0,-90,0,
            0,1,-1,1, mode1s[5], TGATex[0]);

  If Gamemode=1 then begin
      MGEModel_Draw(redview.p.x,redview.p.y,redview.p.z,-90,0,TecRotID+redview.AngleX,TecSizeXID+2,TecSizeYID+2,TecSizeZID+2, mode1s[2], Ttextobj[25]);
      MGEModel_Draw(redview.p.x,redview.p.y,redview.p.z,-90,0,
            TecRotID+redview.AngleX,TecSizeXID,TecSizeYID,TecSizeZID, GMSmode1[TecModID], TGATex[TecTexID]);
  end;



  RenderVehicle(Phantom,90,3,6,TGATex[6],TGATex[1]);

/////////////////////////////////////////////////////////////////////////


  DLight();



  My3dFire.n.x:=sin((Phantom.angleX)/180*Pi)-(sin((Phantom.angleX)/180*Pi)*Phantom.Speed*8);
  My3dFire.n.z:=cos((Phantom.angleX)/180*Pi)-(cos((Phantom.angleX)/180*Pi)*Phantom.Speed*8);
  My3dFire.n.y:=-0.01;

  My3dFire.s.SetP(2,2,2);


 // Fire001.s.SetP(2,2,2);
  //Fire001.FDraw(SetP3D(view.AngleX,view.AngleY,0),SetP3D(view.p.x,view.p.y,view.p.z),-290,10,1257,5,0.5);
  Fire001.FDraw(SetP3D(view.AngleX,view.AngleY,0),SetP3D(view.p.X+sin(view.angleX/180*Pi)*camr*MGEV, view.p.Y+sin(-view.AngleY/180*Pi)*camr,
               view.p.Z+cos(view.angleX/180*Pi)*camr*MGEV),-290,10,1257,2,0.1);
  if p.Speed<1 then My3dFire.FDraw(SetP3D(view.AngleX,view.AngleY,0),SetP3D(view.p.x,view.p.y,view.p.z),
  Phantom.MCP[0].p.x+sin((Phantom.angleX-10)/180*Pi)*(10-(4*Phantom.Speed)),Phantom.MCP[0].p.y-1.5,
  phantom.MCP[0].p.z+cos((Phantom.angleX-10)/180*Pi)*(10-(4*Phantom.Speed)),2,0.1);



 glDisable(GL_FOG);



  R3D_To_2D(MGEW, MGEH);
{    2d сцена     }
{ все объекты рисуются с заднего плана на передний  }
    DLight();



      //RenderSprite(-p.p.x,-p.p.z,4096,4096,p.AngleX,TGATex[0]);

If GameMode=0 then begin
      minmap.Create(TGATex[0],MGEW/8,MGEH-MGEH/8,MGEW/10,MGEH/10);
      minmap.Draw(-Phantom.p.x,Phantom.p.z,3000,Phantom.AngleX+90,0.2+(abs(Phantom.Speed/4)));
      RenderSprite(MGEW/8,MGEH-MGEH/8,MGEW/60/(1+abs(P.Speed/2)),MGEH/40/(1+abs(P.Speed/2)),0,TGATex[5]);

  RenderSprite(MGEW-MGEW/10,MGEH-MGEW/10,MGEW/10,MGEW/10,0,TGATex[3]);
  RenderSprite(MGEW-MGEW/10,MGEH-MGEW/11.5,MGEW/10,MGEW/10,-130+(abs(Phantom.ARMS)*10000),TGATex[4]);

   MenuN[10].fullprop(FloatTostr(round(Phantom.Speed*200)),MGEW-MGEW/10,MGEH-MGEW/30,MGEW/70,MGEW/70,1,StFon,SetColor(255,255,255,255));
   MenuN[10].Draw;

   MenuN[10].fullprop(Phantom.Per,MGEW-MGEW/15,MGEH-MGEW/13,MGEW/70,MGEW/70,1,StFon,SetColor(255,255,255,255));
   MenuN[10].Draw;
end;


   If GameMode=1 then begin
      TextDraw(2,9,1.5,1.5, 'MID  :   '+IntToStr(TecModID));
      TextDraw(2,16,1.5,1.5,'TID  :   '+IntToStr(TecTexID));
      TextDraw(2,23,1.5,1.5,'SX   :   '+FloatToStr(TecSizeXID));
      TextDraw(2,30,1.5,1.5,'SY   :   '+FloatToStr(TecSizeZID));
      TextDraw(2,37,1.5,1.5,'SZ   :   '+FloatToStr(TecSizeYID));



      TextDraw(2,44,1.5,1.5,'RX   :'+FloatToStr(TecRotID));



     

     TextDraw(2,97,1.5,1.5,'Position X='+Inttostr(round(view.p.x))+
     '; Y='+Inttostr(round(view.p.y))+'; Z='+Inttostr(round(view.p.z))+';');
   end;
    TextDraw(72,5,2.5,2.5,'FPS='+IntToStr(FPS));





     MyBut[0].PutBut((MGEH*0.1),(MGEH*0.05),MGEW*0.01,MGEH*0.01);
     MyBut[0].Aktivate(GUICursor);

     MyBut[1].PutBut((MGEH*0.1),(MGEH*0.05),MGEW*0.01,MGEH*0.01);
     MyBut[1].Aktivate(GUICursor);


     MyBut[2].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.1,MGEH*0.07);
     MyBut[2].Aktivate(GUICursor);

     MyBut[3].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.19,MGEH*0.07);
     MyBut[3].Aktivate(GUICursor);

     MyBut[4].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.1,MGEH*0.14);
     MyBut[4].Aktivate(GUICursor);

     MyBut[5].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.19,MGEH*0.14);
     MyBut[5].Aktivate(GUICursor);

     MyBut[7].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.1,MGEH*0.21);
     MyBut[7].Aktivate(GUICursor);

     MyBut[8].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.19,MGEH*0.21);
     MyBut[8].Aktivate(GUICursor);

     MyBut[11].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.1,MGEH*0.28);
     MyBut[11].Aktivate(GUICursor);

     MyBut[12].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.19,MGEH*0.28);
     MyBut[12].Aktivate(GUICursor);

     MyBut[13].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.1,MGEH*0.35);
     MyBut[13].Aktivate(GUICursor);

     MyBut[14].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.19,MGEH*0.35);
     MyBut[14].Aktivate(GUICursor);



     MyBut[9].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.1,MGEH*0.42);
     MyBut[9].Aktivate(GUICursor);

     MyBut[10].PutBut((MGEH*0.05),(MGEH*0.05),MGEW*0.19,MGEH*0.42);
     MyBut[10].Aktivate(GUICursor);





     MyBut[6].PutBut((MGEH*0.1),(MGEH*0.05),MGEW*0.01,MGEH*0.49);
     MyBut[6].Aktivate(GUICursor);


   DLight();
  R2D_To_3D();
{    3d сцена     }


      case GameMode of
         0: begin MyBut[0].BShowing:=true; MyBut[1].BShowing:=false;
            MyBut[2].BShowing:=false;
            MyBut[3].BShowing:=false;
            MyBut[4].BShowing:=false;
            MyBut[5].BShowing:=false;
            MyBut[6].BShowing:=false;
            MyBut[7].BShowing:=false;
            MyBut[8].BShowing:=false;
            MyBut[9].BShowing:=false;
            MyBut[10].BShowing:=false;
            MyBut[11].BShowing:=false;
            MyBut[12].BShowing:=false;
            MyBut[13].BShowing:=false;
            MyBut[14].BShowing:=false;
     if (MyBut[0].State=2)  then begin
        GameMode:=1;
        redview.p:=Phantom.p;
     end;
         end;
         1: begin MyBut[1].BShowing:=true; MyBut[0].BShowing:=false;
            MyBut[2].BShowing:=true;
            MyBut[3].BShowing:=true;
            MyBut[4].BShowing:=true;
            MyBut[5].BShowing:=true;
            MyBut[6].BShowing:=true;
            MyBut[7].BShowing:=true;
            MyBut[8].BShowing:=true;
            MyBut[9].BShowing:=true;
            MyBut[10].BShowing:=true;
            MyBut[11].BShowing:=true;
            MyBut[12].BShowing:=true;
            MyBut[13].BShowing:=true;
            MyBut[14].BShowing:=true;
     if (MyBut[1].State=2) then begin
        GameMode:=0;
     end;
         end;
      end;



     if (MyBut[2].State=2) and (TecModID>0) then Dec(TecModID);
     if (MyBut[3].State=2) and (TecModID<Length(GMSmode1)-1) then inc(TecModID);

     if (MyBut[4].State=2) and (TecTexID>0) then Dec(TecTexID);
     if (MyBut[5].State=2) and (TecTexID<Length(TGATex)-1) then inc(TecTexID);

     if (MyBut[7].State=4)  then TecSizeXID:=TecSizeXID-1;
     if (MyBut[8].State=4)  then TecSizeXID:=TecSizeXID+1;

     if (MyBut[13].State=4)  then TecSizeYID:=TecSizeYID-1;
     if (MyBut[14].State=4)  then TecSizeYID:=TecSizeYID+1;

     if (MyBut[11].State=4)  then TecSizeZID:=TecSizeZID-1;
     if (MyBut[12].State=4)  then TecSizeZID:=TecSizeZID+1;


     if (MyBut[9].State=4)  then TecRotID:=TecRotID-1;
     if (MyBut[10].State=4)  then TecRotID:=TecRotID+1;

    if (MyBut[6].State=2)  then begin
      MyOList.Add(redview.p,SetP3D(TecSizeXID,TecSizeYID,TecSizeZID),SetP3D(-90,0,TecRotID+redview.AngleX),TecTexID,TecModID);
    end;




    glPopMatrix;
glPopMatrix;

  glPopAttrib ;
  glBindFramebufferEXT ( GL_FRAMEBUFFER_EXT ,  0 ) ;
end;
procedure FrameTest();
var I,ft:integer;
MV,MZ:real;

begin
  glViewport(0, 0, MGEW, MGEH); //выделяем область куда будет выводиться наш буфер
  glMatrixMode ( GL_PROJECTION ); //переходим в матрицу проекции
  glLoadIdentity;  //сбрасываем текущую матрицу
  gluPerspective(60,MGEW/MGEH,0.1,800); //Область видимости
  glMatrixMode ( GL_MODELVIEW ); //переходим в модельную матрицу
  glLoadIdentity;//сбрасываем текущую матрицу

glPushMatrix;

  glClearColor(0.1, 0.1, 0.1, 1.0); // цвет фона
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); // очистка буфера цвета

  glPushMatrix;

  R3D_To_2D(MGEW, MGEH);
{    2d сцена     }
{ все объекты рисуются с заднего плана на передний  }

   DLight();
   //



   

  if MenuStay=0 then begin
  RenderSprite(MGEW/2,MGEH/2,MGEW/2,MGEH/2,0,tex3);

  end
    else begin RenderSprite(MGEW/2,MGEH/2,MGEW/2,MGEH/2,0,tex);
    end;

 
 // NameWin.Draw(GUICursor);

  if GUICursor.MState<>0 then Timemouse:=1000;

   Timemouse:=Timemouse-1;

  if Timemouse>0 then GUICursor.draw;

 Keys.Update;
 //MyTextKlav:=MyTextKlav+Keys.DKey;
   if Keys.DKey=char(126) then begin ft:=Length(BigText);
          if ft>0 then SetLength(BigText,ft-1); end;

   If (Keys.DKey<>char(126)) and (Intext=true) then  BigText:=BigText+Keys.DKey;



  R2D_To_3D();
{    3d сцена     }

    glPopMatrix;
glPopMatrix;
end;


procedure DrawFrameScene(W,H:Integer);
var t,I:integer;
begin
  glViewport(0, 0,  MGEW, MGEH); //выделяем область куда будет выводиться наш буфер
  glMatrixMode ( GL_PROJECTION ); //переходим в матрицу проекции
  glLoadIdentity;  //сбрасываем текущую матрицу
  gluPerspective(40, FMW/ FMH,1,10000); //Область видимости
  glMatrixMode ( GL_MODELVIEW ); //переходим в модельную матрицу
  glLoadIdentity;//сбрасываем текущую матрицу

  glBindFramebufferEXT ( GL_FRAMEBUFFER_EXT ,  fbo ) ;
  glPushAttrib ( GL_VIEWPORT_BIT ) ;
  glViewPort ( 0 ,  0 ,  FMW ,  FMH ) ;

  glClearColor(0.1, 0.1, 0.1, 0.0); // цвет фона
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); // очистка буфера цвета
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_NORMALIZE);
  glShadeModel(GL_SMOOTH);
  glLightfv(GL_LIGHT0, GL_POSITION, @glLightPos);
  glLightfv(GL_LIGHT0,GL_EMISSION ,@light0_diffuse);


  glLightfv(GL_LIGHT1, GL_POSITION, @glLightPos1);



  //glmaterialf ( GL_FRONT_AND_BACK ,GL_SHININESS, 1);

  glPushMatrix;
  GluLookAt(P.p.X,P.p.Y,250,   MIRX,P.p.Y,-150,0,1,0);




{    3d сцена     }

   if MenuStay=0 then   begin
   ELight();

   end;




  R3D_To_2D(W, H);
{    2d сцена     }
{ все объекты рисуются с заднего плана на передний  }
    DLight();
    GUICursor.state;
   if MenuStay=0 then   begin
     Commande:=false;
   end else
   begin
     Commande:=true;
   end;
   MenuN[10].posx:=100;
   MenuN[10].posy:=100;
   MenuN[10].text:='intensive'+FloatToStr(INL);
   MenuN[10].Draw;
   RenderSprite(MGEW/2,MGEH/2,MGEW/2,MGEH/2,0,Ttextobj[5]);
   Fir.FDraw(MGEW*0.31,MGEH*0.51,MGEH*0.2,MGEH*0.2);
   RenderSprite(MGEW/2,MGEH/2,MGEW/2,MGEH/2,0,Ttextobj[6]);

   case MenuStay of
   1:begin
     //MenuMap.Draw;
     MenuN[0].Draw;
     for I := 0 to 3 do  begin

      MenuS[I].s.y:=(MGEH/30);
      MenuS[I].s.x:=(MGEW*0.2);
      if (Menus[I].State=1) then MenuS[I].s.x:=(MGEW*0.22);
      MenuS[I].p.x:=MGEW/10;
      MenuS[I].p.y:=MGEH-(MGEH/20)*(7-I);
      MenuS[I].Aktivate(GUICursor);
     end;
     if (Menus[0].State=2) then MenuStay:=0;
     if (Menus[1].State=2) then MenuStay:=2;
     if (Menus[2].State=2) then MenuStay:=3;
     if (Menus[3].State=2) then MenuStay:=100;

   end;
   2:begin
     //MenuMap.Draw;
     MenuN[2].Draw;
     for I := 6 to 8 do  begin
     MenuS[I].s.y:=(MGEH/30);
     MenuS[I].s.x:=(MGEW/3);

     MenuS[I].p.x:=MGEW/10;
     MenuS[I].p.y:=MGEH-(MGEH/20)*(13-I);
     MenuS[I].Aktivate(GUICursor);
     end;
     if (Menus[6].State=2) then MenuStay:=50;
     if (Menus[7].State=2) then MenuStay:=51;
     if (Menus[8].State=2) then MenuStay:=1;
   end;
    3:begin
    // MenuMap.Draw;
     MenuN[3].Draw;
     I:=9;
     MenuS[I].s.y:=(MGEH/30);
     MenuS[I].s.x:=(MGEW/3);
     MenuS[I].p.x:=MGEW/10;
     MenuS[I].p.y:=MGEH-(MGEH/20)*(11-I);
     MenuS[I].Aktivate(GUICursor);
     if (Menus[9].State=2) then MenuStay:=1;
    end;
     50: begin
      Form1.BorderStyle:=bsNone;
      Form1.WindowState:=wsMaximized;
      MenuStay:=2;
     end;

     51:begin
      Form1.BorderStyle:=bsSizeable;
      Form1.WindowState:=wsNormal;
      Form1.Width:=FMW;
      Form1.Height:=FMH;
      MenuStay:=2;
     end;

   end;

   if MenuStay<>0 then begin

     //GUICursor.draw;
   end else
   begin

   end;


   DLight();

  // Fir.FDraw(100,100,20,20);





  R2D_To_3D();
{    3d сцена     }

    glPopMatrix;

  glPopAttrib ;
  glBindFramebufferEXT ( GL_FRAMEBUFFER_EXT ,  0 ) ;

end;



end.
