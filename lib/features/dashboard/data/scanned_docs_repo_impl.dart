import 'dart:io';

import 'package:pdf_scanner/features/dashboard/domain/models/scanned_document.dart';

import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

import '../domain/repo_contracts/scanned_docs_repo.dart';

class ScannedDocumentRepositoryImpl implements ScannedDocumentRepository {
  String? _filePath;

  Future<String> get _directory async {
    if (_filePath == null) {
      final String directory =
          '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}scanned_documents';

      final savedDir = Directory(directory);
      final bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        await savedDir.create();
      }
      _filePath = directory + Platform.pathSeparator;
    }

    return _filePath!;
  }

  @override
  Future<List<ScannedDocument>> getAll() async {
    final List<ScannedDocument> _scannedDocuments = [];
    final directory = Directory(await _directory);

    final List<FileSystemEntity> itemList = directory.listSync();

    for (final item in itemList) {
      if (p.extension(item.path) == '.pdf') {
        final fileName = p.basenameWithoutExtension(item.path);

        _scannedDocuments.add(
          ScannedDocument(
            uuid: fileName,
            previewImageUri: '${await _directory}$fileName.png',
            documentUri: '${await _directory}$fileName.pdf',
          ),
        );
      }
    }

    return _scannedDocuments;
  }

  @override
  Future<void> saveScannedDocument(
      {required String firstPageUri, required Uint8List document}) async {
    final File firstPage = File(firstPageUri);
    final String fileName = const Uuid().v1();

    await firstPage.copy('${await _directory}$fileName.png');

    final File pdfFile = File('${await _directory}$fileName.pdf');

    await pdfFile.writeAsBytes(document);
  }
}
