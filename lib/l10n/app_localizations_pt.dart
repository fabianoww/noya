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
      '\"ac_unit\":[\"neve, frio, invernos, natal, ferias\"],\"access_time\":[\"tempo, relogios, horas, agendamentos\"],\"accessibility\":[\"pessoas, humanos, roupas, vestuario\"],\"accessible_forward\":[\"acessibilidade, cadeiras, rodas\"],\"account_balance\":[\"bancos, financas, dinheiro, gregos, paternon, patrimonio, riqueza\"],\"account_balance_wallet\":[\"carteiras, dinheiro, bancos, juros, riqueza\"],\"agriculture\":[\"fazendas, agriculturas, trator, plantacao, plantacoes, colheitas\"],\"airplanemode_active\":[\"aviao, avioes, viagem, viagens, voo, ferias\"],\"alternate_email\":[\"e-mail, mail, email, arroba, internet\"],\"analytics\":[\"analises, graficos, dados, tendencias\"],\"anchor\":[\"ancoras, barcos, mares, oceanos, viagens\"],\"android\":[\"android, tecnologia, celulares, internet\"],\"apartment\":[\"apartamento, predio, casas, cidades, urbano\"],\"architecture\":[\"arquitetura, compassos, desenhos, ciencias\"],\"assistant_photo\":[\"bandeira, marcos, lugares\"],\"attach_money\":[\"dinheiro, dolar, pagamentos, salarios, bancos, receitas, moedas, riqueza\"],\"audiotrack\":[\"musica, audio, lazer, divertido, diversao\"],\"bakery_dining\":[\"padaria, pao, alimentos, alimentacao, lanches, croissant, frances, paris\"],\"bathtub\":[\"banho, banheira, relaxamento, spa, hotel, hoteis\"],\"beach_access\":[\"praia, ferias, viagem, viagens, relaxamento, divertido, diversao, verao, mares\"],\"bedtime\":[\"cama, sono, noite, luas, ceu\"],\"biotech\":[\"ciencias, tecnologia, microscopio, bacteria, virus, germes, saude\"],\"bolt\":[\"raio, eletricidade, relampago, rapido, tempestade\"],\"brightness_low\":[\"luz, brilho, sol, verao, ferias, praias\"],\"brush\":[\"pincel, pinceis , pinturas, artes\"],\"bug_report\":[\"erros, problemas, falhas, insetos, baratas, joaninhas, besouros\"],\"build\":[\"construcao, ferramentas, consertos, chaves, engenharia\"],\"cake\":[\"bolos, aniversarios, doces, festas\"],\"calculate\":[\"calculadora, matematica, operacoes, operacao, calculos, ciencias\"],\"call\":[\"ligacao, ligacoes, telefones, telecomunicacao, telefonia\"],\"camera_alt\":[\"cameras, fotos, fotografia\"],\"checkroom\":[\"roupas, vestuario, armarios, cabides, closets\"],\"child_friendly\":[\"criancas, bebes, filhos, infancia\"],\"cloud\":[\"nuvem, nuvens, climas, tempo, ceu, chuvas\"],\"color_lens\":[\"cores, artes, paletas, tintas\"],\"commute\":[\"transportes, coletivos, carros, onibus, metro, trens, trem, veiculos\"],\"construction\":[\"construcao, ferramentas, consertos, engenharia, martelos\"],\"content_cut\":[\"cortes, tesouras, tecidos, roupas\"],\"coronavirus\":[\"virus, saude, bacteria, germes\"],\"currency_exchange\":[\"moedas, cambio, dinheiro, pagamentos, trocas, riqueza\"],\"delete\":[\"excluir, exclusao, lixo, lixeira, deletar, delete, apagar, remover\"],\"delivery_dining\":[\"entregas, comidas, refeicao, pedidos, transportes, motocicleta, alimentos, alimentacao\"],\"directions_bike\":[\"bicicleta, bike, lazer, saude, exercicios\"],\"directions_boat\":[\"barco, navio, balsa, transportes, mares, oceanos\"],\"directions_bus\":[\"onibus, transportes, coletivos, cidades\"],\"directions_car\":[\"carros, veiculos, transportes, cidades\"],\"directions_railway\":[\"trem, trens, ferrovias, coletivos, cidades, transportes, veiculos\"],\"directions_subway\":[\"metro, ferrovias, coletivos, cidades, transportes, veiculos\"],\"eco\":[\"ecologia, natureza, folha, arvores, vegetacao, plantas\"],\"elderly\":[\"idosos, terceira idade, avos, senior\"],\"email\":[\"e-mail, mail, email, correios, envelopes, mensagem, mensagens, cartas\"],\"emoji_emotions\":[\"emoji, emocao, sorriso, smiles, diversao, alegria\"],\"emoji_events_outlined\":[\"trofeus, premios, podios, conquistas, vitorias\"],\"emoji_food_beverage\":[\"bebidas, cafes, chas, confortos\"],\"emoji_objects\":[\"ideia, lampada, luz, eureka, inovacao, genialidade\"],\"euro\":[\"euro, moedas, cambio, dinheiro, europa, riqueza\"],\"event\":[\"eventos, calendarios, agendas, compromissos\"],\"extension\":[\"peca, quebra-cabeca, encaixe, jogo, diversao\"],\"face_retouching_natural\":[\"beleza, rosto, selfie, maquiagem\"],\"family_restroom\":[\"familias, pais, maes, filhos\"],\"fastfood\":[\"comidas, refeicao, lanches, delivery, alimentos, alimentacao\"],\"favorite\":[\"favoritos, coraçao, coracoes, amores, paixao, paixoes\"],\"festival\":[\"festival, circos, feiras, diversao, festas\"],\"filter_hdr\":[\"montanhas, paisagem, paisagens, viagens, viagem, natureza\"],\"filter_vintage\":[\"flores, vintage, plantas, natureza\"],\"fitness_center\":[\"academias, exercicios, saude, musculacao\"],\"gavel\":[\"leis, juizes, martelos, justica, tribunal, tribunais\"],\"golf_course\":[\"golfe, esportes, natureza, lazer, jogos\"],\"grade\":[\"estrelas, avaliacao, avaliacoes, notas, brilhantes, céu, espaço, primeiro, vitória\"],\"headset\":[\"fones, audio, musica, fones, games, jogos\"],\"home\":[\"casas, lares, cidades, domesticos\"],\"hotel\":[\"hotel, hoteis, hospedagem, hospedagens, camas, sono, confortavel\"],\"keyboard_rounded\":[\"teclados, computadores, tecnologia, inovacao, programacao\"],\"language\":[\"idiomas, mundos, globos, planetas, internacional, internacionais\"],\"laptop\":[\"notebook, computadores, tecnologia, inovacao, programacao, trabalhos\"],\"liquor\":[\"bebidas, alcool, drink, lazer, diversao, bares\"],\"local_bar\":[\"bares, bebidas, drinks, leisure, diversao, classicos, estilos\"],\"local_cafe\":[\"cafe, canecas, xicaras, intervalos, pausas\"],\"local_dining\":[\"restaurantes, comidas, alimentos, alimentacao, refeicao, refeicoes\"],\"local_florist\":[\"flores, floristas, natureza, plantas\"],\"local_hospital_rounded\":[\"hospital, hospitais, saude, medico, medicina, doutores, ferimentos\"],\"local_gas_station\":[\"posto, combustivel, combustiveis, carros, transportes, veiculos\"],\"shopping_cart\":[\"compras, supermercados, lojas, alimentos, alimentacao, comidas\"],\"local_laundry_service\":[\"lavanderias, roupas, limpeza\"],\"local_library\":[\"bibliotecas, livros, leituras, lazer, culturas, estorias, educacao\"],\"local_pizza\":[\"pizzas, comidas, alimentos, alimentacao, refeicao, refeicoes, lanches\"],\"local_print_shop\":[\"impressoras, impressao, computadores, papel, papeis, documentos\"],\"location_on\":[\"localizacao, localizacoes, lugares, mapas, enderecos, viagem, viagens\"],\"map\":[\"mapas, localizacao, localizacoes, lugares, viagem, viagens\"],\"mouse\":[\"mouses, computadores, tecnologias, inovacao, trabalhos\"],\"movie\":[\"filmes, cinemas, lazer, culturas\"],\"pets\":[\"pets, animal, animais, estimacao, cachorros, gatos\"],\"phone_android\":[\"telefones, celulares, tecnologias, computadores\"],\"pix\":[\"pix, pagamentos, transacao, transacoes, bancos, dinheiro, moedas\"],\"push_pin\":[\"alfinetes, marcar, postar, fixar\"],\"radio_rounded\":[\"radios, musicas, culturas, ondas\"],\"redeem\":[\"presentes, lembrancas, natal, aniversarios\"],\"savings\":[\"poupancas, dinheiro, moedas, bancos, reservas\"],\"science\":[\"ciencias, laboratorios, experimentos, quimicas, universidades, educacao\"],\"self_improvement\":[\"meditacao, meditacoes, bem-estar, calma, zen, yoga, relaxamento\"],\"sports_bar\":[\"bares, esportivos, bebidas, cervejas, lazer, diversao\"],\"sports_baseball\":[\"beisebol, esportes, diversao, atleticos\"],\"sports_basketball\":[\"basquete, esportes, diversao, atleticos\"],\"sports_cricket\":[\"criquete, esportes, diversao, atleticos\"],\"sports_esports\":[\"jogos, videogames, esportes, diversao, eletronicos, xbox, playstation, steam, joystick, controle\"],\"sports_football\":[\"futebol, americano, esportes, diversao, atleticos\"],\"sports_golf\":[\"golfe, esportes, diversao, atleticos\"],\"sports_hockey\":[\"hoquei, esportes, diversao, atleticos\"],\"sports_mma\":[\"mma, lutas, esportes, diversao, atleticos, boxe\"],\"sports_motorsports\":[\"corridas, carros, esportes, diversao\"],\"sports_soccer\":[\"futebol, esportes, diversao, atleticos\"],\"sports_tennis\":[\"tenis, esportes, diversao, atleticos\"],\"sports_volleyball\":[\"volei, esportes, diversao, atleticos\"],\"store\":[\"lojas, comercios, cidades, centros\"],\"thumb_up\":[\"curtir, aprovar, acima, positivos, ok\"],\"thumb_down\":[\"noo gostei, rejeitar, abaixo, negativo\"],\"two_wheeler_outlined\":[\"motos, motocicletas, viagem, viagens, lazer, veiculos, transportes\"],\"videocam_rounded\":[\"videos, cameras, gravacao, gravacoes, filmes\"],\"volunteer_activism\":[\"voluntarios, caridades, doacoes, doar, dar\"],\"vpn_key\":[\"chaves, senhas, segredos, segurancas\"],\"watch_rounded\":[\"relogios, tempos, joias\"],\"wb_incandescent\":[\"lampadas, luzes, ideias, inovacao, eureka\"],\"wb_sunny\":[\"sol, climas, verao, quente, lazer, paisagens\"],\"weekend_rounded\":[\"fim de semana, descansos, sofas, lazer, filmes, tvs, televisao, series\"],\"wine_bar\":[\"vinhos, bebidas, lazer, diversao, bares\"]';

  @override
  String get error_category_icon_required =>
      'Selecione um ícone para sua categoria!';
}
