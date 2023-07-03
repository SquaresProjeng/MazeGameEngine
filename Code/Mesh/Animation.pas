unit Animation;

interface
uses
  SysUtils, Variants, Classes, Graphics, Controls,
  DglOpenGL, DGLUT, Textures, Mesh, Resurce, Command,GFonts,math,
  Controller,Scripter,Phisics,GUIUnit;

Type
  MGEBone = record
    x,y,z:array[0..1] of Real;
    dx,dy,dz:Real;
    mr,r,sr:MGEPoint3D;
    modelsize,modelrot:MGEPoint3D;
    BName:String;
    MoID,DoID,ModelID:integer;
    YeMod:Boolean;
    d:real;
  end;
  MGELBone = record
     r:MGEPoint3D;
  end;
  MGEMoSkelas = record
    BoneID:array of integer;
    ModelID:array of ^TGLMultyMesh;
    N:integer;
    public
      procedure LoadAssotiation(filename:String);
      procedure SaveAssotiation(filename:String);
  end;
  MGESkelet = record
    Sbone:array of MGEBone;
    N,putc:integer;
    CRTED:boolean;
    public
      procedure CreateSkelet(BN,Bdist:integer; dx,dy,dz:Single);  /////BN>=1
      procedure DrawSkelet(Pos,Size,Rot:MGEPoint3D);
      function PutBone(PosX,PosY,PosZ: real;VidX,VidY:real; Curs:MGECursor):integer;  /////////////Ѕольше 404 костей быть не может
      procedure CreateBone(BCapt:String; MontherID:integer; BDist:real);
      procedure DeleteBone(DBoneID:integer; DeleteDother:Boolean);
      procedure RotateBones(RBoneID:integer; RX,RY,RZ:real; RotDoth:boolean);
      procedure UpdateBones();
      procedure SaveSkelet(puloc:String);
      procedure LoadSkelet(puloc:String);
  end;
  MGEAnim120 = record
    SFrame:array[1..120] of MGESkelet;
    Keys:array[1..120] of boolean;
    frames,TecFrame:integer;
    CRTED:boolean;
    public
      procedure CreateAnimation(var MySkelet:MGESkelet);
      procedure RotateBone(IDFrame,IDBone:integer; RX,RY,RZ:real);
      procedure DrawFrame(px,py,pz:real; MyF:integer);
      procedure SaveAnimation(filename:String);
      procedure LoadAnimation(filename:String);
      procedure CalcAnimation();
   end;

procedure MGEBoneModel(x,y,z,rnx,rny,rnz,rx,ry,rz,sx,sy,sz:real; model:TGLMultyMesh; Texture:GLUint);
procedure Calc_Anim120(var Skel:array of MGESkelet; TKeys:array of Boolean);


implementation



procedure Calc_Anim120(var Skel:array of MGESkelet; TKeys:array of Boolean);
	var
		I,O,P,IM,PR,YI,FRM:integer;
		Mass:array of integer;
    Tem:MGELBone;
		X,Y,Z,B,RezX,RezY,ReZ,Rezultx,RezultY,RezultZ:real;
begin
  FRM:=Length(Skel);
	SetLength(Mass, 0);
	for I := 1 to FRM do
		begin
			if TKeys[I]=true then
				begin
					SetLength(Mass, Length(Mass)+1);
					Mass[Length(Mass)-1]:=I;
				end;
		end;
	P:= Length(Mass);
	if P>1 then
		begin
			for I := 1 to P-1 do
				begin
					O:=Mass[I]-(Mass[I-1]+1);
					for IM := 0 to Skel[1].N-1 do
    					begin
     						Tem.r.x:=Skel[Mass[I]].Sbone[IM].r.x-Skel[Mass[I-1]].Sbone[IM].r.x;
     						Tem.r.y:=Skel[Mass[I]].Sbone[IM].r.y-Skel[Mass[I-1]].Sbone[IM].r.y;
     						Tem.r.z:=Skel[Mass[I]].Sbone[IM].r.z-Skel[Mass[I-1]].Sbone[IM].r.z;

     						//Tem.r.y:=CC[Mass[I]][IM].rx-CC[Mass[I-1]][IM].rx;

     						RezultX:=(Tem.r.X/(O+1));
                RezultY:=(Tem.r.Y/(O+1));
     						RezultZ:=(Tem.r.Z/(O+1));

     						RezX:=Skel[Mass[I-1]].Sbone[IM].r.x;
     						RezY:=Skel[Mass[I-1]].Sbone[IM].r.y;
     						Rez :=Skel[Mass[I-1]].Sbone[IM].r.z;

     					  for PR := Mass[I-1] to Mass[I]-1 do
     					    begin
                    Skel[PR+1].Sbone[IM].r.x:= RezX+RezultX; RezX:=RezX+RezultX;
                    Skel[PR+1].Sbone[IM].r.y:= RezY+RezultY; RezY:=RezY+RezultY;
                    Skel[PR+1].Sbone[IM].r.z:= Rez+RezultZ; Rez:=Rez+RezultZ;
                    Skel[PR+1].UpdateBones;
                  end;
     					end;
          end;

      end;
