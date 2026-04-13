// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_menu => 'Main menu';

  @override
  String get nav_back => 'Back';

  @override
  String get fab_tooltip => 'New record';

  @override
  String get navbar_ultimasTransacoes => 'Last transactions';

  @override
  String get navbar_planilha => 'Spreadsheet';

  @override
  String timeline_bar_chart_revenue(Object value) {
    return 'Revenue: $value';
  }

  @override
  String timeline_bar_chart_spent(Object value) {
    return 'Expense: $value';
  }

  @override
  String timeline_bar_chart_goal(Object value) {
    return 'Goal: $value';
  }

  @override
  String get config_title => 'Configurations';

  @override
  String get config_darkmode => 'Dark mode';

  @override
  String get config_goal => 'Monthly expense goal';

  @override
  String get config_backup_create_label => 'Backup data';

  @override
  String get config_backup_create_done => 'Backup created!';

  @override
  String get config_backup_load_label => 'Load data backup';

  @override
  String get config_backup_load_done => 'Backup loaded!';

  @override
  String get config_prediction_fields => 'Autofill fields';

  @override
  String get confirm_backup_load_title => 'Attention!';

  @override
  String get confirm_backup_load_text =>
      'Loading the backup will erase your current data. Do you wish to continue?';

  @override
  String get label_revenue => 'Revenue';

  @override
  String get label_revenues => 'Revenues';

  @override
  String get label_expense => 'Expense';

  @override
  String get label_expenses => 'Expenses';

  @override
  String get label_new => 'New';

  @override
  String get label_enabled => 'Enabled';

  @override
  String get label_disabled => 'Disabled';

  @override
  String get title_new_revenue => 'New revenue';

  @override
  String get title_new_expense => 'New expense';

  @override
  String get title_edit_revenue => 'Edit revenue';

  @override
  String get title_edit_expense => 'Edit expense';

  @override
  String get input_transaction_amount_label => 'Amount';

  @override
  String get input_transaction_amount_hint => 'Amout of the transaction';

  @override
  String get input_transaction_description_label => 'Description';

  @override
  String get input_transaction_description_hint =>
      'Description of the transaction';

  @override
  String get title_new_category => 'New category';

  @override
  String get title_edit_category => 'Edit category';

  @override
  String get input_category_label_label => 'Label';

  @override
  String get input_category_label_hint => 'Label of the category';

  @override
  String get category_icon_label => 'Category icon';

  @override
  String get input_validation_required => 'This field is required';

  @override
  String get input_validation_transaction_amout_not_zero =>
      'The transaction amount cannot be zero';

  @override
  String get input_transaction_payment_method_label => 'Payment method';

  @override
  String get payment_method_cash_debit => 'Cash / Debit';

  @override
  String get payment_method_credit => 'Credit card';

  @override
  String get input_transaction_credit_card_label => 'Credit card';

  @override
  String get input_transaction_installments_label => 'Installments';

  @override
  String get input_transaction_category_label => 'Category';

  @override
  String get input_transaction_date_label => 'Date';

  @override
  String get title_new_credit_card => 'New credit card';

  @override
  String get title_edit_credit_card => 'Edit credit card';

  @override
  String get input_creditcard_description_label => 'Description';

  @override
  String get input_creditcard_description_hint =>
      'Description of the credit card';

  @override
  String get input_creditcard_close_day_label => 'Close day';

  @override
  String get input_creditcard_close_day_hint =>
      'Close day of your billing statement';

  @override
  String get input_creditcard_due_day_label => 'Due day';

  @override
  String get input_creditcard_due_day_hint =>
      'Due day of your billing statement';

  @override
  String get input_validation_day_of_month => 'Inform a value between 1 and 30';

  @override
  String get confirm_delete_transaction_title => 'Attention!';

  @override
  String get confirm_delete_transaction_text =>
      'Do you really want to delete this transaction? This action cannot be undone!';

  @override
  String get button_yes => 'Yes';

  @override
  String get button_no => 'No';

  @override
  String installment_label_suffix(Object value) {
    return ' ($value° installment)';
  }

  @override
  String get backup_config_title => 'Backup configurations';

  @override
  String get backup_config_available_modes => 'Available backup modes';

  @override
  String get backup_config_no_backup_selected =>
      'There is not a backup option selected yet! You can choose one of the options below.';

  @override
  String get backup_config_mode_google_drive => 'Google Drive';

  @override
  String get prediction_config_title => 'Autofill configurations';

  @override
  String get prediction_config_guidelines =>
      'The NOYA app can fill automatically some fields on expense and revenue forms based on your recent history. Here you can ajust these configurations or disable this feature in case you want to fill by your own.';

  @override
  String get prediction_config_on_off_switch => 'Autofill based on history';

  @override
  String get prediction_config_window => 'Evaluation window';

  @override
  String get prediction_config_window_hint => '(in days)';

  @override
  String get text_welcome => 'Welcome!';

  @override
  String get text_orientation =>
      'Start to control your personal finances by adding a transaction on ➕ button below!';
}
