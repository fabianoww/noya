import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noya2/components/loading_spinner.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/prediction_config_data.dart';
import 'package:noya2/services/configuration_service.dart';

class PredictionConfig extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PredictionConfigState();
  }
}

class _PredictionConfigState extends State<PredictionConfig> {
  late bool _enabled;
  late TextEditingController _windowController;
  late Timer _predictionWindowDebounce;

  @override
  void initState() {
    super.initState();
    this._windowController = new TextEditingController();
    ConfigurationService.getConfigValue('prediction_window')
        .then((value) => this._windowController.text = value!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.prediction_config_title),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: AppLocalizations.of(context)!.nav_back,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: FutureBuilder<PredictionConfigData>(
          future: ConfigurationService.getPredictionConfig(),
          builder: (BuildContext context,
              AsyncSnapshot<PredictionConfigData> snapshot) {
            if (snapshot.hasData) {
              this._enabled = snapshot.data!.enabled!;
              return ListView(children: [
                Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                        child: Text(AppLocalizations.of(context)!.prediction_config_guidelines,
                            style: Theme.of(context).textTheme.headlineMedium))),
                Divider(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  height: 36,
                ),
                SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.prediction_config_on_off_switch),
                    value: snapshot.data!.enabled!,
                    activeThumbColor: Theme.of(context).primaryColor,
                    onChanged: (bool value) {
                      setState(() {
                        this._enabled = value;
                        ConfigurationService.savePredictionConfiguration(
                            this._enabled);
                      });
                    }),
                new ListTile(
                  title: Text(AppLocalizations.of(context)!.prediction_config_window),
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
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: new InputDecoration.collapsed(
                                hintText: AppLocalizations
                                    .of(context)!
                                    .prediction_config_window_hint),
                            controller: _windowController,
                            onChanged: (String value) {
                              if (_predictionWindowDebounce?.isActive ?? false)
                                _predictionWindowDebounce.cancel();
                              _predictionWindowDebounce =
                                  Timer(const Duration(milliseconds: 500), () {
                                ConfigurationService.savePredictionWindow(int.parse(value));
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ]);
            } else {
              return LoadingSpinner();
            }
          },
        ));
  }

  @override
  void dispose() {
    _predictionWindowDebounce?.cancel();
    super.dispose();
  }
}
