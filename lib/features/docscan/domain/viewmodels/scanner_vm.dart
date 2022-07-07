import 'package:pdf_scanner/core/app_vm/app_vm.dart';
import 'package:pdf_scanner/core/navigation/navigator.dart';
import 'package:pdf_scanner/features/dashboard/data/scanned_docs_repo_impl.dart';

import '../../../../services/pdf_service.dart';
import '../../../dashboard/domain/repo_contracts/scanned_docs_repo.dart';

class ScannerVm extends AppViewModel {
  late ScannedDocumentRepository? _scannedDocumentsRepo;
  PdfService? _pdfService;

  ScannerVm({ScannedDocumentRepository? scannedRepo, PdfService? pdfService}) {
    _scannedDocumentsRepo = scannedRepo ?? ScannedDocumentRepositoryImpl();
    _pdfService = pdfService ?? PdfService();
  }

  List<String> documents = [];

  String? _error;
  String? get error => _error;

  void saveDocument() async {
    setState(VmState.busy);
    try {
      var generatedPdf = await _pdfService!.generatePdfFromImages(documents);
      await _scannedDocumentsRepo!.saveScannedDocument(
        firstPageUri: documents.first,
        document: await generatedPdf.save(),
      );
      setState(VmState.none);
      AppNavigator.pop();
    } catch (e) {
      _error = e.toString();
      setState(VmState.error);
    }
    notifyListeners();
  }
}
