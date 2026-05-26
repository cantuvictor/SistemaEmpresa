unit ControllerContaPagar;

interface

uses
  System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client, DataModule, ModelContaPagar, Constantes;

type
  TControllerContaPagar = class
  public
  { Retorna lista de contas a pagar filtrada por periodo de emissao, valor, fornecedor e situacao }
  function Buscar(const AEmissaoDe, AEmissaoAte: string; const AValorDe, AValorAte: Double;
    const AFornecedor: string; const AFinalizada: Integer): TObjectList<TContaPagar>;

    { Retorna conta completa com parcelas pelo ID }
    function BuscarPorId(const AId: Integer): TContaPagar;

    { Persiste a conta e suas parcelas em transacao atomica }
    procedure Salvar(const AConta: TContaPagar);

    { Marca a conta como finalizada, impedindo alteracoes futuras }
    procedure Finalizar(const AId: Integer);

    { Remove a conta e suas parcelas em cascata }
    procedure Excluir(const AId: Integer);

    { Calcula a soma dos valores de vencimento das parcelas }
    function SomaParcelas(const AConta: TContaPagar): Double;
  end;

implementation

function TControllerContaPagar.SomaParcelas(const AConta: TContaPagar): Double;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to AConta.Parcelas.Count - 1 do
    Result := Result + AConta.Parcelas[i].VlVencimento;
end;

function TControllerContaPagar.Buscar(const AEmissaoDe, AEmissaoAte: string;
  const AValorDe, AValorAte: Double;
  const AFornecedor: string; const AFinalizada: Integer): TObjectList<TContaPagar>;
var
  qry: TFDQuery;
  conta: TContaPagar;
  sWhere: string;
begin
  Result := TObjectList<TContaPagar>.Create(True);

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := DM.FDConnection1;

    sWhere := 'WHERE 1=1 ';

    if Trim(AEmissaoDe) <> '' then
      sWhere := sWhere + 'AND CP.DT_EMISSAO >= :EMISSAO_DE ';

    if Trim(AEmissaoAte) <> '' then
      sWhere := sWhere + 'AND CP.DT_EMISSAO <= :EMISSAO_ATE ';

    if AValorDe > 0 then
      sWhere := sWhere + 'AND CP.VALOR_TOTAL >= :VALOR_DE ';

    if AValorAte > 0 then
      sWhere := sWhere + 'AND CP.VALOR_TOTAL <= :VALOR_ATE ';

    if Trim(AFornecedor) <> '' then
      sWhere := sWhere + 'AND UPPER(P.NOME) LIKE UPPER(:FORNECEDOR) ';

    if AFinalizada = 1 then
      sWhere := sWhere + 'AND CP.FINALIZADA = 1 '
    else if AFinalizada = 0 then
      sWhere := sWhere + 'AND CP.FINALIZADA = 0 ';

    qry.SQL.Text :=
      'SELECT CP.ID_PAGAR, CP.DT_EMISSAO, CP.VALOR_TOTAL, P.NOME, CP.FINALIZADA, CP.ID_FORNECEDOR ' +
      'FROM CONTA_PAGAR CP ' +
      'JOIN PESSOA P ON P.ID_PESSOA = CP.ID_FORNECEDOR ' +
      sWhere +
      'ORDER BY CP.DT_EMISSAO DESC';

    if Trim(AEmissaoDe) <> '' then
      qry.ParamByName('EMISSAO_DE').AsString := AEmissaoDe;
    if Trim(AEmissaoAte) <> '' then
      qry.ParamByName('EMISSAO_ATE').AsString := AEmissaoAte;
    if AValorDe > 0 then
      qry.ParamByName('VALOR_DE').AsFloat := AValorDe;
    if AValorAte > 0 then
      qry.ParamByName('VALOR_ATE').AsFloat := AValorAte;
    if Trim(AFornecedor) <> '' then
      qry.ParamByName('FORNECEDOR').AsString := '%' + Trim(AFornecedor) + '%';

    qry.Open;

    while not qry.Eof do
    begin
      conta := TContaPagar.Create;
      conta.Id             := qry.FieldByName('ID_PAGAR').AsInteger;
      conta.DtEmissao      := qry.FieldByName('DT_EMISSAO').AsString;
      conta.ValorTotal     := qry.FieldByName('VALOR_TOTAL').AsFloat;
      conta.IdFornecedor   := qry.FieldByName('ID_FORNECEDOR').AsInteger;
      conta.NomeFornecedor := qry.FieldByName('NOME').AsString;
      conta.Finalizada     := qry.FieldByName('FINALIZADA').AsInteger = 1;
      Result.Add(conta);
      qry.Next;
    end;

  finally
    qry.Free;
  end;
end;

function TControllerContaPagar.BuscarPorId(const AId: Integer): TContaPagar;
var
  qry: TFDQuery;
  parcela: TParcelaPagar;
