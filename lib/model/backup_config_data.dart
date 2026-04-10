class BackupConfigData {
  String? _mode;
  DateTime? _lastBackup;

  BackupConfigData(this._mode, this._lastBackup);

  String? get mode {
    return _mode;
  }

  DateTime? get lastBackup {
    return _lastBackup;
  }

}