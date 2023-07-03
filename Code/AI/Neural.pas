unit Neural;

interface
uses Math;

type
  NeuralSystem = record
  x: array of real;
  w: array of real;
  y: real;
  err: real;
  CIN: integer;
  public
   procedure Init(countInputNeural: integer);
   function Learn(xInput: array of real; yInput: real): real;
   function Active(xInput: array of real): real;
end;


Implementation

procedure NeuralSystem.Init(countInputNeural: integer);
var I:integer;
begin
  CIN := countInputNeural;
  SetLength(X,CIN);
  SetLength(W,CIN);
  x[CIN-1]:=countInputNeural;
  w[CIN-1]:=countInputNeural;
  for i := 0 to countInputNeural - 1 do
  w[i] := -1+random(201)/100;
end;


function NeuralSystem.Learn(xInput: array of real; yInput: real): real;
var
  yCopy: real;
  i:integer;
begin
  err := 0;
  yCopy := 0;
    for i := 0 to CIN - 1 do
  yCopy:=yCopy+ (xInput[i] * w[i]);
  yCopy := 1 / (1 + exp(-yCopy));
  err := yInput - yCopy;
    for i := 0 to CIN - 1 do
  w[i]:=w[i]+(err * 0.5 * xInput[i]);
  result := err;
end;

function NeuralSystem.Active(xInput: array of real): real;
var
  I:integer;
begin
  y := 0;
  for i := 0 to CIN - 1 do x[i] := xInput[i];
  for i := 0 to CIN - 1 do y:=y+x[i]*w[i];
  y:= 1/(1 + exp(-y));
  result := y;
end;


end.