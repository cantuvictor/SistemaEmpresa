unit FrmContaPagar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  System.Generics.Collections,
  FireDAC.Comp.Client, DataModule, ModelContaPagar, ControllerContaPagar, Constantes;

type
  TFrmContaPagar = class(TForm)
    pnlCabecalho: TPanel;
    pnlParcelas: TPanel;
    pnlBotoes: TPanel;
    pnlConsulta: TPanel;
    lblEmissao: TLabel;
    lblValorTotal: TLabel;
    lblFornecedor: TLabel;
    lblParcelas: TLabel;
    lblFiltroEmissaoDe: TLabel;
    lblFiltroEmissaoAte: TLabel;
    lblFiltroValorDe: TLabel;
    lblFiltroValorAte: TLabel;
    lblFiltroFornecedor: TLabel;
    lblFiltroFinalizada: TLabel;
    edtValorTotal: TEdit;
    edtFiltroValorDe: TEdit;
    edtFiltroValorAte: TEdit;
    edtFiltroFornecedor: TEdit;
    cmbFornecedor: TComboBox;
    cmbFiltroFinalizada: TComboBox;
    chkFinalizada: TCheckBox;
    grdParcelas: TStringGrid;
    grdContas: TStringGrid;
    btnNovo: TButton;
    btnSalvar: TButton;
    btnFinalizar: TButton;
    btnExcluir: TButton;
    btnCancelar: TButton;
    btnAddParcela: TButton;
    btnBuscar: TButton;
    dtpEmissao: TDateTimePicker;
    dtpFiltroEmissaoDe: TDateTimePicker;
    dtpFiltroEmissaoAte: TDateTimePicker;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAddParcelaClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure grdContasClick(Sender: TObject);
    procedure ApenasValorKeyPress(Sender: TObject; var Key: Char);
  private
    FIdSelecionado: Integer;
    FController: TControllerContaPagar;
    function FormatarReais(const AValor: Double): string;
    function FormatarData(const AData: TDateTime): string;
    function DataParcelaValida(const AData: string; const ANr: Integer): Boolean;
    procedure ConfigurarGridParcelas;
    procedure ConfigurarGridContas;
    procedure CarregarFornecedores;
    procedure CarregarGrid;
    procedure LimparCampos;
    procedure PreencherCampos(AId: Integer);
    procedure PreencherParcelas(AConta: TContaPagar);
    procedure FormatarCampoMoeda(AEdit: TEdit);
    procedure edtValorExit(Sender: TObject);
    function ObterContaDaTela: TContaPagar;
    function ValidarCampos: Boolean;
    function ValidarParcelas: Boolean;
    function ContaFinalizada: Boolean;
    function StrToFloatDef2(const S: string): Double;
  public
    destructor Destroy; override;
  end;

var
  FormContaPagar: TFrmContaPagar;

implementation

{$R *.dfm}

destructor TFrmContaPagar.Destroy;
begin
  FController.Free;
  inherited;
end;

function TFrmContaPagar.FormatarReais(const AValor: Double): string;
begin
  Result := 'R$ ' + FormatFloat('#,##0.00', AValor);
end;

