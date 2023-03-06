unit Phisics;

interface
uses
  Variants, windows, Classes, Graphics,SysUtils, Controls,Forms, Dialogs, DglOpenGL, Textures,
  mesh, Math, ResCon, Scripter, Controller;

 Type
  _P2D=MGEPoint2D;
  _P3D=MGEPoint3D;

  MGE3DVec=record
    N:_P3D;
    I:real;
  end;
  MGEPTriangle=record
    P:Array[0..2] of _P3D;
    T:Array[0..5] of GLFloat;
    A,B,C,D:real;
    Mathing:boolean;
    public
      procedure SetTriangle(x1,y1,z1,x2,y2,z2,x3,y3,z3:GLFloat);
      procedure SetTexCoord(t1,t2,t3,t4,t5,t6:GLFloat);
      procedure Draw(Texture:GLUint);
  end;
  MGEPSphere=record
    P,V,Rot:_P3D;
    PR,speed:real;
    check,put:integer;
    public
      procedure SetSphere(px,py,pz,vx,vy,vz,sp,r:real);
      procedure Update();
  end;
  MGEPCollider=record
    P:_P3D;
    PR,PH:real;
    public
      procedure SetCollider(px,py,pz,r,h:real);
  end;
  MGEPBBox=record
    P,S:_P3D;
    public
      procedure SetBox(px,py,pz,sx,sy,sz:real);
  end;
  MGEPPlane=record
    x,y,z:array[0..1] of real;
    p:array[0..5] of real;
    vg:byte;
    visible:boolean;
    TID:GLUint;
   public
    procedure SetPlane(x1,x2,y1,y2,z1,z2:real;ty:byte);
    procedure SetRotPlane(x1,y1,y2,z1,d,r:real;ty:byte);
    procedure DrawPlane();
  end;
  MGEСharacter = record
    p,ppred,s,d,r:MGEPoint3D;
    dt:MGE3DVec;
    Health,PerI:integer;
    Pl1,Pl2:MGEPSphere;
    AngleX,AngleY,AngleZ,Speed:real;
    FizCheched:Integer;
    EAn:boolean;
    public
    procedure Create(CP,CS,CD:MGEPoint3D; PovX, MySpeed:real);
    procedure UpdateP(ASp:array of MGEPSphere; APl,AFence:array of MGEPPlane;Poligs:array of MGEPTriangle; PovX:real; KW,KA,KS,KD,Ksp:boolean);
  end;


  MGEVehicle = record
    p,ppred,s,d,Wn1,CamIn:MGEPoint3D;
    dt:MGE3DVec;
    Health,PerI:integer;
    AngleX,AngleY,AngleZ,AYK,Speed,MSpeed,ARMS,MUsk:real;
    Live:boolean;
    Per:String;
    weel,weelg: array[0..3] of MGEPSphere;
    wm: array[0..3] of real;
    MCP: array[0..2] of MGEPSphere;
    KJ,WeelRot,WS,CarS,CarVS: real; ///// 0.2
    DFront,DBack,DFW,DBW,DistToTrig:real;
    FizCheched:Integer;
    public
    procedure Create(CP,CS,CD:MGEPoint3D; CDFront,CDBack,CDFW,CDBW,WeelSize,CarSize,CarSdvig,UX,MaxSpeed:real);
    procedure UpdateP(ASp:array of MGEPSphere; APl,AFence:array of MGEPPlane;Poligs:array of MGEPTriangle; KW,KA,KS,KD,Ksp:boolean);
  end;




      function CheckPlayerInBox(B:MGEPBBox; Pl:MGEPlayer):boolean;
      function CollisionPlayer(Pl:MGEPlayer):MGEPlayer;

      function CTSpInSp(var MSph,PSph:MGEPSphere):MGE3DVec;
      procedure CDSpInSp(var MSph,PSph:MGEPSphere; ResTest:MGE3DVec; M1,M2:boolean);


      function CTSpInTrian(var MSph:MGEPSphere; XTrian:MGEPTriangle):real;
      function CDSpInTrian(MSph:MGEPSphere; XTrian:MGEPTriangle; text:real):MGEPSphere;

      function CTSpInPlane(var MSph:MGEPSphere; Xplane:MGEPPlane):real;
      function CDSpInPlane(MSph:MGEPSphere; Xplane:MGEPPlane; text:real):MGEPSphere;
      function CDSpInFence(MSph:MGEPSphere; Xplane:MGEPPlane; text:real; var SpD,SverX:real):MGEPSphere;



implementation


function CTSpInSp(var MSph,PSph:MGEPSphere):MGE3DVec;
var AX,AY,AZ,D:real;
    ResV:MGE3DVec;
begin
   AX:=MSph.P.x-PSph.P.x;
   AY:=MSph.P.y-PSph.P.y;
   AZ:=MSph.P.z-PSph.P.z;
   D:=sqrt(sqr(AX)+sqr(AY)+sqr(AZ));
   ResV.N.SetP(AX/D,AY/D,AZ/D);
   ResV.I:=D;
   Result:=ResV;
end;
procedure CDSpInSp(var MSph,PSph:MGEPSphere; ResTest:MGE3DVec; M1,M2:boolean);
  var G,N:integer;
      DMax:real;
begin
  DMax:=Msph.PR+Psph.PR;
  G:=0;
  if (M1=true) and (M2=true) and (DMax>ResTest.I)  then  G:=1;
  if (M1=true) and (M2=false) and (DMax>ResTest.I) then  G:=2;
  if (M1=false) and (M2=true) and (DMax>ResTest.I) then  G:=3;
  case G of
    1:  begin
          MSph.P.SetP(MSph.P.x+ResTest.N.x*(DMax-ResTest.I)/2,MSph.P.y+ResTest.N.y*(DMax-ResTest.I)/2,MSph.p.Z+ResTest.N.z*(DMax-ResTest.I)/2);
          PSph.P.SetP(PSph.P.x-ResTest.N.x*(DMax-ResTest.I)/2,PSph.P.y-ResTest.N.y*(DMax-ResTest.I)/2,PSph.p.Z-ResTest.N.z*(DMax-ResTest.I)/2);
    end;
    2:  begin
          MSph.P.SetP(MSph.P.x+ResTest.N.x*(DMax-ResTest.I),MSph.P.y+ResTest.N.y*(DMax-ResTest.I),MSph.p.Z+ResTest.N.z*(DMax-ResTest.I));
    end;
    3:  begin
          PSph.P.SetP(PSph.P.x-ResTest.N.x*(DMax-ResTest.I),PSph.P.y-ResTest.N.y*(DMax-ResTest.I),PSph.p.Z-ResTest.N.z*(DMax-ResTest.I));
    end;
  end;
