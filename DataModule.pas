unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Phys.SQLiteWrapper.Stat;

type
  TDM = class(TDataModule)
    { Conexao principal com o banco de dados SQLite via FireDAC }
    FDConnection1: TFDConnection;
    { Driver necessario para conectar ao SQLite }
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    { Inicializa a conexao e cria as tabelas na primeira execucao }
    procedure DataModuleCreate(Sender: TObject);
  private
    { Cria as tabelas do banco caso nao existam, garantindo integridade referencial }
    procedure CriarBanco;
  public
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
var
  sCaminho: string;
begin
  { Monta o caminho do arquivo de banco no mesmo diretorio do executavel }
  sCaminho := ExtractFilePath(ParamStr(0)) + 'financeiro.db';

  FDConnection1.Params.Clear;
  FDConnection1.Params.Add('DriverID=SQLite');
  FDConnection1.Params.Add('Database=' + sCaminho);
  FDConnection1.Params.Add('OpenMode=CreateUTF8');

  FDConnection1.Connected := True;

  CriarBanco;
end;

procedure TDM.CriarBanco;
begin
  { Ativa checagem de chaves estrangeiras no SQLite, desativada por padrao }
  FDConnection1.ExecSQL('PRAGMA foreign_keys = ON');

  { Tabela de cidades normalizada em 3FN, evitando duplicidade de dados geograficos }
  FDConnection1.ExecSQL(
    'CREATE TABLE IF NOT EXISTS CIDADE (' +
    '  ID_CIDADE INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  NOME      TEXT NOT NULL,' +
    '  ESTADO    TEXT NOT NULL CHECK(LENGTH(ESTADO) = 2)' +
    ')'
  );

  { Tabela unificada de pessoas: campo TIPO define se e Cliente, Fornecedor ou Ambos }
  FDConnection1.ExecSQL(
    'CREATE TABLE IF NOT EXISTS PESSOA (' +
    '  ID_PESSOA  INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  NOME       TEXT NOT NULL,' +
    '  TIPO       TEXT NOT NULL CHECK(TIPO IN (''C'',''F'',''A'')),' +
    '  CPF_CNPJ   TEXT NOT NULL UNIQUE,' +
    '  EMAIL      TEXT,' +
    '  TELEFONE   TEXT,' +
    '  ENDERECO   TEXT,' +
    '  CEP        TEXT,' +
    '  ID_CIDADE  INTEGER REFERENCES CIDADE(ID_CIDADE)' +
    ')'
  );

  { Cabecalho das contas a pagar: vinculado a um fornecedor e possui controle de finalizacao }
  FDConnection1.ExecSQL(
    'CREATE TABLE IF NOT EXISTS CONTA_PAGAR (' +
    '  ID_PAGAR      INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  DT_EMISSAO    TEXT NOT NULL,' +
    '  VALOR_TOTAL   REAL NOT NULL CHECK(VALOR_TOTAL > 0),' +
    '  ID_FORNECEDOR INTEGER NOT NULL REFERENCES PESSOA(ID_PESSOA),' +
    '  FINALIZADA    INTEGER NOT NULL DEFAULT 0 CHECK(FINALIZADA IN (0,1))' +
    ')'
  );

  { Parcelas das contas a pagar: ON DELETE CASCADE remove parcelas ao excluir a conta }
  FDConnection1.ExecSQL(
    'CREATE TABLE IF NOT EXISTS PARCELA_PAGAR (' +
    '  ID_PARCELA    INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  ID_PAGAR      INTEGER NOT NULL REFERENCES CONTA_PAGAR(ID_PAGAR) ON DELETE CASCADE,' +
    '  NR_PARCELA    INTEGER NOT NULL,' +
    '  DT_VENCIMENTO TEXT NOT NULL,' +
    '  VL_VENCIMENTO REAL NOT NULL CHECK(VL_VENCIMENTO > 0),' +
    '  DT_PAGAMENTO  TEXT,' +
    '  VL_PAGAMENTO  REAL' +
    ')'
  );

  { Cabecalho das contas a receber: vinculado a um cliente e possui controle de finalizacao }
  FDConnection1.ExecSQL(
    'CREATE TABLE IF NOT EXISTS CONTA_RECEBER (' +
    '  ID_RECEBER  INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  DT_EMISSAO  TEXT NOT NULL,' +
    '  VALOR_TOTAL REAL NOT NULL CHECK(VALOR_TOTAL > 0),' +
    '  ID_CLIENTE  INTEGER NOT NULL REFERENCES PESSOA(ID_PESSOA),' +
    '  FINALIZADA  INTEGER NOT NULL DEFAULT 0 CHECK(FINALIZADA IN (0,1))' +
    ')'
  );

  { Parcelas das contas a receber: ON DELETE CASCADE remove parcelas ao excluir a conta }
  FDConnection1.ExecSQL(
    'CREATE TABLE IF NOT EXISTS PARCELA_RECEBER (' +
    '  ID_PARCELA     INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  ID_RECEBER     INTEGER NOT NULL REFERENCES CONTA_RECEBER(ID_RECEBER) ON DELETE CASCADE,' +
    '  NR_PARCELA     INTEGER NOT NULL,' +
    '  DT_VENCIMENTO  TEXT NOT NULL,' +
    '  VL_VENCIMENTO  REAL NOT NULL CHECK(VL_VENCIMENTO > 0),' +
    '  DT_RECEBIMENTO TEXT,' +
    '  VL_RECEBIMENTO REAL' +
    ')'
  );
end;

end.
