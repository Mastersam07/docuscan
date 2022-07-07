import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_scanner/features/docscan/presentation/views/doc_scan.dart';
import 'package:pdf_scanner/features/docviewer/presentation/views/doc_viewer.dart';

import '../../features/dashboard/domain/models/scanned_document.dart';
import '../../features/dashboard/presentation/views/dashboard.dart';
import 'navigator.dart';

abstract class AppRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case dashboardViewRoute:
        return getPageRoute(
          settings: settings,
          view: const DashboardScreen(),
        );
      case docViewerViewRoute:
        return getPageRoute(
          settings: settings,
          view: DocViewerScreen(
              scannedDocument: settings.arguments as ScannedDocument),
        );

      case docScanViewRoute:
        return getPageRoute(
          settings: settings,
          view: const DocScanScreen(),
        );

      default:
        return getPageRoute(
          settings: settings,
          view: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static PageRoute<dynamic> getPageRoute({
    required RouteSettings settings,
    required Widget view,
  }) {
    return Platform.isIOS
        ? CupertinoPageRoute(settings: settings, builder: (_) => view)
        : MaterialPageRoute(settings: settings, builder: (_) => view);
  }
}