end;
function CTSpInPlane(var MSph:MGEPSphere; Xplane:MGEPPlane):real;
var
  a,b,c,s,h,d:real;
begin
  case Xplane.vg of
    0: begin     ////// Панель повернутая по оси Z
      a:=sqr(MSph.P.z-Xplane.z[0])+sqr(MSph.P.y-Xplane.y[0]);
      b:=sqr(MSph.P.z-Xplane.z[1])+sqr(MSph.P.y-Xplane.y[1]);
      c:=sqr(Xplane.z[1]-Xplane.z[0])+sqr(Xplane.y[1]-Xplane.y[0]);
      s:=((MSph.P.z-Xplane.z[1])*(Xplane.y[0]-Xplane.y[1])-(Xplane.z[0]-Xplane.z[1])*(MSph.P.y-Xplane.y[1]))/2;
      h:=2*s/sqrt(c);
      //MSph.V.y:=(Xplane.y[1]-Xplane.y[0])/sqrt(c)*MSph.speed;

    end;
    1: begin    ////// Панель повернутая по оси X
      a:=sqr(MSph.P.x-Xplane.x[0])+sqr(MSph.P.y-Xplane.y[0]);
      b:=sqr(MSph.P.x-Xplane.x[1])+sqr(MSph.P.y-Xplane.y[1]);
      c:=sqr(Xplane.x[1]-Xplane.x[0])+sqr(Xplane.y[1]-Xplane.y[0]);
      s:=((MSph.P.x-Xplane.x[1])*(Xplane.y[0]-Xplane.y[1])-(Xplane.x[0]-Xplane.x[1])*(MSph.P.y-Xplane.y[1]))/2;
      h:=2*s/sqrt(c);
      //MSph.V.y:=(Xplane.y[1]-Xplane.y[0])/sqrt(c)*MSph.speed;
    end;
    2: begin     /////  Панель повернутая по оси Y
      a:=sqr(MSph.P.x-Xplane.x[0])+sqr(MSph.P.z-Xplane.z[0]);
      b:=sqr(MSph.P.x-Xplane.x[1])+sqr(MSph.P.z-Xplane.z[1]);
      c:=sqr(Xplane.x[1]-Xplane.x[0])+sqr(Xplane.z[1]-Xplane.z[0]);
      s:=((MSph.P.x-Xplane.x[1])*(Xplane.z[0]-Xplane.z[1])-(Xplane.x[0]-Xplane.x[1])*(MSph.P.z-Xplane.z[1]))/2;
      h:=2*s/sqrt(c);
      
    end;
  end;

  result:=h; ////// Расстояние до панели
end;
function CDSpInPlane(MSph:MGEPSphere; Xplane:MGEPPlane; text:real):MGEPSphere;
var
  pdx,pdz:boolean;
  nsp:MGEPSphere;
  dist,TC:real;
begin
    ////////// Определение новой позиции сферы относительно горизонтальных панелей
  nsp:=msph;
  if (MSph.P.x>Xplane.x[0]) and (MSph.P.x<=Xplane.x[1]) then pdx:=true else pdx:=false;
  if (MSph.P.Z>Xplane.Z[0]) and (MSph.P.Z<=Xplane.Z[1]) then pdz:=true else pdz:=false;
  if (pdx=true) and (pdz=true) then
    begin
       dist:=text;
       TC:=(dist-Msph.PR);
       if (TC<Msph.PR) and (TC>-Msph.PR*8) then begin
          Nsp.P.Y:=Msph.P.y-TC+(Msph.PR*0.5);
          inc(Nsp.check);
       end;
      { dist:=text;
       TC:=-(dist-Msph.PR);
       if (TC<Msph.PR*2)  then begin
       Nsp.P.Y:=Msph.P.y-TC+(Msph.PR*1.9);
          inc(Nsp.check);
       end;     }

    end;
result:=Nsp;
end;

function MathMatrix(A,B:_P3D):_P3D;
var TemN:_P3D;
    TX,TY,TZ:real;
begin
    TX:=(A.y*B.z)-(A.z*B.y);
    TY:=(A.z*B.x)-(A.x*B.z);
    TZ:=(A.x*B.y)-(A.y*B.x);
    TemN.SetP(TX,TY,TZ);
    result:=TemN;
end;
function CTSpInTrian(var MSph:MGEPSphere; XTrian:MGEPTriangle):real;
var M1M2,M1M3,N:_P3D;
    Dist:real;
begin
  if XTrian.Mathing=false then begin
     M1M2.SetP(XTrian.p[1].x-XTrian.p[0].x,XTrian.p[1].y-XTrian.p[0].y,
        XTrian.p[1].z-XTrian.p[0].z);
     M1M3.SetP(XTrian.p[2].x-XTrian.p[0].x,XTrian.p[2].y-XTrian.p[0].y,
        XTrian.p[2].z-XTrian.p[0].z);
     N:=MathMatrix(M1M2,M1M3);
     XTrian.A:=N.x;
     XTrian.B:=N.y;
     XTrian.C:=N.z;
     XTrian.D:=(N.x*(-XTrian.p[0].x))+(N.y*(-XTrian.p[0].y))+
        (N.z*(-XTrian.p[0].z));
     XTrian.Mathing:=true;
  end;
  Dist:=((XTrian.A*MSph.P.x)+(XTrian.B*MSph.P.y)+(XTrian.C*MSph.P.z)+XTrian.D)/
///D =  __________________________________________________________________________
                sqrt(sqr(XTrian.A)+sqr(XTrian.B)+sqr(XTrian.C));
