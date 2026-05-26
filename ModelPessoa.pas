unit ModelPessoa;

interface

type
  TCidade = class
  private
    FId: Integer;
    FNome: string;
    FEstado: string;
  public
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property Estado: string read FEstado write FEstado;
  end;

  TPessoa = class
  private
    FId: Integer;
    FNome: string;
    FTipo: string;
    FCpfCnpj: string;
    FEmail: string;
    FTelefone: string;
    FEndereco: string;
    FCep: string;
    FCidade: TCidade;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property Tipo: string read FTipo write FTipo;
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property Email: string read FEmail write FEmail;
    property Telefone: string read FTelefone write FTelefone;
    property Endereco: string read FEndereco write FEndereco;
    property Cep: string read FCep write FCep;
    property Cidade: TCidade read FCidade write FCidade;
  end;

implementation

constructor TPessoa.Create;
begin
  inherited;
  FCidade := TCidade.Create;
end;

destructor TPessoa.Destroy;
begin
  FCidade.Free;
  inherited;
end;

end.
