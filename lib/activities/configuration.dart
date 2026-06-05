import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:noya2/activities/prediction_config.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/services/backup_service.dart';
import 'package:noya2/services/configuration_service.dart';
import 'package:intl/intl.dart';

class Configuration extends StatefulWidget {
  
  const Configuration({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  late TextEditingController _goalController;
  bool _autofillEnabled = true;

  @override
  void initState() {
    super.initState();
    _goalController = TextEditingController();

    ConfigurationService.isPredictionEnabled().then((predictionEnabled) {
      setState(() => _autofillEnabled = predictionEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    //this._darkMode = DynamicTheme.of(context).themeData.brightness == Brightness.dark;
    NumberFormat numberFormat = NumberFormat.currency(locale: Localizations.localeOf(context).toString(), symbol: "", decimalDigits: 2);
    CurrencyTextInputFormatter textInputFormatter = CurrencyTextInputFormatter.currency(locale: AppLocalizations.of(context)!.localeName, symbol: '', decimalDigits: 2);

    ConfigurationService.getGoal().then((goal) => _goalController.text = numberFormat.format(goal ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.config_title),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: AppLocalizations.of(context)!.nav_back,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context)!.config_goal),
          trailing: SizedBox(
            width: 150.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextField(
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    inputFormatters: [textInputFormatter],
                    decoration: InputDecoration.collapsed(
                        hintText: NumberFormat.currency(symbol: "").format(0)),
                    controller: _goalController,
                    onChanged: (String value) {
                      double newGoal = numberFormat.parse(value).toDouble();
                      ConfigurationService.saveGoalConfiguration(newGoal);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.config_backup_create_label),
          onTap: () {
            BackupService().createBackup().then((_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.config_backup_create_done)));
              }
            });
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.config_backup_load_label),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.confirm_backup_load_title),
                  content: Text(AppLocalizations.of(context)!.confirm_backup_load_text),
                  actions: <Widget>[
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.button_no),
                      onPressed: () => Navigator.of(context).pop()
                    ),
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.button_yes),
                      onPressed: () => BackupService().loadBackup().then((_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.config_backup_load_done)));
                          Navigator.of(context).pop();
                        }
                      })
                    ),
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.config_prediction_fields),
          trailing: Text(_autofillEnabled
              ? AppLocalizations.of(context)!.label_enabled
              : AppLocalizations.of(context)!.label_disabled),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return PredictionConfig();
              }),
            ).then((value) {
              ConfigurationService.isPredictionEnabled()
                  .then((predictionEnabled) {
                setState(() => _autofillEnabled = predictionEnabled);
              });
            });
          },
        )
      ]),
    );
  }
}