Result:=Dist;
end;
function CheckTriangle2D(MSph:MGEPSphere; XTrian:MGEPTriangle):boolean;
  var x1,y1,x2,y2,x3,y3,tx,ty:real;
begin
  x1:=XTrian.p[0].x;
  y1:=XTrian.p[0].z;
  x2:=XTrian.p[1].x;
  y2:=XTrian.p[1].z;
  x3:=XTrian.p[2].x;
  y3:=XTrian.p[2].z;
  tx:=MSph.P.x;
  ty:=MSph.P.z;
  if((tx-x1)*(y1-y2)-(ty-y1)*(x1-x2)>=0)
  and((tx-x2)*(y2-y3)-(ty-y2)*(x2-x3)>=0)
  and((tx-x3)*(y3-y1)-(ty-y3)*(x3-x1)>=0) then
  result:=true else result:=false;
end;
function CDSpInTrian(MSph:MGEPSphere; XTrian:MGEPTriangle; text:real):MGEPSphere;
var
  nsp:MGEPSphere;
  dist,TC:real;
begin
  nsp:=msph;
   if CheckTriangle2D(MSph,XTrian)=true then begin
       dist:=text;
       TC:=-(dist-Msph.PR);
       if (TC<Msph.PR*2) and (TC>-Msph.PR*10)  then begin
       Nsp.P.Y:=Msph.P.y-TC+(Msph.PR*1.9);
          inc(Nsp.check);
       end;
   end;
result:=Nsp;
end;

function CDSpInFence(MSph:MGEPSphere; Xplane:MGEPPlane; text:real; var SpD,SverX:real):MGEPSphere;
var
  pdx,pdy,sl:boolean;
  nsp:MGEPSphere;
  hdx,hdz:real;
  SrP,d,dt:MGEPoint3D;
  dist,gip,ining:real;
  ed:integer;
begin
    ///////// Определение новой позиции сферы относительно вертикальных панелей
   nsp:=msph;
   gip:=sqrt(sqr(Xplane.x[0]-Xplane.x[1])+ sqr(Xplane.z[0]-Xplane.z[1]));
   hdx:=(Xplane.x[0]-Xplane.x[1])/gip;
   hdz:=(Xplane.z[0]-Xplane.z[1])/gip;
   Srp.x:=(Xplane.x[0]+Xplane.x[1])/2;
   Srp.z:=(Xplane.z[0]+Xplane.z[1])/2;
   //if (hdx>=hdz) then sl:=true else sl:=false;
   if (MSph.P.Y>Xplane.Y[0]-MSph.PR) and (MSph.P.Y<=Xplane.Y[1]+MSph.PR) then pdy:=true else pdy:=false;
   ining:=Sqrt(sqr((Srp.x-MSph.P.x))+sqr((Srp.z-MSph.P.z)));

     // d.x:= -Sin(SverX/180*Pi);
      //d.z:= -cos(SverX/180*Pi);
      //dt.x:=(hdx+d.x)/2;
      //dt.z:=(hdz+d.z)/2;
      SverX:=0;
  if (ining<gip/2+Msph.PR) and (pdy=true) then
    begin
       dist:=text;
       if dist<0 then ed:=-1 else ed:=1;
       if (abs(dist)<=Msph.PR*2) and (abs(dist)>-Msph.PR*2) then begin
          Nsp.P.X:=Msph.P.X+ed*hdz*(Msph.PR*2-abs(dist));
          Nsp.P.Z:=Msph.P.Z-ed*hdx*(Msph.PR*2-abs(dist));

        SverX:=10;
       end;
    end;
result:=Nsp;
end;
procedure MGEPPlane.SetPlane(x1: real; x2: real; y1: real; y2: real; z1: real; z2: real; ty:byte);
begin
  x[0]:=x1;  x[1]:=x2;
  y[0]:=y1;  y[1]:=y2;
  z[0]:=z1;  z[1]:=z2;
  p[0]:=x1;  p[1]:=x2;
  p[2]:=y1;  p[3]:=y2;
  p[4]:=z1;  p[5]:=z2;
  vg:=ty;
end;
procedure MGEPPlane.SetRotPlane(x1,y1,y2,z1,d,r:real;ty:byte);
begin
  x[0]:=x1;  x[1]:=x[0]+d*cos(r*pi/180);
  y[0]:=y1;  y[1]:=y2;
  z[0]:=z1;  z[1]:=z[0]+d*sin(r*pi/180);
  p[0]:=x[0];  p[1]:=x[1];
  p[2]:=y[0];  p[3]:=y[1];
  p[4]:=z[0];  p[5]:=z[1];
  vg:=ty;
end;
procedure MGEPTriangle.SetTexCoord(t1: Single; t2: Single; t3: Single; t4: Single; t5: Single; t6: Single);
begin
  t[0]:=t1;
  t[1]:=t2;
  t[2]:=t3;
  t[3]:=t4;
  t[4]:=t5;
  t[5]:=t6;
end;
procedure MGEPTriangle.Draw(Texture: GLUint);
begin
glPushMatrix;
glBindTexture(GL_TEXTURE_2D, Texture);
glBegin(GL_TRIANGLES);
    glNormal3f( 1.0, 1.0, 1.0);
    glTexCoord2f(t[0], t[1]); glVertex3f(p[0].x, p[0].y,  p[0].z);
    glTexCoord2f(t[2], t[3]); glVertex3f(p[1].x, p[1].y,  p[1].z);
    glTexCoord2f(t[4], t[5]); glVertex3f(p[2].x,  p[2].y,  p[2].z);
   glEnd;
glPopMatrix;
end;

procedure MGEPPlane.DrawPlane();
var
  nox,noy,noz,nod:real;
begin
glPushMatrix;
case vg of
 2:  begin
    nod:=sqrt(sqr(x[0]-x[1])+sqr(z[0]-z[1]));
    noz:=abs(x[0]-x[1])/nod;
    nox:=abs(z[0]-z[1])/nod;
 end;
 1:  glNormal3f( 0.0, 1.0, 0.0);
 0:  glNormal3f( 0.0, 1.0, 0.0);