function TFrmContaPagar.FormatarData(const AData: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd', AData);
end;

procedure TFrmContaPagar.ApenasValorKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', ',', #8]) then
    Key := #0;
end;

function TFrmContaPagar.StrToFloatDef2(const S: string): Double;
var
  sVal: string;
begin
  sVal := StringReplace(S, 'R$ ', '', [rfReplaceAll]);
  sVal := StringReplace(sVal, '.', '', [rfReplaceAll]);
  sVal := StringReplace(sVal, ',', '.', [rfReplaceAll]);
  Result := StrToFloatDef(sVal, 0);
end;

function TFrmContaPagar.DataParcelaValida(const AData: string; const ANr: Integer): Boolean;
var
  dData: TDateTime;
begin
  Result := False;

  if AData = '' then
  begin
    ShowMessage(StrMsgDataParcelaVazia + IntToStr(ANr) + '.');
    Exit;
  end;

  if not TryStrToDate(AData, dData) then
  begin
    ShowMessage(StrMsgDataParcelaInvalida + IntToStr(ANr) + StrMsgDataParcelaFormato);
    Exit;
  end;

  if dData < dtpEmissao.Date then
  begin
    ShowMessage(StrMsgDataParcelaInvalida + IntToStr(ANr) + StrMsgDataParcelaEmissao);
    Exit;
  end;

  Result := True;
end;

procedure TFrmContaPagar.FormCreate(Sender: TObject);
begin
  FIdSelecionado := 0;
  FController := TControllerContaPagar.Create;

  dtpEmissao.Date := Now;
  dtpFiltroEmissaoDe.Date := Now;
  dtpFiltroEmissaoAte.Date := Now;

  ConfigurarGridParcelas;
  ConfigurarGridContas;
  CarregarFornecedores;
  CarregarGrid;

  edtValorTotal.OnKeyPress := ApenasValorKeyPress;
  edtFiltroValorDe.OnKeyPress := ApenasValorKeyPress;
  edtFiltroValorAte.OnKeyPress := ApenasValorKeyPress;

  edtValorTotal.OnExit := edtValorExit;
  edtFiltroValorDe.OnExit := edtValorExit;
  edtFiltroValorAte.OnExit := edtValorExit;
end;

procedure TFrmContaPagar.ConfigurarGridParcelas;
begin
  grdParcelas.Cells[0, 0] := 'Nr';
  grdParcelas.Cells[1, 0] := 'Dt. Vencimento';
  grdParcelas.Cells[2, 0] := 'Vl. Vencimento';
  grdParcelas.Cells[3, 0] := 'Dt. Pagamento';
  grdParcelas.Cells[4, 0] := 'Vl. Pagamento';

  grdParcelas.ColWidths[0] := 30;
  grdParcelas.ColWidths[1] := 150;
  grdParcelas.ColWidths[2] := 130;
  grdParcelas.ColWidths[3] := 150;
  grdParcelas.ColWidths[4] := grdParcelas.ClientWidth
    - grdParcelas.ColWidths[0]
    - grdParcelas.ColWidths[1]
    - grdParcelas.ColWidths[2]
    - grdParcelas.ColWidths[3]
    - 5;

  grdParcelas.Options := grdParcelas.Options + [goEditing];
end;

procedure TFrmContaPagar.ConfigurarGridContas;
begin
  grdContas.Cells[0, 0] := 'ID';
  grdContas.Cells[1, 0] := 'Emissao';
  grdContas.Cells[2, 0] := 'Valor Total';
  grdContas.Cells[3, 0] := 'Fornecedor';
  grdContas.Cells[4, 0] := 'Finalizada';

  grdContas.ColWidths[0] := 40;
  grdContas.ColWidths[1] := 100;
  grdContas.ColWidths[2] := 120;
  grdContas.ColWidths[3] := 200;
  grdContas.ColWidths[4] := grdContas.ClientWidth
    - grdContas.ColWidths[0]
    - grdContas.ColWidths[1]
    - grdContas.ColWidths[2]
    - grdContas.ColWidths[3]
    - 5;

  grdContas.Options := grdContas.Options - [goEditing];
end;

procedure TFrmContaPagar.CarregarFornecedores;
var
  qry: TFDQuery;
begin
  cmbFornecedor.Items.Clear;
  cmbFornecedor.Items.AddObject('-- Selecione --', TObject(0));

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := DM.FDConnection1;
    qry.SQL.Text := StrSqlBuscarFornecedores;
    qry.Open;

    while not qry.Eof do
    begin
      cmbFornecedor.Items.AddObject(
        qry.FieldByName('NOME').AsString,
        TObject(qry.FieldByName('ID_PESSOA').AsInteger));
      qry.Next;
    end;

  finally
    qry.Free;
  end;

  cmbFornecedor.ItemIndex := 0;
end;

procedure TFrmContaPagar.CarregarGrid;
var
  lista: TObjectList<TContaPagar>;
  conta: TContaPagar;
  iLinha, i, iFinalizada: Integer;
  sEmissaoDe, sEmissaoAte: string;
begin
  case cmbFiltroFinalizada.ItemIndex of
    1: iFinalizada := 1;
    2: iFinalizada := 0;
  else
    iFinalizada := -1;
  end;

  sEmissaoDe := FormatDateTime('yyyy-mm-dd', dtpFiltroEmissaoDe.Date);
  sEmissaoAte := FormatDateTime('yyyy-mm-dd', dtpFiltroEmissaoAte.Date);

  lista := FController.Buscar(
    sEmissaoDe,
    sEmissaoAte,
    StrToFloatDef2(edtFiltroValorDe.Text),
    StrToFloatDef2(edtFiltroValorAte.Text),
    Trim(edtFiltroFornecedor.Text),
    iFinalizada);

  try
    grdContas.RowCount := 2;
    for i := 0 to 4 do
      grdContas.Cells[i, 1] := '';

    iLinha := 1;
    for i := 0 to lista.Count - 1 do
    begin
      conta := lista[i];
      grdContas.RowCount := iLinha + 1;
      grdContas.Cells[0, iLinha] := IntToStr(conta.Id);
      grdContas.Cells[1, iLinha] := FormatDateTime('dd/mm/yyyy',
        StrToDateDef(conta.DtEmissao, Now));
      grdContas.Cells[2, iLinha] := FormatarReais(conta.ValorTotal);
      grdContas.Cells[3, iLinha] := conta.NomeFornecedor;
      if conta.Finalizada then
        grdContas.Cells[4, iLinha] := 'Sim'
      else
        grdContas.Cells[4, iLinha] := 'Nao';
      Inc(iLinha);
    end;
  finally
    lista.Free;
  end;
end;

procedure TFrmContaPagar.PreencherParcelas(AConta: TContaPagar);
var
  i: Integer;
  parcela: TParcelaPagar;
begin
  grdParcelas.RowCount := 2;

  for i := 0 to AConta.Parcelas.Count - 1 do
  begin
    parcela := AConta.Parcelas[i];
    if i >= grdParcelas.RowCount - 1 then
      grdParcelas.RowCount := i + 2;
    grdParcelas.Cells[0, i + 1] := IntToStr(parcela.NrParcela);
    grdParcelas.Cells[1, i + 1] := parcela.DtVencimento;
    grdParcelas.Cells[2, i + 1] := FormatarReais(parcela.VlVencimento);
    grdParcelas.Cells[3, i + 1] := parcela.DtPagamento;
    grdParcelas.Cells[4, i + 1] := FormatarReais(parcela.VlPagamento);
  end;
end;

procedure TFrmContaPagar.PreencherCampos(AId: Integer);
var
  conta: TContaPagar;
  i: Integer;
begin
  conta := FController.BuscarPorId(AId);
  if not Assigned(conta) then
    Exit;

  try
    FIdSelecionado        := conta.Id;
    dtpEmissao.Date       := StrToDateDef(conta.DtEmissao, Now);
    edtValorTotal.Text    := FormatarReais(conta.ValorTotal);
    chkFinalizada.Checked := conta.Finalizada;

    for i := 0 to cmbFornecedor.Items.Count - 1 do
    begin
      if Integer(cmbFornecedor.Items.Objects[i]) = conta.IdFornecedor then
      begin
        cmbFornecedor.ItemIndex := i;
        Break;
      end;
    end;

    PreencherParcelas(conta);
  finally
    conta.Free;
  end;
end;

procedure TFrmContaPagar.FormatarCampoMoeda(AEdit: TEdit);
var
  dValor: Double;
begin
  dValor := StrToFloatDef2(AEdit.Text);
  AEdit.Text := FormatarReais(dValor);
end;

procedure TFrmContaPagar.edtValorExit(Sender: TObject);
begin
  FormatarCampoMoeda(TEdit(Sender));
end;

function TFrmContaPagar.ObterContaDaTela: TContaPagar;
var
  i: Integer;
  parcela: TParcelaPagar;
begin
  Result := TContaPagar.Create;
  Result.Id           := FIdSelecionado;
  Result.DtEmissao    := FormatarData(dtpEmissao.Date);
  Result.ValorTotal   := StrToFloatDef2(edtValorTotal.Text);
  Result.IdFornecedor := Integer(cmbFornecedor.Items.Objects[cmbFornecedor.ItemIndex]);

  for i := 1 to grdParcelas.RowCount - 1 do
  begin
    if StrToFloatDef2(grdParcelas.Cells[2, i]) = 0 then
      Continue;

    parcela := TParcelaPagar.Create;
    parcela.NrParcela    := i;
    parcela.DtVencimento := Trim(grdParcelas.Cells[1, i]);
    parcela.VlVencimento := StrToFloatDef2(grdParcelas.Cells[2, i]);
    parcela.DtPagamento  := Trim(grdParcelas.Cells[3, i]);
    parcela.VlPagamento  := StrToFloatDef2(grdParcelas.Cells[4, i]);
    Result.Parcelas.Add(parcela);
  end;
end;

function TFrmContaPagar.ContaFinalizada: Boolean;
begin
  Result := chkFinalizada.Checked;
end;

function TFrmContaPagar.ValidarParcelas: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to grdParcelas.RowCount - 1 do
  begin
    if StrToFloatDef2(grdParcelas.Cells[2, i]) = 0 then
      Continue;
    if not DataParcelaValida(grdParcelas.Cells[1, i], i) then
      Exit;
  end;
  Result := True;
end;

function TFrmContaPagar.ValidarCampos: Boolean;
var
  dTotal: Double;
  iParcelas, i: Integer;
begin
  Result := False;

  if cmbFornecedor.ItemIndex <= 0 then
  begin
    ShowMessage(StrMsgFornecedorObrigatorio);
    cmbFornecedor.SetFocus;
    Exit;
  end;

  dTotal := StrToFloatDef2(edtValorTotal.Text);
  if dTotal <= 0 then
  begin
    ShowMessage(StrMsgValorPositivo);
    edtValorTotal.SetFocus;
    Exit;
  end;

  iParcelas := 0;
  for i := 1 to grdParcelas.RowCount - 1 do
    if StrToFloatDef2(grdParcelas.Cells[2, i]) > 0 then
      Inc(iParcelas);

  if iParcelas = 0 then
  begin
    ShowMessage(StrMsgParcelaObrigatoria);
    Exit;
  end;

  if not ValidarParcelas then
    Exit;

  Result := True;
end;

procedure TFrmContaPagar.LimparCampos;
begin
  FIdSelecionado := 0;
  dtpEmissao.Date := Now;
  edtValorTotal.Text := '';
  cmbFornecedor.ItemIndex := 0;
  chkFinalizada.Checked := False;
  grdParcelas.RowCount := 2;
  grdParcelas.Cells[0, 1] := '';
  grdParcelas.Cells[1, 1] := '';
  grdParcelas.Cells[2, 1] := '';
  grdParcelas.Cells[3, 1] := '';
  grdParcelas.Cells[4, 1] := '';
  edtValorTotal.SetFocus;
end;

procedure TFrmContaPagar.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TFrmContaPagar.btnCancelarClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TFrmContaPagar.btnAddParcelaClick(Sender: TObject);
var
  iLinha: Integer;
begin
  if grdParcelas.Cells[1, 1] = '' then
    iLinha := 1
  else
    iLinha := grdParcelas.RowCount;

  if iLinha >= grdParcelas.RowCount then
    grdParcelas.RowCount := iLinha + 1;

  grdParcelas.Cells[0, iLinha] := IntToStr(iLinha);
  grdParcelas.Cells[1, iLinha] := '';
  grdParcelas.Cells[2, iLinha] := 'R$ 0,00';
  grdParcelas.Cells[3, iLinha] := '';
  grdParcelas.Cells[4, iLinha] := 'R$ 0,00';
end;

procedure TFrmContaPagar.btnBuscarClick(Sender: TObject);
begin
  CarregarGrid;
end;

procedure TFrmContaPagar.grdContasClick(Sender: TObject);
var
  iId: Integer;
begin
  if grdContas.Row < 1 then
    Exit;

  if grdContas.Cells[0, grdContas.Row] = '' then
    Exit;

  iId := StrToIntDef(grdContas.Cells[0, grdContas.Row], 0);

  if iId = 0 then
    Exit;

  PreencherCampos(iId);
end;

procedure TFrmContaPagar.btnExcluirClick(Sender: TObject);
begin
  if FIdSelecionado = 0 then
  begin
    ShowMessage(StrMsgSelecioneExcluir);
    Exit;
  end;

  if ContaFinalizada then
  begin
    ShowMessage(StrMsgContaFinalizadaExcluir);
    Exit;
  end;

  if MessageDlg(StrMsgConfirmaExclusaoConta,
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    FController.Excluir(FIdSelecionado);
    LimparCampos;
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage(StrMsgErroExcluir + E.Message);
  end;
end;

procedure TFrmContaPagar.btnFinalizarClick(Sender: TObject);
var
  dTotal, dSoma: Double;
begin
  if FIdSelecionado = 0 then
  begin
    ShowMessage(StrMsgSalvarAntesFinalizar);
    Exit;
  end;

  if ContaFinalizada then
  begin
    ShowMessage(StrMsgContaJaFinalizada);
    Exit;
  end;

  dTotal := StrToFloatDef2(edtValorTotal.Text);

  dSoma := 0;
  var i: Integer;
  for i := 1 to grdParcelas.RowCount - 1 do
    dSoma := dSoma + StrToFloatDef2(grdParcelas.Cells[2, i]);

  if Abs(dTotal - dSoma) > 0.01 then
  begin
    ShowMessage(Format(StrMsgSomaParcelas,
      [FormatarReais(dSoma), FormatarReais(dTotal)]));
    Exit;
  end;

  if MessageDlg(StrMsgConfirmaFinalizar,
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    FController.Finalizar(FIdSelecionado);
    chkFinalizada.Checked := True;
    CarregarGrid;
    ShowMessage(StrMsgFinalizadoSucesso);
  except
    on E: Exception do
      ShowMessage(StrMsgErroFinalizar + E.Message);
  end;
end;

procedure TFrmContaPagar.btnSalvarClick(Sender: TObject);
var
  conta: TContaPagar;
begin
  if not ValidarCampos then
    Exit;

  if ContaFinalizada then
  begin
    ShowMessage(StrMsgContaFinalizadaAlterar);
    Exit;
  end;

  conta := ObterContaDaTela;
  try
    FController.Salvar(conta);
    FIdSelecionado := conta.Id;
    ShowMessage(StrMsgContaSalva);
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage(StrMsgErroSalvar + E.Message);
  end;
  conta.Free;
end;

end.
