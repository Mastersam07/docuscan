import 'package:flutter/material.dart';
import 'package:pdf_scanner/core/navigation/navigator.dart';

import 'features/dashboard/presentation/views/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: AppNavigator.key,
      onGenerateRoute: AppRouter.generateRoutes,
      home: const DashboardScreen(),
    );
  }
}
