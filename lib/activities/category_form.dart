import 'package:flutter/material.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/components/category_icon.dart';
import 'package:noya2/components/horizontal_divider.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/services/category_service.dart';
import 'package:noya2/services/transaction_service.dart';

class CategoryForm extends StatefulWidget {
  late Category _category;
  late ValueNotifier<Category?> _notifier;

  CategoryForm(int type, ValueNotifier<Category?> notifier) {
    this._category = new Category(null, null, null, type);
    this._notifier = notifier;
  }
  CategoryForm.edit(Category category, ValueNotifier<Category?> notifier) {
    this._category = category;
    this._notifier = notifier;
  }

  @override
  State<StatefulWidget> createState() {
    return _CategoryFormState(this._category, this._notifier);
  }
}

class _CategoryFormState extends State<CategoryForm> {
  late Category _category;
  late ValueNotifier<Category?> _notifier;
  final _formKey = GlobalKey<FormState>();
  List<CategoryIcon> iconList = [];
  late ValueNotifier<IconData> _iconChangeNotifier;

  _CategoryFormState(Category category, ValueNotifier<Category?> notifier) {
    this._category = category;
    this._notifier = notifier;
    _iconChangeNotifier = ValueNotifier(category.icon ?? _icons[0]);

    for (var i = 0; i < _icons.length; i++) {
      IconData icon = _icons[i];
      this.iconList.add(CategoryIcon(
            icon: icon,
            listener: _iconChangeNotifier,
            onPressed: () {
              this._category.icon = icon;
              this._iconChangeNotifier.value = icon;
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(this.getTitle(context)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: AppLocalizations.of(context)!.nav_back,
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            Visibility(
              visible: _category.id != null,
              child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () => validateDelete(context),
                    child: Icon(Icons.delete, size: 26.0),
                  )),
            )
          ]
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.create_rounded),
                              labelText: AppLocalizations.of(context)!.input_category_label_label,
                              hintText: AppLocalizations.of(context)!.input_category_label_hint),
                          textCapitalization: TextCapitalization.sentences,
                          initialValue: _category.label,
                          validator: (String? value) {
                            return value?.isEmpty ?? true ? AppLocalizations.of(context)!.input_validation_required : null;
                          },
                          onSaved: (value) => this._category.label = value!,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus())),
                  RadioGroup<int>(
                    groupValue: this._category.type, // The currently selected value
                    onChanged: (int? value) {
                      setState(() {
                        this._category.type = value!;
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Row(children: [Radio<int>(value: Category.EXPENSE), Text(AppLocalizations.of(context)!.label_expense)]),
                        Row(children: [Radio<int>(value: Category.REVENUE), Text(AppLocalizations.of(context)!.label_revenue)])
                      ],
                    ),
                  ),
                  HorizontalDivider(AppLocalizations.of(context)!.category_icon_label),
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: MediaQuery.of(context).size.width ~/ 50, 
                          children: this.iconList
                      )
                  ),
                  Container(height: 50)
                ],
              ),
            )),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              CategoryService.save(this._category).then((id) {
                this._category.id = id;
                this._notifier.value = this._category;
                Navigator.pop(context);
              });
            }
          },
        ));
  }

  String getTitle(BuildContext context) {
    if (this._category != null && this._category.id != null) {
      return AppLocalizations.of(context)!.title_edit_category;
    } else {
      return AppLocalizations.of(context)!.title_new_category;
    }
  }

  void validateDelete(BuildContext context) {
    TransactionService.getTransactionsCount(this._category).then((count) {
       if (count > 0) {
        showErrorMessage(AppLocalizations.of(context)!.error_delete_category_exists_transactions(count));
      } else {
        showConfirmBeforeDelete(context);
      }
    });
  }

  void showConfirmBeforeDelete(BuildContext context) {
    // set up the buttons
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm_delete_category_title),
          content: Text(AppLocalizations.of(context)!.confirm_delete_category_text),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.button_no),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
                child: Text(AppLocalizations.of(context)!.button_yes),
                onPressed: () {
                  deleteCategory(context);
                })
          ],
        );
      },
    );
  }

  void showErrorMessage(String message) {
    // set up the buttons
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.error_title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.error_close),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  void deleteCategory(BuildContext context) {
    CategoryService.delete(_category!).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  final List<IconData> _icons = [
    Icons.ac_unit,
    Icons.access_time,
    Icons.accessibility,
    Icons.accessible_forward,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.agriculture,
    Icons.airplanemode_active,
    Icons.alternate_email,
    Icons.analytics,
    Icons.anchor,
    Icons.android,
    Icons.apartment,
    Icons.architecture,
    Icons.assistant_photo,
    Icons.attach_money,
    Icons.audiotrack,
    Icons.bakery_dining,
    Icons.bathtub,
    Icons.beach_access,
    Icons.bedtime,
    Icons.biotech,
    Icons.bolt,
    Icons.brightness_low,
    Icons.brush,
    Icons.bug_report,
    Icons.build,
    Icons.cake,
    Icons.calculate,
    Icons.call,
    Icons.camera_alt,
    Icons.checkroom,
    Icons.child_friendly,
    Icons.cloud,
    Icons.color_lens,
    Icons.commute,
    Icons.construction,
    Icons.content_cut,
    Icons.coronavirus,
    Icons.currency_exchange,
    Icons.delete,
    Icons.delivery_dining,
    Icons.directions_bike,
    Icons.directions_boat,
    Icons.directions_bus,
    Icons.directions_car,
    Icons.directions_railway,
    Icons.directions_subway,
    Icons.eco,
    Icons.elderly,
    Icons.email,
    Icons.emoji_emotions,
    Icons.emoji_events_outlined,
    Icons.emoji_food_beverage,
    Icons.emoji_objects,
    Icons.euro,
    Icons.event,
    Icons.extension,
    Icons.face_retouching_natural,
    Icons.family_restroom,
    Icons.fastfood,
    Icons.favorite,
    Icons.festival,
    Icons.filter_hdr,
    Icons.filter_vintage,
    Icons.fitness_center,
    Icons.gavel,
    Icons.golf_course,
    Icons.grade,
    Icons.headset,
    Icons.home,
    Icons.hotel,
    Icons.keyboard_rounded,
    Icons.language,
    Icons.laptop,
    Icons.liquor,
    Icons.local_bar,
    Icons.local_cafe,
    Icons.local_dining,
    Icons.local_florist,
    Icons.local_hospital_rounded,
    Icons.local_gas_station,
    Icons.shopping_cart,
    Icons.local_laundry_service,
    Icons.local_library,
    Icons.local_pizza,
    Icons.local_print_shop,
    Icons.location_on,
    Icons.map,
    Icons.mouse,
    Icons.movie,
    Icons.pets,
    Icons.phone_android,
    Icons.pix,
    Icons.push_pin,
    Icons.radio_rounded,
    Icons.redeem,
    Icons.savings,
    Icons.science,
    Icons.self_improvement,
    Icons.sports_bar,
    Icons.sports_baseball,
    Icons.sports_basketball,
    Icons.sports_cricket,
    Icons.sports_esports,
    Icons.sports_football,
    Icons.sports_golf,
    Icons.sports_hockey,
    Icons.sports_mma,
    Icons.sports_motorsports,
    Icons.sports_soccer,
    Icons.sports_tennis,
    Icons.sports_volleyball,
    Icons.store,
    Icons.thumb_up,
    Icons.thumb_down,
    Icons.two_wheeler_outlined,
    Icons.videocam_rounded,
    Icons.volunteer_activism,
    Icons.vpn_key,
    Icons.watch_rounded,
    Icons.wb_incandescent,
    Icons.wb_sunny,
    Icons.weekend_rounded,
    Icons.wine_bar
  ];
}