end;
glBindTexture(GL_TEXTURE_2D, TID);
glBegin(GL_QUADS);
case vg of
 2: begin
     glNormal3f( nox, 0.0, noz);
    glTexCoord2f(0.0, 1.0); glVertex3f(x[1], y[1],  z[1]);
    glTexCoord2f(-1.0, 1.0); glVertex3f(x[0], y[1],  z[0]);
    glTexCoord2f(-1.0, 0.0); glVertex3f(x[0],  y[0],  z[0]);
    glTexCoord2f(0.0, 0.0); glVertex3f(x[1],  y[0],  z[1]);
 end;
 1: begin
    glTexCoord2f(0.0, 0.0); glVertex3f(x[1], y[1],  z[1]);
    glTexCoord2f(-1.0, 0.0); glVertex3f(x[0], y[0],  z[1]);
    glTexCoord2f(-1.0, 1.0); glVertex3f(x[0],  y[0],  z[0]);
    glTexCoord2f(0.0, 1.0); glVertex3f(x[1],  y[1],  z[0]);
 end;
 0: begin
    glTexCoord2f(0.0, 0.0); glVertex3f(x[1], y[1],  z[1]);
    glTexCoord2f(-1.0, 0.0); glVertex3f(x[0], y[1],  z[1]);
    glTexCoord2f(-1.0, 1.0); glVertex3f(x[0],  y[0],  z[0]);
    glTexCoord2f(0.0, 1.0); glVertex3f(x[1],  y[0],  z[0]);
 end;
end;
   glEnd;
glPopMatrix;
end;
procedure MGEPBBox.    SetBox(px: Real; py: Real; pz: Real; sx: Real; sy: Real; sz: Real);
begin
  p.x:=px; p.y:=py; p.z:=pz;
  s.x:=sx; s.y:=sy; s.z:=sz;
end;
procedure MGEPSphere.  SetSphere(px: Real; py: Real; pz: Real; vx,vy,vz,sp, r: Real);
begin
  p.x:=px;  p.y:=py;  p.z:=pz;
  v.x:=vx;  v.y:=vy;  v.z:=vz;
  PR:=R;
  speed:=sp;
end;
procedure MGEPSphere.Update;
begin
  p.x:=p.x+v.x*speed;
  p.y:=p.y+v.y*speed;
  p.z:=p.z+v.z*speed;
end;
procedure MGEPCollider.SetCollider(px: Real; py: Real; pz: Real; r: Real; h: Real);
begin
  p.x:=px;  p.y:=py;  p.z:=pz;
  PR:=R;PH:=H;
end;
function CheckPlayerInBox(B:MGEPBBox; Pl: MGEPlayer):boolean;
begin
if (B.P.x+B.S.x>pl.p.x) and  (B.P.x-B.S.x<pl.p.x) and
    (B.P.z+B.S.z>pl.p.z)  and   (B.P.z-B.S.z<pl.p.z) and
      (B.P.y+B.S.y>pl.p.y)  and   (B.P.y-B.S.y<pl.p.y) then result:=true else
      result:=false;

end;
function CollisionPlayer(Pl: MGEPlayer):MGEPlayer;
begin

end;
procedure MGEPTriangle.SetTriangle(x1: Single; y1: Single; z1: Single; x2: Single; y2: Single; z2: Single; x3: Single; y3: Single; z3: Single);
begin
  P[0].SetP(x1,y1,z1);
  P[1].SetP(x2,y2,z2);
  P[2].SetP(x3,y3,z3);
end;

procedure MGEСharacter.Create(CP: MGEpoint3D; CS: MGEpoint3D; CD: MGEpoint3D; PovX, MySpeed: Real);
begin
  P:=CP; S:=CS; R:=CD;
  Speed:=MySpeed; AngleX:=PovX;
  PL1.SetSphere(P.x,P.y,P.z,0,0,0,0,S.x*20);

end;

procedure MGEСharacter.UpdateP(ASp: array of MGEPSphere; APl: array of MGEPPlane; AFence: array of MGEPPlane; Poligs: array of MGEPTriangle; PovX: Real; KW: Boolean; KA: Boolean; KS: Boolean; KD: Boolean; Ksp: Boolean);
var I,N,L,K,PP,PS,PF,PL:integer;
    SrSp:MGEPSphere;
    TempAngle1,AYK,RSP:real;
    TempVec,TempVec1,TempVec2,TempVecX,TempVecY:MGE3DVec;
begin
  EAn:=false;
  RSP:=0;
  Speed:=0;
  if KW<>false  then  begin
    Speed:=0.04;
    EAn:=true;
    RSP:=Speed;
  end;
  if KS<>false  then  begin
    Speed:=-0.04;
    EAn:=true;
    RSP:=Speed;
  end;
  if (KD<>false)  then begin
  AngleX:=AngleX-2;
  end;
  if (KA<>false)  then begin
  AngleX:=AngleX+2;
  end;
  if Ksp<>false then  begin
  end;
  
      AYK:=cos(AngleY/180*Pi);
      d.x:= -Sin(angleX/180*Pi)*RSP*AYK;
      d.y:= Sin(angleY/180*Pi)*RSP;
      d.z:= -cos(angleX/180*Pi)*RSP*AYK;

  PP:=Length(Apl);
  PS:=Length(Asp);
  PF:=Length(AFence);
  PL:=Length(Poligs);

      Pl1.Speed:= RSP;
      Pl1.v.x:= -Sin(angleX/180*Pi)*Pl1.Speed*AYK;
      Pl1.v.y:= Sin(angleY/180*Pi)*Pl1.Speed;
      Pl1.v.z:= -cos(angleX/180*Pi)*Pl1.Speed*AYK;

        Pl1.check:=0;
        if PS>0 then for L := 0 to PS - 1 do CDSpInSp(Pl1,Asp[L],CTSpInSp(Pl1,Asp[L]),true,true);
        if PP>0 then for L := 0 to PP - 1 do Pl1:=CDSpInPlane(Pl1,APl[L],CTSpInPlane(Pl1,APl[L]));
        if PF>0 then for L := 0 to PF - 1 do Pl1:=CDSpInFence(Pl1,AFence[L],CTSpInPlane(Pl1,AFence[L]),Pl1.Speed,Pl1.Rot.x);
        if PL>0 then for L := 0 to PL - 1 do Pl1:=CDSpInTrian(Pl1,Poligs[L],CTSpInTrian(Pl1,Poligs[L]));


    if (Pl1.check>0) then begin if (Pl1.v.y<-1) then Pl1.v.y:=Pl1.v.y/2 else Pl1.v.y:=0+Sin(angleY/180*Pi)*Pl1.Speed; end;
          FizCheched:=FizCheched+Pl1.check;

        Pl1.check:=0;
        if (Pl1.v.y>-5) and (Pl1.p.y>-2000) then Pl1.v.y:=Pl1.v.y-0.04;
        if (Pl1.p.y+Pl1.v.y<-2000) then Pl1.v.y:=abs(Pl1.v.y)*0.2;
        Pl1.p.Y:=Pl1.p.Y+Pl1.v.y*16;

        Pl1.p.X:=Pl1.p.X+Pl1.v.x*4;
        {Работа инерции персонажа в движке}
        Pl1.p.Z:=Pl1.p.Z+Pl1.v.z*4;
        If (abs(Pl1.v.x)>0.001) then Pl1.v.x:=Pl1.v.x*0.92;
        If (abs(Pl1.v.z)>0.001) then Pl1.v.z:=Pl1.v.z*0.92;
        If (abs(Pl1.v.x)<=0.001) then Pl1.v.x:=0;
        If (abs(Pl1.v.z)<=0.001) then Pl1.v.z:=0;



