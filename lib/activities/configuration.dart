import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:noya2/activities/backup_config.dart';
import 'package:noya2/activities/prediction_config.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/services/configuration_service.dart';
//import 'package:noya2/styles/dynamic_theme.dart';
//import 'package:noya2/styles/themes.dart';
import 'package:intl/intl.dart';

class Configuration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  bool _darkMode = false;
  late TextEditingController _goalController;
  bool _autofillEnabled = true;

  @override
  void initState() {
    super.initState();
    this._goalController = new TextEditingController();
    ConfigurationService.getGoal().then((goal) => this._goalController.text =
        NumberFormat.currency(symbol: "").format(goal));

    ConfigurationService.isPredictionEnabled().then((predictionEnabled) {
      setState(() => this._autofillEnabled = predictionEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    //this._darkMode = DynamicTheme.of(context).themeData.brightness == Brightness.dark;

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
        /*
        SwitchListTile(
            title: Text(AppLocalizations.of(context)!.config_darkmode),
            value: _darkMode,
            activeThumbColor: Theme.of(context).colorScheme.primary,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
                DynamicTheme.of(context).setThemeData(
                    _darkMode ? Themes.darkTheme : Themes.lightTheme);
                ConfigurationService.saveThemeConfiguration(
                    _darkMode ? Themes.darkThemeKey : Themes.lightThemeKey);
                //context.findAncestorStateOfType<State<NoyaApp>>();
              });
            }),
            */
        new ListTile(
          title: Text(AppLocalizations.of(context)!.config_goal),
          trailing: new Container(
            width: 150.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Expanded(
                  flex: 3,
                  child: new TextField(
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyTextInputFormatter.currency()],
                    decoration: new InputDecoration.collapsed(
                        hintText: NumberFormat.currency(symbol: "").format(0)),
                    controller: _goalController,
                    onChanged: (String value) {
                      double newGoal =
                          NumberFormat.currency(symbol: "").parse(value).toDouble();
                      ConfigurationService.saveGoalConfiguration(newGoal);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        new ListTile(
          title: Text(AppLocalizations.of(context)!.config_backup_mode),
          trailing: Text('teste'), // FIXME
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return BackupConfig();
              }),
            ).then((value) {
              //Provider.of<RefreshController>(context).notifyListeners();
            });
          },
        ),
        new ListTile(
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
                setState(() => this._autofillEnabled = predictionEnabled);
              });
            });
          },
        )
      ]),
    );
  }
}
