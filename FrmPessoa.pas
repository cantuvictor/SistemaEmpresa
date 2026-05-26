unit FrmPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, System.Net.HttpClient, System.JSON,
  FireDAC.Comp.Client, DataModule, ModelPessoa, ControllerPessoa, Constantes, System.Generics.Collections;

type
  TFormPessoa = class(TForm)
    lblNome: TLabel;
    lblTipo: TLabel;
    lblEmail: TLabel;
    lblCpfCnpj: TLabel;
    lblCep: TLabel;
    lblTelefone: TLabel;
    lblCidade: TLabel;
    lblEndereco: TLabel;
    lblEstado: TLabel;
    edtNome: TEdit;
    edtCpfCnpj: TEdit;
    edtEmail: TEdit;
    edtEndereco: TEdit;
    edtCep: TEdit;
    edtTelefone: TEdit;
    edtCidade: TEdit;
    cmbTipo: TComboBox;
    edtEstado: TEdit;
    btnNovo: TButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    btnExcluir: TButton;
    btnBuscarCep: TButton;
    pnlCadastro: TPanel;
    lblCadastro: TLabel;
    pnlBotoes: TPanel;
    pnlGrid: TPanel;
    lblFiltroNome: TLabel;
    lblFiltroTipo: TLabel;
    edtFiltroNome: TEdit;
    edtFiltroCpf: TEdit;
    edtFiltroCidade: TEdit;
    edtFiltroEstado: TEdit;
    cmbFiltroTipo: TComboBox;
    btnBuscar: TButton;
    grdPessoas: TStringGrid;
    Label1: TLabel;
    lblFiltros: TLabel;
    Label2: TLabel;
    procedure btnBuscarCepClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdPessoasClick(Sender: TObject);
    procedure ApenasNumerosKeyPress(Sender: TObject; var Key: Char);
  private
    FIdSelecionado: Integer;
    FController: TControllerPessoa;
    procedure ConfigurarGrid;
    procedure CarregarGrid;
    procedure LimparCampos;
    procedure PreencherCampos(AId: Integer);
    procedure PreencherPessoa(APessoa: TPessoa);
    function ObterPessoaDaTela: TPessoa;
    function ValidarCampos: Boolean;
    function ValidarCPFCNPJ(const ADoc: string): Boolean;
    function ValidarEmail(const AEmail: string): Boolean;
    function ApenasNumeros(const S: string): string;
    function FormatarCep(const ACep: string): string;
    function FormatarCpfCnpj(const ADoc: string): string;
    procedure BuscarCep(const ACep: string);
    function TipoParaIndice(const ATipo: string): Integer;
    function IndiceParaTipo(const AIndice: Integer): string;
  public
    destructor Destroy; override;
  end;

var
  FormPessoa: TFormPessoa;

implementation

{$R *.dfm}

destructor TFormPessoa.Destroy;
begin
  FController.Free;
  inherited;
end;

procedure TFormPessoa.FormCreate(Sender: TObject);
begin
  FIdSelecionado := 0;
  FController := TControllerPessoa.Create;
  ConfigurarGrid;
  CarregarGrid;
end;

procedure TFormPessoa.ApenasNumerosKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