end;


procedure MGEVehicle.Create(CP,CS,CD:MGEPoint3D; CDFront,CDBack,CDFW,CDBW,WeelSize,CarSize,CarSdvig,UX,MaxSpeed:real);
begin
  P:=CP; S:=CS; D:=CD;
  DFront:=CDFront;
  DBack:= CDBack;
  DFW:= CDFW;
  DBW:= CDBW;
  WS:=WeelSize;
  CarS:=CarSize;
  CarVS:=CarSdvig;
  MUsk:=Ux;
  Health:=100;AngleX:=0;AngleY:=0;Live:=true;

  MCP[0].SetSphere(P.x+sin((AngleX+180)/180*Pi)*S.x,
  P.y,P.z+cos((angleX+180)/180*Pi)*S.x,0,0,0,0,S.x*0.7);
  MCP[1].SetSphere(P.x,P.y,P.z,0,0,0,0,S.x);
  MCP[2].SetSphere(P.x+sin((AngleX)/180*Pi)*S.x,
  P.y,P.z+cos((angleX)/180*Pi)*S.x,0,0,0,0,S.x*0.7);

  weel[0].SetSphere(MCP[0].P.x+sin((AngleX+90)/180*Pi)*CDFW,
    MCP[0].P.y,MCP[0].P.z+cos((AngleX+90)/180*Pi)*CDFW,0,0,0,0,WS);

  weel[1].SetSphere(MCP[0].P.x+sin((AngleX-90)/180*Pi)*CDFW,
    MCP[0].P.y,MCP[0].P.z+cos((AngleX-90)/180*Pi)*CDFW,0,0,0,0,WS);

  weel[2].SetSphere(MCP[2].P.x+sin((AngleX+90)/180*Pi)*CDBW,
    MCP[2].P.y,MCP[2].P.z+cos((AngleX+90)/180*Pi)*CDBW,0,0,0,0,WS);

  weel[3].SetSphere(MCP[2].P.x+sin((AngleX-90)/180*Pi)*CDBW,
    MCP[2].P.y,MCP[2].P.z+cos((AngleX-90)/180*Pi)*CDBW,0,0,0,0,WS);

  MSpeed:=MaxSpeed/200;
end;
procedure MGEVehicle.UpdateP(ASp:array of MGEPSphere; APl,AFence:array of MGEPPlane; Poligs:array of MGEPTriangle; KW,KA,KS,KD,Ksp:boolean);
var I,N,L,K,PP,PS,PF,PL,TWF:integer;
    SrSp:MGEPSphere;
    PerP,ZadP,Wv1,Wv2,Wn2:MGEPoint3D;
    TempAngle1,TempAngle2,D1,D2,TS:real;
    TempVec,TempVec1,TempVec2,TempVecX,TempVecY:MGE3DVec;
begin

  //if Speed-(MSpeed/6)<(MSpeed/5)*PerI then PerI:=PerI-1;
  //if Speed-(MSpeed/6)>(MSpeed/5)*PerI then PerI:=PerI+1;
  if PerI>0 then Per:=IntTostr(PerI) else Per:='N';
  if Speed<0 then Per:='R';

    if (PerI=0) and (Speed>0) then PerI:=1;
    if (Speed<=0) then PerI:=0;

     // if  ARMS<(MSpeed/5)*PerI then ARMS:=ARMS+0.02;
     if (ARMS<0.007) and (PerI>1) and (KW=false) then begin
         PerI:=PerI-1;
         ARMS:=0.01;
      end;
     if (ARMS>0.010) and (PerI<5) and (KW=true) then begin
         PerI:=PerI+1;
         ARMS:=0.008;
      end;

    if ARMS>=0.015 then ARMS:=0.014;
    if (ARMS>0.001) then ARMS:=ARMS-0.00007;

    if (MCP[0].Speed<MSpeed*0.8) then PerI:=4;
    if (MCP[0].Speed<MSpeed*0.5) then PerI:=3;
    if (MCP[0].Speed<MSpeed*0.3) then PerI:=2;
    if (MCP[0].Speed<MSpeed*0.2) then PerI:=1;
