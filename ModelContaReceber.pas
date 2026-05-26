unit ModelContaReceber;

interface

uses
  System.Generics.Collections;

type
  TParcelaReceber = class
  private
    FId: Integer;
    FIdReceber: Integer;
    FNrParcela: Integer;
    FDtVencimento: string;
    FVlVencimento: Double;
    FDtRecebimento: string;
    FVlRecebimento: Double;
  public
    property Id: Integer read FId write FId;
    property IdReceber: Integer read FIdReceber write FIdReceber;
    property NrParcela: Integer read FNrParcela write FNrParcela;
    property DtVencimento: string read FDtVencimento write FDtVencimento;
    property VlVencimento: Double read FVlVencimento write FVlVencimento;
    property DtRecebimento: string read FDtRecebimento write FDtRecebimento;
    property VlRecebimento: Double read FVlRecebimento write FVlRecebimento;
  end;

  TContaReceber = class
  private
    FId: Integer;
    FDtEmissao: string;
    FValorTotal: Double;
    FIdCliente: Integer;
    FNomeCliente: string;
    FFinalizada: Boolean;
    FParcelas: TObjectList<TParcelaReceber>;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Integer read FId write FId;
    property DtEmissao: string read FDtEmissao write FDtEmissao;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property IdCliente: Integer read FIdCliente write FIdCliente;
    property NomeCliente: string read FNomeCliente write FNomeCliente;
    property Finalizada: Boolean read FFinalizada write FFinalizada;
    property Parcelas: TObjectList<TParcelaReceber> read FParcelas;
  end;

implementation

constructor TContaReceber.Create;
begin
  inherited;
  FParcelas := TObjectList<TParcelaReceber>.Create(True);
end;

destructor TContaReceber.Destroy;
begin
  FParcelas.Free;
  inherited;
end;

end.
