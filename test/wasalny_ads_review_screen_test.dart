import 'package:barwah_app/app/navigation/wasalny_supervisor_tabs_shell.dart';
import 'package:barwah_app/features/wasalny_supervisor/data/datasources/wasalny_ads_mock_data_source.dart';
import 'package:barwah_app/features/wasalny_supervisor/data/repositories/wasalny_ads_repository_impl.dart';
import 'package:barwah_app/features/wasalny_supervisor/domain/entities/wasalny_ad.dart';
import 'package:barwah_app/features/wasalny_supervisor/domain/usecases/get_wasalny_ads_usecase.dart';
import 'package:barwah_app/features/wasalny_supervisor/domain/usecases/update_wasalny_ad_status_usecase.dart';
import 'package:barwah_app/features/wasalny_supervisor/presentation/controllers/wasalny_ads_cubit.dart';
import 'package:barwah_app/features/wasalny_supervisor/presentation/screens/wasalny_ads_review_screen.dart';
import 'package:barwah_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildScreen(WasalnyAdsCubit cubit) => MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: BlocProvider.value(
          value: cubit,
          child: const Scaffold(body: WasalnyAdsReviewScreen()),
        ),
      );

  WasalnyAdsCubit createCubit() {
    final repository = WasalnyAdsRepositoryImpl(
      dataSource: WasalnyAdsMockDataSource(),
    );
    return WasalnyAdsCubit(
      getAds: GetWasalnyAdsUseCase(repository: repository),
      updateAdStatus: UpdateWasalnyAdStatusUseCase(repository: repository),
    )..loadAds();
  }

  testWidgets('review page shows Wasalny ads and moderation actions',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final cubit = createCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(buildScreen(cubit));
    await tester.pumpAndSettle();

    expect(find.text('إعلانات المنتجات المستعملة'), findsOneWidget);
    expect(find.text('كاميرا كانون EOS R6 مستعملة'), findsOneWidget);
    expect(find.text('بلايستيشن 5 مع ذراعين ولعبة'), findsOneWidget);
    expect(find.text('إخفاء'), findsWidgets);
    expect(find.text('رفض بسبب'), findsWidgets);
    expect(find.text('تعليق الإعلان'), findsWidgets);
    expect(find.text('قبول'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('opening a pending ad shows its inspection details',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final cubit = createCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(buildScreen(cubit));
    await tester.pumpAndSettle();
    await tester.tap(find.text('كاميرا كانون EOS R6 مستعملة').first);
    await tester.pumpAndSettle();
    expect(find.text('معرض صور المنتج المفحوص'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('السعر المعتمد للنشر'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('رفض الإعلان ومخالفة المعايير'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('تعديل وفحص بيانات الإعلان المستعمل'), findsOneWidget);
    expect(find.text('السعر المعتمد للنشر'), findsOneWidget);
    expect(find.text('اعتماد الإعلان للنشر'), findsOneWidget);
    expect(find.text('طلب تعديل من الناشر'), findsOneWidget);
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold).last).bottomNavigationBar,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('suspending a pending ad requires a reason', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final cubit = createCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(buildScreen(cubit));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تعليق الإعلان').first);
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('تعليق الإعلان'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('تأكيد العملية'));
    await tester.pumpAndSettle();
    expect(find.text('السبب مطلوب لإكمال العملية.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'مراجعة مستندات الإعلان');
    await tester.tap(find.text('تأكيد العملية'));
    await tester.pumpAndSettle();

    final loaded = cubit.state as WasalnyAdsLoaded;
    final suspended = loaded.ads.singleWhere((ad) => ad.id == 'wasalny-ad-1');
    expect(suspended.status, WasalnyAdStatus.suspended);
    expect(suspended.decisionNote, 'مراجعة مستندات الإعلان');
    expect(find.text('تم تعليق الإعلان.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hiding an ad requires a reason and stores it', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final cubit = createCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(buildScreen(cubit));
    await tester.pumpAndSettle();
    await tester.tap(find.text('إخفاء').first);
    await tester.pumpAndSettle();
    expect(find.text('إخفاء الإعلان'), findsOneWidget);

    await tester.tap(find.text('تأكيد العملية'));
    await tester.pumpAndSettle();
    expect(find.text('السبب مطلوب لإكمال العملية.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'صورة المنتج غير واضحة');
    await tester.tap(find.text('تأكيد العملية'));
    await tester.pumpAndSettle();
    final loaded = cubit.state as WasalnyAdsLoaded;
    final hidden = loaded.ads.singleWhere((ad) => ad.id == 'wasalny-ad-1');
    expect(hidden.status, WasalnyAdStatus.hidden);
    expect(hidden.decisionNote, 'صورة المنتج غير واضحة');
    expect(tester.takeException(), isNull);
  });

  testWidgets('accepting an ad updates its review status', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final cubit = createCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(buildScreen(cubit));
    await tester.pumpAndSettle();
    await tester.tap(find.text('قبول').first);
    await tester.pumpAndSettle();

    final loaded = cubit.state as WasalnyAdsLoaded;
    final approved = loaded.ads.singleWhere((ad) => ad.id == 'wasalny-ad-1');
    expect(approved.status, WasalnyAdStatus.approved);
    expect(find.text('تم قبول الإعلان ونشره.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Wasalny supervisor replaces reports with Wasalny requests',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: WasalnySupervisorTabsShell(onLogout: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('الحساب'), findsOneWidget);
    expect(find.text('طلبات وصلني'), findsOneWidget);
    expect(find.text('التقارير'), findsNothing);
    expect(find.text('ترويج المنتجات'), findsOneWidget);
    expect(find.text('قيد المراجعة'), findsWidgets);
    expect(find.text('إعلانات المنتجات المستعملة'), findsOneWidget);
    expect(find.byTooltip('إشعارات وصلني'), findsOneWidget);
    expect(find.byTooltip('الدردشات'), findsOneWidget);
    await tester.tap(find.byTooltip('إشعارات وصلني'));
    await tester.pumpAndSettle();
    expect(find.text('إشعارات وصلني'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('الدردشات'));
    await tester.pumpAndSettle();
    expect(find.text('الدردشات'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('ترويج المنتجات').last);
    await tester.pumpAndSettle();
    expect(find.text('طلبات ترويج منتجات وصلني'), findsOneWidget);
    expect(find.text('كاميرا كانون EOS R6 مستعملة'), findsOneWidget);
    expect(find.text('اعتماد الترويج'), findsOneWidget);
    expect(find.text('عرض حالة الدفع'), findsWidgets);

    await tester.tap(find.text('قيد المراجعة').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('الحساب').last);
    await tester.pumpAndSettle();
    expect(find.text('م. طارق بن عبد العزيز العتيبي'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('متابعة الشكوى'),
      250,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('متابعة الشكوى'));
    await tester.pumpAndSettle();
    expect(find.text('الشكوى #CMP-1042'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('التقارير'),
      250,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('التقارير'));
    await tester.pumpAndSettle();
    expect(find.text('ملخص الأداء الميداني'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).first, const Offset(0, 700));
    await tester.pumpAndSettle();
    await tester.tap(find.text('طلبات وصلني').last);
    await tester.pumpAndSettle();
    expect(find.text('بروتوكول أمان وساطة وصلني'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chat with advertiser button opens conversation screen',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final cubit = createCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(buildScreen(cubit));
    await tester.pumpAndSettle();
    await tester.tap(find.text('كاميرا كانون EOS R6 مستعملة').first);
    await tester.pumpAndSettle();

    expect(
        find.byKey(const ValueKey('chat-with-seller-button')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('chat-with-seller-button')));
    await tester.pumpAndSettle();

    expect(find.text('عبد الرحمن الشمري'), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.send_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'call advertiser button opens phone dialog with copy and call actions',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final cubit = createCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(buildScreen(cubit));
    await tester.pumpAndSettle();
    await tester.tap(find.text('كاميرا كانون EOS R6 مستعملة').first);
    await tester.pumpAndSettle();

    expect(
        find.byKey(const ValueKey('call-seller-button')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('call-seller-button')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('الاتصال بالمعلن'),
      ),
      findsOneWidget,
    );
    expect(find.text('050 000 1042'), findsOneWidget);
    expect(find.text('اتصال الآن'), findsOneWidget);
    expect(find.byIcon(Icons.copy), findsOneWidget);

    await tester.tap(find.text('اتصال الآن'));
    await tester.pumpAndSettle();
    expect(find.textContaining('050 000 1042'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'contact action button opens modal sheet with chat and call options',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final cubit = createCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(buildScreen(cubit));
    await tester.pumpAndSettle();
    await tester.tap(find.text('كاميرا كانون EOS R6 مستعملة').first);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('chat-or-call-action-button')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('دردشة مع المعلن أو الاتصال به'), findsOneWidget);
    await tester
        .tap(find.byKey(const ValueKey('chat-or-call-action-button')));
    await tester.pumpAndSettle();

    expect(find.text('التواصل مع الشخص المعلن'), findsOneWidget);
    expect(find.byKey(const ValueKey('sheet-chat-option')), findsOneWidget);
    expect(find.byKey(const ValueKey('sheet-call-option')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('sheet-chat-option')));
    await tester.pumpAndSettle();
    expect(find.text('عبد الرحمن الشمري'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