if FizCheched>0 then  begin
    if abs(MCP[0].Speed)>0.002 then MCP[0].Speed:=MCP[0].Speed*0.995;  if abs(MCP[0].Speed)<=0.002 then MCP[0].Speed:=0;
     Speed:=  MCP[0].Speed;

  if KW<>false  then  begin
    if (ARMS<0.015) and (PerI<=5) and (PerI>1) then  ARMS:=ARMS+MUsk*0.00005;
    if (ARMS<0.015) and (PerI<=5) and (PerI<=1) then  ARMS:=ARMS+MUsk*0.0001;

   { if MCP[0].Speed<0.002 then MCP[0].Speed:=0.003; } if MCP[0].Speed<MSpeed then begin MCP[0].Speed:=MCP[0].Speed+ARMS/2;
    end;

  end;


  if KS<>false  then  begin  if MCP[0].Speed>-0.003 then MCP[0].Speed:=MCP[0].Speed-0.007;
    If MCP[0].Speed>-0.23 then MCP[0].Speed:=MCP[0].Speed-0.002;
  //if (ARMS>0.001) then ARMS:=ARMS-0.0005;
  end;
  if Ksp<>false then  begin  if abs(MCP[0].Speed)>0.002 then begin MCP[0].Speed:=MCP[0].Speed*0.95;
    PerI:=PerI-1;
  end;


  if MCP[0].Speed>0 then AngleX:=AngleX+(WeelRot*9)*((MCP[0].Speed)/2);  end;
  //if (ARMS>0.001) then ARMS:=ARMS-0.0005;
end;
      AYK:=cos(AngleY/180*Pi);
      d.x:= -Sin(angleX/180*Pi)*MCP[0].Speed*AYK;
      d.y:= Sin(angleY/180*Pi)*MCP[0].Speed;
      d.z:= -cos(angleX/180*Pi)*MCP[0].Speed*AYK;

  if abs(WeelRot)>1 then MCP[0].Speed:=MCP[0].Speed*(abs(WeelRot)/abs(WeelRot*1.005));
  if abs(WeelRot)>0.04 then begin WeelRot:=WeelRot*(0.96/(1/1+abs(MCP[0].Speed)*0.11)); end;
  if abs(WeelRot)<=0.04 then WeelRot:=0;

  if (KD<>false)  then WeelRot:=WeelRot-0.2;
  if (KA<>false)  then WeelRot:=WeelRot+0.2;

if FizCheched>0 then  begin
  AngleX:=AngleX+(WeelRot*7)*((MCP[0].Speed)/2);
