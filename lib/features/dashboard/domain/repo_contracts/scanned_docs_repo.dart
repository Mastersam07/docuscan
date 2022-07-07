import 'dart:typed_data';

import '../models/scanned_document.dart';

abstract class ScannedDocumentRepository {
  /// Returns a list of all scanned documents.
  Future<List<ScannedDocument>> getAll();

  /// Saves a scanned document.
  Future<void> saveScannedDocument({
    required String firstPageUri,
    required Uint8List document,
  });
}
