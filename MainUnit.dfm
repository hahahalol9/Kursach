object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Fancy Typing'
  ClientHeight = 300
  ClientWidth = 1400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 1400
    Height = 300
    TabOrder = 0
  end
  object MainMenu: TMainMenu
    Left = 477
    Top = 183
    object exts1: TMenuItem
      Caption = 'Texts'
      object EnglishMenu: TMenuItem
        Caption = 'English'
        ImageName = 'fsdfadfasfdaf'
      end
      object RussianMenu: TMenuItem
        Caption = 'Russian'
      end
      object OtherMenu: TMenuItem
        Caption = 'Other'
      end
    end
    object AddTextItem: TMenuItem
      Caption = 'Add text'
      OnClick = AddTextItemClick
    end
    object Statistic1: TMenuItem
      Caption = 'Statistic'
      OnClick = Statistic1Click
    end
    object Music1: TMenuItem
      Caption = 'Music'
      object Next: TMenuItem
        Caption = 'Next'
        ShortCut = 112
        OnClick = NextClick
      end
      object Stop: TMenuItem
        Caption = 'Stop'
        ShortCut = 113
        OnClick = StopClick
      end
      object Continue: TMenuItem
        Caption = 'Continue'
        ShortCut = 114
        OnClick = ContinueClick
      end
      object AddVolume: TMenuItem
        Caption = 'Add Volume'
        ShortCut = 115
        OnClick = AddVolumeClick
      end
      object LowerVolume: TMenuItem
        Caption = 'Lower Volume'
        ShortCut = 116
        OnClick = LowerVolumeClick
      end
    end
    object S1: TMenuItem
      Caption = 'Settings'
      OnClick = S1Click
    end
    object Instruction1: TMenuItem
      Caption = 'Instruction'
      OnClick = Instruction1Click
    end
  end
end
