unit ControllerContaReceber;

interface

uses
  System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client, DataModule, ModelContaReceber, Constantes;

type
  TControllerContaReceber = class
  public
    { Retorna lista de contas a receber filtrada por valor, cliente e situacao }
    function Buscar(const AValorDe, AValorAte: Double;
      const ACliente: string; const AFinalizada: Integer): TObjectList<TContaReceber>;

    { Retorna conta completa com parcelas pelo ID }
    function BuscarPorId(const AId: Integer): TContaReceber;

    { Persiste a conta e suas parcelas em transacao atomica }
    procedure Salvar(const AConta: TContaReceber);

    { Marca a conta como finalizada, impedindo alteracoes futuras }
    procedure Finalizar(const AId: Integer);

    { Remove a conta e suas parcelas em cascata }
    procedure Excluir(const AId: Integer);

    { Calcula a soma dos valores de vencimento das parcelas }
    function SomaParcelas(const AConta: TContaReceber): Double;
  end;

implementation

function TControllerContaReceber.SomaParcelas(const AConta: TContaReceber): Double;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to AConta.Parcelas.Count - 1 do
    Result := Result + AConta.Parcelas[i].VlVencimento;
end;

function TControllerContaReceber.Buscar(const AValorDe, AValorAte: Double;
  const ACliente: string; const AFinalizada: Integer): TObjectList<TContaReceber>;
var
  qry: TFDQuery;
  conta: TContaReceber;
  sWhere: string;
begin
  Result := TObjectList<TContaReceber>.Create(True);

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := DM.FDConnection1;

    sWhere := 'WHERE 1=1 ';

    if AValorDe > 0 then
      sWhere := sWhere + 'AND CR.VALOR_TOTAL >= :VALOR_DE ';

    if AValorAte > 0 then
      sWhere := sWhere + 'AND CR.VALOR_TOTAL <= :VALOR_ATE ';

    if Trim(ACliente) <> '' then
      sWhere := sWhere + 'AND UPPER(P.NOME) LIKE UPPER(:CLIENTE) ';

    if AFinalizada = 1 then
      sWhere := sWhere + 'AND CR.FINALIZADA = 1 '
    else if AFinalizada = 0 then
      sWhere := sWhere + 'AND CR.FINALIZADA = 0 ';

    qry.SQL.Text :=
      'SELECT CR.ID_RECEBER, CR.DT_EMISSAO, CR.VALOR_TOTAL, P.NOME, CR.FINALIZADA, CR.ID_CLIENTE ' +
      'FROM CONTA_RECEBER CR ' +
      'JOIN PESSOA P ON P.ID_PESSOA = CR.ID_CLIENTE ' +
      sWhere +
      'ORDER BY CR.DT_EMISSAO DESC';

    if AValorDe > 0 then
      qry.ParamByName('VALOR_DE').AsFloat := AValorDe;
    if AValorAte > 0 then
      qry.ParamByName('VALOR_ATE').AsFloat := AValorAte;
    if Trim(ACliente) <> '' then
      qry.ParamByName('CLIENTE').AsString := '%' + Trim(ACliente) + '%';

    qry.Open;

    while not qry.Eof do
    begin
      conta := TContaReceber.Create;
      conta.Id          := qry.FieldByName('ID_RECEBER').AsInteger;
      conta.DtEmissao   := qry.FieldByName('DT_EMISSAO').AsString;
      conta.ValorTotal  := qry.FieldByName('VALOR_TOTAL').AsFloat;
      conta.IdCliente   := qry.FieldByName('ID_CLIENTE').AsInteger;
      conta.NomeCliente := qry.FieldByName('NOME').AsString;
      conta.Finalizada  := qry.FieldByName('FINALIZADA').AsInteger = 1;
      Result.Add(conta);
      qry.Next;
    end;

  finally
    qry.Free;
  end;
end;

function TControllerContaReceber.BuscarPorId(const AId: Integer): TContaReceber;
var
  qry: TFDQuery;
  parcela: TParcelaReceber;
