object FrmContaPagar: TFrmContaPagar
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Contas a Pagar'
  ClientHeight = 700
  ClientWidth = 950
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
    Top = 0
    Width = 950
    Height = 161
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lblEmissao: TLabel
      Left = 8
      Top = 61
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
      Top = 61
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
    object lblFornecedor: TLabel
      Left = 10
      Top = 111
      Width = 68
      Height = 15
      Caption = 'Fornecedor *'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 6
      Top = 23
      Width = 170
      Height = 32
      Caption = 'Contas a Pagar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtValorTotal: TEdit
      Left = 208
      Top = 82
      Width = 153
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object cmbFornecedor: TComboBox
      Left = 8
      Top = 132
      Width = 465
      Height = 23
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object chkFinalizada: TCheckBox
      Left = 367
      Top = 85
      Width = 81
      Height = 17
      Caption = 'Finalizada'
      Enabled = False
      TabOrder = 2
    end
    object dtpEmissao: TDateTimePicker
      Left = 8
      Top = 82
      Width = 186
      Height = 23
      Date = 46166.000000000000000000
      Time = 0.958089351850503600
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object pnlParcelas: TPanel
    Left = 0
    Top = 167
    Width = 950
    Height = 185
    BevelOuter = bvNone
    TabOrder = 1
    object lblParcelas: TLabel
      Left = 8
      Top = 19
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
      Left = 8
      Top = 46
      Width = 929
      Height = 110
      FixedCols = 0
      RowCount = 2
      TabOrder = 0
    end
    object btnAddParcela: TButton
      Left = 787
      Top = 10
      Width = 150
      Height = 30
      Caption = '+ Adicionar Parcela'
      TabOrder = 1
      OnClick = btnAddParcelaClick
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 346
    Width = 950
    Height = 56
    BevelOuter = bvNone
    TabOrder = 2
    object btnNovo: TButton
      Left = 267
      Top = 1
      Width = 123
      Height = 39
      Caption = 'Novo'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnSalvar: TButton
      Left = 686
      Top = 1
      Width = 123
      Height = 39
      Caption = 'Salvar'
      TabOrder = 1
      OnClick = btnSalvarClick
    end
    object btnFinalizar: TButton
      Left = 547
      Top = 1
      Width = 123
      Height = 39
      Caption = 'Finalizar'
      TabOrder = 2
      OnClick = btnFinalizarClick
    end
    object btnExcluir: TButton
      Left = 407
      Top = 1
      Width = 123
      Height = 39
      Caption = 'Excluir'
      TabOrder = 3
      OnClick = btnExcluirClick
    end
    object btnCancelar: TButton
      Left = 127
      Top = -1
      Width = 123
      Height = 39
      Caption = 'Cancelar'
      TabOrder = 4
      OnClick = btnCancelarClick
    end
  end
  object pnlConsulta: TPanel
    Left = -8
    Top = 408
    Width = 958
    Height = 294
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object lblFiltroEmissaoDe: TLabel
      Left = 14
      Top = 40
      Width = 60
      Height = 15
      Caption = 'Emiss'#227'o De'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblFiltroEmissaoAte: TLabel
      Left = 206
      Top = 40
      Width = 18
      Height = 15
      Caption = 'At'#233
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblFiltroValorDe: TLabel
      Left = 415
      Top = 39
      Width = 43
      Height = 15
      Caption = 'Valor De'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblFiltroValorAte: TLabel
      Left = 565
      Top = 39
      Width = 47
      Height = 15
      Caption = 'Valor At'#233
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblFiltroFornecedor: TLabel
      Left = 14
      Top = 90
      Width = 60
      Height = 15
      Caption = 'Fornecedor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblFiltroFinalizada: TLabel
      Left = 483
      Top = 90
      Width = 52
      Height = 15
      Caption = 'Finalizada'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 9
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
    object edtFiltroValorDe: TEdit
      Left = 415
      Top = 60
      Width = 144
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtFiltroValorAte: TEdit
      Left = 565
      Top = 60
      Width = 144
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object edtFiltroFornecedor: TEdit
      Left = 14
      Top = 111
      Width = 457
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object cmbFiltroFinalizada: TComboBox
      Left = 477
      Top = 111
      Width = 145
      Height = 23
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Items.Strings = (
        'Todos'
        'Sim'
        'Nao')
    end
    object btnBuscar: TButton
      Left = 634
      Top = 112
      Width = 145
      Height = 23
      Caption = 'Buscar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnBuscarClick
    end
    object grdContas: TStringGrid
      Left = 14
      Top = 141
      Width = 921
      Height = 108
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = grdContasClick
    end
    object dtpFiltroEmissaoDe: TDateTimePicker
      Left = 14
      Top = 61
      Width = 186
      Height = 23
      Date = 46166.000000000000000000
      Time = 0.958225844908156400
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object dtpFiltroEmissaoAte: TDateTimePicker
      Left = 206
      Top = 61
      Width = 186
      Height = 23
      Date = 46166.000000000000000000
      Time = 0.958275486111233500
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
  end
end