end;


procedure MGEAnim120.DrawFrame(px: Real; py: Real; pz: Real; MyF:integer);
begin
  //SFrame[MyF].DrawSkelet(px,py,pz);
end;

procedure MGEAnim120.RotateBone(IDFrame: Integer; IDBone: Integer; RX: Real; RY: Real; RZ: Real);
begin
  //SFrame[2].RotateBones(IDBone,RX,RY,RZ,false);
end;

procedure MGEBoneModel(x,y,z,rnx,rny,rnz,rx,ry,rz,sx,sy,sz:real; model:TGLMultyMesh; Texture:GLUint);
begin
         glBindTexture(GL_TEXTURE_2D,Texture);
        glTranslatef(x,y,z);
//////////////////поворот модели////////////////////////
          glRotatef(rx,0,1,0);
          glRotatef(ry,1,0,0);
          glRotatef(rz,0,0,1);
///////////////основна€ подстройка /////////////////////
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

procedure MGEMoSkelas.LoadAssotiation(filename: string);
begin

end;
procedure MGEMoSkelas.SaveAssotiation(filename: string);
begin

end;
procedure MGEAnim120.CreateAnimation(var MySkelet: MGESkelet);
var I,u:integer;
temp:MGESkelet;
begin
  if CRTED=false then begin
    temp:=MySkelet;
    frames:=120;
    TecFrame:=0;
      for I := 1 to 120 do  begin
        SFrame[i].N:= temp.N;
        SFrame[i].Sbone:=temp.Sbone;
        SFrame[i].putc:= temp.putc;
        SFrame[i].CRTED:= true;
      end;
    CRTED:=true;
  end;
  CRTED:=true;
end;
procedure MGEAnim120.SaveAnimation(filename: string);
begin

end;
procedure MGEAnim120.LoadAnimation(filename: string);
begin

end;
procedure MGEAnim120.CalcAnimation;
begin

end;
procedure MGESkelet.CreateSkelet(BN: Integer; Bdist: Integer; dx,dy,dz:Single);
var I:integer;
begin
N:=0;
if BN<=0 then  BN:=1;
if BN>=1 then begin
  inc(N);
  SetLength(Sbone,N);
  Sbone[0].x[0]:=0;
  Sbone[0].y[0]:=0;
  Sbone[0].z[0]:=0;

  Sbone[0].BName:='MotherBone';
  Sbone[0].d:=Bdist;

  Sbone[0].dx:=dx;
  Sbone[0].dy:=dy;
  Sbone[0].dz:=dz;

  Sbone[0].modelsize.x:=Sbone[0].d/2;
  Sbone[0].modelsize.y:=Sbone[0].d/2;
  Sbone[0].modelsize.z:=Sbone[0].d/2;

  Sbone[0].modelrot.x:=0;
  Sbone[0].modelrot.y:=90;
  Sbone[0].modelrot.z:=0;

  Sbone[0].x[1]:=Sbone[0].x[0]+Sbone[0].dx*Sbone[0].d;
  Sbone[0].y[1]:=Sbone[0].y[0]+Sbone[0].dy*Sbone[0].d;
  Sbone[0].z[1]:=Sbone[0].z[0]+Sbone[0].dz*Sbone[0].d;

  if BN>=1 then begin
      for I := 1 to BN-1 do
        begin
          CreateBone('Bone '+inttostr(I), I-1, Bdist);
        end;
    end;
  end;
 CRTED:=true;
