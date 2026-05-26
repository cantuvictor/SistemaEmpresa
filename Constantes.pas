unit Constantes;

interface

const
  { Mensagens de confirmação }
  StrMsgConfirmaExclusao       = 'Deseja realmente excluir este registro?';
  StrMsgConfirmaExclusaoConta  = 'Deseja realmente excluir esta conta?';
  StrMsgConfirmaFinalizar      = 'Deseja finalizar esta conta? Não será possível alterar depois.';

  { Mensagens de sucesso }
  StrMsgSalvoSucesso           = 'Registro salvo com sucesso!';
  StrMsgContaSalva             = 'Conta salva com sucesso!';
  StrMsgFinalizadoSucesso      = 'Conta finalizada com sucesso!';

  { Mensagens de erro geral }
  StrMsgErroSalvar             = 'Erro ao salvar: ';
  StrMsgErroExcluir            = 'Erro ao excluir: ';
  StrMsgErroFinalizar          = 'Erro ao finalizar: ';
  StrMsgErroCep                = 'Erro ao buscar CEP: ';
  StrMsgErroVinculo            = 'Não é possível excluir este registro, pois ele está vinculado a contas a pagar ou receber.';

  { Mensagens de validação - Pessoa }
  StrMsgNomeObrigatorio        = 'Nome é obrigatório.';
  StrMsgTipoObrigatorio        = 'Selecione o tipo.';
  StrMsgCpfCnpjInvalido        = 'CPF/CNPJ inválido.';
  StrMsgEmailInvalido          = 'E-mail inválido.';
  StrMsgCpfCnpjDuplicado       = 'CPF/CNPJ já cadastrado para outra pessoa.';
  StrMsgCepInvalido            = 'CEP inválido. Digite 8 dígitos.';
  StrMsgCepNaoEncontrado       = 'CEP não encontrado.';
  StrMsgCepErroProcessar       = 'Erro ao processar retorno do CEP.';

  { Mensagens de validação - Contas }
  StrMsgFornecedorObrigatorio  = 'Selecione um fornecedor.';
  StrMsgClienteObrigatorio     = 'Selecione um cliente.';
  StrMsgValorPositivo          = 'O valor total deve ser maior que zero.';
  StrMsgParcelaObrigatoria     = 'Adicione ao menos uma parcela com valor maior que zero.';
  StrMsgContaFinalizadaAlterar = 'Conta finalizada não pode ser alterada.';
  StrMsgContaFinalizadaExcluir = 'Conta finalizada não pode ser excluída.';
  StrMsgContaJaFinalizada      = 'Conta já está finalizada.';
  StrMsgSalvarAntesFinalizar   = 'Salve a conta antes de finalizar.';
  StrMsgSelecioneExcluir       = 'Selecione um registro para excluir.';

  { Mensagens de validação - Parcelas }
  StrMsgDataParcelaVazia       = 'Preencha a data de vencimento da parcela ';
  StrMsgDataParcelaInvalida    = 'Data inválida na parcela ';
  StrMsgDataParcelaFormato     = '. Use o formato DD/MM/AAAA.';
  StrMsgDataParcelaEmissao     = ' não pode ser menor que a data de emissão.';
  StrMsgSomaParcelas           = 'A soma das parcelas (%s) não confere com o valor total (%s).';

  { SQL }
  StrSqlBuscarFornecedores     = 'SELECT ID_PESSOA, NOME FROM PESSOA WHERE TIPO IN (''F'', ''A'') ORDER BY NOME';
  StrSqlBuscarClientes         = 'SELECT ID_PESSOA, NOME FROM PESSOA WHERE TIPO IN (''C'', ''A'') ORDER BY NOME';
  StrSqlLastInsertId           = 'SELECT last_insert_rowid() AS ID';

  { UFs brasileiras }
  StrUfs: array[0..26] of string = (
    'AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO',
    'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR',
    'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO'
  );

implementation

end.