function TFormPessoa.ApenasNumeros(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    if S[i] in ['0'..'9'] then
      Result := Result + S[i];
end;

function TFormPessoa.FormatarCep(const ACep: string): string;
var
  sCep: string;
begin
  sCep := ApenasNumeros(ACep);
  if Length(sCep) = 8 then
    Result := Copy(sCep, 1, 5) + '-' + Copy(sCep, 6, 3)
  else
    Result := sCep;
end;

function TFormPessoa.FormatarCpfCnpj(const ADoc: string): string;
var
  sDoc: string;
begin
  sDoc := ApenasNumeros(ADoc);
  if Length(sDoc) = 11 then
    Result :=
      Copy(sDoc, 1, 3) + '.' +
      Copy(sDoc, 4, 3) + '.' +
      Copy(sDoc, 7, 3) + '-' +
      Copy(sDoc, 10, 2)
  else if Length(sDoc) = 14 then
    Result :=
      Copy(sDoc, 1, 2) + '.' +
      Copy(sDoc, 3, 3) + '.' +
      Copy(sDoc, 6, 3) + '/' +
      Copy(sDoc, 9, 4) + '-' +
      Copy(sDoc, 13, 2)
  else
    Result := sDoc;
end;

function TFormPessoa.TipoParaIndice(const ATipo: string): Integer;
begin
  if ATipo = 'C' then Result := 0
  else if ATipo = 'F' then Result := 1
  else if ATipo = 'A' then Result := 2
  else Result := -1;
end;

function TFormPessoa.IndiceParaTipo(const AIndice: Integer): string;
begin
  case AIndice of
    0: Result := 'C';
    1: Result := 'F';
    2: Result := 'A';
  else
    Result := '';
  end;
end;

function TFormPessoa.ValidarEmail(const AEmail: string): Boolean;
var
  sEmail: string;
  iPosArroba, iPosPonto: Integer;
begin
  Result := False;
  sEmail := Trim(AEmail);

  if sEmail = '' then
    Exit;

  iPosArroba := Pos('@', sEmail);
  if iPosArroba < 2 then
    Exit;

  iPosPonto := LastDelimiter('.', sEmail);
  if iPosPonto <= iPosArroba then
    Exit;

  if iPosPonto >= Length(sEmail) then
    Exit;

  Result := True;
end;

function TFormPessoa.ValidarCPFCNPJ(const ADoc: string): Boolean;
var
  sDoc: string;
  i, soma, resto: Integer;
  pesos: array of Integer;
begin
  Result := False;
  sDoc := ApenasNumeros(ADoc);

  if (Length(sDoc) <> 11) and (Length(sDoc) <> 14) then
    Exit;

  if Length(sDoc) = 11 then
  begin
    soma := 0;
    for i := 1 to 9 do
      soma := soma + StrToInt(sDoc[i]) * (11 - i);
    resto := (soma * 10) mod 11;
    if resto = 10 then resto := 0;
    if resto <> StrToInt(sDoc[10]) then Exit;

    soma := 0;
    for i := 1 to 10 do
      soma := soma + StrToInt(sDoc[i]) * (12 - i);
    resto := (soma * 10) mod 11;
    if resto = 10 then resto := 0;
    if resto <> StrToInt(sDoc[11]) then Exit;

    Result := True;
    Exit;
  end;

  pesos := [5,4,3,2,9,8,7,6,5,4,3,2];
  soma := 0;
  for i := 0 to 11 do
    soma := soma + StrToInt(sDoc[i+1]) * pesos[i];
  resto := soma mod 11;
  if resto < 2 then resto := 0 else resto := 11 - resto;
  if resto <> StrToInt(sDoc[13]) then Exit;

  pesos := [6,5,4,3,2,9,8,7,6,5,4,3,2];
  soma := 0;
  for i := 0 to 12 do
    soma := soma + StrToInt(sDoc[i+1]) * pesos[i];
  resto := soma mod 11;
  if resto < 2 then resto := 0 else resto := 11 - resto;
  if resto <> StrToInt(sDoc[14]) then Exit;

  Result := True;
end;

function TFormPessoa.ValidarCampos: Boolean;
begin
  Result := False;

  if Trim(edtNome.Text) = '' then
  begin
    ShowMessage(StrMsgNomeObrigatorio);
    edtNome.SetFocus;
    Exit;
  end;

  if cmbTipo.ItemIndex < 0 then
  begin
    ShowMessage(StrMsgTipoObrigatorio);
    cmbTipo.SetFocus;
    Exit;
  end;

  if not ValidarCPFCNPJ(edtCpfCnpj.Text) then
  begin
    ShowMessage(StrMsgCpfCnpjInvalido);
    edtCpfCnpj.SetFocus;
    Exit;
  end;

  if (Trim(edtEmail.Text) <> '') and (not ValidarEmail(edtEmail.Text)) then
  begin
    ShowMessage(StrMsgEmailInvalido);
    edtEmail.SetFocus;
    Exit;
  end;

  if FController.CpfCnpjDuplicado(ApenasNumeros(edtCpfCnpj.Text), FIdSelecionado) then
  begin
    ShowMessage(StrMsgCpfCnpjDuplicado);
    edtCpfCnpj.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TFormPessoa.ConfigurarGrid;
begin
  grdPessoas.Cells[0, 0] := 'ID';
  grdPessoas.Cells[1, 0] := 'Nome';
  grdPessoas.Cells[2, 0] := 'Tipo';
  grdPessoas.Cells[3, 0] := 'CPF/CNPJ';
  grdPessoas.Cells[4, 0] := 'E-mail';
  grdPessoas.Cells[5, 0] := 'Cidade/UF';

  grdPessoas.ColWidths[0] := 40;
  grdPessoas.ColWidths[1] := 200;
  grdPessoas.ColWidths[2] := 80;
  grdPessoas.ColWidths[3] := 130;
  grdPessoas.ColWidths[4] := 180;
  grdPessoas.ColWidths[5] := grdPessoas.ClientWidth
    - grdPessoas.ColWidths[0]
    - grdPessoas.ColWidths[1]
    - grdPessoas.ColWidths[2]
    - grdPessoas.ColWidths[3]
    - grdPessoas.ColWidths[4]
    - 5;
end;

procedure TFormPessoa.CarregarGrid;
var
  lista: TObjectList<TPessoa>;
  pessoa: TPessoa;
  iLinha, i: Integer;
  sTipo: string;
begin
  sTipo := IndiceParaTipo(cmbFiltroTipo.ItemIndex - 1);

  lista := FController.Buscar(
    Trim(edtFiltroNome.Text),
    sTipo,
    ApenasNumeros(edtFiltroCpf.Text),
    Trim(edtFiltroCidade.Text),
    Trim(edtFiltroEstado.Text));

  try
    grdPessoas.RowCount := 2;
    for i := 0 to 5 do
      grdPessoas.Cells[i, 1] := '';

    iLinha := 1;
    for i := 0 to lista.Count - 1 do
    begin
      pessoa := lista[i];
      grdPessoas.RowCount := iLinha + 1;
      grdPessoas.Cells[0, iLinha] := IntToStr(pessoa.Id);
      grdPessoas.Cells[1, iLinha] := pessoa.Nome;
      grdPessoas.Cells[2, iLinha] := pessoa.Tipo;
      grdPessoas.Cells[3, iLinha] := FormatarCpfCnpj(pessoa.CpfCnpj);
      grdPessoas.Cells[4, iLinha] := pessoa.Email;
      grdPessoas.Cells[5, iLinha] := pessoa.Cidade.Nome + '/' + pessoa.Cidade.Estado;
      Inc(iLinha);
    end;
  finally
    lista.Free;
  end;
end;

procedure TFormPessoa.LimparCampos;
begin
  FIdSelecionado := 0;
  edtNome.Text := '';
  cmbTipo.ItemIndex := -1;
  edtCpfCnpj.Text := '';
  edtEmail.Text := '';
  edtTelefone.Text := '';
  edtCep.Text := '';
  edtEndereco.Text := '';
  edtCidade.Text := '';
  edtEstado.Text := '';
  edtNome.SetFocus;
end;

procedure TFormPessoa.PreencherPessoa(APessoa: TPessoa);
begin
  FIdSelecionado     := APessoa.Id;
  edtNome.Text       := APessoa.Nome;
  edtCpfCnpj.Text    := FormatarCpfCnpj(APessoa.CpfCnpj);
  edtEmail.Text      := APessoa.Email;
  edtTelefone.Text   := APessoa.Telefone;
  edtCep.Text        := FormatarCep(APessoa.Cep);
  edtEndereco.Text   := APessoa.Endereco;
  edtCidade.Text     := APessoa.Cidade.Nome;
  edtEstado.Text     := APessoa.Cidade.Estado;
  cmbTipo.ItemIndex  := TipoParaIndice(APessoa.Tipo);
end;

procedure TFormPessoa.PreencherCampos(AId: Integer);
var
  pessoa: TPessoa;
begin
  pessoa := FController.BuscarPorId(AId);
  if not Assigned(pessoa) then
    Exit;
  try
    PreencherPessoa(pessoa);
  finally
    pessoa.Free;
  end;
end;

function TFormPessoa.ObterPessoaDaTela: TPessoa;
begin
  Result := TPessoa.Create;
  Result.Id            := FIdSelecionado;
  Result.Nome          := Trim(edtNome.Text);
  Result.Tipo          := IndiceParaTipo(cmbTipo.ItemIndex);
  Result.CpfCnpj       := ApenasNumeros(edtCpfCnpj.Text);
  Result.Email         := Trim(edtEmail.Text);
  Result.Telefone      := Trim(edtTelefone.Text);
  Result.Cep           := ApenasNumeros(edtCep.Text);
  Result.Endereco      := Trim(edtEndereco.Text);
  Result.Cidade.Nome   := Trim(edtCidade.Text);
  Result.Cidade.Estado := Trim(edtEstado.Text);
end;

procedure TFormPessoa.BuscarCep(const ACep: string);
var
  oHttp: THTTPClient;
  oResp: IHTTPResponse;
  oJson: TJSONObject;
  sCep: string;
begin
  sCep := ApenasNumeros(ACep);

  if Length(sCep) <> 8 then
  begin
    ShowMessage(StrMsgCepInvalido);
    Exit;
  end;

  oHttp := THTTPClient.Create;
  try
    try
      oResp := oHttp.Get('https://viacep.com.br/ws/' + sCep + '/json/');

      if oResp.StatusCode <> 200 then
      begin
        ShowMessage(StrMsgCepNaoEncontrado);
        Exit;
      end;

      oJson := TJSONObject.ParseJSONValue(oResp.ContentAsString) as TJSONObject;
      try
        if oJson = nil then
        begin
          ShowMessage(StrMsgCepErroProcessar);
          Exit;
        end;

        if oJson.GetValue('erro') <> nil then
        begin
          ShowMessage(StrMsgCepNaoEncontrado);
          Exit;
        end;

        edtEndereco.Text := oJson.GetValue('logradouro').Value;
        edtCidade.Text   := oJson.GetValue('localidade').Value;
        edtEstado.Text   := oJson.GetValue('uf').Value;

      finally
        oJson.Free;
      end;

    except
      on E: Exception do
        ShowMessage(StrMsgErroCep + E.Message);
    end;
  finally
    oHttp.Free;
  end;
end;

procedure TFormPessoa.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TFormPessoa.btnCancelarClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TFormPessoa.btnBuscarCepClick(Sender: TObject);
begin
  BuscarCep(edtCep.Text);
end;

procedure TFormPessoa.btnBuscarClick(Sender: TObject);
begin
  CarregarGrid;
end;

procedure TFormPessoa.grdPessoasClick(Sender: TObject);
var
  iId: Integer;
begin
  if grdPessoas.Row < 1 then
    Exit;

  if grdPessoas.Cells[0, grdPessoas.Row] = '' then
    Exit;

  iId := StrToIntDef(grdPessoas.Cells[0, grdPessoas.Row], 0);

  if iId = 0 then
    Exit;

  PreencherCampos(iId);
end;

procedure TFormPessoa.btnExcluirClick(Sender: TObject);
begin
  if FIdSelecionado = 0 then
  begin
    ShowMessage(StrMsgSelecioneExcluir);
    Exit;
  end;

  if MessageDlg(StrMsgConfirmaExclusao,
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    FController.Excluir(FIdSelecionado);
    LimparCampos;
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFormPessoa.btnSalvarClick(Sender: TObject);
var
  pessoa: TPessoa;
begin
  if not ValidarCampos then
    Exit;

  pessoa := ObterPessoaDaTela;
  try
    FController.Salvar(pessoa);
    ShowMessage(StrMsgSalvoSucesso);
    LimparCampos;
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage(StrMsgErroSalvar + E.Message);
  end;
  pessoa.Free;
end;

end.
