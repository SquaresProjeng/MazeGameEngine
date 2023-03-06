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
  Inventary = record
    My_Case: array[1..5,1..5] of Bloks;
    My_Arm: array[1..5] of Bloks;
    public
    procedure Create();
    procedure CreateCheatCase();
    procedure ShowInventary(x,y,snx,sny:integer);
    procedure AddECase(X,Y:integer; New:Bloks);

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
  RState:=0;
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

  if RState=0 then begin  Vehicle.MCP[1].p.SetP(RacePoint[TecPoint].x,RacePoint[TecPoint].y,RacePoint[TecPoint].z);
    Vehicle.AngleY:=0;
    Vehicle.Speed:=0;
    Vehicle.weel[0].speed:=0;
    Vehicle.weel[1].speed:=0;
    Vehicle.weel[2].speed:=0;
    Vehicle.weel[3].speed:=0;

    Vehicle.MCP[0].speed:=0;
    Vehicle.MCP[1].speed:=0;
    Vehicle.MCP[2].speed:=0;

   // View.AngleX:=RotX+180;

  end;
  //,SetP3D(10,10,10),SetP3D(0.1,0.1,0.1),
 // 17,5.5,6,6,2.5,20,2);
  TemM:=1;
  RState:=1;
  //Vr1.SetSphere(RacePoint[1].x,0,RacePoint[1].z,0,0,0,1,30);


end;
procedure MGERace.Apdate(Vehicle: MGEVehicle; var  Tres,TS:integer);
var D:real;
begin
    If (RState=1) and (TS<=NP ) then begin
    TecM:=TS;
     D:=sqrt(sqr(RacePoint[TS].x-Vehicle.p.x)+sqr(RacePoint[TS].z-Vehicle.p.z));
     if D<=80  then inc(TecM);
    end;

    if (TecM>=NP) and (Tres=1) then begin
    TecM:=0; 
    RState:=0;
  end;

   Tres:=RState;
   TS:=TecM;
end;


  procedure Inventary.Create;
    var i,j:integer;
  begin
    for I := 1 to 5 do
      for J := 1 to 5 do
        begin
          My_Case[i,j].ID:=4;
          My_Case[i,j].N:=64;
        end;
  end;
  procedure Inventary.CreateCheatCase;
    var i,j:integer;
  begin
    for I := 1 to 5 do
      for J := 1 to 5 do
        begin
          My_Case[i,j].ID:=4;
          My_Case[i,j].N:=255;
        end;
  end;

  procedure Inventary.AddECase(X: Integer; Y: Integer; New: Bloks);
  begin

  end;

  procedure Inventary.ShowInventary(x: Integer; y: Integer; snx: Integer; sny: Integer);
    var i,j:integer;
  begin
    for I := 1 to 5 do
      for J := 1 to 5 do
        begin
          Render_Symvol(inttostr(My_Case[I,J].N),round(sny/3),round(x+I*snx*2.01),round(y+sny/2.01+J*sny*2.01),1,1,255,255,255);
          RenderSprite(x+I*snx*2.01,y+J*sny*2.01,snx,sny,0,Ttextobj[My_Case[I,J].ID]);
        end;

    
  end;


end.
