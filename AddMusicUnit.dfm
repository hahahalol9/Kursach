object AddMusicForm: TAddMusicForm
  Left = 0
  Top = 0
  Caption = 'AddMusicForm'
  ClientHeight = 323
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object AddNewSong: TButton
    Left = 8
    Top = 258
    Width = 107
    Height = 57
    Caption = 'Add new'
    TabOrder = 0
    OnClick = AddNewSongClick
  end
  object RemoveSong: TButton
    Left = 166
    Top = 258
    Width = 107
    Height = 57
    Caption = 'Remove'
    TabOrder = 1
    OnClick = RemoveSongClick
  end
  object SongBox: TListBox
    Left = 8
    Top = 8
    Width = 265
    Height = 233
    ItemHeight = 13
    TabOrder = 2
  end
  object OpenSong: TOpenDialog
    Left = 272
    Top = 104
  end
end
