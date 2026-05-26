object FormPessoa: TFormPessoa
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Pessoas'
  ClientHeight = 611
  ClientWidth = 886
  Color = clWhitesmoke
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlCadastro: TPanel
    Left = 0
    Top = -6
    Width = 897
    Height = 323
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object lblCep: TLabel
      Left = 279
      Top = 176
      Width = 21
      Height = 15
      Caption = 'CEP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblCidade: TLabel
      Left = 279
      Top = 234
      Width = 37
      Height = 15
      Caption = 'Cidade'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblCpfCnpj: TLabel
      Left = 16
      Top = 119
      Width = 61
      Height = 15
      Caption = 'CPF/CNPJ *'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblEmail: TLabel
      Left = 279
      Top = 118
      Width = 34
      Height = 15
      Caption = 'E-mail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblEndereco: TLabel
      Left = 16
      Top = 234
      Width = 49
      Height = 15
      Caption = 'Endere'#231'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblEstado: TLabel
      Left = 451
      Top = 234
      Width = 14
      Height = 15
      Caption = 'UF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblNome: TLabel
      Left = 16
      Top = 65
      Width = 41
      Height = 15
      Caption = 'Nome *'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblTelefone: TLabel
      Left = 16
      Top = 176
      Width = 45
      Height = 15
      Caption = 'Telefone'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblTipo: TLabel
      Left = 279
      Top = 63
      Width = 32
      Height = 15
      Caption = 'Tipo *'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblCadastro: TLabel
      Left = 16
      Top = 18
      Width = 248
      Height = 37
      Caption = 'Cadastro de Pessoa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -27
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 439
      Top = 253
      Width = 6
      Height = 21
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnBuscarCep: TButton
      Left = 406
      Top = 197
      Width = 66
      Height = 23
      Caption = 'Buscar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = False
      OnClick = btnBuscarCepClick
    end
    object cmbTipo: TComboBox
      Left = 279
      Top = 86
      Width = 193
      Height = 23
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Items.Strings = (
        'Cliente'
        'Fornecedor'
        'Ambos')
    end
    object edtCep: TEdit
      Left = 279
      Top = 197
      Width = 121
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnKeyPress = ApenasNumerosKeyPress
    end
    object edtCidade: TEdit
      Left = 279
      Top = 257
      Width = 154
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object edtCpfCnpj: TEdit
      Left = 16
      Top = 138
      Width = 193
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnKeyPress = ApenasNumerosKeyPress
    end
    object edtEmail: TEdit
      Left = 279
      Top = 138
      Width = 193
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object edtEndereco: TEdit
      Left = 16
      Top = 255
      Width = 213
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object edtEstado: TEdit
      Left = 451
      Top = 257
      Width = 21
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object edtNome: TEdit
      Left = 16
      Top = 86
      Width = 193
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object edtTelefone: TEdit
      Left = 16
      Top = 197
      Width = 193
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 315
    Width = 897
    Height = 72
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object btnCancelar: TButton
      Left = 177
      Top = 8
      Width = 123
      Height = 39
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = False
      OnClick = btnCancelarClick
    end
    object btnExcluir: TButton
      Left = 470
      Top = 8
      Width = 123
      Height = 39
      Caption = 'Excluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TabStop = False
      OnClick = btnExcluirClick
    end
    object btnSalvar: TButton
      Left = 616
      Top = 8
      Width = 123
      Height = 39
      Caption = 'Salvar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TabStop = False
      OnClick = btnSalvarClick
    end
    object btnNovo: TButton
      Left = 322
      Top = 8
      Width = 123
      Height = 39
      Caption = 'Novo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      TabStop = False
      OnClick = btnNovoClick
    end
  end
  object pnlGrid: TPanel
    Left = -12
    Top = 378
    Width = 901
    Height = 234
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    object lblFiltroNome: TLabel
      Left = 22
      Top = 24
      Width = 33
      Height = 15
      Caption = 'Nome'
    end
    object lblFiltroTipo: TLabel
      Left = 223
      Top = 25
      Width = 24
      Height = 15
      Align = alCustom
      Caption = 'Tipo'
    end
    object lblFiltroCpf: TLabel
      Left = 377
      Top = 25
      Width = 53
      Height = 15
      Align = alCustom
      Caption = 'CPF/CNPJ'
    end
    object lblFiltroCidade: TLabel
      Left = 507
      Top = 24
      Width = 37
      Height = 15
      Align = alCustom
      Caption = 'Cidade'
    end
    object lblFiltroEstado: TLabel
      Left = 645
      Top = 24
      Width = 14
      Height = 15
      Align = alCustom
      Caption = 'UF'
    end
    object lblFiltros: TLabel
      Left = 22
      Top = -7
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
    object Label2: TLabel
      Left = 632
      Top = 45
      Width = 10
      Height = 18
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtFiltroNome: TEdit
      Left = 22
      Top = 45
      Width = 191
      Height = 23
      TabOrder = 0
    end
    object cmbFiltroTipo: TComboBox
      Left = 223
      Top = 46
      Width = 145
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      Items.Strings = (
        'Todos'
        'Clientes'
        'Fornecedor'
        'Ambos')
    end
    object btnBuscar: TButton
      Left = 679
      Top = 46
      Width = 162
      Height = 23
      Caption = 'Buscar'
      TabOrder = 2
      TabStop = False
      OnClick = btnBuscarClick
    end
    object grdPessoas: TStringGrid
      Left = 22
      Top = 83
      Width = 859
      Height = 148
      ColCount = 6
      FixedCols = 0
      RowCount = 2
      TabOrder = 3
      OnClick = grdPessoasClick
    end
    object edtFiltroCpf: TEdit
      Left = 377
      Top = 46
      Width = 121
      Height = 23
      TabOrder = 4
      OnKeyPress = ApenasNumerosKeyPress
    end
    object edtFiltroCidade: TEdit
      Left = 507
      Top = 45
      Width = 121
      Height = 23
      TabOrder = 5
    end
    object edtFiltroEstado: TEdit
      Left = 643
      Top = 45
      Width = 23
      Height = 23
      TabOrder = 6
    end
  end
end