begin
  Result := nil;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := DM.FDConnection1;
    qry.SQL.Text := 'SELECT * FROM CONTA_PAGAR WHERE ID_PAGAR = :ID';
    qry.ParamByName('ID').AsInteger := AId;
    qry.Open;

    if qry.IsEmpty then
      Exit;

    Result := TContaPagar.Create;
    Result.Id           := qry.FieldByName('ID_PAGAR').AsInteger;
    Result.DtEmissao    := qry.FieldByName('DT_EMISSAO').AsString;
    Result.ValorTotal   := qry.FieldByName('VALOR_TOTAL').AsFloat;
    Result.IdFornecedor := qry.FieldByName('ID_FORNECEDOR').AsInteger;
    Result.Finalizada   := qry.FieldByName('FINALIZADA').AsInteger = 1;

    qry.Close;
    qry.SQL.Text :=
      'SELECT * FROM PARCELA_PAGAR WHERE ID_PAGAR = :ID ORDER BY NR_PARCELA';
    qry.ParamByName('ID').AsInteger := AId;
    qry.Open;

    while not qry.Eof do
    begin
      parcela := TParcelaPagar.Create;
      parcela.Id           := qry.FieldByName('ID_PARCELA').AsInteger;
      parcela.IdPagar      := AId;
      parcela.NrParcela    := qry.FieldByName('NR_PARCELA').AsInteger;
      parcela.DtVencimento := qry.FieldByName('DT_VENCIMENTO').AsString;
      parcela.VlVencimento := qry.FieldByName('VL_VENCIMENTO').AsFloat;
      parcela.DtPagamento  := qry.FieldByName('DT_PAGAMENTO').AsString;
      parcela.VlPagamento  := qry.FieldByName('VL_PAGAMENTO').AsFloat;
      Result.Parcelas.Add(parcela);
      qry.Next;
    end;

  finally
    qry.Free;
  end;
end;

procedure TControllerContaPagar.Salvar(const AConta: TContaPagar);
var
  qry: TFDQuery;
  iId, i: Integer;
  parcela: TParcelaPagar;
begin
  DM.FDConnection1.StartTransaction;
  try
    if AConta.Id = 0 then
    begin
      DM.FDConnection1.ExecSQL(
        'INSERT INTO CONTA_PAGAR (DT_EMISSAO, VALOR_TOTAL, ID_FORNECEDOR, FINALIZADA) ' +
        'VALUES (:DT, :VL, :FORN, 0)',
        [AConta.DtEmissao, AConta.ValorTotal, AConta.IdFornecedor]);

      qry := TFDQuery.Create(nil);
      try
        qry.Connection := DM.FDConnection1;
        qry.SQL.Text := StrSqlLastInsertId;
        qry.Open;
        iId := qry.FieldByName('ID').AsInteger;
      finally
        qry.Free;
      end;

      AConta.Id := iId;
    end
    else
    begin
      DM.FDConnection1.ExecSQL(
        'UPDATE CONTA_PAGAR SET DT_EMISSAO=:DT, VALOR_TOTAL=:VL, ID_FORNECEDOR=:FORN ' +
        'WHERE ID_PAGAR=:ID',
        [AConta.DtEmissao, AConta.ValorTotal, AConta.IdFornecedor, AConta.Id]);

      DM.FDConnection1.ExecSQL(
        'DELETE FROM PARCELA_PAGAR WHERE ID_PAGAR = ' + IntToStr(AConta.Id));
    end;

    for i := 0 to AConta.Parcelas.Count - 1 do
    begin
      parcela := AConta.Parcelas[i];

      if parcela.VlVencimento = 0 then
        Continue;

      DM.FDConnection1.ExecSQL(
        'INSERT INTO PARCELA_PAGAR (ID_PAGAR, NR_PARCELA, DT_VENCIMENTO, VL_VENCIMENTO, DT_PAGAMENTO, VL_PAGAMENTO) ' +
        'VALUES (:ID, :NR, :DTV, :VLV, :DTP, :VLP)',
        [AConta.Id, parcela.NrParcela, parcela.DtVencimento,
         parcela.VlVencimento, parcela.DtPagamento, parcela.VlPagamento]);
    end;

    DM.FDConnection1.Commit;

  except
    on E: Exception do
    begin
      DM.FDConnection1.Rollback;
      raise;
    end;
  end;
end;

procedure TControllerContaPagar.Finalizar(const AId: Integer);
begin
  DM.FDConnection1.ExecSQL(
    'UPDATE CONTA_PAGAR SET FINALIZADA = 1 WHERE ID_PAGAR = ' + IntToStr(AId));
end;

procedure TControllerContaPagar.Excluir(const AId: Integer);
begin
  DM.FDConnection1.ExecSQL(
    'DELETE FROM CONTA_PAGAR WHERE ID_PAGAR = ' + IntToStr(AId));
end;

end.
