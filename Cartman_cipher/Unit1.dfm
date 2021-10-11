object Form1: TForm1
  Left = 234
  Top = 125
  BorderStyle = bsSingle
  Caption = 'Cartman Delphi'
  ClientHeight = 377
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 321
    Height = 25
    Caption = 'Test cipher'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 40
    Width = 321
    Height = 329
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
