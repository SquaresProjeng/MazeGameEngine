object Form1: TForm1
  AlignWithMargins = True
  Left = 0
  Top = 0
  AlphaBlendValue = 100
  BiDiMode = bdLeftToRight
  BorderStyle = bsNone
  Caption = 'MazeGameEngine v1.01b'
  ClientHeight = 794
  ClientWidth = 1227
  Color = clSilver
  TransparentColorValue = clNone
  Ctl3D = False
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poDesktopCenter
  PrintScale = poNone
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 32
  end
  object DrawGrGL: TTimer
    Interval = 30
    OnTimer = FormPaint
  end
  object PhisicsTimer: TTimer
    Interval = 10
    OnTimer = PhizProcessTimer
    Left = 64
  end
  object Timer2: TTimer
    Tag = 4000
    Interval = 5000
    OnTimer = Timer2Timer
    Left = 96
  end
  object Timer3: TTimer
    Tag = 100
    Interval = 200
    OnTimer = Timer3Timer
    Left = 128
  end
  object Timer4: TTimer
    Interval = 100
    Left = 160
  end
  object Timer5: TTimer
    Interval = 50
    Left = 192
  end
end
