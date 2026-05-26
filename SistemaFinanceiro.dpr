program SistemaFinanceiro;

uses
  Vcl.Forms,
  FrmPrincipal in 'FrmPrincipal.pas' {FormPrincipal},
  DataModule in 'DataModule.pas' {DM: TDataModule},
  FrmPessoa in 'FrmPessoa.pas' {FormPessoa},
  FrmContaPagar in 'FrmContaPagar.pas' {FrmContaPagar},
  FrmContaReceber in 'FrmContaReceber.pas' {FormContaReceber},
  ModelPessoa in 'ModelPessoa.pas',
  ModelContaPagar in 'ModelContaPagar.pas',
  ModelContaReceber in 'ModelContaReceber.pas',
  ControllerPessoa in 'ControllerPessoa.pas',
  ControllerContaPagar in 'ControllerContaPagar.pas',
  ControllerContaReceber in 'ControllerContaReceber.pas',
  Constantes in 'Constantes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FormPrincipal);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormPessoa, FormPessoa);
  Application.CreateForm(TFrmContaPagar, FormContaPagar);
  Application.CreateForm(TFormContaReceber, FormContaReceber);
  Application.Run;
end.
