import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_scanner/features/dashboard/domain/viewmodels/dashboard_vm.dart';

import '../../../../core/navigation/navigator.dart';
import '../../domain/models/scanned_document.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardVm _model;

  @override
  void initState() {
    super.initState();
    _model = DashboardVm();
    _model.loadScannedDocuments();
    _model.addListener(() => mounted ? setState(() {}) : null);
  }

  @override
  void dispose() {
    _model.removeListener(() {});
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DocuScan'),
      ),
      body: Builder(
        builder: (context) {
          if (_model.isBusy) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_model.hasEncounteredError) {
            return Center(
              child: Text(_model.error ?? 'Something goes wrong'),
            );
          }

          if (_model.scannedDocuments.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'Click on the camera to scan',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            );
          }

          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            children: List.generate(
              _model.scannedDocuments.length,
              (index) {
                return GestureDetector(
                  onTap: () => AppNavigator.pushNamed(docViewerViewRoute,
                      arguments: _model.scannedDocuments[index]),
                  child: DocumentCard(
                    doc: _model.scannedDocuments[index],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _model.scan(),
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  const DocumentCard({Key? key, required this.doc}) : super(key: key);
  final ScannedDocument doc;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(
              File(
                doc.previewImageUri,
              ),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: const Color(0x70000000),
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 5,
              ),
              width: double.infinity,
              child: Text(
                doc.uuid,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
