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
  String get menu_home => 'Home';

  @override
  String get menu_category => 'Categories';

  @override
  String get menu_credit_card => 'Credit cards';

  @override
  String get menu_settings => 'Settings';

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
  String get config_title => 'Settings';

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

  @override
  String get category_list_no_data => 'You don\'t have any category yet!';

  @override
  String get category_list_no_data_orientation =>
      'Register your first category on the ➕ button above!';

  @override
  String get confirm_delete_category_title => 'Attention!';

  @override
  String get confirm_delete_category_text =>
      'Do you really want to delete this category? This action cannot be undone!';

  @override
  String error_delete_category_exists_transactions(Object num) {
    return 'This category cannot be deleted. There are $num transactions linked to it!';
  }

  @override
  String get error_title => 'Oops!';

  @override
  String get error_close => 'Close';

  @override
  String get credit_card_list_no_data => 'You don\'t have any credit card yet!';

  @override
  String get credit_card_list_no_data_orientation =>
      'Register your first credit card on the ➕ button above!';

  @override
  String get confirm_delete_credit_card_title => 'Attention!';

  @override
  String get confirm_delete_credit_card_text =>
      'Do you really want to delete this credit card? This action cannot be undone!';

  @override
  String error_delete_credit_card_exists_transactions(Object num) {
    return 'This credit card cannot be deleted. There are $num transactions linked to it!';
  }

  @override
  String get category_icon_search_hint => 'Search an icon';

  @override
  String get category_icon_keywords =>
      '\"ac_unit\":[\"snow, cold, winter\"],\"access_time\":[\"time, clock, hour\"],\"accessibility\":[\"accessibility, person\"],\"accessible_forward\":[\"accessible, wheelchair\"],\"account_balance\":[\"bank, finance\"],\"account_balance_wallet\":[\"wallet, money\"],\"agriculture\":[\"farm, agriculture\"],\"airplanemode_active\":[\"airplane, travel, flight\"],\"alternate_email\":[\"email, at\"],\"analytics\":[\"analytics, chart, data\"],\"anchor\":[\"anchor, boat\"],\"android\":[\"android, technology\"],\"apartment\":[\"apartment, building\"],\"architecture\":[\"architecture, building\"],\"assistant_photo\":[\"flag, photo\"],\"attach_money\":[\"money, dollar, cash\"],\"audiotrack\":[\"music, audio\"],\"bakery_dining\":[\"bakery, bread\"],\"bathtub\":[\"bath, bathtub\"],\"beach_access\":[\"beach, vacation\"],\"bedtime\":[\"bed, sleep, night\"],\"biotech\":[\"science, biotech\"],\"bolt\":[\"bolt, electricity\"],\"brightness_low\":[\"light, brightness\"],\"brush\":[\"brush, paint, art\"],\"bug_report\":[\"bug, error\"],\"build\":[\"build, tools, repair\"],\"cake\":[\"cake, birthday\"],\"calculate\":[\"calculator, math\"],\"call\":[\"call, phone\"],\"camera_alt\":[\"camera, photo\"],\"checkroom\":[\"clothes, wardrobe\"],\"child_friendly\":[\"child, baby\"],\"cloud\":[\"cloud, weather\"],\"color_lens\":[\"color, art\"],\"commute\":[\"commute, transport\"],\"construction\":[\"construction, tools\"],\"content_cut\":[\"cut, scissors\"],\"coronavirus\":[\"virus, health\"],\"currency_exchange\":[\"currency, exchange, money\"],\"delete\":[\"delete, trash\"],\"delivery_dining\":[\"delivery, food\"],\"directions_bike\":[\"bike, bicycle\"],\"directions_boat\":[\"boat, ship\"],\"directions_bus\":[\"bus, transport\"],\"directions_car\":[\"car, vehicle\"],\"directions_railway\":[\"train, railway\"],\"directions_subway\":[\"subway, metro\"],\"eco\":[\"eco, nature, leaf\"],\"elderly\":[\"elderly, senior\"],\"email\":[\"email, mail\"],\"emoji_emotions\":[\"emoji, emotion, smile\"],\"emoji_events_outlined\":[\"trophy, award\"],\"emoji_food_beverage\":[\"food, drink, coffee\"],\"emoji_objects\":[\"idea, bulb\"],\"euro\":[\"euro, money\"],\"event\":[\"event, calendar\"],\"extension\":[\"extension, puzzle\"],\"face_retouching_natural\":[\"beauty, face\"],\"family_restroom\":[\"family, restroom\"],\"fastfood\":[\"fast food, burger\"],\"favorite\":[\"favorite, heart, love\"],\"festival\":[\"festival, celebration\"],\"filter_hdr\":[\"mountain, landscape\"],\"filter_vintage\":[\"flower, vintage\"],\"fitness_center\":[\"fitness, gym, exercise\"],\"gavel\":[\"law, judge, gavel\"],\"golf_course\":[\"golf, sport\"],\"grade\":[\"star, rating\"],\"headset\":[\"headset, audio, music\"],\"home\":[\"home, house\"],\"hotel\":[\"hotel, lodging\"],\"keyboard_rounded\":[\"keyboard, computer\"],\"language\":[\"language, world\"],\"laptop\":[\"laptop, computer\"],\"liquor\":[\"liquor, drink\"],\"local_bar\":[\"bar, drink\"],\"local_cafe\":[\"cafe, coffee\"],\"local_dining\":[\"restaurant, food\"],\"local_florist\":[\"flower, florist\"],\"local_hospital_rounded\":[\"hospital, health\"],\"local_gas_station\":[\"gas, fuel\"],\"shopping_cart\":[\"shopping, cart, store\"],\"local_laundry_service\":[\"laundry, clothes\"],\"local_library\":[\"library, books\"],\"local_pizza\":[\"pizza, food\"],\"local_print_shop\":[\"printer, print\"],\"location_on\":[\"location, place, map\"],\"map\":[\"map, location\"],\"mouse\":[\"mouse, computer\"],\"movie\":[\"movie, cinema, film\"],\"pets\":[\"pet, animal, dog\"],\"phone_android\":[\"phone, mobile\"],\"pix\":[\"pix, payment\"],\"push_pin\":[\"pin, mark\"],\"radio_rounded\":[\"radio, music\"],\"redeem\":[\"gift, present\"],\"savings\":[\"savings, money\"],\"science\":[\"science, lab\"],\"self_improvement\":[\"meditation, wellness\"],\"sports_bar\":[\"sports bar, drink\"],\"sports_baseball\":[\"baseball, sport\"],\"sports_basketball\":[\"basketball, sport\"],\"sports_cricket\":[\"cricket, sport\"],\"sports_esports\":[\"gaming, games\"],\"sports_football\":[\"football, sport\"],\"sports_golf\":[\"golf, sport\"],\"sports_hockey\":[\"hockey, sport\"],\"sports_mma\":[\"mma, fight, sport\"],\"sports_motorsports\":[\"racing, car, sport\"],\"sports_soccer\":[\"soccer, football, sport\"],\"sports_tennis\":[\"tennis, sport\"],\"sports_volleyball\":[\"volleyball, sport\"],\"store\":[\"store, shop\"],\"thumb_up\":[\"like, approve\"],\"thumb_down\":[\"dislike, reject\"],\"two_wheeler_outlined\":[\"motorcycle, bike\"],\"videocam_rounded\":[\"video, camera\"],\"volunteer_activism\":[\"volunteer, charity\"],\"vpn_key\":[\"key, password\"],\"watch_rounded\":[\"watch, time\"],\"wb_incandescent\":[\"bulb, light, idea\"],\"wb_sunny\":[\"sun, weather\"],\"weekend_rounded\":[\"weekend, rest\"],\"wine_bar\":[\"wine, drink\"]';

  @override
  String get error_category_icon_required =>
      'Select an icon for your category!';
}
