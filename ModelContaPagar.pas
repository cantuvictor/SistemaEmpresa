unit ModelContaPagar;

interface

uses
  System.Generics.Collections;

type
  TParcelaPagar = class
  private
    FId: Integer;
    FIdPagar: Integer;
    FNrParcela: Integer;
    FDtVencimento: string;
    FVlVencimento: Double;
    FDtPagamento: string;
    FVlPagamento: Double;
  public
    property Id: Integer read FId write FId;
    property IdPagar: Integer read FIdPagar write FIdPagar;
    property NrParcela: Integer read FNrParcela write FNrParcela;
    property DtVencimento: string read FDtVencimento write FDtVencimento;
    property VlVencimento: Double read FVlVencimento write FVlVencimento;
    property DtPagamento: string read FDtPagamento write FDtPagamento;
    property VlPagamento: Double read FVlPagamento write FVlPagamento;
  end;

  TContaPagar = class
  private
    FId: Integer;
    FDtEmissao: string;
    FValorTotal: Double;
    FIdFornecedor: Integer;
    FNomeFornecedor: string;
    FFinalizada: Boolean;
    FParcelas: TObjectList<TParcelaPagar>;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Integer read FId write FId;
    property DtEmissao: string read FDtEmissao write FDtEmissao;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property IdFornecedor: Integer read FIdFornecedor write FIdFornecedor;
    property NomeFornecedor: string read FNomeFornecedor write FNomeFornecedor;
    property Finalizada: Boolean read FFinalizada write FFinalizada;
    property Parcelas: TObjectList<TParcelaPagar> read FParcelas;
  end;

implementation

constructor TContaPagar.Create;
begin
  inherited;
  FParcelas := TObjectList<TParcelaPagar>.Create(True);
end;

destructor TContaPagar.Destroy;
begin
  FParcelas.Free;
  inherited;
end;

end.
