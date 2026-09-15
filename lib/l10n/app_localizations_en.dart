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
  String get navbar_analytics => 'Analytics';

  @override
  String get analytics_expenses_by_category => 'Expenses by category';

  @override
  String get analytics_history => 'History';

  @override
  String get analytics_evolution => 'Evolution';

  @override
  String get analytics_no_data => 'No data available';

  @override
  String get analytics_period_month => 'Monthly';

  @override
  String get analytics_period_year => 'Annual';

  @override
  String get analytics_period_custom => 'Custom';

  @override
  String get analytics_start_date => 'Start date';

  @override
  String get analytics_end_date => 'End date';

  @override
  String get analytics_select_start_date => 'Select start date';

  @override
  String get analytics_select_end_date => 'Select end date';

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
  String get input_transaction_amount_hint => 'Transaction amount';

  @override
  String get input_transaction_description_label => 'Description';

  @override
  String get input_transaction_description_hint => 'Transaction\'s amount';

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
      '\"ac_unit\":[\"snow, cold, winters, christmas, vacations\"],\"access_time\":[\"time, clocks, hours, schedules\"],\"accessibility\":[\"persons, humans, clothing\"],\"accessible_forward\":[\"accessible, wheels, chairs\"],\"account_balance\":[\"banks, finances, greeks, parthenon, heritage, money, wealth\"],\"account_balance_wallet\":[\"wallets, money, banks, interests, wealth\"],\"agriculture\":[\"farms, agriculture, tractor, crops, harvests\"],\"airplanemode_active\":[\"airplanes, travel, flights, vacations\"],\"alternate_email\":[\"e-mail, mail, email, at, internet\"],\"analytics\":[\"analytics, charts, data, trends\"],\"anchor\":[\"anchor, boat, seas, oceans, travels\"],\"android\":[\"android, technology, cellphones, internet\"],\"apartment\":[\"apartment, building, homes, city, cities, towns, urban\"],\"architecture\":[\"architecture, compass, drawing, sciences\"],\"assistant_photo\":[\"flag, landmark, places\"],\"attach_money\":[\"money, dollar, cash, wages, banks, incomes, currency, payments, wealth\"],\"audiotrack\":[\"music, audio, leisure, fun\"],\"bakery_dining\":[\"bakery, bread, foods, snacks, croissant, french, paris\"],\"bathtub\":[\"bath, bathtub, relaxation, spa, hotels\"],\"beach_access\":[\"beaches, vacation, travels, relaxation, fun, summer, seas\"],\"bedtime\":[\"bed, sleep, night, moons, sky\"],\"biotech\":[\"sciences, technology, microscope, bacteria, viruses, germs, health\"],\"bolt\":[\"bolt, electricity, lightning, fast, storm\"],\"brightness_low\":[\"light, brightness, sun, summer, vacations, beaches\"],\"brush\":[\"brushes, paint, paintings, arts\"],\"bug_report\":[\"bug, error, faults, insects, cockroaches, ladybugs, beetles\"],\"build\":[\"builds, tools, repairs, fixes, wrench, engeneering\"],\"cake\":[\"cakes, birthdays, sweets, candy, parties, party\"],\"calculate\":[\"calculator, math, operations, calculations, sciences\"],\"call\":[\"calls, phones, telecommunications, telephony\"],\"camera_alt\":[\"cameras, photos, photography\"],\"checkroom\":[\"clothes, wardrobe, hangers, closets\"],\"child_friendly\":[\"children, baby, babies, kids, infancy\"],\"cloud\":[\"clouds, weather, climate, sky, rain\"],\"color_lens\":[\"colors, arts, palletes, ink, paints\"],\"commute\":[\"commute, transport, cars, buses, metro, subway, trains, vehicles\"],\"construction\":[\"construction, tools, repairs, fixes, engeneering, hammers\"],\"content_cut\":[\"cuts, scissors, fabrics, clothing, clothes\"],\"coronavirus\":[\"virus, health, bacteria, germs\"],\"currency_exchange\":[\"currency, exchange, money, wages, payments, wealth\"],\"delete\":[\"delete, trash, bin, remove, erase\"],\"delivery_dining\":[\"delivery, foods, meals, orders, transport, motorcycle, bike\"],\"directions_bike\":[\"bike, bicycle, leisure, health, exercise\"],\"directions_boat\":[\"boats, ship, ferry, transport, seas, oceans\"],\"directions_bus\":[\"buses, transports, commute, cities\"],\"directions_car\":[\"cars, vehicles, transports, cities\"],\"directions_railway\":[\"trains, railways, commute, cities, transports, vehicles\"],\"directions_subway\":[\"subway, metro, railways, commute, cities, transports, vehicles\"],\"eco\":[\"ecology, nature, leafs, trees, vegetation, plants\"],\"elderly\":[\"elderly, senior, grandpa, grandma\"],\"email\":[\"e-mail, mail, email, post office, envelopes, messages, letters\"],\"emoji_emotions\":[\"emoji, emotions, smiles, fun, joy\"],\"emoji_events_outlined\":[\"trophys, awards, podiums, achievements, victory, victories\"],\"emoji_food_beverage\":[\"drinks, coffees, teas, comfort\"],\"emoji_objects\":[\"idea, bulb, light, eureka, innovation, genius\"],\"euro\":[\"euro, currency, exchange, money, europe, wealth\"],\"event\":[\"events, calendars, agendas, commitments\"],\"extension\":[\"pieces, puzzles, fitting, games, fun\"],\"face_retouching_natural\":[\"beauty, faces, selfie, makeup\"],\"family_restroom\":[\"family, families, dad, father, mom, mother, children, kids\"],\"fastfood\":[\"foods, meals, snacks, delivery\"],\"favorite\":[\"favorites, hearts, loves, passions\"],\"festival\":[\"festivals, circus, fairs, fun, parties, party\"],\"filter_hdr\":[\"mountains, landscapes, travels, nature\"],\"filter_vintage\":[\"flowers, plants, nature\"],\"fitness_center\":[\"fitness, gym, exercises, health\"],\"gavel\":[\"laws, judges, gavels, hammers, justice, courts\"],\"golf_course\":[\"golf, sports, nature, leisure, games\"],\"grade\":[\"stars, ratings, brilliant, sky, space, first, wining\"],\"headset\":[\"headset, audio, music, phones, games\"],\"home\":[\"home, houses, city, town, domestic\"],\"hotel\":[\"hotel, lodging, bed, sleep, cozy\"],\"keyboard_rounded\":[\"keyboard, computer, technology, innovation, programming\"],\"language\":[\"language, world, globe, planet, international\"],\"laptop\":[\"laptops, computers, technology, innovation, programming, work\"],\"liquor\":[\"liquor, drinks, beverage, leisure, fun, bar, booze\"],\"local_bar\":[\"bar, drinks, beverage, liquor, leisure, fun, classic, style\"],\"local_cafe\":[\"cafe, coffee, breakfast, cups, break\"],\"local_dining\":[\"restaurants, foods, meals, dining\"],\"local_florist\":[\"flowers, florists, nature, plants\"],\"local_hospital_rounded\":[\"hospitals, health, medical, doctors, injury\"],\"local_gas_station\":[\"gas, fuel, cars, transport, vehicles\"],\"shopping_cart\":[\"shopping, supermarket, stores, foods, grocery, groceries\"],\"local_laundry_service\":[\"laundry, clothes, wash, cleaning\"],\"local_library\":[\"library, books, reading, leisure, culture, story, education\"],\"local_pizza\":[\"pizza, foods, meals, snacks, dinner\"],\"local_print_shop\":[\"printers, prints, computers, papers, documents\"],\"location_on\":[\"locations, places, maps, address, travels\"],\"map\":[\"maps, locations, places, travels\"],\"mouse\":[\"mouse, computers, technology, innovation, work\"],\"movie\":[\"movies, cinemas, films, leisure, culture\"],\"pets\":[\"pets, animals, dogs, cats\"],\"phone_android\":[\"mobiles, technology, computers, cellphones\"],\"pix\":[\"pix, payments, transactions, banks, money, cash, currency\"],\"push_pin\":[\"pin, mark, post, fix\"],\"radio_rounded\":[\"radio, music, culture, waves\"],\"redeem\":[\"gifts, presents, christmas, birthdays\"],\"savings\":[\"savings, money, cash, currency, banks\"],\"science\":[\"science, labs, laboratory, experiments, chemistry, university, education\"],\"self_improvement\":[\"meditation, wellness, calm, zen, yoga, relax\"],\"sports_bar\":[\"sports, beer, drinks, beverage, leisure, fun, bar, booze\"],\"sports_baseball\":[\"baseball, sports, fun, athletics\"],\"sports_basketball\":[\"basketball, sports, fun, athletics\"],\"sports_cricket\":[\"cricket, sports, fun, athletics\"],\"sports_esports\":[\"gaming, games, sports, fun, electronics, xbox, playstation, steam, joystick\"],\"sports_football\":[\"football, sports, fun, athletics\"],\"sports_golf\":[\"golf, sports, fun, athletics\"],\"sports_hockey\":[\"hockey, sports, diversao, athletics\"],\"sports_mma\":[\"mma, fights, sports, fun, athletics, box\"],\"sports_motorsports\":[\"racing, cars, sports, fun\"],\"sports_soccer\":[\"soccer, football, sports, fun, athletics\"],\"sports_tennis\":[\"tennis, sports, fun, athletics\"],\"sports_volleyball\":[\"volleyball, sports, fun, athletics\"],\"store\":[\"stores, shops, city, downtown\"],\"thumb_up\":[\"likes, approves, up, positives, ok\"],\"thumb_down\":[\"dislikes, rejects, down, negative\"],\"two_wheeler_outlined\":[\"motorcycle, bike, travels, leisure, vehicles, transports\"],\"videocam_rounded\":[\"video, camera, record, movie, film\"],\"volunteer_activism\":[\"volunteers, charity, donations, give\"],\"vpn_key\":[\"keys, passwords, secrets, security\"],\"watch_rounded\":[\"watchs, times, clocks, jewelry\"],\"wb_incandescent\":[\"bulbs, lights, ideas, innovation, eureka\"],\"wb_sunny\":[\"suns, weather, summer, hot, leisure, outdoors\"],\"weekend_rounded\":[\"weekends, rests, sofas, leisure, movies, films, tvs, series\"],\"wine_bar\":[\"wines, drinks, liquor, beverage, leisure, fun, bar, booze\"]';

  @override
  String get error_category_icon_required =>
      'Select an icon for your category!';
}
