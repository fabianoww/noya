import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/components/backup_card.dart';
import 'package:noya2/components/horizontal_divider.dart';
import 'package:noya2/components/loading_spinner.dart';
import 'package:noya2/integration/google_auth_client.dart';
import 'package:noya2/model/backup_config_data.dart';
import 'package:noya2/services/configuration_service.dart';
//import 'package:googleapis/drive/v3.dart' as drive;
//import 'package:google_sign_in/google_sign_in.dart' as signIn;

class BackupConfig extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BackupConfigState();
  }
}

class _BackupConfigState extends State<BackupConfig> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.backup_config_title),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: AppLocalizations.of(context)!.nav_back,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: FutureBuilder<BackupConfigData>(
          future: ConfigurationService.getBackupConfig(),
          builder:
              (BuildContext context, AsyncSnapshot<BackupConfigData> snapshot) {
            if (snapshot.hasData) {
              List<Widget> items = [];

              if (snapshot.data!.mode == null) {
                items.add(Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                        child: Text(
                            AppLocalizations.of(context)!.backup_config_no_backup_selected,
                            style: Theme.of(context).textTheme.headlineMedium))));
              }

              items.add(HorizontalDivider(
                  AppLocalizations.of(context)!.backup_config_available_modes));
              items.add(BackupCard(
                  AppLocalizations.of(context)!.backup_config_mode_google_drive,
                  Icons.add_to_drive,
                  selectGoogleDriveMode));
              return ListView(children: items);
            } else {
              return LoadingSpinner();
            }
          },
        ));
  }

  void selectGoogleDriveMode() async {
    restoreDataFromGoogleDrive();
  }

  void backupDataOnGoogleDrive() async {
    /*
    // todo
    final googleSignIn = signIn.GoogleSignIn.standard(
        scopes: [drive.DriveApi.DriveAppdataScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();

    final authHeaders = await account.authHeaders;
    print(authHeaders);
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    //final databasesPath = await getDatabasesPath();
    final databasePath =
        '/storage/emulated/0/Android/data/com.fbnolvr.noya/files'; // FIXME
    File databaseFile = File('${databasePath}/noya.db');

    final Stream<List<int>> mediaStream = databaseFile.openRead();
    var media = new drive.Media(mediaStream, await databaseFile.length());
    var driveFile = new drive.File();
    driveFile.name = "noya_backup.db";
    driveFile.parents = ['appDataFolder'];
    final result = await driveApi.files.create(
      driveFile,
      uploadMedia: media,
    );
    print("Upload result: $result");
    */
  }

  void restoreDataFromGoogleDrive() async {
    /*
    // todo
    final googleSignIn = signIn.GoogleSignIn.standard(
        scopes: [drive.DriveApi.DriveAppdataScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();

    final authHeaders = await account.authHeaders;
    print(authHeaders);
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    //final databasesPath = await getDatabasesPath();
    final databasePath =
        '/storage/emulated/0/Android/data/com.fbnolvr.noya/files'; // FIXME

    driveApi.files.list(corpora: 'user', spaces: 'appDataFolder').then((value) {
      for (var file in value.files) {
        print('File name: ${file.name}');
        print('Id: ${file.id}');

        driveApi.files
            .get(file.id, downloadOptions: drive.DownloadOptions.FullMedia)
            .then((response) {
          File backupFile = File('${databasePath}/noya_bkp.db');

          List<int> content = [];
          response.stream.listen((data) {
            print("DataReceived: ${data.length}");
            content.insertAll(content.length, data);
          }, onDone: () async {
            File backupFile = File("${databasePath}/noya_bkp.db");
            print("Total length: ${content.length}");
            await backupFile.writeAsBytes(content);
            int tam = await backupFile.length();
            print("file length: ${tam}");
            print("Task Done");
          }, onError: (error) {
            print("Some Error");
          });
        });
      }
    });
  */
  }
}
