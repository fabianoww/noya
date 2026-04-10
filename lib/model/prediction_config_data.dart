class PredictionConfigData {
  bool? _enabled;
  int? _window;

  PredictionConfigData(this._enabled, this._window);

  bool? get enabled {
    return _enabled;
  }

  int? get window {
    return _window;
  }

}