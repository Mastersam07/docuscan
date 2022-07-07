import '../../../../core/app_vm/app_vm.dart';
import '../../../../core/navigation/navigator.dart';
import '../../data/scanned_docs_repo_impl.dart';
import '../models/scanned_document.dart';
import '../repo_contracts/scanned_docs_repo.dart';

class DashboardVm extends AppViewModel {
  late ScannedDocumentRepository? _scannedDocumentsRepo;

  DashboardVm({ScannedDocumentRepository? scannedRepo}) {
    _scannedDocumentsRepo = scannedRepo ?? ScannedDocumentRepositoryImpl();
  }

  List<ScannedDocument> _scannedDocuments = [];
  List<ScannedDocument> get scannedDocuments => _scannedDocuments;

  String? _error;
  String? get error => _error;

  Future<void> loadScannedDocuments() async {
    setState(VmState.busy);
    try {
      _scannedDocuments = await _scannedDocumentsRepo!.getAll();
      setState(VmState.none);
    } catch (e) {
      _error = e.toString();
      setState(VmState.error);
    }
    notifyListeners();
  }

  Future<void> scan() async {
    await AppNavigator.pushNamed(docScanViewRoute);
    loadScannedDocuments();
  }
}
