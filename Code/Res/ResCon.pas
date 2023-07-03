unit ResCon;

interface
uses
  Classes, Math;

Const
{  Ресурсы для OpenGL }
  GL_CLAMP_TO_EDGE =$812F;
  GL_POLYGON_OFFSET_FILL  = $8037;
{ коды клавиш }
  VK_W = $57;   VK_1 = $31;
  VK_S = $53;   VK_2 = $32;
  VK_D = $44;   VK_3 = $33;
  VK_A = $41;   VK_4 = $34;
  VK_B = $42;   VK_F = $46;

  VK_G = $47;   VK_I = $49;
  VK_H = $48;   VK_L = $4C;
  VK_M = $4D;   VK_N = $4E;
  VK_O = $4F;   VK_P = $50;
  VK_T = $54;   VK_V = $56;
  VK_Y = $59;   VK_K = $4B;

  VK_X = $58;   VK_Q = $51;
  VK_E = $45;   VK_C = $43;
  VK_U = $55;   VK_Z = $5A;
  VK_J = $4A;   VK_R = $52;

  VK_5 = $35;   VK_6 = $36;
  VK_7 = $37;   VK_8 = $38;
  VK_9 = $39;   VK_0 = $30;

  VK_YO     =  $C0;   VK_PLUS     = $BB;
  VK_MIN    =  $BD;   VK_RX       = $DB;
  VK_RTZ    =  $DD;   VK_RG       = $BA;
  VK_R3     =  $DE;   VK_RB       = $BC;
  VK_RIO    =  $BE;   VK_RTOCHKA  = $BF;
  VK_PALKA  =  $DC;

  VK_F1 = $70;
  VK_F2 = $71;
  VK_F3 = $72;
  VK_F4 = $73;
  VK_F5 = $74;
  VK_F6 = $75;
  VK_F7 = $76;
  VK_F8 = $77;
  VK_F9 = $78;
  VK_F10 = $79;

  VK_SPACE =  $20;
  VK_RETURN = $0D;
  VK_BACK =  $8;
  VK_TAB =   $9;
  VK_CAPS = $14;
  VK_CTRL = $11;
  VK_ALT =  $12;
  VK_ESC =  $1B;
  VK_PU =   $21;
  VK_PD =  $22;
  VK_END =  $23;
  VK_DEL = $2E;

  { коды материалов }
  steklo  = 0;
  mettal  = 1;
  plastic = 2;



implementation

end.
