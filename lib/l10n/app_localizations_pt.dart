// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get app_menu => 'Menu principal';

  @override
  String get menu_home => 'Início';

  @override
  String get menu_category => 'Categorias';

  @override
  String get menu_credit_card => 'Cartões de crédito';

  @override
  String get menu_settings => 'Configurações';

  @override
  String get nav_back => 'Voltar';

  @override
  String get fab_tooltip => 'Novo registro';

  @override
  String get navbar_ultimasTransacoes => 'Últimas transações';

  @override
  String get navbar_planilha => 'Planilhas';

  @override
  String timeline_bar_chart_revenue(Object value) {
    return 'Receitas: $value';
  }

  @override
  String timeline_bar_chart_spent(Object value) {
    return 'Despesas: $value';
  }

  @override
  String timeline_bar_chart_goal(Object value) {
    return 'Meta: $value';
  }

  @override
  String get config_title => 'Configurações';

  @override
  String get config_darkmode => 'Modo escuro';

  @override
  String get config_goal => 'Meta mensal de despesa';

  @override
  String get config_backup_create_label => 'Realizar backup dos dados';

  @override
  String get config_backup_create_done => 'Backup gerado!';

  @override
  String get config_backup_load_label => 'Carregar backup dos dados';

  @override
  String get config_backup_load_done => 'Backup carregado!';

  @override
  String get config_prediction_fields => 'Preenchimento automático de campos';

  @override
  String get confirm_backup_load_title => 'Atenção!';

  @override
  String get confirm_backup_load_text =>
      'Ao carregar o backup, os dados atuais serão perdidos. Deseja continuar?';

  @override
  String get label_revenue => 'Receita';

  @override
  String get label_revenues => 'Receitas';

  @override
  String get label_expense => 'Despesa';

  @override
  String get label_expenses => 'Despesas';

  @override
  String get label_new => 'Novo';

  @override
  String get label_enabled => 'Ativado';

  @override
  String get label_disabled => 'Desativado';

  @override
  String get title_new_revenue => 'Nova receita';

  @override
  String get title_new_expense => 'Nova despesa';

  @override
  String get title_edit_revenue => 'Edição de receita';

  @override
  String get title_edit_expense => 'Edição de despesa';

  @override
  String get input_transaction_amount_label => 'Quantia';

  @override
  String get input_transaction_amount_hint => 'Quantia da transação';

  @override
  String get input_transaction_description_label => 'Descrição';

  @override
  String get input_transaction_description_hint => 'Descrição da transação';

  @override
  String get title_new_category => 'Nova categoria';

  @override
  String get title_edit_category => 'Edição de categoria';

  @override
  String get input_category_label_label => 'Nome';

  @override
  String get input_category_label_hint => 'Nome da categoria';

  @override
  String get category_icon_label => 'Ícone da categoria';

  @override
  String get input_validation_required => 'Este campo é obrigatório';

  @override
  String get input_validation_transaction_amout_not_zero =>
      'A quantida da transação não pode ser zero';

  @override
  String get input_transaction_payment_method_label => 'Meio de pagamento';

  @override
  String get payment_method_cash_debit => 'Dinheiro / Débito';

  @override
  String get payment_method_credit => 'Cartão de crédito';

  @override
  String get input_transaction_credit_card_label => 'Cartão de crédito';

  @override
  String get input_transaction_installments_label => 'Parcelas';

  @override
  String get input_transaction_category_label => 'Categoria';

  @override
  String get input_transaction_date_label => 'Data';

  @override
  String get title_new_credit_card => 'Novo cartão de crédito';

  @override
  String get title_edit_credit_card => 'Edição de cartão de crédito';

  @override
  String get input_creditcard_description_label => 'Descrição';

  @override
  String get input_creditcard_description_hint =>
      'Descrição do cartão de crédito';

  @override
  String get input_creditcard_close_day_label => 'Dia do fechamento';

  @override
  String get input_creditcard_close_day_hint => 'Dia do fechamento da fatura';

  @override
  String get input_creditcard_due_day_label => 'Dia do vencimento';

  @override
  String get input_creditcard_due_day_hint => 'Dia do vencimento da fatura';

  @override
  String get input_validation_day_of_month => 'Informe um número entre 1 e 30';

  @override
  String get confirm_delete_transaction_title => 'Atenção!';

  @override
  String get confirm_delete_transaction_text =>
      'Deseja realmente apagar essa transação? Essa operação não poderá ser desfeita!';

  @override
  String get button_yes => 'Sim';

  @override
  String get button_no => 'Não';

  @override
  String installment_label_suffix(Object value) {
    return ' ($value° parcela)';
  }

  @override
  String get backup_config_title => 'Configurações de backup';

  @override
  String get backup_config_available_modes => 'Modos de backup disponíveis';

  @override
  String get backup_config_no_backup_selected =>
      'Ainda não há uma opção de backup selecionada! Você pode escolher uma das opções abaixo.';

  @override
  String get backup_config_mode_google_drive => 'Google Drive';

  @override
  String get prediction_config_title =>
      'Configurações de preenchimento automático';

  @override
  String get prediction_config_guidelines =>
      'O aplicativo NOYA pode preencher automaticamente alguns campos do formulário de despesa e receita com base no seu histórico recente. Aqui você pode ajustar essas configurações ou desabilitá-las totalmente caso deseje preencher por conta prória.';

  @override
  String get prediction_config_on_off_switch =>
      'Preenchimento com base no histórico';

  @override
  String get prediction_config_window => 'Janela de avaliação';

  @override
  String get prediction_config_window_hint => '(em dias)';

  @override
  String get text_welcome => 'Seja bem vindo!';

  @override
  String get text_orientation =>
      'Comece a controlar suas finanças adicionando uma transação clicando no botão ➕ abaixo!';

  @override
  String get category_list_no_data =>
      'Ainda não há nenhuma categoria cadastrada!';

  @override
  String get category_list_no_data_orientation =>
      'Cadastre sua primeira categoria clicando no botão ➕ acima!';

  @override
  String get confirm_delete_category_title => 'Atenção!';

  @override
  String get confirm_delete_category_text =>
      'Deseja realmente apagar essa categoria? Essa operação não poderá ser desfeita!';

  @override
  String error_delete_category_exists_transactions(Object num) {
    return 'Essa categoria não pode ser apagada pois existem $num transações associadas!';
  }

  @override
  String get error_title => 'Ops!';

  @override
  String get error_close => 'Fechar';

  @override
  String get credit_card_list_no_data =>
      'Ainda não há nenhum cartão de crédito cadastrado!';

  @override
  String get credit_card_list_no_data_orientation =>
      'Cadastre seu primeiro cartão de crédito clicando no botão ➕ acima!';

  @override
  String get confirm_delete_credit_card_title => 'Atenção!';

  @override
  String get confirm_delete_credit_card_text =>
      'Deseja realmente apagar esse cartão de crédito? Essa operação não poderá ser desfeita!';

  @override
  String error_delete_credit_card_exists_transactions(Object num) {
    return 'Esse cartão de crédito não pode ser apagado pois existem $num transações associadas!';
  }
}
