unit Mesh;

interface

uses
  Windows, Messages, Classes, Graphics, Forms, ExtCtrls, Menus,
  Controls, Dialogs, SysUtils, OpenGL, Math;

Type
    PGLVertex = ^TGLVertex;
    TGLVertex = record
       x,y,z : GLFloat;
    end;

    PGLVector = ^TGLVector;
    TGLVector = array[0..2] of GLFloat;

    PGLFace = ^TGLFace;
    TGLFace = array[0..2] of GLInt;

    PGLVertexArray = ^TGLVertexArray;
    TGLVertexArray = array[Word] of TGLVertex;

    PGLFacesArray = ^TGLFacesArray;
    TGLFacesArray = array[word] of TGLFace;

    TGLMultyMesh = class;

    TGLMesh = class
      Vertices : PGLVertexArray; // Массив вершин
      Faces : PGLFacesArray;   // Массив граней
      FasetNormals : PGLVertexArray; // Массив фасетных нормалей
      SmoothNormals : PGLVertexArray; // Массив сглаживающих нормалей
      VertexCount : Integer;  // Число вершин
      FacesCount : Integer;   // Число граней
      fExtent : GLFloat;      // Масштабный коэффициент
      Extent : GLBoolean;     // Флаг масштабирования
      Parent : TGLMultyMesh;
      public
      procedure LoadFromFile( const FileName : String );
      procedure CalcNormals;
      procedure Draw(Smooth,Textured : Boolean);
      destructor Destroy; override;
    end;

    TGLMultyMesh = class
      Meshes : TList;  // Сетки
      CurrentFrame : Integer; // Текущий кадр
      Action : Boolean;       // Статус анимации (вкл/выкл)
      fExtent : GLFloat;      // Масштаб
      Extent : Boolean;       // Масштабировать?
      fSmooth : Boolean;      // сглаживать?
      TexVertices : PGLVertexArray; // Массив вершин текстуры
      TexFaces : PGLFacesArray;  // Массив граней текстуры
      TexVCount, TexFCount : Integer; // Количество вершин и граней текстуры
      TexturePresent : Boolean;
      public
      procedure LoadFromFile( const FileName : String );
      procedure Draw;
      constructor Create;
      destructor Destroy; override;
      published
    end;

    function Max(v1,v2:GLFloat):GLFloat;

implementation

function Max(v1,v2:GLFloat) : GLFloat;
begin
  if v1 >= v2 then result := v1
  else result := v2;
end;

procedure TGLMesh.CalcNormals;
var
  i : Integer;
  wrki, vx1, vy1, vz1, vx2, vy2, vz2 : GLfloat;
  nx, ny, nz : GLfloat;
  wrkVector : TGLVertex;
  wrkVector1, wrkVector2, wrkVector3 : TGLVertex;
  wrkFace : TGLFace;
begin
  For i := 0 to FacesCount - 1 do begin
     wrkFace := Faces[i];
     wrkVector1 := Vertices[wrkFace[0]];
     wrkVector2 := Vertices[wrkFace[1]];
     wrkVector3 := Vertices[wrkFace[2]];

     vx1 := wrkVector1.x - wrkVector2.x;
     vy1 := wrkVector1.y - wrkVector2.y;
     vz1 := wrkVector1.z*fExtent - wrkVector2.z*fExtent;

     vx2 := wrkVector2.x - wrkVector3.x;
     vy2 := wrkVector2.y - wrkVector3.y;
     vz2 := wrkVector2.z - wrkVector3.z;

     // вектор перпендикулярен центру треугольника
     nx := vy1 * vz2 - vz1 * vy2;
     ny := vz1 * vx2 - vx1 * vz2;
     nz := vx1 * vy2 - vy1 * vx2;

     // получаем унитарный вектор единичной длины
     wrki := sqrt (nx * nx + ny * ny + nz * nz);
     If wrki = 0 then wrki := 1; // для предотвращения деления на ноль

     wrkVector.x := nx / wrki;
     wrkVector.y := ny / wrki;
     wrkVector.z := nz / wrki;

     FasetNormals[i] := wrkVector;
  end;
end;

procedure TGLMesh.LoadFromFile;
var
   f : TextFile;
   S : String;
   i : Integer;
   Vertex : TGLVertex;
   Normal : TGLVertex;
   SNormal : TGLVertex;
   Face : TGLFace;
   MaxVertex : GLFloat;
