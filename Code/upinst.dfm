object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'MG MapRedactor'
  ClientHeight = 87
  ClientWidth = 765
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object file1: TMenuItem
      Caption = 'file'
      object openMGEmap1: TMenuItem
        Caption = 'open MGE map'
      end
      object saveMGEmap1: TMenuItem
        Caption = 'save MGE map'
      end
      object close1: TMenuItem
        Caption = 'exid'
      end
    end
    object settings1: TMenuItem
      Caption = 'settings'
      object teme1: TMenuItem
        Caption = 'teme'
      end
      object properties1: TMenuItem
        Caption = 'properties'
      end
    end
    object info1: TMenuItem
      Caption = 'info'
      object about1: TMenuItem
        Caption = 'about'
      end
    end
  end
end
