import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../dashboard/domain/models/scanned_document.dart';

class DocViewerScreen extends StatelessWidget {
  final ScannedDocument scannedDocument;

  const DocViewerScreen({Key? key, required this.scannedDocument})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final file = File(scannedDocument.documentUri);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DocuScan'),
      ),
      body: PdfPreview(
        build: (_) => file.readAsBytesSync(),
        canChangePageFormat: false,
        canDebug: false,
        previewPageMargin: EdgeInsets.zero,
      ),
    );
  }
}
