import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @app_menu.
  ///
  /// In pt, this message translates to:
  /// **'Menu principal'**
  String get app_menu;

  /// No description provided for @nav_back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get nav_back;

  /// No description provided for @fab_tooltip.
  ///
  /// In pt, this message translates to:
  /// **'Novo registro'**
  String get fab_tooltip;

  /// No description provided for @navbar_ultimasTransacoes.
  ///
  /// In pt, this message translates to:
  /// **'Últimas transações'**
  String get navbar_ultimasTransacoes;

  /// No description provided for @navbar_planilha.
  ///
  /// In pt, this message translates to:
  /// **'Planilhas'**
  String get navbar_planilha;

  /// No description provided for @timeline_bar_chart_revenue.
  ///
  /// In pt, this message translates to:
  /// **'Receitas: {value}'**
  String timeline_bar_chart_revenue(Object value);

  /// No description provided for @timeline_bar_chart_spent.
  ///
  /// In pt, this message translates to:
  /// **'Despesas: {value}'**
  String timeline_bar_chart_spent(Object value);

  /// No description provided for @timeline_bar_chart_goal.
  ///
  /// In pt, this message translates to:
  /// **'Meta: {value}'**
  String timeline_bar_chart_goal(Object value);

  /// No description provided for @config_title.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get config_title;

  /// No description provided for @config_darkmode.
  ///
  /// In pt, this message translates to:
  /// **'Modo escuro'**
  String get config_darkmode;

  /// No description provided for @config_goal.
  ///
  /// In pt, this message translates to:
  /// **'Meta mensal de despesa'**
  String get config_goal;

  /// No description provided for @config_backup_mode.
  ///
  /// In pt, this message translates to:
  /// **'Modo de backup'**
  String get config_backup_mode;

  /// No description provided for @config_prediction_fields.
  ///
  /// In pt, this message translates to:
  /// **'Preenchimento automático de campos'**
  String get config_prediction_fields;

  /// No description provided for @label_revenue.
  ///
  /// In pt, this message translates to:
  /// **'Receita'**
  String get label_revenue;

  /// No description provided for @label_revenues.
  ///
  /// In pt, this message translates to:
  /// **'Receitas'**
  String get label_revenues;

  /// No description provided for @label_expense.
  ///
  /// In pt, this message translates to:
  /// **'Despesa'**
  String get label_expense;

  /// No description provided for @label_expenses.
  ///
  /// In pt, this message translates to:
  /// **'Despesas'**
  String get label_expenses;

  /// No description provided for @label_new.
  ///
  /// In pt, this message translates to:
  /// **'Novo'**
  String get label_new;

  /// No description provided for @label_enabled.
  ///
  /// In pt, this message translates to:
  /// **'Ativado'**
  String get label_enabled;

  /// No description provided for @label_disabled.
  ///
  /// In pt, this message translates to:
  /// **'Desativado'**
  String get label_disabled;

  /// No description provided for @title_new_revenue.
  ///
  /// In pt, this message translates to:
  /// **'Nova receita'**
  String get title_new_revenue;

  /// No description provided for @title_new_expense.
  ///
  /// In pt, this message translates to:
  /// **'Nova despesa'**
  String get title_new_expense;

  /// No description provided for @title_edit_revenue.
  ///
  /// In pt, this message translates to:
  /// **'Edição de receita'**
  String get title_edit_revenue;

  /// No description provided for @title_edit_expense.
  ///
  /// In pt, this message translates to:
  /// **'Edição de despesa'**
  String get title_edit_expense;

  /// No description provided for @input_transaction_amount_label.
  ///
  /// In pt, this message translates to:
  /// **'Quantia'**
  String get input_transaction_amount_label;

  /// No description provided for @input_transaction_amount_hint.
  ///
  /// In pt, this message translates to:
  /// **'Quantia da transação'**
  String get input_transaction_amount_hint;

  /// No description provided for @input_transaction_description_label.
  ///
  /// In pt, this message translates to:
  /// **'Descrição'**
  String get input_transaction_description_label;

  /// No description provided for @input_transaction_description_hint.
  ///
  /// In pt, this message translates to:
  /// **'Descrição da transação'**
  String get input_transaction_description_hint;

  /// No description provided for @title_new_category.
  ///
  /// In pt, this message translates to:
  /// **'Nova categoria'**
  String get title_new_category;

  /// No description provided for @title_edit_category.
  ///
  /// In pt, this message translates to:
  /// **'Edição de categoria'**
  String get title_edit_category;

  /// No description provided for @input_category_label_label.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get input_category_label_label;

  /// No description provided for @input_category_label_hint.
  ///
  /// In pt, this message translates to:
  /// **'Nome da categoria'**
  String get input_category_label_hint;

  /// No description provided for @category_icon_label.
  ///
  /// In pt, this message translates to:
  /// **'Ícone da categoria'**
  String get category_icon_label;

  /// No description provided for @input_validation_required.
  ///
  /// In pt, this message translates to:
  /// **'Este campo é obrigatório'**
  String get input_validation_required;

  /// No description provided for @input_validation_transaction_amout_not_zero.
  ///
  /// In pt, this message translates to:
  /// **'A quantida da transação não pode ser zero'**
  String get input_validation_transaction_amout_not_zero;

  /// No description provided for @input_transaction_payment_method_label.
  ///
  /// In pt, this message translates to:
  /// **'Meio de pagamento'**
  String get input_transaction_payment_method_label;

  /// No description provided for @payment_method_cash_debit.
  ///
  /// In pt, this message translates to:
  /// **'Dinheiro / Débito'**
  String get payment_method_cash_debit;

  /// No description provided for @payment_method_credit.
  ///
  /// In pt, this message translates to:
  /// **'Cartão de crédito'**
  String get payment_method_credit;

  /// No description provided for @input_transaction_credit_card_label.
  ///
  /// In pt, this message translates to:
  /// **'Cartão de crédito'**
  String get input_transaction_credit_card_label;

  /// No description provided for @input_transaction_installments_label.
  ///
  /// In pt, this message translates to:
  /// **'Parcelas'**
  String get input_transaction_installments_label;

  /// No description provided for @input_transaction_category_label.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get input_transaction_category_label;

  /// No description provided for @input_transaction_date_label.
  ///
  /// In pt, this message translates to:
  /// **'Data'**
  String get input_transaction_date_label;

  /// No description provided for @title_new_credit_card.
  ///
  /// In pt, this message translates to:
  /// **'Novo cartão de crédito'**
  String get title_new_credit_card;

  /// No description provided for @title_edit_credit_card.
  ///
  /// In pt, this message translates to:
  /// **'Edição de cartão de crédito'**
  String get title_edit_credit_card;

  /// No description provided for @input_creditcard_description_label.
  ///
  /// In pt, this message translates to:
  /// **'Descrição'**
  String get input_creditcard_description_label;

  /// No description provided for @input_creditcard_description_hint.
  ///
  /// In pt, this message translates to:
  /// **'Descrição do cartão de crédito'**
  String get input_creditcard_description_hint;

  /// No description provided for @input_creditcard_close_day_label.
  ///
  /// In pt, this message translates to:
  /// **'Dia do fechamento'**
  String get input_creditcard_close_day_label;

  /// No description provided for @input_creditcard_close_day_hint.
  ///
  /// In pt, this message translates to:
  /// **'Dia do fechamento da fatura'**
  String get input_creditcard_close_day_hint;

  /// No description provided for @input_creditcard_due_day_label.
  ///
  /// In pt, this message translates to:
  /// **'Dia do vencimento'**
  String get input_creditcard_due_day_label;

  /// No description provided for @input_creditcard_due_day_hint.
  ///
  /// In pt, this message translates to:
  /// **'Dia do vencimento da fatura'**
  String get input_creditcard_due_day_hint;

  /// No description provided for @input_validation_day_of_month.
  ///
  /// In pt, this message translates to:
  /// **'Informe um número entre 1 e 30'**
  String get input_validation_day_of_month;

  /// No description provided for @confirm_delete_transaction_title.
  ///
  /// In pt, this message translates to:
  /// **'Atenção!'**
  String get confirm_delete_transaction_title;

  /// No description provided for @confirm_delete_transaction_text.
  ///
  /// In pt, this message translates to:
  /// **'Deseja realmente apagar essa transação? Essa operação não poderá ser desfeita!'**
  String get confirm_delete_transaction_text;

  /// No description provided for @button_yes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get button_yes;

  /// No description provided for @button_no.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get button_no;

  /// No description provided for @installment_label_suffix.
  ///
  /// In pt, this message translates to:
  /// **' ({value}° parcela)'**
  String installment_label_suffix(Object value);

  /// No description provided for @backup_config_title.
  ///
  /// In pt, this message translates to:
  /// **'Configurações de backup'**
  String get backup_config_title;

  /// No description provided for @backup_config_available_modes.
  ///
  /// In pt, this message translates to:
  /// **'Modos de backup disponíveis'**
  String get backup_config_available_modes;

  /// No description provided for @backup_config_no_backup_selected.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não há uma opção de backup selecionada! Você pode escolher uma das opções abaixo.'**
  String get backup_config_no_backup_selected;

  /// No description provided for @backup_config_mode_google_drive.
  ///
  /// In pt, this message translates to:
  /// **'Google Drive'**
  String get backup_config_mode_google_drive;

  /// No description provided for @prediction_config_title.
  ///
  /// In pt, this message translates to:
  /// **'Configurações de preenchimento automático'**
  String get prediction_config_title;

  /// No description provided for @prediction_config_guidelines.
  ///
  /// In pt, this message translates to:
  /// **'O aplicativo NOYA pode preencher automaticamente alguns campos do formulário de despesa e receita com base no seu histórico recente. Aqui você pode ajustar essas configurações ou desabilitá-las totalmente caso deseje preencher por conta prória.'**
  String get prediction_config_guidelines;

  /// No description provided for @prediction_config_on_off_switch.
  ///
  /// In pt, this message translates to:
  /// **'Preenchimento com base no histórico'**
  String get prediction_config_on_off_switch;

  /// No description provided for @prediction_config_window.
  ///
  /// In pt, this message translates to:
  /// **'Janela de avaliação'**
  String get prediction_config_window;

  /// No description provided for @prediction_config_window_hint.
  ///
  /// In pt, this message translates to:
  /// **'(em dias)'**
  String get prediction_config_window_hint;

  /// No description provided for @text_welcome.
  ///
  /// In pt, this message translates to:
  /// **'Seja bem vindo!'**
  String get text_welcome;

  /// No description provided for @text_orientation.
  ///
  /// In pt, this message translates to:
  /// **'Comece a controlar suas finanças adicionando uma transação clicando no botão ➕ abaixo!'**
  String get text_orientation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
