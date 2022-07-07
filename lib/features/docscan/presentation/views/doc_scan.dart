import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pdf_scanner/features/docscan/domain/viewmodels/scanner_vm.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

import '../widgets/busy_indicator.dart';

class DocScanScreen extends StatefulWidget {
  const DocScanScreen({Key? key}) : super(key: key);

  @override
  _DocScanScreenState createState() => _DocScanScreenState();
}

class _DocScanScreenState extends State<DocScanScreen> {
  late ScannerVm _model;

  @override
  void initState() {
    super.initState();
    _model = ScannerVm();
    _model.addListener(() => mounted ? setState(() {}) : null);
  }

  @override
  void dispose() {
    for (final document in _model.documents) {
      File(document).delete();
    }
    _model.removeListener(() {});
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      show: _model.isBusy,
      title: 'Converting...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan document'),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              if (index < _model.documents.length) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.file(
                      File(_model.documents[index]),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        File(_model.documents[index]).delete();
                        _model.documents.removeAt(index);
                        setState(() {});
                      },
                      elevation: 0.0,
                      fillColor: const Color(0x50000000),
                      child: const Icon(
                        Icons.delete,
                        size: 35.0,
                      ),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                    ),
                  ],
                );
              } else {
                return InkWell(
                  onTap: () {
                    try {
                      EdgeDetection.detectEdge.then((value) {
                        if (value != null) {
                          _model.documents.add(value);
                          setState(() {});
                        }
                      });
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 50,
                    ),
                    decoration: BoxDecoration(
                      border: RDottedLineBorder.all(
                        width: 1,
                        dottedLength: 6,
                        dottedSpace: 10,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add,
                            size: 35,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Add new image',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            itemCount: _model.documents.length + 1,
            pagination: const SwiperPagination(),
            control: const SwiperControl(),
            viewportFraction: 0.8,
            itemHeight: 20,
            scale: 0.9,
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              primary: _model.documents.isNotEmpty ? Colors.blue : Colors.grey,
              backgroundColor:
                  _model.documents.isNotEmpty ? Colors.blue : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              fixedSize: const Size.fromHeight(54),
            ),
            onPressed: _model.documents.isNotEmpty ? _model.saveDocument : null,
            icon: const Icon(
              Icons.print,
              color: Colors.white,
            ),
            label: const Text(
              'Generate PDF',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
