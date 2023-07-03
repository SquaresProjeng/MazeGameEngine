unit Scripter;

interface
uses
  Variants, Classes, Graphics, Controls, Dialogs, DGLUT, Textures, mesh, Math,
  ResCon;



 Type  ScriMachine = array of integer;
 type masstr = array[1..50] of string;
 Type
  KDS = record
    N:Byte;
    Slova:masstr;
  end;
Const
  NCodes = 28;

var
  Scrcom:array[1..28] of String;


procedure TranScripts();
function ReadScript(fi:String):ScriMachine;
procedure LoadMainScript(MainDir:String);
//зкщсувг

implementation




procedure mp(s1: string; var count: byte);
var
    i1, i2: byte;
      i, L: byte;
begin
  L:= length(s1);
  i1:= 1; i2:= 0;
  count:= 0;
    for i:=1 to L do begin
      if (s1[I]<> ' ') and (s1[I]<> '') then continue
      else
      inc(count);
    end;
end;
Function ms(s1: string; var s2: masstr; var count: Byte):KDS;
var S,Slovo:string;
    i1, i2: byte;
    i, L: byte;
    MY:KDS;
begin
  S:=S1;
  S:=S + ' ';
  Count:=0;
  while Pos(' ',S) > 0 do
   begin
     Slovo:=Copy(S,1,Pos(' ',S)-1); {Выделяем слово из строки}
     inc(count);
     s2[count]:=Slovo;
     Delete(S,1,Length(Slovo)+1); {Удаляем слово из основной строки}
   end;
   My.N:=count;
   My.Slova:=S2;
end;
function LoadFile(put:string):integer;
var
  sl: TStringList;
  NS:integer;
begin
  sl := TStringList.Create;
  sl.LoadFromFile(put);
  NS := sl.Count;
  sl.Free;
  result:=NS;
end;
function TranslateCode(Slovo:String):integer;
  var
    I,J:integer;
begin
  for I := 1 to NCodes do
    begin
      if Slovo=Scrcom[I] then  J:=I;
    end;
    result:=J;
end;
procedure TranScripts();
var
  I:integer;
begin
  Scrcom[1]:='MGEModel';
  Scrcom[2]:='MGEFire';
  Scrcom[3]:='Name';
  Scrcom[4]:='Full_Points';
  Scrcom[5]:='Pos';
  Scrcom[6]:='Rot';
  Scrcom[7]:='Size';
  Scrcom[8]:='{';
  Scrcom[9]:='}';
  Scrcom[10]:=':';
  Scrcom[11]:='!';
  Scrcom[12]:='EndFile';
  Scrcom[13]:='StartFile';
  Scrcom[14]:='=';
  Scrcom[15]:='New_Map';
  Scrcom[16]:='Create';
  Scrcom[17]:='MGETexture';
  Scrcom[18]:='(';
  Scrcom[19]:=')';
  Scrcom[20]:='False';
  Scrcom[21]:='True';
  Scrcom[22]:='P_X';
  Scrcom[23]:='P_Y';
  Scrcom[24]:='P_Z';
  Scrcom[25]:='*';
  Scrcom[26]:='(';
  Scrcom[27]:=')';
  Scrcom[28]:='MGESprite';
end;
function ReadScript(fi:String):ScriMachine;
var
  fil,fo:Textfile;
  I,J,K,L,L2,O,NStr:integer;
  NSlov,Prov:Byte;
  MyCode: ScriMachine;
  s2: masstr;
  DL:KDS;
  Stroka:String;
  BiCode:ScriMachine;
begin
  NStr:=LoadFile(fi);
  AssignFile(fil,fi); reset(fil);
  for J := 0 to NStr-1 do
    begin
        K:=Length(MyCode);
      readln(fil,stroka);
      if Length(stroka)>0 then
        begin
        DL:=ms(stroka, s2, nslov);
        if DL.N>0 then begin
        O:=K+DL.N;
        SetLength(MyCode,O+1);
          for i:= 1 to nslov do
            begin
              MyCode[K+i]:=TranslateCode(s2[i]);
            end;
        end;
        end;

    end;
    CloseFile(fil);


  //AssignFile(fo,'rashifrovka.txt'); rewrite(fo);
  L:= Length(MyCode);

  for I := 0 to L-1 do begin
     if MyCode[I]<>0 then
      begin
        L2:=Length(BiCode);
        inc(L2);
        SetLength(BiCode,L2);
        BiCode[L2-1]:= MyCode[I];
      end;
  end;

  Result:=BiCode;
  //CloseFile(fo);
end;

procedure LoadMainScript(MainDir:String);
begin
 // ReadScript();
end;


end.
