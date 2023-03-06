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
    PredD,VRP,DX,D,DZ,MyAngle:real;
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
  if VRP>0 then VRP:=VRP-1;
end;

procedure MGEDriver.update(Car: MGEVehicle; CPoint: MGEpoint3D);
var VR,MSP:real;
    MNOJ,Y:integer;
begin
  DX:=Car.p.x-CPoint.x;
  DZ:=Car.p.z-CPoint.z;
  D:=sqrt(sqr(DX)+sqr(DZ));
  VR:=DZ/D;
  If DX>0 then MyAngle:=(arccos(DZ/D)*180/Pi);
  If DX<=0 then MyAngle:=-(arccos(DZ/D)*180/Pi);
  MNOJ:=Trunc(Car.AngleX/360);
  if MNOJ>=0 then Y:=1;
  if MNOJ<0 then Y:=-1;

  if (MyAngle>Car.AngleX+180) or (MyAngle<Car.AngleX-180) then MyAngle:= MyAngle-360*(MNOJ+Y);


 { if (MyAngle>Car.AngleX+180) then MyAngle:=MyAngle-360*MNOJ;
  if (MyAngle<Car.AngleX-180) then MyAngle:=MyAngle+360*MNOJ;    }


   KA:=false;
   KD:=false;

  if (D>40) then begin
    if (MyAngle>Car.AngleX+5) then KA:=true;
    if (MyAngle<Car.AngleX-5) then KD:=true;
  end;

 { if (D<50) and (PredD>D) and   then begin
    KA:=false;
    KD:=false;
  end;   }
  if (D>60)  and (D<=200) then MSP:=Car.MSpeed/10;
  if (D>200) and (D<=400) then MSP:=Car.MSpeed/2;
  if (D>400) then MSP:=Car.MSpeed;


  if (D>60) and  (Car.MCP[1].speed<MSP)  then KW:=true else KW:=false;

  if (D<=60) then begin
    KA:=false;
    Ksp:=true;
    KD:=false;
  end
  else
    begin
      Ksp:=false;
    end;


  PredD:=D;
  if VRP>0 then VRP:=VRP-1;

end;






end.
