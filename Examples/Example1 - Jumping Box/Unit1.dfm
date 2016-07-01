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
  object Label1: TLabel
    Left = 8
    Top = 27
    Width = 357
    Height = 13
    Caption = 
      'http://guineashots.com/2014/10/25/implementing-a-behavior-tree-p' +
      'art-2/'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 119
    Height = 13
    Caption = 'Example 1-  Jumping Box'
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 400
    Top = 64
  end
end