end;
  FizCheched:=0;


  PP:=Length(Apl);
  PS:=Length(Asp);
  PF:=Length(AFence);
  PL:=Length(Poligs);
      MCP[0].v.x:= -Sin(angleX/180*Pi)*MCP[0].Speed*AYK;
      MCP[0].v.y:= Sin(angleY/180*Pi)*MCP[0].Speed/2;
      MCP[0].v.z:= -cos(angleX/180*Pi)*MCP[0].Speed*AYK;

    for I := 0 to 2 do begin
      MCP[I].Speed:= MCP[0].Speed;
      MCP[I].v.x:= -Sin(angleX/180*Pi)*MCP[I].Speed*AYK;
      MCP[I].v.y:= Sin(angleY/180*Pi)*MCP[I].Speed;
      MCP[I].v.z:= -cos(angleX/180*Pi)*MCP[I].Speed*AYK;

        MCP[I].check:=0;
        if PS>0 then for L := 0 to PS - 1 do CDSpInSp(MCP[I],Asp[L],CTSpInSp(MCP[I],Asp[L]),true,true);
        if PP>0 then for L := 0 to PP - 1 do MCP[I]:=CDSpInPlane(MCP[I],APl[L],CTSpInPlane(MCP[I],APl[L]));
        if PF>0 then for L := 0 to PF - 1 do MCP[I]:=CDSpInFence(MCP[I],AFence[L],CTSpInPlane(MCP[I],AFence[L]),MCP[0].Speed,TS);
        if PL>0 then for L := 0 to PL - 1 do MCP[I]:=CDSpInTrian(MCP[I],Poligs[L],CTSpInTrian(MCP[I],Poligs[L]));


    if (MCP[I].check>0) then begin if (MCP[I].v.y<-1) then MCP[I].v.y:=MCP[I].v.y/2 else MCP[I].v.y:=0+Sin(angleY/180*Pi)*MCP[0].Speed; end;
          FizCheched:=FizCheched+MCP[I].check;

        MCP[I].check:=0;
        if (MCP[I].v.y>-5) and (MCP[I].p.y>-2000) then MCP[I].v.y:=MCP[I].v.y-0.04;
        if (MCP[I].p.y+MCP[I].v.y<-2000) then MCP[I].v.y:=abs(MCP[I].v.y)*0.2;
        MCP[I].p.Y:=MCP[I].p.Y+MCP[I].v.y*4;

        MCP[I].p.X:=MCP[I].p.X+MCP[I].v.x*4;
        {Работа инерции персонажа в движке}
        MCP[I].p.Z:=MCP[I].p.Z+MCP[I].v.z*4;
        If (abs(MCP[I].v.x)>0.001) then MCP[I].v.x:=MCP[I].v.x*0.92;
        If (abs(MCP[I].v.z)>0.001) then MCP[I].v.z:=MCP[I].v.z*0.92;
        If (abs(MCP[I].v.x)<=0.001) then MCP[I].v.x:=0;
        If (abs(MCP[I].v.z)<=0.001) then MCP[I].v.z:=0;
       end;
    TWF:=0;
    for I := 0 to 3 do begin
        MCP[I].check:=0;
        if PS>0 then for L := 0 to PS - 1 do CDSpInSp(Weel[I],Asp[L],CTSpInSp(Weel[I],Asp[L]),true,true);
        if PP>0 then for L := 0 to PP - 1 do Weel[I]:=CDSpInPlane(Weel[I],APl[L],CTSpInPlane(Weel[I],APl[L]));
        if PF>0 then for L := 0 to PF - 1 do begin
            Weel[I]:=CDSpInFence(Weel[I],AFence[L],CTSpInPlane(Weel[I],AFence[L]),MCP[0].Speed,TS);
            if (TS>0) and (TWF=0) then begin
              case I of
               0:TWF:=1;
               1:TWF:=2;
               2:TWF:=3;
               3:TWF:=4;
              end;
            end;
        end;

        if PL>0 then for L := 0 to PL - 1 do begin Weel[I]:=CDSpInTrian(Weel[I],Poligs[L],CTSpInTrian(Weel[I],Poligs[L]));
        DistToTrig:=CTSpInTrian(Weel[1],Poligs[L]);
        end;

    WM[i]:=WM[i]+MCP[0].Speed*24;

    if (Weel[I].check>0) then begin
    if (Weel[I].v.y<-1) then Weel[I].v.y:=Weel[I].v.y/2 else Weel[I].v.y:=0+Sin(angleY/180*Pi)*MCP[0].Speed; end;

        FizCheched:=FizCheched+Weel[I].check;
       Weel[I].check:=0;
        if (Weel[I].v.y>-5) and (Weel[I].p.y>-2000) then Weel[I].v.y:=Weel[I].v.y-0.02;
        Weel[I].p.X:=Weel[I].p.X+Weel[I].v.x*4*AYK;
        if (Weel[I].p.y+Weel[I].v.y<-2000) then Weel[I].v.y:=abs(Weel[I].v.y)*0.1;
        {Работа инерции персонажа в движке}
        Weel[I].p.Y:=Weel[I].p.Y+Weel[I].v.y*4;
        Weel[I].p.Z:=Weel[I].p.Z+Weel[I].v.z*4*AYK;
        If (abs(Weel[I].v.x)>0.001) then Weel[I].v.x:=Weel[I].v.x*0.92;
        If (abs(Weel[I].v.z)>0.001) then Weel[I].v.z:=Weel[I].v.z*0.92;
        If (abs(Weel[I].v.x)<=0.001) then Weel[I].v.x:=0;
        If (abs(Weel[I].v.z)<=0.001) then Weel[I].v.z:=0;
       end;
    if PerI>2 then begin
     case TWF of
       1:begin AngleX:=AngleX+20;
         MCP[0].speed:=MCP[0].speed*0.8;
       end;
       2:begin AngleX:=AngleX-20;
         MCP[0].speed:=MCP[0].speed*0.8;
       end;
     end;
    end;



  TempVec:=CTSpInSp(MCP[0],MCP[1]);
  AngleY:=arcsin(TempVec.N.y)*180/pi;
  if AngleY>80 then AngleY:=80;
  if AngleY<-80 then AngleY:=-80;

  AYK:=cos(AngleY/180*Pi);

    If (round(MCP[0].P.x)=round(MCP[1].P.x)) and (round(MCP[0].P.z)=round(MCP[1].P.z)) then begin
      MCP[1].P.x:=MCP[1].P.x-sin((AngleX)/180*Pi);
    end;


    MCP[0].P.SetP((MCP[1].P.x-sin((AngleX)/180*Pi)*DFront*AYK),
    MCP[0].P.y,MCP[1].p.Z-cos((AngleX)/180*Pi)*DFront*AYK);

    MCP[2].P.SetP((MCP[1].P.x-sin((AngleX+180)/180*Pi)*(DBack)*AYK),
    MCP[2].P.y,MCP[1].p.Z-cos((AngleX+180)/180*Pi)*(DBack)*AYK);


  TempVec:=CTSpInSp(MCP[0],MCP[2]);
  AngleY:=arcsin(TempVec.N.y)*180/pi;
  if AngleY>80 then AngleY:=80;
  if AngleY<-80 then AngleY:=-80;

  AYK:=cos(AngleY/180*Pi);


  weel[0].P.X:=(MCP[0].P.x+sin((AngleX+90)/180*Pi)*DFW)-(sin((AngleX)/180*Pi)*(DFW/2)*AYK);
  weel[0].P.Z:=(MCP[0].P.z+cos((AngleX+90)/180*Pi)*DFW)-(cos((AngleX)/180*Pi)*(DFW/2)*AYK);

  weel[1].P.X:=(MCP[0].P.x+sin((AngleX-90)/180*Pi)*DFW)-(sin((AngleX)/180*Pi)*DFW/2*AYK);
  weel[1].P.Z:=(MCP[0].P.z+cos((AngleX-90)/180*Pi)*DFW)-(cos((AngleX)/180*Pi)*DFW/2*AYK);

  weel[2].P.X:=(MCP[2].P.x+sin((AngleX+90)/180*Pi)*DBW)+(sin((AngleX)/180*Pi)*DFW/2*AYK);
  weel[2].P.Z:=(MCP[2].P.z+cos((AngleX+90)/180*Pi)*DBW)+(cos((AngleX)/180*Pi)*DFW/2*AYK);

  weel[3].P.X:=(MCP[2].P.x+sin((AngleX-90)/180*Pi)*DBW)+(sin((AngleX)/180*Pi)*DFW/2*AYK);
  weel[3].P.Z:=(MCP[2].P.z+cos((AngleX-90)/180*Pi)*DBW)+(cos((AngleX)/180*Pi)*DFW/2*AYK);



  weelg[0]:=weel[0];
  weelg[1]:=weel[1];
  weelg[2]:=weel[2];
  weelg[3]:=weel[3];


  TempVec:=CTSpInSp(weelg[0],weelg[1]);

    weelg[0].P.SetP(weelg[0].P.x+TempVec.N.x*((DFW*2)-TempVec.I)/2,
    weelg[0].P.y+TempVec.N.y*((DFW*2)-TempVec.I)/2,weelg[0].p.Z+TempVec.N.z*((DFW*2)-TempVec.I)/2);

    weelg[1].P.SetP(weelg[1].P.x-TempVec.N.x*((DFW*2)-TempVec.I)/2,
    weelg[1].P.y-TempVec.N.y*((DFW*2)-TempVec.I)/2,weelg[1].p.Z-TempVec.N.z*((DFW*2)-TempVec.I)/2);

  TempVec:=CTSpInSp(weelg[2],weelg[3]);

    weelg[2].P.SetP(weelg[2].P.x+TempVec.N.x*((DBW*2)-TempVec.I)/2,
    weelg[2].P.y+TempVec.N.y*((DBW*2)-TempVec.I)/2,weelg[2].p.Z+TempVec.N.z*((DBW*2)-TempVec.I)/2);

    weelg[3].P.SetP(weelg[3].P.x-TempVec.N.x*((DBW*2)-TempVec.I)/2,
    weelg[3].P.y-TempVec.N.y*((DBW*2)-TempVec.I)/2,weelg[3].p.Z-TempVec.N.z*((DBW*2)-TempVec.I)/2);

  D1:=sqrt(sqr(DFW*2)+sqr(DFront+DBack));

  TempVec:=CTSpInSp(weelg[1],weelg[3]);

    weelg[1].P.SetP(weelg[1].P.x+TempVec.N.x*((D1)-TempVec.I)/2,
    weelg[1].P.y+TempVec.N.y*((D1)-TempVec.I)/2,weelg[1].p.Z+TempVec.N.z*((D1)-TempVec.I)/2);

    weelg[3].P.SetP(weelg[3].P.x-TempVec.N.x*((D1)-TempVec.I)/2,
    weelg[3].P.y-TempVec.N.y*((D1)-TempVec.I)/2,weelg[3].p.Z-TempVec.N.z*((D1)-TempVec.I)/2);

  TempVec:=CTSpInSp(weelg[0],weelg[2]);

    weelg[0].P.SetP(weelg[0].P.x+TempVec.N.x*((D1)-TempVec.I)/2,
    weelg[0].P.y+TempVec.N.y*((D1)-TempVec.I)/2,weelg[0].p.Z+TempVec.N.z*((D1)-TempVec.I)/2);

    weelg[2].P.SetP(weelg[2].P.x-TempVec.N.x*((D1)-TempVec.I)/2,
    weelg[2].P.y-TempVec.N.y*((D1)-TempVec.I)/2,weelg[2].p.Z-TempVec.N.z*((D1)-TempVec.I)/2);

  if CTSpInSp(weelg[0],weel[0]).I>weel[0].PR*2 then weel[0]:=weelg[0];
  if CTSpInSp(weelg[1],weel[1]).I>weel[1].PR*2 then weel[1]:=weelg[1];
  if CTSpInSp(weelg[2],weel[2]).I>weel[2].PR*2 then weel[2]:=weelg[2];
  if CTSpInSp(weelg[3],weel[3]).I>weel[3].PR*2 then weel[3]:=weelg[3];

  SrSp.P.SetP(((weelg[0].P.X+weelg[1].P.X+weelg[2].P.X+weelg[3].P.X)/4)-(TempVecY.N.x*TempVecY.N.y*DFW/1.5)+(sin((AngleX)/180*Pi)*(CarVS)),
          ((weelg[0].P.Y+weelg[1].P.Y+weelg[2].P.Y+weelg[3].P.Y)/4)+(sqrt(1-sqr(TempVecY.N.y))*DFW/1.5),
           ((weelg[0].P.Z+weelg[1].P.Z+weelg[2].P.Z+weelg[3].P.Z)/4)-(TempVecY.N.z*TempVecY.N.y*DFW/1.5)+(cos((AngleX)/180*Pi)*(CarVS)));

  if CTSpInSp(SrSp,MCP[0]).I>DFront then MCP[0].P.Y:=MCP[0].P.Y+CTSpInSp(SrSp,MCP[0]).N.Y*4;
  if CTSpInSp(SrSp,MCP[1]).I>10 then MCP[1].P.Y:=MCP[1].P.Y+CTSpInSp(SrSp,MCP[1]).N.Y*4;
  if CTSpInSp(SrSp,MCP[2]).I>DBack then MCP[2].P.Y:=MCP[2].P.Y+CTSpInSp(SrSp,MCP[2]).N.Y*4;

  TempVec1:=CTSpInSp(weel[0],weel[1]);
  TempAngle1:=arcsin(TempVec1.N.y)*180/pi;
  TempVec2:=CTSpInSp(weel[2],weel[3]);
  TempAngle2:=arcsin(TempVec2.N.y)*180/pi;

  TempVecX.N.x:=(TempVec1.N.x+TempVec2.N.x)/2;
  TempVecX.N.y:=(TempVec1.N.y+TempVec2.N.y)/2;
  TempVecX.N.z:=(TempVec1.N.z+TempVec2.N.z)/2;

  AngleZ:=(TempAngle1+TempAngle2)/2;

  TempVec1:=CTSpInSp(weel[0],weel[2]);
  TempAngle1:=arcsin(TempVec1.N.y)*180/pi;
  TempVec2:=CTSpInSp(weel[1],weel[3]);
  TempAngle2:=arcsin(TempVec2.N.y)*180/pi;
  AngleY:=(TempAngle1+TempAngle2)/2;

  TempVec:=CTSpInSp(weelg[0],weelg[2]);
  TempVecY:=CTSpInSp(weelg[2],weelg[3]);


 // Wv1,Wv2,Wn1,Wn2

      Wv1.SetP(weelg[1].P.X-weelg[0].P.X,weelg[1].P.Y-weelg[0].P.Y,
        weelg[1].P.Z-weelg[0].P.Z);
     Wv2.SetP(weelg[2].P.X-weelg[0].P.X,weelg[2].P.Y-weelg[0].P.Y,
        weelg[2].P.Z-weelg[0].P.Z);
     Wn1:=MathMatrix(Wv1,Wv2);

  CamIn.SetP(((weelg[0].P.X+weelg[1].P.X+weelg[2].P.X+weelg[3].P.X)/4)+(Wn1.x*0.05),
          ((weelg[0].P.Y+weelg[1].P.Y+weelg[2].P.Y+weelg[3].P.Y)/4)+(Wn1.y*0.05),
           ((weelg[0].P.Z+weelg[1].P.Z+weelg[2].P.Z+weelg[3].P.Z)/4)+(Wn1.z*0.05));


  P.SetP(((weelg[0].P.X+weelg[1].P.X+weelg[2].P.X+weelg[3].P.X)/4)+(Wn1.x*0.03){+(sin((AngleX)/180*Pi)*(CarVS)*TempVecY.N.y)},
          ((weelg[0].P.Y+weelg[1].P.Y+weelg[2].P.Y+weelg[3].P.Y)/4)+(Wn1.y*0.03),
           ((weelg[0].P.Z+weelg[1].P.Z+weelg[2].P.Z+weelg[3].P.Z)/4)+(Wn1.z*0.03){+(sin((AngleX)/180*Pi)*(CarVS)*TempVecY.N.y)});
   //
 dt:=TempVecY;

end;



end.