begin
   AssignFile(f,FileName);
   Reset(f);
   repeat
     ReadLn(f, S);
   until (S = 'numverts numfaces') or eof(f);
   // Читаем количество вершин и граней
   Readln(f,VertexCount,FacesCount);
   // Выделяем память для хранения сетки
   GetMem(Vertices,VertexCount*SizeOf(TGLVertex));
   GetMem(SmoothNormals,VertexCount*SizeOf(TGLVector));
   GetMem(Faces,FacesCount*SizeOf(TGLFace));
   GetMem(FasetNormals,FacesCount*SizeOf(TGLVector));

   ReadLn(f, S); // Пропускаем строку Mesh vertices:
   // Считываем вершины
   for i := 0 to VertexCount - 1 do
     begin
       Readln(f,Vertex.x,Vertex.y,Vertex.z);
       Vertices[i] := Vertex;
     end;

   ReadLn(f, S); // Пропустим строку end vertices
   ReadLn(f, S); // Пропустим строку Mesh faces:
   // Считываем грани
   for i := 0 to FacesCount - 1 do
     begin
       Readln(f,Face[0],Face[1],Face[2]);
       Face[0] := Face[0] - 1;
       Face[1] := Face[1] - 1;
       Face[2] := Face[2] - 1;
       Faces[i] := Face;
     end;

   ReadLn(f, S); // Пропустим строку end faces
   ReadLn(f, S); // Пропустим строку Faset normals:
   // фасетные нормали
   for i := 0 to FacesCount - 1 do
     begin
       Readln(f,Normal.x,Normal.y,Normal.z);
       FasetNormals[i] := Normal;
     end;

   ReadLn(f, S); // Пропустим строку end faset normals
   ReadLn(f, S); // Пропустим строку Smooth normals:
   // Считываем сглаживающие нормали
   for i := 0 to VertexCount - 1 do
     begin
       Readln(f,SNormal.x,SNormal.y,SNormal.z);
       SmoothNormals[i] := SNormal;
     end;

   CloseFile(f);

   // Рассчитываем масштаб
   MaxVertex := 0;
   for i := 0 to VertexCount - 1 do
     begin
       MaxVertex := Max(MaxVertex,Vertices[i].x);
       MaxVertex := Max(MaxVertex,Vertices[i].y);
       MaxVertex := Max(MaxVertex,Vertices[i].z);
     end;
   fExtent := MaxVertex;

 //  CalcNormals;
end;

procedure TGLMesh.Draw(Smooth, Textured: Boolean);
var
   i : Integer;
   Face,TexFace : TGLFace;
   TexVertex : TGLVertex;
begin
  for i := 0 to FacesCount - 1 do begin
    glBegin(GL_TRIANGLES);
      Face := Faces[i];
      if Smooth then begin
        glNormal3fv(@SmoothNormals[Face[0]]);
        if Textured then begin
           TexFace := Parent.TexFaces[i];
           TexVertex := Parent.TexVertices[TexFace[0]];
           glTexCoord2f(TexVertex.x,1-TexVertex.y);
        end;
        glVertex3fv(@Vertices[Face[0]]);
        glNormal3fv(@SmoothNormals[Face[1]]);
        if Textured then begin
           TexFace := Parent.TexFaces[i];
           TexVertex := Parent.TexVertices[TexFace[1]];
           glTexCoord2f(TexVertex.x,1-TexVertex.y);
        end;
        glVertex3fv(@Vertices[Face[1]]);
        glNormal3fv(@SmoothNormals[Face[2]]);
        if Textured then begin
           TexFace := Parent.TexFaces[i];
           TexVertex := Parent.TexVertices[TexFace[2]];
           glTexCoord2f(TexVertex.x,1-TexVertex.y);
        end;
        glVertex3fv(@Vertices[Face[2]]);
      end else begin
        glNormal3fv(@FasetNormals[i]);
        if Textured then begin
           TexFace := Parent.TexFaces[i];
           TexVertex := Parent.TexVertices[TexFace[0]];
           glTexCoord2f(TexVertex.x,1-TexVertex.y);
        end;
        glVertex3fv(@Vertices[Face[0]]);
        if Textured then begin
           TexFace := Parent.TexFaces[i];
           TexVertex := Parent.TexVertices[TexFace[1]];
           glTexCoord2f(TexVertex.x,1-TexVertex.y);
        end;
        glVertex3fv(@Vertices[Face[1]]);
        if Textured then begin
           TexFace := Parent.TexFaces[i];
           TexVertex := Parent.TexVertices[TexFace[2]];
           glTexCoord2f(TexVertex.x,1-TexVertex.y);
        end;
        glVertex3fv(@Vertices[Face[2]]);
      end;
    glEnd;
  end;
end;

destructor TGLMesh.Destroy;
begin
   FreeMem(Vertices,VertexCount*SizeOf(TGLVertex));
   FreeMem(SmoothNormals,VertexCount*SizeOf(TGLVertex));
   FreeMem(Faces,FacesCount*SizeOf(TGLFace));
   FreeMem(FasetNormals,FacesCount*SizeOf(TGLVector));
end;

