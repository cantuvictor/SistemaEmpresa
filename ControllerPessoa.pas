unit ControllerPessoa;

interface

uses
  System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client, DataModule, ModelPessoa, Constantes;

type
  TControllerPessoa = class
  private
    { Busca ou cria cidade no banco, evitando duplicatas }
    function ObterOuCriarCidade(const ANome, AEstado: string): Integer;
  public
    { Retorna lista de pessoas filtrada por nome, tipo, CPF/CNPJ, cidade e estado }
    function Buscar(const ANome, ATipo, ACpfCnpj, ACidade, AEstado: string): TObjectList<TPessoa>;

    { Retorna uma pessoa completa com cidade pelo ID }
    function BuscarPorId(const AId: Integer): TPessoa;

    { Persiste a pessoa no banco, inserindo ou atualizando conforme o ID }
    procedure Salvar(const APessoa: TPessoa);

    { Remove a pessoa do banco, lancando excecao amigavel se houver vinculo com contas }
    procedure Excluir(const AId: Integer);

    { Verifica se ja existe outro registro com o mesmo CPF/CNPJ }
    function CpfCnpjDuplicado(const ACpfCnpj: string; const AId: Integer): Boolean;
  end;

implementation

function TControllerPessoa.ObterOuCriarCidade(const ANome, AEstado: string): Integer;
var
  qry: TFDQuery;
begin
  Result := 0;

  if (Trim(ANome) = '') or (Trim(AEstado) = '') then
    Exit;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := DM.FDConnection1;
    qry.SQL.Text := 'SELECT ID_CIDADE FROM CIDADE WHERE NOME = :NOME AND ESTADO = :ESTADO';
    qry.ParamByName('NOME').AsString := Trim(ANome);
    qry.ParamByName('ESTADO').AsString := Trim(AEstado);
    qry.Open;

    if qry.IsEmpty then
    begin
      DM.FDConnection1.ExecSQL(
        'INSERT INTO CIDADE (NOME, ESTADO) VALUES (:NOME, :ESTADO)',
        [Trim(ANome), Trim(AEstado)]);
      qry.Close;
      qry.SQL.Text := StrSqlLastInsertId;
      qry.Open;
      Result := qry.FieldByName('ID').AsInteger;
    end
    else
      Result := qry.FieldByName('ID_CIDADE').AsInteger;

  finally
    qry.Free;
  end;
end;

function TControllerPessoa.CpfCnpjDuplicado(const ACpfCnpj: string; const AId: Integer): Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := DM.FDConnection1;
    qry.SQL.Text :=
      'SELECT ID_PESSOA FROM PESSOA WHERE CPF_CNPJ = :CPF AND ID_PESSOA <> :ID';
    qry.ParamByName('CPF').AsString := ACpfCnpj;
    qry.ParamByName('ID').AsInteger := AId;
    qry.Open;
    Result := not qry.IsEmpty;
  finally
    qry.Free;
  end;
end;

function TControllerPessoa.Buscar(const ANome, ATipo, ACpfCnpj, ACidade, AEstado: string): TObjectList<TPessoa>;
var
  qry: TFDQuery;
  pessoa: TPessoa;
  sWhere: string;
begin
  Result := TObjectList<TPessoa>.Create(True);

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := DM.FDConnection1;

    sWhere := 'WHERE 1=1 ';

    if Trim(ANome) <> '' then
      sWhere := sWhere + 'AND UPPER(P.NOME) LIKE UPPER(:NOME) ';

    if Trim(ATipo) <> '' then
      sWhere := sWhere + 'AND P.TIPO = :TIPO ';

    if Trim(ACpfCnpj) <> '' then
      sWhere := sWhere + 'AND P.CPF_CNPJ LIKE :CPF ';

    if Trim(ACidade) <> '' then
      sWhere := sWhere + 'AND UPPER(C.NOME) LIKE UPPER(:CIDADE) ';

    if Trim(AEstado) <> '' then
      sWhere := sWhere + 'AND UPPER(C.ESTADO) = UPPER(:ESTADO) ';

    qry.SQL.Text :=
      'SELECT P.ID_PESSOA, P.NOME, P.TIPO, P.CPF_CNPJ, P.EMAIL, P.TELEFONE, ' +
      '       P.ENDERECO, P.CEP, C.NOME AS NM_CIDADE, C.ESTADO, C.ID_CIDADE ' +
      'FROM PESSOA P ' +
      'LEFT JOIN CIDADE C ON C.ID_CIDADE = P.ID_CIDADE ' +
      sWhere +
      'ORDER BY P.NOME';

    if Trim(ANome) <> '' then
      qry.ParamByName('NOME').AsString := '%' + Trim(ANome) + '%';
    if Trim(ATipo) <> '' then
      qry.ParamByName('TIPO').AsString := Trim(ATipo);
    if Trim(ACpfCnpj) <> '' then
      qry.ParamByName('CPF').AsString := '%' + Trim(ACpfCnpj) + '%';
    if Trim(ACidade) <> '' then
      qry.ParamByName('CIDADE').AsString := '%' + Trim(ACidade) + '%';
    if Trim(AEstado) <> '' then
      qry.ParamByName('ESTADO').AsString := Trim(AEstado);

    qry.Open;

    while not qry.Eof do
    begin
      pessoa := TPessoa.Create;
      pessoa.Id       := qry.FieldByName('ID_PESSOA').AsInteger;
      pessoa.Nome     := qry.FieldByName('NOME').AsString;
      pessoa.Tipo     := qry.FieldByName('TIPO').AsString;
      pessoa.CpfCnpj  := qry.FieldByName('CPF_CNPJ').AsString;
      pessoa.Email    := qry.FieldByName('EMAIL').AsString;
      pessoa.Telefone := qry.FieldByName('TELEFONE').AsString;
      pessoa.Endereco := qry.FieldByName('ENDERECO').AsString;
      pessoa.Cep      := qry.FieldByName('CEP').AsString;
      pessoa.Cidade.Id     := qry.FieldByName('ID_CIDADE').AsInteger;
      pessoa.Cidade.Nome   := qry.FieldByName('NM_CIDADE').AsString;
      pessoa.Cidade.Estado := qry.FieldByName('ESTADO').AsString;
      Result.Add(pessoa);
      qry.Next;
    end;

  finally
    qry.Free;
  end;
