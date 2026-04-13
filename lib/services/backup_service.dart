import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:file_selector/file_selector.dart';

class BackupService {

  Future<void> createBackup() async {
    //String dbPath = '/data/user/0/com.fbnolvr.noya2/databases/noya.db';
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, 'noya.db');
    Directory filesDir = await getApplicationDocumentsDirectory();

    // Verificando se o diretório de backup existe
    Directory backupsDir = Directory(join(filesDir.path, 'backups'));
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }

    backupsDir.list().forEach((file) {
      file.delete();
    });

    String timestamp = DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
    String destPath = join(backupsDir.path, 'noya_backup_$timestamp.db');

    // Copy the file
    File sourceFile = File(dbPath);
    if (await sourceFile.exists()) {
      await sourceFile.copy(destPath);
    }

    final params = ShareParams(
      text: 'Noya Backup',
      files: [XFile(destPath)],
    );

    final result = await SharePlus.instance.share(params);
  }


  Future<void> loadBackup() async {
    /*
    FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        print(file.path);
      } else {
        // User canceled the picker
      }
      */

      const XTypeGroup typeGroup = XTypeGroup(
        label: 'DB',
        extensions: <String>['db'],
        uniformTypeIdentifiers: <String>['public.db'],
      );
      final XFile? file = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );
      
      final databasesPath = await getDatabasesPath();
      final dbPath = join(databasesPath, 'noya.db');
      file?.saveTo(dbPath);
    }
}