end;
procedure MGESkelet.DrawSkelet(Pos,Size,Rot:MGEPoint3D);
  var i:integer;
begin
if CRTED=true then   begin
    {  MGEModel_Draw(Sbone[0].x[0]+posx,Sbone[0].y[0]+posy,Sbone[0].z[0]+posz,
                    0,0,0,1,Mode1s[1],Ttextobj[3]); }
     //M3Point(posx,posy,posz,Sbone[0].x[0],Sbone[0].y[0],Sbone[0].z[0],10,255,255,0);

        glTranslatef(Pos.x,Pos.y,Pos.z);
        glRotatef(Rot.x,1,0,0);
        glRotatef(Rot.y,0,1,0);
        glRotatef(Rot.z,0,0,1);
        glPushMatrix;
            glScalef(Size.x,Size.Y,Size.Z);
    for I := 0 to N - 1 do  begin
     If Sbone[I].YeMod=true then  MGEBoneModel(((Sbone[I].x[0]+Sbone[I].x[1])/2),
                    ((Sbone[I].y[0]+Sbone[I].y[1])/2),
                    ((Sbone[I].z[0]+Sbone[I].z[1])/2),
                    Sbone[I].modelrot.x,Sbone[I].modelrot.y,Sbone[I].modelrot.z,
                            Sbone[i].sr.x,Sbone[i].sr.y,Sbone[i].sr.z,
                     Sbone[i].modelsize.x,Sbone[i].modelsize.y,Sbone[i].modelsize.z,
                     ResModel[Sbone[I].ModelID],Ttextobj[23]);
    end;
        glPopMatrix;
        glRotatef(-Rot.z,0,0,1);
        glRotatef(-Rot.y,0,1,0);
        glRotatef(-Rot.x,1,0,0);
        glTranslatef(-Pos.x,-Pos.y,-Pos.z);

end;
end;
function  MGESkelet.PutBone(PosX,PosY,PosZ: real; VidX: Real; VidY: Real; Curs:MGECursor):integer; ////////////работает при смещение скелета на 0 0 0
var
    VX,VY,VZ,kx,ky,kz,MGEVH:real;
    dist, i,MD,RADM,rez:integer;
begin
    rez:=404;
if (CRTED=true) and ((Curs.state=3) or (Curs.state=1)) then begin

    kx:=posX;
    ky:=posY;
    kz:=posZ;
    dist:=0;
    MGEVH:=cos(-VidY/180*Pi);
  while dist<250 do
    begin
      dist:=dist+1;
            kx:=kx-sin(VidX/180*pi)*MGEVH;
            ky:=ky-sin(-VidY/180*Pi);
            kz:=kz-cos(VidX/180*pi)*MGEVH;
        for I := 0 to N - 1 do
        begin
               VX:=((Sbone[I].x[0]+Sbone[I].x[1])/2) ;
               VY:=((Sbone[I].y[0]+Sbone[I].y[1])/2) ;
               VZ:=((Sbone[I].z[0]+Sbone[I].z[1])/2) ;
               RADM:=round(Sbone[I].d/4);
                MD:=round(Sqrt(sqr(VX-kx)+sqr(VY-ky)+sqr(Vz-kz)));
                  if MD<1+RADM then begin
                    rez:=I;
                    dist:=250;
                    //break;
                  end;
        end;
    end;
end;
   result:=rez;