begin
  Result := nil;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := DM.FDConnection1;
    qry.SQL.Text := 'SELECT * FROM CONTA_RECEBER WHERE ID_RECEBER = :ID';
    qry.ParamByName('ID').AsInteger := AId;
    qry.Open;

    if qry.IsEmpty then
      Exit;

    Result := TContaReceber.Create;
    Result.Id         := qry.FieldByName('ID_RECEBER').AsInteger;
    Result.DtEmissao  := qry.FieldByName('DT_EMISSAO').AsString;
    Result.ValorTotal := qry.FieldByName('VALOR_TOTAL').AsFloat;
    Result.IdCliente  := qry.FieldByName('ID_CLIENTE').AsInteger;
    Result.Finalizada := qry.FieldByName('FINALIZADA').AsInteger = 1;

    qry.Close;
    qry.SQL.Text :=
      'SELECT * FROM PARCELA_RECEBER WHERE ID_RECEBER = :ID ORDER BY NR_PARCELA';
    qry.ParamByName('ID').AsInteger := AId;
    qry.Open;

    while not qry.Eof do
    begin
      parcela := TParcelaReceber.Create;
      parcela.Id            := qry.FieldByName('ID_PARCELA').AsInteger;
      parcela.IdReceber     := AId;
      parcela.NrParcela     := qry.FieldByName('NR_PARCELA').AsInteger;
      parcela.DtVencimento  := qry.FieldByName('DT_VENCIMENTO').AsString;
      parcela.VlVencimento  := qry.FieldByName('VL_VENCIMENTO').AsFloat;
      parcela.DtRecebimento := qry.FieldByName('DT_RECEBIMENTO').AsString;
      parcela.VlRecebimento := qry.FieldByName('VL_RECEBIMENTO').AsFloat;
      Result.Parcelas.Add(parcela);
      qry.Next;
    end;

  finally
    qry.Free;
  end;
end;

procedure TControllerContaReceber.Salvar(const AConta: TContaReceber);
var
  qry: TFDQuery;
  iId, i: Integer;
  parcela: TParcelaReceber;
begin
  DM.FDConnection1.StartTransaction;
  try
    if AConta.Id = 0 then
    begin
      DM.FDConnection1.ExecSQL(
        'INSERT INTO CONTA_RECEBER (DT_EMISSAO, VALOR_TOTAL, ID_CLIENTE, FINALIZADA) ' +
        'VALUES (:DT, :VL, :CLI, 0)',
        [AConta.DtEmissao, AConta.ValorTotal, AConta.IdCliente]);

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
        'UPDATE CONTA_RECEBER SET DT_EMISSAO=:DT, VALOR_TOTAL=:VL, ID_CLIENTE=:CLI ' +
        'WHERE ID_RECEBER=:ID',
        [AConta.DtEmissao, AConta.ValorTotal, AConta.IdCliente, AConta.Id]);

      DM.FDConnection1.ExecSQL(
        'DELETE FROM PARCELA_RECEBER WHERE ID_RECEBER = ' + IntToStr(AConta.Id));
    end;

    for i := 0 to AConta.Parcelas.Count - 1 do
    begin
      parcela := AConta.Parcelas[i];

      if parcela.VlVencimento = 0 then
        Continue;

      DM.FDConnection1.ExecSQL(
        'INSERT INTO PARCELA_RECEBER (ID_RECEBER, NR_PARCELA, DT_VENCIMENTO, VL_VENCIMENTO, DT_RECEBIMENTO, VL_RECEBIMENTO) ' +
        'VALUES (:ID, :NR, :DTV, :VLV, :DTR, :VLR)',
        [AConta.Id, parcela.NrParcela, parcela.DtVencimento,
         parcela.VlVencimento, parcela.DtRecebimento, parcela.VlRecebimento]);
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

procedure TControllerContaReceber.Finalizar(const AId: Integer);
begin
  DM.FDConnection1.ExecSQL(
    'UPDATE CONTA_RECEBER SET FINALIZADA = 1 WHERE ID_RECEBER = ' + IntToStr(AId));
end;

procedure TControllerContaReceber.Excluir(const AId: Integer);
begin
  DM.FDConnection1.ExecSQL(
    'DELETE FROM CONTA_RECEBER WHERE ID_RECEBER = ' + IntToStr(AId));
end;

end.
