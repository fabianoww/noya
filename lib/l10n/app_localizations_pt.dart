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

  @override
  String get category_icon_search_hint => 'Buscar um ícone';

  @override
  String get category_icon_keywords =>
      '\"ac_unit\":[\"neve, frio, inverno\"],\"access_time\":[\"tempo, relógio, hora\"],\"accessibility\":[\"acessibilidade, pessoa\"],\"accessible_forward\":[\"acessível, cadeira de rodas\"],\"account_balance\":[\"banco, finanças\"],\"account_balance_wallet\":[\"carteira, dinheiro\"],\"agriculture\":[\"fazenda, agricultura\"],\"airplanemode_active\":[\"avião, viagem, voo\"],\"alternate_email\":[\"e-mail, arroba\"],\"analytics\":[\"análise, gráfico, dados\"],\"anchor\":[\"âncora, barco\"],\"android\":[\"android, tecnologia\"],\"apartment\":[\"apartamento, prédio\"],\"architecture\":[\"arquitetura, prédio\"],\"assistant_photo\":[\"bandeira, foto\"],\"attach_money\":[\"dinheiro, dólar, pagamento\"],\"audiotrack\":[\"música, áudio\"],\"bakery_dining\":[\"padaria, pão\"],\"bathtub\":[\"banho, banheira\"],\"beach_access\":[\"praia, férias\"],\"bedtime\":[\"cama, sono, noite\"],\"biotech\":[\"ciência, biotecnologia\"],\"bolt\":[\"raio, eletricidade\"],\"brightness_low\":[\"luz, brilho\"],\"brush\":[\"pincel, pintura, arte\"],\"bug_report\":[\"erro, problema\"],\"build\":[\"construção, ferramentas, conserto\"],\"cake\":[\"bolo, aniversário\"],\"calculate\":[\"calculadora, matemática\"],\"call\":[\"ligação, telefone\"],\"camera_alt\":[\"câmera, foto\"],\"checkroom\":[\"roupas, armário\"],\"child_friendly\":[\"criança, bebê\"],\"cloud\":[\"nuvem, clima\"],\"color_lens\":[\"cor, arte\"],\"commute\":[\"deslocamento, transporte\"],\"construction\":[\"construção, ferramentas\"],\"content_cut\":[\"corte, tesoura\"],\"coronavirus\":[\"vírus, saúde\"],\"currency_exchange\":[\"moeda, câmbio, dinheiro\"],\"delete\":[\"excluir, lixo\"],\"delivery_dining\":[\"entrega, comida\"],\"directions_bike\":[\"bicicleta\"],\"directions_boat\":[\"barco, navio\"],\"directions_bus\":[\"ônibus, transporte\"],\"directions_car\":[\"carro, veículo\"],\"directions_railway\":[\"trem, ferrovia\"],\"directions_subway\":[\"metrô, transporte\"],\"eco\":[\"ecologia, natureza, folha\"],\"elderly\":[\"idoso, terceira idade\"],\"email\":[\"e-mail, correio\"],\"emoji_emotions\":[\"emoji, emoção, sorriso\"],\"emoji_events_outlined\":[\"troféu, prêmio\"],\"emoji_food_beverage\":[\"comida, bebida, café\"],\"emoji_objects\":[\"ideia, lâmpada\"],\"euro\":[\"euro, dinheiro\"],\"event\":[\"evento, calendário\"],\"extension\":[\"extensão, quebra-cabeça\"],\"face_retouching_natural\":[\"beleza, rosto\"],\"family_restroom\":[\"família, banheiro\"],\"fastfood\":[\"lanche, hambúrguer\"],\"favorite\":[\"favorito, coração, amor\"],\"festival\":[\"festival, comemoração\"],\"filter_hdr\":[\"montanha, paisagem\"],\"filter_vintage\":[\"flor, vintage\"],\"fitness_center\":[\"academia, exercício\"],\"gavel\":[\"lei, juiz, martelo\"],\"golf_course\":[\"golfe, esporte\"],\"grade\":[\"estrela, avaliação\"],\"headset\":[\"fone, áudio, música\"],\"home\":[\"casa, lar\"],\"hotel\":[\"hotel, hospedagem\"],\"keyboard_rounded\":[\"teclado, computador\"],\"language\":[\"idioma, mundo\"],\"laptop\":[\"notebook, computador\"],\"liquor\":[\"bebida, álcool\"],\"local_bar\":[\"bar, bebida\"],\"local_cafe\":[\"café\"],\"local_dining\":[\"restaurante, comida\"],\"local_florist\":[\"flor, florista\"],\"local_hospital_rounded\":[\"hospital, saúde\"],\"local_gas_station\":[\"posto, combustível\"],\"shopping_cart\":[\"compras, carrinho, loja\"],\"local_laundry_service\":[\"lavanderia, roupas\"],\"local_library\":[\"biblioteca, livros\"],\"local_pizza\":[\"pizza, comida\"],\"local_print_shop\":[\"impressora, impressão\"],\"location_on\":[\"localização, lugar, mapa\"],\"map\":[\"mapa, localização\"],\"mouse\":[\"mouse, computador\"],\"movie\":[\"filme, cinema\"],\"pets\":[\"animal, estimação, cachorro\"],\"phone_android\":[\"telefone, celular\"],\"pix\":[\"pix, pagamento\"],\"push_pin\":[\"alfinete, marcar\"],\"radio_rounded\":[\"rádio, música\"],\"redeem\":[\"presente, lembrança\"],\"savings\":[\"poupança, dinheiro\"],\"science\":[\"ciência, laboratório\"],\"self_improvement\":[\"meditação, bem-estar\"],\"sports_bar\":[\"bar esportivo, bebida\"],\"sports_baseball\":[\"beisebol, esporte\"],\"sports_basketball\":[\"basquete, esporte\"],\"sports_cricket\":[\"críquete, esporte\"],\"sports_esports\":[\"jogos, videogame\"],\"sports_football\":[\"futebol americano, esporte\"],\"sports_golf\":[\"golfe, esporte\"],\"sports_hockey\":[\"hóquei, esporte\"],\"sports_mma\":[\"mma, luta, esporte\"],\"sports_motorsports\":[\"corrida, carro, esporte\"],\"sports_soccer\":[\"futebol, esporte\"],\"sports_tennis\":[\"tênis, esporte\"],\"sports_volleyball\":[\"vôlei, esporte\"],\"store\":[\"loja, comércio\"],\"thumb_up\":[\"curtir, aprovar\"],\"thumb_down\":[\"não gostei, rejeitar\"],\"two_wheeler_outlined\":[\"moto, motocicleta\"],\"videocam_rounded\":[\"vídeo, câmera\"],\"volunteer_activism\":[\"voluntário, caridade\"],\"vpn_key\":[\"chave, senha\"],\"watch_rounded\":[\"relógio, tempo\"],\"wb_incandescent\":[\"lâmpada, luz, ideia\"],\"wb_sunny\":[\"sol, clima\"],\"weekend_rounded\":[\"fim de semana, descanso\"],\"wine_bar\":[\"vinho, bebida\"]';
}
