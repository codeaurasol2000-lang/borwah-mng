import 'package:barwah_app/features/products/presentation/screens/product_supervisor_profile_screen.dart';
import 'package:barwah_app/features/products/presentation/screens/product_supervisor_wallet_screen.dart';
import 'package:barwah_app/features/products/data/datasources/product_supervisor_audit_data_source.dart';
import 'package:barwah_app/features/products/data/repositories/product_supervisor_audit_repository_impl.dart';
import 'package:barwah_app/features/products/domain/entities/product_supervisor_audit_entry.dart';
import 'package:barwah_app/features/products/domain/repositories/product_supervisor_audit_repository.dart';
import 'package:barwah_app/l10n/app_localizations.dart';
import 'package:barwah_app/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    final dataSource = _MemoryAuditDataSource();
    sl.registerLazySingleton<ProductSupervisorAuditDataSource>(
      () => dataSource,
    );
    sl.registerLazySingleton<ProductSupervisorAuditRepository>(
      () => ProductSupervisorAuditRepositoryImpl(dataSource: sl()),
    );
  });

  Widget buildTestApp() {
    return const MaterialApp(
      locale: Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: ProductSupervisorProfileScreen(onLogout: _ignoreLogout),
      ),
    );
  }

  testWidgets('available balance opens the supervisor wallet', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('الرصيد المتاح والمستحقات'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('الرصيد المتاح والمستحقات'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductSupervisorWalletScreen), findsOneWidget);
    expect(find.text('محفظة المشرف'), findsOneWidget);
    expect(find.text('طلب سحب المستحقات المالية'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('سجل العمليات والتحويلات الأخيرة'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('سجل العمليات والتحويلات الأخيرة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wallet withdrawal request asks for confirmation',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProductSupervisorWalletScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final requestButton = find.text('تأكيد وطلب السحب المالي');
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    await tester.ensureVisible(requestButton);
    await tester.tap(requestButton);
    await tester.pumpAndSettle();

    expect(find.text('تأكيد طلب السحب'), findsOneWidget);
    expect(find.text('تأكيد السحب'), findsOneWidget);
    await tester.tap(find.text('تأكيد السحب'));
    await tester.pumpAndSettle();
    expect(find.text('تم تسجيل طلب السحب بنجاح.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _ignoreLogout() {}

class _MemoryAuditDataSource implements ProductSupervisorAuditDataSource {
  final List<ProductSupervisorAuditEntry> entries = [];

  @override
  Future<List<ProductSupervisorAuditEntry>> getEntries() async =>
      List.of(entries);

  @override
  Future<void> saveEntry(ProductSupervisorAuditEntry entry) async {
    entries.add(entry);
  }
}
