import 'package:barwah_app/features/wasalny_supervisor/presentation/screens/wasalny_requests_screen.dart';
import 'package:barwah_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildScreen() => const MaterialApp(
        locale: Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(body: WasalnyRequestsScreen()),
      );

  testWidgets('requests page shows summary and sample orders', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('بروتوكول أمان وساطة وصلني'), findsOneWidget);
    expect(find.text('نسبة الإتمام'), findsOneWidget);
    expect(find.text('كاميرا كانون EOS R6 (نظيفة جداً)'), findsOneWidget);
    expect(find.text('توصيل'), findsNothing);
    expect(find.text('الفحص الميداني'), findsNothing);
    expect(find.text('معاينة الطلب'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('revealing a request contact requires confirmation',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();
    await tester.tap(find.text('إظهار البيانات للمشتري').first);
    await tester.pumpAndSettle();

    expect(find.text('هل تريد إظهار بيانات التواصل للطرفين في هذا الطلب؟'),
        findsOneWidget);
    await tester.tap(
      find.widgetWithText(FilledButton, 'إظهار البيانات للمشتري'),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('إخفاء البيانات').first,
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('050 000 1042'), findsOneWidget);
    expect(find.textContaining('050 000 2042'), findsOneWidget);
    await tester.tap(find.text('إخفاء البيانات').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('050 000 1042'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview opens request details', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();
    await tester.tap(find.text('معاينة الطلب').first);
    await tester.pumpAndSettle();

    expect(find.text('تفاصيل الطلب'), findsOneWidget);
    expect(find.text('رقم الطلب'), findsOneWidget);
    expect(find.text('W-1042'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sold request keeps reveal and preview actions available',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();
    await tester.tap(find.text('تم البيع').first);
    await tester.pumpAndSettle();
    expect(find.text('آيفون 15 برو سعة 256 جيجابايت'), findsOneWidget);
    expect(find.text('إظهار البيانات للمشتري'), findsOneWidget);
    expect(find.text('معاينة الطلب'), findsOneWidget);

    await tester.tap(find.text('معاينة الطلب'));
    await tester.pumpAndSettle();
    expect(find.text('تفاصيل الطلب'), findsOneWidget);
    expect(find.text('W-1024'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('إظهار البيانات للمشتري'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(FilledButton, 'إظهار البيانات للمشتري'),
    );
    await tester.pumpAndSettle();
    expect(find.text('إخفاء البيانات'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