end;
procedure MGESkelet.CreateBone(BCapt: string; MontherID: Integer; BDist: Real);
begin
///////////// –аботает при условии, что уже создан скелет!!!!!
  if CRTED=true then begin
  inc(N);
  SetLength(Sbone,N);
  Sbone[N-1].x[0]:=Sbone[MontherID].x[1];
  Sbone[N-1].y[0]:=Sbone[MontherID].y[1];
  Sbone[N-1].z[0]:=Sbone[MontherID].z[1];
  Sbone[N-1].MoID:=MontherID;
  Sbone[N-1].BName:=BCapt;
  Sbone[N-1].d:=Bdist;

  Sbone[N-1].r.x:=Sbone[MontherID].sr.x;
  Sbone[N-1].r.y:=Sbone[MontherID].sr.y;
  Sbone[N-1].r.z:=Sbone[MontherID].sr.z;

  Sbone[N-1].dx:=sin(Sbone[N-1].sr.x/180*Pi);
  Sbone[N-1].dy:=sin(-Sbone[N-1].sr.y/180*Pi);
  Sbone[N-1].dz:=cos(Sbone[N-1].sr.x/180*Pi);

  Sbone[N-1].modelsize.x:=Sbone[N-1].d/2;
  Sbone[N-1].modelsize.y:=Sbone[N-1].d/2;
  Sbone[N-1].modelsize.z:=Sbone[N-1].d/2;

  Sbone[N-1].modelrot.x:=0;
  Sbone[N-1].modelrot.y:=90;
  Sbone[N-1].modelrot.z:=0;

  Sbone[N-1].x[1]:=Sbone[N-1].x[0]+Sbone[N-1].dx*Sbone[N-1].d;
  Sbone[N-1].y[1]:=Sbone[N-1].y[0]+Sbone[N-1].dy*Sbone[N-1].d;
  Sbone[N-1].z[1]:=Sbone[N-1].z[0]+Sbone[N-1].dz*Sbone[N-1].d;
  end;
end;
procedure MGESkelet.DeleteBone(DBoneID: Integer; DeleteDother:  Boolean);
var
  I,MDID,DID:integer;
begin
if (DBoneID<=N-1) and (N>1) then
  case DeleteDother of
  false: begin
    DID:=DBoneID;
    MDID:=Sbone[DBoneID].MoID;
      for I := DBoneID+1 to N-1 do if Sbone[I].MoID=DID then Sbone[I].MoID:=MDID;
      Sbone[DBoneID]:=Sbone[N-1];
      N:=N-1;
      if putc>N then putc:=n;
      
      SetLength(Sbone,N);
  end;
  true: begin
     //////////////////ѕока не удал€ем дерево костей((((
  end;
  end;
end;
procedure MGESkelet.RotateBones(RBoneID: Integer; RX,RY,RZ:real; RotDoth: Boolean);
var
  I:integer;
  X0,Y0,Z0,X1,Y1,Z1,R:real;
begin
  if RBoneID>=0 then begin
    X0:=Sbone[RBoneID].x[0];
    Y0:=Sbone[RBoneID].y[0];
    Z0:=Sbone[RBoneID].z[0];
    R:=SBone[RBoneID].d;

    x1:=round(x0+r*cos(RY*pi/180));
    y1:=round(y0+r*sin(RY*pi/180));

    x1:=round(x0+r*cos(RX*pi/180));
    z1:=round(z0+r*sin(RX*pi/180));

    Sbone[RBoneID].x[1]:=X1;
    Sbone[RBoneID].y[1]:=Y1;
    Sbone[RBoneID].z[1]:=Z1;

    Sbone[RBoneID].r.x:=Sbone[RBoneID].r.x+RX;
    Sbone[RBoneID].r.y:=Sbone[RBoneID].r.y+RY;
    Sbone[RBoneID].r.z:=Sbone[RBoneID].r.z+RZ;

if RBoneID>0 then begin
    Sbone[RBoneID].mr.x:=Sbone[Sbone[RBoneID].MoID].sr.x;
    Sbone[RBoneID].mr.y:=Sbone[Sbone[RBoneID].MoID].sr.y;
    Sbone[RBoneID].mr.z:=Sbone[Sbone[RBoneID].MoID].sr.z;
