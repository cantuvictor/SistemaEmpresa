object FormContaReceber: TFormContaReceber
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Contas a Receber'
  ClientHeight = 661
  ClientWidth = 934
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlCabecalho: TPanel
    Left = 0
    Top = -13
    Width = 945
    Height = 161
    BevelOuter = bvNone
    TabOrder = 0
    object lblEmissao: TLabel
      Left = 8
      Top = 64
      Width = 94
      Height = 15
      Caption = 'Data de Emiss'#227'o *'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblValorTotal: TLabel
      Left = 208
      Top = 64
      Width = 63
      Height = 15
      Caption = 'Valor Total *'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblCliente: TLabel
      Left = 8
      Top = 114
      Width = 45
      Height = 15
      Caption = 'Cliente *'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 26
      Width = 196
      Height = 32
      Caption = 'Contas a Receber'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dtpEmissao: TDateTimePicker
      Left = 8
      Top = 85
      Width = 186
      Height = 23
      Date = 46166.000000000000000000
      Time = 0.977756111111375500
      TabOrder = 0
    end
    object edtValorTotal: TEdit
      Left = 208
      Top = 85
      Width = 153
      Height = 23
      TabOrder = 1
    end
    object cmbCliente: TComboBox
      Left = 8
      Top = 135
      Width = 465
      Height = 23
      Style = csDropDownList
      TabOrder = 2
    end
    object chkFinalizada: TCheckBox
      Left = 367
      Top = 88
      Width = 81
      Height = 17
      Caption = 'Finalizada'
      Enabled = False
      TabOrder = 3
    end
  end
  object pnlParcelas: TPanel
    Left = 0
    Top = 151
    Width = 937
    Height = 194
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 12
      Top = 13
      Width = 56
      Height = 21
      Caption = 'Parcelas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object grdParcelas: TStringGrid
      Left = 12
      Top = 38
      Width = 917
      Height = 120
      FixedCols = 0
      RowCount = 2
      TabOrder = 0
    end
    object btnAddParcela: TButton
      Left = 779
      Top = 3
      Width = 150
      Height = 30
      Caption = '+ Adicionar Parcela'
      TabOrder = 1
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 344
    Width = 937
    Height = 65
    BevelOuter = bvNone
    TabOrder = 2
    object btnNovo: TButton
      Tag = 8
      Left = 267
      Top = 19
      Width = 123
      Height = 39
      Caption = 'Novo'
      TabOrder = 0
    end
    object btnExcluir: TButton
      Tag = 8
      Left = 405
      Top = 19
      Width = 123
      Height = 39
      Caption = 'Excluir'
      TabOrder = 1
    end
    object btnCancelar: TButton
      Tag = 8
      Left = 127
      Top = 19
      Width = 123
      Height = 39
      Caption = 'Cancelar'
      TabOrder = 2
    end
    object btnFinalizar: TButton
      Tag = 8
      Left = 541
      Top = 19
      Width = 123
      Height = 39
      Caption = 'Finalizar'
      TabOrder = 3
    end
    object btnSalvar: TButton
      Tag = 8
      Left = 677
      Top = 19
      Width = 123
      Height = 39
      Caption = 'Salvar'
      TabOrder = 4
    end
  end
  object pnlConsulta: TPanel
    Left = 0
    Top = 408
    Width = 937
    Height = 249
    BevelOuter = bvNone
    TabOrder = 3
    object lblFiltroEmissaoDe: TLabel
      Left = 12
      Top = 32
      Width = 70
      Height = 15
      Caption = 'Emiss'#227'o De'
    end
    object lblFiltroEmissaoAte: TLabel
      Left = 200
      Top = 32
      Width = 18
      Height = 15
      Caption = 'At'#233
    end
    object lblFiltroValorAte: TLabel
      Left = 571
      Top = 32
      Width = 47
      Height = 15
      Caption = 'Valor At'#233
    end
    object lblFiltroCliente: TLabel
      Left = 8
      Top = 91
      Width = 37
      Height = 15
      Caption = 'Cliente'
    end
    object lblFiltroValorDe: TLabel
      Left = 416
      Top = 32
      Width = 43
      Height = 15
      Caption = 'Valor De'
    end
    object lblFiltroFinalizada: TLabel
      Left = 479
      Top = 91
      Width = 52
      Height = 15
      Caption = 'Finalizada'
    end
    object Label3: TLabel
      Left = 12
      Top = 1
      Width = 55
      Height = 25
      Caption = 'Filtros'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dtpFiltroEmissaoDe: TDateTimePicker
      Left = 8
      Top = 53
      Width = 186
      Height = 23
      Date = 46166.000000000000000000
      Time = 0.979704351848340600
      TabOrder = 0
    end
    object dtpFiltroEmissaoAte: TDateTimePicker
      Left = 199
      Top = 53
      Width = 186
      Height = 23
      Date = 46166.000000000000000000
      Time = 0.979741643517627400
      TabOrder = 1
    end
    object edtFiltroValorDe: TEdit
      Left = 416
      Top = 54
      Width = 144
      Height = 23
      TabOrder = 2
    end
    object edtFiltroCliente: TEdit
      Left = 8
      Top = 112
      Width = 465
      Height = 23
      TabOrder = 3
    end
    object edtFiltroValorAte: TEdit
      Left = 566
      Top = 54
      Width = 144
      Height = 23
      TabOrder = 4
    end
    object btnBuscar: TButton
      Left = 635
      Top = 110
      Width = 145
      Height = 23
      Caption = 'Buscar'
      TabOrder = 5
    end
    object grdContas: TStringGrid
      Left = 12
      Top = 141
      Width = 917
      Height = 91
      FixedCols = 0
      RowCount = 2
      TabOrder = 6
    end
    object cmbFiltroFinalizada: TComboBox
      Left = 479
      Top = 112
      Width = 145
      Height = 23
      TabOrder = 7
      Items.Strings = (
        'Todos'
        'Sim'
        'N'#227'o')
    end
  end
end