end;

function TControllerPessoa.BuscarPorId(const AId: Integer): TPessoa;
var
  qry: TFDQuery;
begin
  Result := nil;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := DM.FDConnection1;
    qry.SQL.Text :=
      'SELECT P.*, C.NOME AS NM_CIDADE, C.ESTADO, C.ID_CIDADE ' +
      'FROM PESSOA P ' +
      'LEFT JOIN CIDADE C ON C.ID_CIDADE = P.ID_CIDADE ' +
      'WHERE P.ID_PESSOA = :ID';
    qry.ParamByName('ID').AsInteger := AId;
    qry.Open;

    if qry.IsEmpty then
      Exit;

    Result := TPessoa.Create;
    Result.Id       := qry.FieldByName('ID_PESSOA').AsInteger;
    Result.Nome     := qry.FieldByName('NOME').AsString;
    Result.Tipo     := qry.FieldByName('TIPO').AsString;
    Result.CpfCnpj  := qry.FieldByName('CPF_CNPJ').AsString;
    Result.Email    := qry.FieldByName('EMAIL').AsString;
    Result.Telefone := qry.FieldByName('TELEFONE').AsString;
    Result.Endereco := qry.FieldByName('ENDERECO').AsString;
    Result.Cep      := qry.FieldByName('CEP').AsString;
    Result.Cidade.Id     := qry.FieldByName('ID_CIDADE').AsInteger;
    Result.Cidade.Nome   := qry.FieldByName('NM_CIDADE').AsString;
    Result.Cidade.Estado := qry.FieldByName('ESTADO').AsString;

  finally
    qry.Free;
  end;
end;

procedure TControllerPessoa.Salvar(const APessoa: TPessoa);
var
  iIdCidade: Integer;
begin
  iIdCidade := ObterOuCriarCidade(APessoa.Cidade.Nome, APessoa.Cidade.Estado);

  if APessoa.Id = 0 then
  begin
    if iIdCidade = 0 then
      DM.FDConnection1.ExecSQL(
        'INSERT INTO PESSOA (NOME, TIPO, CPF_CNPJ, EMAIL, TELEFONE, CEP, ENDERECO, ID_CIDADE) ' +
        'VALUES (:NOME, :TIPO, :CPFCNPJ, :EMAIL, :TEL, :CEP, :END, NULL)',
        [APessoa.Nome, APessoa.Tipo, APessoa.CpfCnpj, APessoa.Email,
         APessoa.Telefone, APessoa.Cep, APessoa.Endereco])
    else
      DM.FDConnection1.ExecSQL(
        'INSERT INTO PESSOA (NOME, TIPO, CPF_CNPJ, EMAIL, TELEFONE, CEP, ENDERECO, ID_CIDADE) ' +
        'VALUES (:NOME, :TIPO, :CPFCNPJ, :EMAIL, :TEL, :CEP, :END, :CID)',
        [APessoa.Nome, APessoa.Tipo, APessoa.CpfCnpj, APessoa.Email,
         APessoa.Telefone, APessoa.Cep, APessoa.Endereco, iIdCidade]);
  end
  else
  begin
    if iIdCidade = 0 then
      DM.FDConnection1.ExecSQL(
        'UPDATE PESSOA SET NOME=:NOME, TIPO=:TIPO, CPF_CNPJ=:CPFCNPJ, ' +
        'EMAIL=:EMAIL, TELEFONE=:TEL, CEP=:CEP, ENDERECO=:END, ID_CIDADE=NULL ' +
        'WHERE ID_PESSOA=:ID',
        [APessoa.Nome, APessoa.Tipo, APessoa.CpfCnpj, APessoa.Email,
         APessoa.Telefone, APessoa.Cep, APessoa.Endereco, APessoa.Id])
    else
      DM.FDConnection1.ExecSQL(
        'UPDATE PESSOA SET NOME=:NOME, TIPO=:TIPO, CPF_CNPJ=:CPFCNPJ, ' +
        'EMAIL=:EMAIL, TELEFONE=:TEL, CEP=:CEP, ENDERECO=:END, ID_CIDADE=:CID ' +
        'WHERE ID_PESSOA=:ID',
        [APessoa.Nome, APessoa.Tipo, APessoa.CpfCnpj, APessoa.Email,
         APessoa.Telefone, APessoa.Cep, APessoa.Endereco, iIdCidade, APessoa.Id]);
  end;
end;
procedure TControllerPessoa.Excluir(const AId: Integer);
begin
  try
    DM.FDConnection1.ExecSQL(
      'DELETE FROM PESSOA WHERE ID_PESSOA = ' + IntToStr(AId));
  except
    on E: Exception do
    begin
      if Pos('FOREIGN KEY', E.Message) > 0 then
        raise Exception.Create(StrMsgErroVinculo)
      else
        raise;
    end;
  end;
end;

end.