end;
  {  Sbone[RBoneID].sr.x:=Sbone[RBoneID].mr.x*sin(Sbone[RBoneID].r.x)+Sbone[RBoneID].r.x;
    Sbone[RBoneID].sr.y:={Sbone[RBoneID].mr.y*abs(sin(Sbone[RBoneID].r.y))+Sbone[RBoneID].r.y;
    Sbone[RBoneID].sr.z:=Sbone[RBoneID].mr.z+Sbone[RBoneID].r.z;   }

    UpdateBones;
  end;


end;
procedure MGESkelet.UpdateBones;
var I,Y:integer;
begin
 If (CRTED=True) and (N>=1) then  begin
 Sbone[0].sr.x:=Sbone[0].r.x;
 Sbone[0].sr.y:=Sbone[0].r.y;
 Sbone[0].sr.z:=Sbone[0].r.z;

 Sbone[0].dx:=sin(Sbone[0].sr.x/180*Pi);
 Sbone[0].dy:=sin(-Sbone[0].sr.y/180*Pi);
 Sbone[0].dz:=cos(Sbone[0].sr.x/180*Pi);

    Sbone[0].x[1]:=Sbone[0].x[0]+Sbone[0].dx*Sbone[0].d*cos(-Sbone[0].sr.y/180*Pi);
    Sbone[0].y[1]:=Sbone[0].y[0]+Sbone[0].dy*Sbone[0].d;
    Sbone[0].z[1]:=Sbone[0].z[0]+Sbone[0].dz*Sbone[0].d*cos(-Sbone[0].sr.y/180*Pi);
 for Y := 1 to N - 1 do  begin
    Sbone[Sbone[Y].MoID].DoID:=Y;
 end;
 for I := 1 to N - 1 do  begin
 Sbone[I].mr.x:=Sbone[Sbone[I].MoID].sr.x;
 Sbone[I].mr.y:=Sbone[Sbone[I].MoID].sr.y;
 Sbone[I].mr.z:=Sbone[Sbone[I].MoID].sr.z;

 {Sbone[I].sr.x:=-Sbone[I].r.x+Sbone[I].mr.x  ;
 Sbone[I].sr.y:=Sbone[I].r.y+Sbone[I].mr.y ;
 Sbone[I].sr.z:=Sbone[I].r.z+Sbone[I].mr.z  ;   }

 Sbone[I].sr.x:=Sbone[I].r.x;
 Sbone[I].sr.y:=Sbone[I].r.y;
 Sbone[I].sr.z:=Sbone[I].r.z;

     Sbone[I].dx:=sin(Sbone[I].sr.x/180*Pi);
     Sbone[I].dy:=sin(-Sbone[I].sr.y/180*Pi);
     Sbone[I].dz:=cos(Sbone[I].sr.x/180*Pi);

    Sbone[I].x[0]:=Sbone[Sbone[I].MoID].x[1];
    Sbone[I].y[0]:=Sbone[Sbone[I].MoID].y[1];
    Sbone[I].z[0]:=Sbone[Sbone[I].MoID].z[1];

    Sbone[I].x[1]:=Sbone[I].x[0]+Sbone[I].dx*Sbone[I].d*cos(-Sbone[I].sr.y/180*Pi);
    Sbone[I].y[1]:=Sbone[I].y[0]+Sbone[I].dy*Sbone[I].d;
    Sbone[I].z[1]:=Sbone[I].z[0]+Sbone[I].dz*Sbone[I].d*cos(-Sbone[I].sr.y/180*Pi);


 end;
 end;
end;
procedure MGESkelet.SaveSkelet(puloc: string);
var
  fi:Textfile;
  i:integer;
begin
  assignfile(fi,puloc); rewrite(fi);
  writeln(fi,'This is Gosha by Squares Projeng!');
  writeln(fi,'Script version v 0.3');
  Writeln(fi, N);
  for I := 0 to n - 1 do  begin
    Write(fi,Sbone[i].x[0],' ',Sbone[i].y[0],' ',Sbone[i].z[0],' ');
    Writeln(fi,Sbone[i].x[1],' ',Sbone[i].y[1],' ',Sbone[i].z[1]);
    Write(fi,Sbone[i].dx,' ',Sbone[i].dy,' ',Sbone[i].dz,' ');
    Writeln(fi,Sbone[i].sr.x,' ',Sbone[i].sr.y,' ',Sbone[i].sr.z);
    Write(fi,Sbone[i].mr.x,' ',Sbone[i].mr.y,' ',Sbone[i].mr.z,' ');
    Writeln(fi,Sbone[i].r.x,' ',Sbone[i].r.y,' ',Sbone[i].r.z);
    Writeln(fi,Sbone[i].BName);
    Writeln(fi,Sbone[i].MoID,' ',Sbone[i].DoID,' ',Sbone[i].d);
    Writeln(fi,Sbone[i].ModelID);
    Writeln(fi,Sbone[i].YeMod);
    if Sbone[i].YeMod=true then
    Write(fi,Sbone[i].modelsize.x,' ',Sbone[i].modelsize.y,' ',Sbone[i].modelsize.z,' ');
    if Sbone[i].YeMod=true then
    Writeln(fi,Sbone[i].modelrot.x,' ',Sbone[i].modelrot.y,' ',Sbone[i].modelrot.z);
  end;
 Writeln(fi,'ResFileNone');
 Writeln(fi,'End Skelet');
 Closefile(fi);
end;
procedure MGESkelet.LoadSkelet(puloc: string);
var
  fi:Textfile;
  i,k:integer;
  ver,hm:String;
begin
  assignfile(fi,puloc); reset(fi);
  Readln(fi);
  Readln(fi,Ver);
  if Ver='Script version v 0.1' then  begin
    Readln(fi, K);
    N:=K;
    SetLength(SBone,N);
    for I := 0 to n - 1 do  begin
      Read(fi,Sbone[i].x[0],Sbone[i].y[0],Sbone[i].z[0]);
      Readln(fi,Sbone[i].x[1],Sbone[i].y[1],Sbone[i].z[1]);
      Read(fi,Sbone[i].dx,Sbone[i].dy,Sbone[i].dz);
      Readln(fi,Sbone[i].sr.x,Sbone[i].sr.y,Sbone[i].sr.z);
      Readln(fi,Sbone[i].BName);
      Readln(fi,Sbone[i].MoID,Sbone[i].d);
      Sbone[i].modelsize.SetP(Sbone[i].d/2,Sbone[i].d/2,Sbone[i].d/2);
      Sbone[i].modelrot.SetP(0,90,0);
      Sbone[i].YeMod:=true;
      Sbone[i].ModelID:=2;
    end;

  end;
  if Ver='Script version v 0.2' then  begin
    Readln(fi, K);
    N:=K;
    SetLength(SBone,N);
    for I := 0 to n - 1 do  begin
      Read(fi,Sbone[i].x[0],Sbone[i].y[0],Sbone[i].z[0]);
      Readln(fi,Sbone[i].x[1],Sbone[i].y[1],Sbone[i].z[1]);
      Read(fi,Sbone[i].dx,Sbone[i].dy,Sbone[i].dz);
      Readln(fi,Sbone[i].r.x,Sbone[i].r.y,Sbone[i].r.z);
      Readln(fi,Sbone[i].BName);
      Readln(fi,Sbone[i].MoID,Sbone[i].d);
      Readln(fi,Sbone[i].ModelID);
      Readln(fi,hm);
      if hm='TRUE' then Sbone[i].YeMod:=true else Sbone[i].YeMod:=false;

    if Sbone[i].YeMod=true then
    Read(fi,Sbone[i].modelsize.x,Sbone[i].modelsize.y,Sbone[i].modelsize.z);
    if Sbone[i].YeMod=true then
    Readln(fi,Sbone[i].modelrot.x,Sbone[i].modelrot.y,Sbone[i].modelrot.z);
  end;
  end;
  if Ver='Script version v 0.3' then  begin
    Readln(fi, K);
    N:=K;
    SetLength(SBone,N);
    for I := 0 to n - 1 do  begin
      Read(fi,Sbone[i].x[0],Sbone[i].y[0],Sbone[i].z[0]);
      Readln(fi,Sbone[i].x[1],Sbone[i].y[1],Sbone[i].z[1]);
      Read(fi,Sbone[i].dx,Sbone[i].dy,Sbone[i].dz);
      Readln(fi,Sbone[i].sr.x,Sbone[i].sr.y,Sbone[i].sr.z);
      Read(fi,Sbone[i].mr.x,Sbone[i].mr.y,Sbone[i].mr.z);
      Readln(fi,Sbone[i].r.x,Sbone[i].r.y,Sbone[i].r.z);
      Readln(fi,Sbone[i].BName);
      Readln(fi,Sbone[i].MoID,Sbone[i].DoID,Sbone[i].d);
      Readln(fi,Sbone[i].ModelID);
      Readln(fi,hm);
      if hm='TRUE' then Sbone[i].YeMod:=true else Sbone[i].YeMod:=false;

    if Sbone[i].YeMod=true then
    Read(fi,Sbone[i].modelsize.x,Sbone[i].modelsize.y,Sbone[i].modelsize.z);
    if Sbone[i].YeMod=true then
    Readln(fi,Sbone[i].modelrot.x,Sbone[i].modelrot.y,Sbone[i].modelrot.z);
  end;
  end;
    CRTED:=true;
    Readln(fi);
    Read(fi);
 Closefile(fi);
 UpdateBones;
end;

end.
