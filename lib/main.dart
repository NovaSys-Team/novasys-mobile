import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';
import 'repositories/auth_repository.dart';
import 'theme/app_theme.dart';
import 'views/entry_views.dart';

void main() => runApp(const NovaSysApp());

class NovaSysApp extends StatefulWidget {
  const NovaSysApp({super.key});
  @override
  State<NovaSysApp> createState() => _NovaSysAppState();
}

class _NovaSysAppState extends State<NovaSysApp> {
  final controller = AuthController(DemoAuthRepository());
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NovaSys',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: SplashView(controller: controller),
  );
}
