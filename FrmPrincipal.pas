unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, DataModule, Vcl.ExtCtrls;

type
  TFrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    mnuPessoas: TMenuItem;
    mnuPagar: TMenuItem;
    mnuReceber: TMenuItem;
    Image1: TImage;
    procedure mnuPessoasClick(Sender: TObject);
    procedure mnuPagarClick(Sender: TObject);
    procedure mnuReceberClick(Sender: TObject);
  private
  public
  end;

var
  FormPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses
  FrmPessoa, FrmContaPagar, FrmContaReceber;

procedure TFrmPrincipal.mnuPessoasClick(Sender: TObject);
begin
  FormPessoa.ShowModal;
end;

procedure TFrmPrincipal.mnuPagarClick(Sender: TObject);
begin
  FormContaPagar.ShowModal;
end;

procedure TFrmPrincipal.mnuReceberClick(Sender: TObject);
begin
  FormContaReceber.ShowModal;
end;

end.