procedure TGLMultyMesh.LoadFromFile;
var
   f : TextFile;
   S : String;
   procedure ReadNextMesh(AParent : TGLMultyMesh);
     var
        i : Integer;
   	Vertex : TGLVertex;
   	Face : TGLFace;
        Normal : TGLVertex;
   	MaxVertex : GLFloat;
        NextMesh : TGLMesh;
     begin
        NextMesh := TGLMesh.Create;
        repeat
          ReadLn(f, S);
        until (S = 'numverts numfaces') or eof(f);
        // Читаем количество вершин и граней
        Readln(f,NextMesh.VertexCount,NextMesh.FacesCount);
        // Выделяем память для хранения сетки
        GetMem(NextMesh.Vertices,NextMesh.VertexCount*SizeOf(TGLVertex));
        GetMem(NextMesh.SmoothNormals,NextMesh.VertexCount*SizeOf(TGLVector));
        GetMem(NextMesh.Faces,NextMesh.FacesCount*SizeOf(TGLFace));
        GetMem(NextMesh.FasetNormals,NextMesh.FacesCount*SizeOf(TGLVector));

        ReadLn(f,S); // Пропускаем строку Mesh vertices:
        // Считываем вершины
        for i := 0 to NextMesh.VertexCount - 1 do
          begin
            Readln(f,Vertex.x,Vertex.y,Vertex.z);
            NextMesh.Vertices[i] := Vertex;
          end;

        ReadLn(f,S); // Пропускаем строку end vertices
        ReadLn(f,S); // Пропускаем строку Mesh faces:
        // Считываем грани
        for i := 0 to NextMesh.FacesCount - 1 do
          begin
            Readln(f,Face[0],Face[1],Face[2]);
            Face[0] := Face[0] - 1;
            Face[1] := Face[1] - 1;
            Face[2] := Face[2] - 1;
            NextMesh.Faces[i] := Face;
          end;
          ReadLn(f,S); // Пропускаем строку end faces
          ReadLn(f,S); // Пропускаем строку Faset Normals:
        for i := 0 to NextMesh.FacesCount - 1 do
          begin
            Readln(f,Normal.x,Normal.y,Normal.z);
            NextMesh.FasetNormals[i] := Normal;
          end;

          ReadLn(f,S); // Пропускаем строку end faset normals
          ReadLn(f,S); // Пропускаем строку SmoothNormals:
          // Считываем сглаживающие нормали
          for i := 0 to NextMesh.VertexCount - 1 do
            begin
              Readln(f,Normal.x,Normal.y,Normal.z);
              NextMesh.SmoothNormals[i] := Normal;
            end;
       // Рассчитываем масштаб
     MaxVertex := 0;
     for i := 0 to NextMesh.VertexCount - 1 do  //
         begin
           MaxVertex := Max(MaxVertex,NextMesh.Vertices[i].x);
           MaxVertex := Max(MaxVertex,NextMesh.Vertices[i].y);
           MaxVertex := Max(MaxVertex,NextMesh.Vertices[i].z);
         end;
       NextMesh.fExtent := 1/MaxVertex;

       NextMesh.Parent := AParent;

       Meshes.Add(NextMesh);
     end;

   Procedure ReadTextureBlock;
   var
      i : Integer;
      Vertex : TGLVertex;
      Face : TGLFace;
   begin
     Readln(f,S);
     Readln(f,TexVCount,TexFCount);

     if Assigned(TexVertices) then FreeMem(TexVertices);
     if Assigned(TexFaces) then FreeMem(TexFaces);

     GetMem(TexVertices,TexVCount*SizeOf(TGLVertex));
     GetMem(TexFaces,TexFCount*SizeOf(TGLFace));

     Readln(f,S);

     if S <> 'Texture vertices:' then begin
       ShowMessage('Texture not present!');
       TexturePresent := False;
       Exit;
     end;

     for i := 0 to TexVCount - 1 do begin
       Readln(f,Vertex.x,Vertex.y,Vertex.z);
       TexVertices[i] := Vertex;
     end;

     Readln(f,S);// Пропускаем строку "end texture vertices"
     Readln(f,S);// Пропускаем строку "Texture faces:"

     for i := 0 to TexFCount - 1 do begin
       Readln(f,Face[0],Face[1],Face[2]);
       Face[0] := Face[0] - 1;
       Face[1] := Face[1] - 1;
       Face[2] := Face[2] - 1;
       TexFaces[i] := Face;
     end;

     TexturePresent := True;
   end;

begin
   Meshes := TList.Create;
   AssignFile(f,FileName);
   Reset(f);
   While not Eof(f) do begin
     Readln(f,S);
     if S = 'New object' then ReadNextMesh(Self);
     if S = 'New Texture:' then ReadTextureBlock;
   end;
   CloseFile(f);
end;

procedure TGLMultyMesh.Draw;
begin
  if Extent then
     begin
       fExtent := TGLMesh(Meshes.Items[CurrentFrame]).fExtent;
       glScalef(fExtent,fExtent,fExtent);
     end;

  TGLMesh(Meshes.Items[CurrentFrame]).Draw(fSmooth,TexturePresent);

  if Action then begin
    inc(CurrentFrame);
    if CurrentFrame > (Meshes.Count - 1) then CurrentFrame := 0;
  end;
end;

constructor TGLMultyMesh.Create;
begin
  Action := False;
  CurrentFrame := 0;
end;

destructor TGLMultyMesh.Destroy;
Var i : Integer;
begin
  for i := 0 to Meshes.Count - 1 do
    begin
      TGLMesh(Meshes.Items[i]).Destroy;
    end;
  Meshes.Free;
end;

end.
