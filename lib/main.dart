import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/di/injection_container.dart' as di;
import 'core/utils/app_locale_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocaleController.instance.load();

  try {
    // تهيئة حقن التبعيات (GetIt)
    await di.initDependencies();
  } catch (e, stackTrace) {
    debugPrint("DI Initialization Error: $e");
    debugPrint(stackTrace.toString());
  }

  runApp(const BarwahApp());
}
