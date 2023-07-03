unit Mechanic;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DglOpenGL, DGLUT, Textures,mesh,GFonts,controller,Resurce,Phisics,math;

Type
  Bloks = record
    ID,N:byte;
  end;


Type
  MGERace = record
    RacePoint:array of MGEPoint3D;
    NP,TecPoint:integer;
    TimeS,TimeM,Fin:integer;
    RState,TecM,TemM:integer;

    public
      procedure Create(AP:array of MGEPoint3D);
      procedure StartRace(var Vehicle:MGEVehicle);
      procedure Apdate(Vehicle:MGEVehicle; var Tres,TS:integer);
  end;

  


implementation
uses GUI,GUIUnit;


procedure MGERace.Create(AP: array of MGEpoint3D);
var I:integer;
begin
  NP:=Length(AP);
if NP>1 then  begin

  SetLength(RacePoint,NP);
  for I := 0 to NP - 1 do begin
    RacePoint[i].x:= AP[i].x;
    RacePoint[i].y:= AP[i].y;
    RacePoint[i].z:= AP[i].z;
  end;
  RState:=0;  TecPoint:=0;
  TPR:=0;
end;
end;
procedure MGERace.StartRace(var Vehicle: MGEVehicle);
var
  D, RotX,NvX,NvZ:real;
begin
  D:=sqrt(sqr(RacePoint[1].x-RacePoint[0].x)+sqr(RacePoint[1].z-RacePoint[0].x));
  NvX:=(RacePoint[1].x-RacePoint[0].x)/D;
  NvZ:=(RacePoint[1].z-RacePoint[0].x)/D;
  RotX:=Vehicle.AngleX;

  if RState=0 then begin
    //Vehicle.p.SetP(RacePoint[TecPoint].x,RacePoint[TecPoint].y+10,RacePoint[TecPoint].z);
    Vehicle.Create(SetP3D(RacePoint[TecPoint].x,RacePoint[TecPoint].y+10,RacePoint[TecPoint].z),SetP3D(5,5,5),SetP3D(0.1,0.1,0.1),
          7,2.5,3,3,1.30,9.25,-2.5,Vehicle.MUsk,Vehicle.MSpeed*200);
  end;
  TemM:=1;
  RState:=1;
end;
procedure MGERace.Apdate(Vehicle: MGEVehicle; var  Tres,TS:integer);
var D:real;
begin
    If (RState=1) and (TS<=NP ) then begin
    TecM:=TS;
     D:=sqrt(sqr(RacePoint[TS].x-Vehicle.p.x)+sqr(RacePoint[TS].z-Vehicle.p.z));
     if D<=90  then inc(TecM);
    end;

    if (TecM>=NP) and (Tres=1) then begin
    TecM:=0; 
    RState:=0;
  end;

   Tres:=RState;
   TS:=TecM;
end;



end.
