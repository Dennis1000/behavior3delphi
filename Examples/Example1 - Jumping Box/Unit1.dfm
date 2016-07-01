object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Example 1 - Jumping Box'
  ClientHeight = 424
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 192
    Top = 152
    Width = 129
    Height = 57
    Brush.Color = clBlue
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 400
    Top = 64
  end
end
