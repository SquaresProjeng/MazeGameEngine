unit MGEAIController;

interface
uses Mechanic, Phisics, Controller, math;

type
  MGEDriver = record
    Success:boolean;
    PredD,VRP,DX,D,DZ,MyAngle:real;
    KW,KA,KS,KD,Ksp:boolean;
    public
      procedure update(Car:MGEVehicle; CPoint:MGEPoint3D);
  end;

  MGEBot = record
    Success:boolean;
    PredD,DX,D,DZ,MyAngle:real;
    KW,KA,KS,KD,Ksp:boolean;
    public
      procedure update(MBot:MGEÑharacter; CPoint:MGEPoint3D);
  end;



implementation

procedure MGEBot.update(MBot: MGEÑharacter; CPoint: MGEpoint3D);
var VR,MSP:real;
    MNOJ,Y:integer;
begin
  DX:=MBot.Pl1.P.x-CPoint.x;
  DZ:=MBot.Pl1.P.z-CPoint.z;
  D:=sqrt(sqr(DX)+sqr(DZ));
  VR:=DZ/D;
  If DX>0 then MyAngle:=(arccos(DZ/D)*180/Pi);
  If DX<=0 then MyAngle:=-(arccos(DZ/D)*180/Pi);
  MNOJ:=Trunc(MBot.AngleX/360);
  if MNOJ>=0 then Y:=1;
  if MNOJ<0 then Y:=-1;
  if (MyAngle>MBot.AngleX+180) or (MyAngle<MBot.AngleX-180) then MyAngle:= MyAngle-360*(MNOJ+Y);

 // MBot.AngleX:=MyAngle;
   KA:=false;
   KD:=false;
  if (abs(D)>5) then begin
    if (MyAngle>MBot.AngleX+2) then KA:=true;
    if (MyAngle<MBot.AngleX-2) then KD:=true;
  end;
  if (abs(D)>2) then KW:=true else KW:=false;
  if (abs(D)<=1) then begin
    KA:=false;
    //Ksp:=true;
    KD:=false;
    KW:=false;
  end;
  PredD:=D;
end;

function CheckDist(p1,p2,p3,needp:MGEpoint3D):integer;
var D1,D2,D3:real;
    TD:integer;
begin
    D1:=sqrt(sqr(p1.x-needp.x)+sqr(p1.z-needp.z));
    D2:=sqrt(sqr(p2.x-needp.x)+sqr(p2.z-needp.z));
    D3:=sqrt(sqr(p3.x-needp.x)+sqr(p3.z-needp.z));
    TD:=1;
    if D2<D1 then TD:=2;
    if D3<D2 then TD:=3;
    result:=TD;
end;

procedure MGEDriver.update(Car: MGEVehicle; CPoint: MGEpoint3D);
var VR,MSP:real;
    MNOJ,T:integer;
    Pp1,Pp2,Pp3:MGEpoint3D;
begin
  DX:=Car.p.x-CPoint.x;
  DZ:=Car.p.z-CPoint.z;
  D:=sqrt(sqr(DX)+sqr(DZ));

  Pp1.SetP(Car.p.x-Sin(Car.angleX/180*Pi)*4,0,Car.p.z-Cos(Car.angleX/180*Pi)*4);
  Pp2.SetP(Car.p.x-Sin((Car.angleX-15)/180*Pi)*4,0,Car.p.z-Cos((Car.angleX-15)/180*Pi)*4);
  Pp3.SetP(Car.p.x-Sin((Car.angleX+15)/180*Pi)*4,0,Car.p.z-Cos((Car.angleX+15)/180*Pi)*4);
  T:=CheckDist(Pp1,Pp2,Pp3,CPoint);

   KA:=false;
   KD:=false;
   Ksp:=false;
   case T of
      2:KD:=true;
      3:KA:=true;
   end;


  if (D>70) then KW:=true else KW:=false;

  if (D<=5) then begin
    KA:=false;
    Ksp:=true;
    KD:=false;
  end;
end;






end.
