import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'برواح المازوري'**
  String get appName;

  /// No description provided for @cfoSessionTimestamp.
  ///
  /// In ar, this message translates to:
  /// **'1446/11/04 هـ - 10:45 ص'**
  String get cfoSessionTimestamp;

  /// No description provided for @ordersUnit.
  ///
  /// In ar, this message translates to:
  /// **'طلبات'**
  String get ordersUnit;

  /// No description provided for @financialGovernanceTitle.
  ///
  /// In ar, this message translates to:
  /// **'لائحة الحوكمة وتفويض الصلاحيات المالية'**
  String get financialGovernanceTitle;

  /// No description provided for @ongoingOperatingInvoices.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير ومستحقات التشغيل الجارية'**
  String get ongoingOperatingInvoices;

  /// No description provided for @completedAndMatched.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة ومطابقة 100%'**
  String get completedAndMatched;

  /// No description provided for @switchLanguage.
  ///
  /// In ar, this message translates to:
  /// **'تغيير اللغة'**
  String get switchLanguage;

  /// No description provided for @languageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد تسجيل الخروج'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد تسجيل الخروج من حسابك؟'**
  String get logoutConfirmMessage;

  /// No description provided for @logoutCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get logoutCancel;

  /// No description provided for @logoutConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logoutConfirm;

  /// No description provided for @appSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'نظام الإدارة والإشراف الميداني'**
  String get appSubtitle;

  /// No description provided for @secureLoginPortal.
  ///
  /// In ar, this message translates to:
  /// **'بوابة تسجيل دخول آمنة ومشفّرة'**
  String get secureLoginPortal;

  /// No description provided for @workEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني الوظيفي'**
  String get workEmail;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @roleAccessNotice.
  ///
  /// In ar, this message translates to:
  /// **'يتم تحديد واجهة العمل وصلاحيات النظام تلقائياً حسب الرتبة الإشرافية فور التحقق.'**
  String get roleAccessNotice;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginButton;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @requestAccessReset.
  ///
  /// In ar, this message translates to:
  /// **'طلب استعادة الوصول عبر المسؤول التقني'**
  String get requestAccessReset;

  /// No description provided for @restrictedAccessFooter.
  ///
  /// In ar, this message translates to:
  /// **'هذا التطبيق مخصص للإدارة والمشرفين فقط'**
  String get restrictedAccessFooter;

  /// No description provided for @copyrightNotice.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار 3.4.0 (داخلي) • جميع الحقوق محفوظة لشركة برواح المازوري'**
  String get copyrightNotice;

  /// No description provided for @certifiedFinancialAuditor.
  ///
  /// In ar, this message translates to:
  /// **'مدقق مالي معتمد'**
  String get certifiedFinancialAuditor;

  /// No description provided for @liveFinancialSession.
  ///
  /// In ar, this message translates to:
  /// **'الجلسة المالية المباشرة'**
  String get liveFinancialSession;

  /// No description provided for @financialControlTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرقابة المالية المركزية - برواح المازوري'**
  String get financialControlTitle;

  /// No description provided for @cfoControlPanelSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة تحكم المدير المالي | الوردية المالية النشطة ومطابقة السيولة الحية'**
  String get cfoControlPanelSubtitle;

  /// No description provided for @cfoName.
  ///
  /// In ar, this message translates to:
  /// **'أ. سليمان الراجحي'**
  String get cfoName;

  /// No description provided for @cfoRole.
  ///
  /// In ar, this message translates to:
  /// **'المدير المالي التنفيذي'**
  String get cfoRole;

  /// No description provided for @cfoBadgeCode.
  ///
  /// In ar, this message translates to:
  /// **'#CF0-01'**
  String get cfoBadgeCode;

  /// No description provided for @currencySar.
  ///
  /// In ar, this message translates to:
  /// **'ج.م'**
  String get currencySar;

  /// No description provided for @totalAggregatedLiquidity.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي السيولة النقدية والضمانات المجمعة'**
  String get totalAggregatedLiquidity;

  /// No description provided for @alRajhiMainOperating.
  ///
  /// In ar, this message translates to:
  /// **'مصرف الراجحي (الحساب التشغيلي الرئيسي)'**
  String get alRajhiMainOperating;

  /// No description provided for @snbEscrowAccount.
  ///
  /// In ar, this message translates to:
  /// **'البنك الأهلي السعودي (حساب الضمان Escrow)'**
  String get snbEscrowAccount;

  /// No description provided for @pendingMerchantWithdrawalsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات السحب المعلقة قيد المراجعة للتجار والمستخدمين'**
  String get pendingMerchantWithdrawalsTitle;

  /// No description provided for @pendingSupervisorWithdrawalsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات السحب المعلقة قيد المراجعة للمشرفين و المساعدين'**
  String get pendingSupervisorWithdrawalsTitle;

  /// No description provided for @auditInvoiceNote.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج تدقيق ومطابقة فواتير قبل التوقيع'**
  String get auditInvoiceNote;

  /// No description provided for @pendingSubscriptionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الاشتراكات والترقيات المعلقة'**
  String get pendingSubscriptionsTitle;

  /// No description provided for @pendingSubscriptionsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ترقيات باقات المتاجر، اشتراكات الفنيين، وتجديد الاشتراكات السنوية بانتظار الاعتماد المالي'**
  String get pendingSubscriptionsSubtitle;

  /// No description provided for @reviewSubscriptionsAction.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة واعتماد الاشتراكات'**
  String get reviewSubscriptionsAction;

  /// No description provided for @operationalExpenses.
  ///
  /// In ar, this message translates to:
  /// **'المصاريف والمدفوعات التشغيلية'**
  String get operationalExpenses;

  /// No description provided for @expensesManagementTitle.
  ///
  /// In ar, this message translates to:
  /// **'المصاريف والمدفوعات'**
  String get expensesManagementTitle;

  /// No description provided for @amountToDisburse.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المطلوب دفعه وصرفه'**
  String get amountToDisburse;

  /// No description provided for @accountAndPaymentChannel.
  ///
  /// In ar, this message translates to:
  /// **'الحساب وقناة الدفع للخصم المباشر'**
  String get accountAndPaymentChannel;

  /// No description provided for @noAccountsAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حسابات متاحة'**
  String get noAccountsAvailable;

  /// No description provided for @escrowBalanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'رصيد حساب الضمان:'**
  String get escrowBalanceLabel;

  /// No description provided for @currentLedgerBalanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الدفتري الحالي:'**
  String get currentLedgerBalanceLabel;

  /// No description provided for @expenseCategoryAndDocuments.
  ///
  /// In ar, this message translates to:
  /// **'تصنيف المصروف والمستندات المؤيدة'**
  String get expenseCategoryAndDocuments;

  /// No description provided for @detailedExpenseReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب سحب وصرف المصروف تفصيلياً'**
  String get detailedExpenseReason;

  /// No description provided for @expenseDetailsHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بياناً تفصيلياً بالمصروف'**
  String get expenseDetailsHint;

  /// No description provided for @invoiceSupportDocument.
  ///
  /// In ar, this message translates to:
  /// **'مرفق الفاتورة الضريبية والمستند المؤيد'**
  String get invoiceSupportDocument;

  /// No description provided for @attachDocumentOptional.
  ///
  /// In ar, this message translates to:
  /// **'إرفاق صورة المستند إن وجدت'**
  String get attachDocumentOptional;

  /// No description provided for @strictFinancialDisbursementGovernance.
  ///
  /// In ar, this message translates to:
  /// **'حوكمة الصرف المالي المشدد'**
  String get strictFinancialDisbursementGovernance;

  /// No description provided for @disbursementGovernanceNote.
  ///
  /// In ar, this message translates to:
  /// **'تخضع هذه العملية للرقابة المستندية والمطابقة البنكية الآلية، ويتم توثيق أمر الصرف في سجل التدقيق المالي برقم تتبع مشفر وتتطلب تأكيد التوقيع الرقمي المباشر للمدير المالي (CFO).'**
  String get disbursementGovernanceNote;

  /// No description provided for @approvePaymentOrder.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد أمر الدفع وإرساله للإدارة'**
  String get approvePaymentOrder;

  /// No description provided for @cancelPaymentOrder.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الأمر والتراجع عنه'**
  String get cancelPaymentOrder;

  /// No description provided for @paymentApprovedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم اعتماد أمر الدفع بنجاح'**
  String get paymentApprovedSuccessfully;

  /// No description provided for @monthlyTotalExpenses.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي مدفوعات الشهر'**
  String get monthlyTotalExpenses;

  /// No description provided for @expenseManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الصرف'**
  String get expenseManagement;

  /// No description provided for @scheduledDisbursementItems.
  ///
  /// In ar, this message translates to:
  /// **'4 بنود صرف مجدولة'**
  String get scheduledDisbursementItems;

  /// No description provided for @recordNewPayment.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل بيان دفع جديد / إدارة المصاريف'**
  String get recordNewPayment;

  /// No description provided for @monthlyEarnedCommissions.
  ///
  /// In ar, this message translates to:
  /// **'عمولات التطبيق المحصلة هذا الشهر'**
  String get monthlyEarnedCommissions;

  /// No description provided for @netRegulatoryRevenue.
  ///
  /// In ar, this message translates to:
  /// **'صافي الإيراد الرقابي'**
  String get netRegulatoryRevenue;

  /// No description provided for @comparedToLastMonth.
  ///
  /// In ar, this message translates to:
  /// **'مقارنة بالشهر السابق (249,450 ج.م)'**
  String get comparedToLastMonth;

  /// No description provided for @balancesUnderRegulatoryAudit.
  ///
  /// In ar, this message translates to:
  /// **'أرصدة معلقة تحت التدقيق الرقابي'**
  String get balancesUnderRegulatoryAudit;

  /// No description provided for @frozenWalletsNote.
  ///
  /// In ar, this message translates to:
  /// **'محافظ مجمدة احترازياً بطلب الإدارة العامة والمشرفين لوجود بلاغات ونزاعات مفتوحة.'**
  String get frozenWalletsNote;

  /// No description provided for @operationalDepartmentsWallets.
  ///
  /// In ar, this message translates to:
  /// **'محافظ الأقسام التشغيلية المباشرة'**
  String get operationalDepartmentsWallets;

  /// No description provided for @activeSectorsCount.
  ///
  /// In ar, this message translates to:
  /// **'4 قطاعات حية'**
  String get activeSectorsCount;

  /// No description provided for @merchantsWalletTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة قسم التجار والمتاجر'**
  String get merchantsWalletTitle;

  /// No description provided for @merchantsWalletDesc.
  ///
  /// In ar, this message translates to:
  /// **'رصيد دوري متاح للتسوية البنكية والسحب'**
  String get merchantsWalletDesc;

  /// No description provided for @usedAndEscrowWalletTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة المستعمل وعربون «وصلني»'**
  String get usedAndEscrowWalletTitle;

  /// No description provided for @usedAndEscrowWalletDesc.
  ///
  /// In ar, this message translates to:
  /// **'حساب ضمان وتأمين صفقات نشط (Escrow)'**
  String get usedAndEscrowWalletDesc;

  /// No description provided for @servicesMaintenanceWalletTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة طلبات الخدمات والصيانة'**
  String get servicesMaintenanceWalletTitle;

  /// No description provided for @servicesMaintenanceWalletDesc.
  ///
  /// In ar, this message translates to:
  /// **'مستحقات فنيين معتمدين ومزودي الخدمات'**
  String get servicesMaintenanceWalletDesc;

  /// No description provided for @deliveryLogisticsWalletTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة مناديب التوصيل واللوجستيات'**
  String get deliveryLogisticsWalletTitle;

  /// No description provided for @deliveryLogisticsWalletDesc.
  ///
  /// In ar, this message translates to:
  /// **'أجور ومستحقات الشحن والتسليم الميداني'**
  String get deliveryLogisticsWalletDesc;

  /// No description provided for @instantLiquidityAdequacyRatio.
  ///
  /// In ar, this message translates to:
  /// **'مؤشر كفاية السيولة المصرفية الفورية'**
  String get instantLiquidityAdequacyRatio;

  /// No description provided for @verySafeAndStable.
  ///
  /// In ar, this message translates to:
  /// **'آمن ومستقر جداً'**
  String get verySafeAndStable;

  /// No description provided for @dailyWithdrawalCoverageRatio.
  ///
  /// In ar, this message translates to:
  /// **'نسبة تغطية طلبات السحب اليومية'**
  String get dailyWithdrawalCoverageRatio;

  /// No description provided for @excessCashCoverage.
  ///
  /// In ar, this message translates to:
  /// **'تغطية نقدية فائضة'**
  String get excessCashCoverage;

  /// No description provided for @statutoryMinimumRequirement.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى النظامي المشترط: 85.0%'**
  String get statutoryMinimumRequirement;

  /// No description provided for @autoBankingSettlement.
  ///
  /// In ar, this message translates to:
  /// **'التسوية المصرفية التلقائية عبر نظام سداد & SARIE: مكتملة ومطابقة 100%'**
  String get autoBankingSettlement;

  /// No description provided for @governancePolicyNotice.
  ///
  /// In ar, this message translates to:
  /// **'وفق لائحة الحوكمة والسياسات المالية: المشرفون الميدانيون ورؤساء الأقسام لا يملكون أي صلاحية لتعديل الأرصدة أو السحب أو التحويل البنكي. تنفيذ وتوثيق العمليات المالية حصري للمدير المالي المعتمد برقم تفويض مصرفي رسمي.'**
  String get governancePolicyNotice;

  /// No description provided for @governancePolicyClause.
  ///
  /// In ar, this message translates to:
  /// **'بند #04 - أ'**
  String get governancePolicyClause;

  /// No description provided for @urgentWithdrawalsAction.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة طلبات السحب العاجلة (14 طلباً جاهزاً للصرف)'**
  String get urgentWithdrawalsAction;

  /// No description provided for @exportDailyReportPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير تقرير السيولة والمركز المالي اليومي (PDF)'**
  String get exportDailyReportPdf;

  /// No description provided for @liquidityDistributedOnChannels.
  ///
  /// In ar, this message translates to:
  /// **'السيولة الموزعة على القنوات المصرفية'**
  String get liquidityDistributedOnChannels;

  /// No description provided for @liveBankingReconciliation.
  ///
  /// In ar, this message translates to:
  /// **'مطابقة بنكية حية (SARI/SARIE نشط 100%)'**
  String get liveBankingReconciliation;

  /// No description provided for @instantSync.
  ///
  /// In ar, this message translates to:
  /// **'تزامن فوري'**
  String get instantSync;

  /// No description provided for @mainBanksCount.
  ///
  /// In ar, this message translates to:
  /// **'3 بنوك رئيسية'**
  String get mainBanksCount;

  /// No description provided for @instaPayCount.
  ///
  /// In ar, this message translates to:
  /// **'2 إنستاباي InstaPay'**
  String get instaPayCount;

  /// No description provided for @digitalWalletsCount.
  ///
  /// In ar, this message translates to:
  /// **'2 محافظ رقمية'**
  String get digitalWalletsCount;

  /// No description provided for @officialBankAccountsAndIban.
  ///
  /// In ar, this message translates to:
  /// **'الحسابات البنكية الرسمية وحسابات الآيبان'**
  String get officialBankAccountsAndIban;

  /// No description provided for @bankAccountsScreenSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة السيولة والمطابقة مع الشبكة السعودية للمدفوعات'**
  String get bankAccountsScreenSubtitle;

  /// No description provided for @refreshBalances.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الأرصدة'**
  String get refreshBalances;

  /// No description provided for @noAccountsInCategory.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حسابات مسجلة ضمن هذا التصنيف'**
  String get noAccountsInCategory;

  /// No description provided for @operationalAccountsFilter.
  ///
  /// In ar, this message translates to:
  /// **'حسابات تشغيلية'**
  String get operationalAccountsFilter;

  /// No description provided for @escrowAccountsFilter.
  ///
  /// In ar, this message translates to:
  /// **'حسابات ضمان Escrow'**
  String get escrowAccountsFilter;

  /// No description provided for @paymentGatewaysFilter.
  ///
  /// In ar, this message translates to:
  /// **'بوابات الدفع الإلكتروني'**
  String get paymentGatewaysFilter;

  /// No description provided for @digitalWalletsFilter.
  ///
  /// In ar, this message translates to:
  /// **'المحافظ الرقمية'**
  String get digitalWalletsFilter;

  /// No description provided for @instantBankSyncNote.
  ///
  /// In ar, this message translates to:
  /// **'تحديث ومطابقة تلقائية متزامنة مع كافة القنوات'**
  String get instantBankSyncNote;

  /// No description provided for @createBankAccount.
  ///
  /// In ar, this message translates to:
  /// **'إضافة حساب جديد'**
  String get createBankAccount;

  /// No description provided for @exportAccountStatementButton.
  ///
  /// In ar, this message translates to:
  /// **'تصدير كشف PDF'**
  String get exportAccountStatementButton;

  /// No description provided for @openDailyLedger.
  ///
  /// In ar, this message translates to:
  /// **'سجل الحركات المصرفية والعمليات اليومية'**
  String get openDailyLedger;

  /// No description provided for @dailyLedgerDescription.
  ///
  /// In ar, this message translates to:
  /// **'عرض قيود اليومية، الإيداعات، والحوالات الصادرة والواردة'**
  String get dailyLedgerDescription;

  /// No description provided for @escrowAccountBadge.
  ///
  /// In ar, this message translates to:
  /// **'حساب ضمان'**
  String get escrowAccountBadge;

  /// No description provided for @availableLedgerBalanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الدفتري المتاح:'**
  String get availableLedgerBalanceLabel;

  /// No description provided for @ibanOrIdentifierLabel.
  ///
  /// In ar, this message translates to:
  /// **'الآيبان / المعرّف:'**
  String get ibanOrIdentifierLabel;

  /// No description provided for @connectedReconciledViaSarie.
  ///
  /// In ar, this message translates to:
  /// **'متصل ومطابق لحظياً عبر SARIE'**
  String get connectedReconciledViaSarie;

  /// No description provided for @linkBankAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'ربط حساب مصرفي جديد'**
  String get linkBankAccountTitle;

  /// No description provided for @enterBankDetailsToApprove.
  ///
  /// In ar, this message translates to:
  /// **'أدخل تفاصيل الحساب المصرفي للاعتماد'**
  String get enterBankDetailsToApprove;

  /// No description provided for @bankNameField.
  ///
  /// In ar, this message translates to:
  /// **'اسم البنك'**
  String get bankNameField;

  /// No description provided for @ibanField.
  ///
  /// In ar, this message translates to:
  /// **'رقم الآيبان (IBAN)'**
  String get ibanField;

  /// No description provided for @bankLinkRequestSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب الربط'**
  String get bankLinkRequestSent;

  /// No description provided for @saveAccount.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الحساب'**
  String get saveAccount;

  /// No description provided for @exportAccountsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تصدير كشف الحسابات'**
  String get exportAccountsTitle;

  /// No description provided for @pdfReportExplanation.
  ///
  /// In ar, this message translates to:
  /// **'سيتم توليد تقرير رسمي مفصل بصيغة PDF بجميع الأرصدة المصرفية المتطابقة.'**
  String get pdfReportExplanation;

  /// No description provided for @download.
  ///
  /// In ar, this message translates to:
  /// **'تحميل'**
  String get download;

  /// No description provided for @cancelAction.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancelAction;

  /// No description provided for @accountsExportSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تصدير كشف الحسابات بنجاح'**
  String get accountsExportSuccess;

  /// No description provided for @accountsCount.
  ///
  /// In ar, this message translates to:
  /// **'3 حسابات'**
  String get accountsCount;

  /// No description provided for @collectionAndDistribution.
  ///
  /// In ar, this message translates to:
  /// **'تحصيل وتوزيع'**
  String get collectionAndDistribution;

  /// No description provided for @sadadAndSarie.
  ///
  /// In ar, this message translates to:
  /// **'سداد & SARIE'**
  String get sadadAndSarie;

  /// No description provided for @frozenEscrowAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب مجمد للأمانات'**
  String get frozenEscrowAccount;

  /// No description provided for @emergencyAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب الطوارئ والتسويات البنكية الفورية'**
  String get emergencyAccount;

  /// No description provided for @approvedT0.
  ///
  /// In ar, this message translates to:
  /// **'معتمد T+0'**
  String get approvedT0;

  /// No description provided for @dailyLedgerBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الدفتري الحالي'**
  String get dailyLedgerBalance;

  /// No description provided for @ibanNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الآيبان (IBAN)'**
  String get ibanNumber;

  /// No description provided for @internalAccountNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الحساب الداخلي'**
  String get internalAccountNumber;

  /// No description provided for @dailyLogLedger.
  ///
  /// In ar, this message translates to:
  /// **'سجل الحركات اليومية'**
  String get dailyLogLedger;

  /// No description provided for @reviewHeldEscrow.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة المحتجزات'**
  String get reviewHeldEscrow;

  /// No description provided for @reconciliationDisputesNote.
  ///
  /// In ar, this message translates to:
  /// **'خاضع للمطابقة المالية الآلية مع بوابة النزاعات'**
  String get reconciliationDisputesNote;

  /// No description provided for @approvedEWallets.
  ///
  /// In ar, this message translates to:
  /// **'المحافظ الإلكترونية المعتمدة (E-Wallets)'**
  String get approvedEWallets;

  /// No description provided for @walletsCount.
  ///
  /// In ar, this message translates to:
  /// **'محفظتان'**
  String get walletsCount;

  /// No description provided for @stcPayEnterprise.
  ///
  /// In ar, this message translates to:
  /// **'محفظة stc pay للأعمال (Enterprise)'**
  String get stcPayEnterprise;

  /// No description provided for @apiConnected.
  ///
  /// In ar, this message translates to:
  /// **'مربوطة API'**
  String get apiConnected;

  /// No description provided for @actualWalletBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الفعلي في المحفظة'**
  String get actualWalletBalance;

  /// No description provided for @withdrawalFeesFree.
  ///
  /// In ar, this message translates to:
  /// **'رسوم السحب: مجاناً (اتفاقية شركات)'**
  String get withdrawalFeesFree;

  /// No description provided for @urpayBusiness.
  ///
  /// In ar, this message translates to:
  /// **'محفظة urpay (يورباي للأعمال)'**
  String get urpayBusiness;

  /// No description provided for @activeStatus.
  ///
  /// In ar, this message translates to:
  /// **'نشطة'**
  String get activeStatus;

  /// No description provided for @salarySupportDisbursement.
  ///
  /// In ar, this message translates to:
  /// **'صرف رواتب مساندة'**
  String get salarySupportDisbursement;

  /// No description provided for @feedWalletBalance.
  ///
  /// In ar, this message translates to:
  /// **'تغذية رصيد المحفظة'**
  String get feedWalletBalance;

  /// No description provided for @bankingGovernanceAuthNote.
  ///
  /// In ar, this message translates to:
  /// **'تعديل أو سحب أو إلغاء ربط أي قناة مصرفية يخضع لمعايير الأمن المالي المشدد، ويتطلب مصادقة ثنائية عبر منصة نفاذ (2FA) ومصادقة التوقيع الإلكتروني المشفر (SHA-256) للمدير المالي التنفيذي.'**
  String get bankingGovernanceAuthNote;

  /// No description provided for @addNewBankAccount.
  ///
  /// In ar, this message translates to:
  /// **'إضافة حساب بنكي أو قناة دفع جديدة'**
  String get addNewBankAccount;

  /// No description provided for @exportAccountsStatementPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير بيان الحسابات (PDF)'**
  String get exportAccountsStatementPdf;

  /// No description provided for @exportDetailedStatementExcel.
  ///
  /// In ar, this message translates to:
  /// **'بيان تفصيلي (Excel)'**
  String get exportDetailedStatementExcel;

  /// No description provided for @bankingAndCashSurveillanceGateway.
  ///
  /// In ar, this message translates to:
  /// **'بوابة الصرف والرقابة النقدية'**
  String get bankingAndCashSurveillanceGateway;

  /// No description provided for @merchantWithdrawalsHeaderTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات سحب مستحقات التجار و المستخدمين و المناديب'**
  String get merchantWithdrawalsHeaderTitle;

  /// No description provided for @merchantWithdrawalsHeaderSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قائمة طلبات السحب النقدي المعتمدة للمتاجر والمزودين'**
  String get merchantWithdrawalsHeaderSubtitle;

  /// No description provided for @pendingRequests.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات المعلقة'**
  String get pendingRequests;

  /// No description provided for @underRegulatoryHold.
  ///
  /// In ar, this message translates to:
  /// **'تحت الاحتراز'**
  String get underRegulatoryHold;

  /// No description provided for @regulatoryFreeze.
  ///
  /// In ar, this message translates to:
  /// **'تجميد رقابي'**
  String get regulatoryFreeze;

  /// No description provided for @allTab.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get allTab;

  /// No description provided for @merchantsTab.
  ///
  /// In ar, this message translates to:
  /// **'التجار'**
  String get merchantsTab;

  /// No description provided for @usersTab.
  ///
  /// In ar, this message translates to:
  /// **'المستخدمين'**
  String get usersTab;

  /// No description provided for @verifiedViaNafath.
  ///
  /// In ar, this message translates to:
  /// **'معتمد ومطابق عبر النفاذ الموحد'**
  String get verifiedViaNafath;

  /// No description provided for @underReviewStatus.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get underReviewStatus;

  /// No description provided for @grossAmount.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المبلغ المطلوب (Gross):'**
  String get grossAmount;

  /// No description provided for @platformFee.
  ///
  /// In ar, this message translates to:
  /// **'عمولة المنصة والخدمات'**
  String get platformFee;

  /// No description provided for @netTransferredAmount.
  ///
  /// In ar, this message translates to:
  /// **'صافي المبلغ المحول للحساب البنكي:'**
  String get netTransferredAmount;

  /// No description provided for @receivingBank.
  ///
  /// In ar, this message translates to:
  /// **'المصرف المستلم:'**
  String get receivingBank;

  /// No description provided for @submissionDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ تقديم الطلب:'**
  String get submissionDate;

  /// No description provided for @automatedTaxAuditResult.
  ///
  /// In ar, this message translates to:
  /// **'نتيجة الفحص الآلي للمطابقة الضريبية والمحفظة'**
  String get automatedTaxAuditResult;

  /// No description provided for @automatedTaxAuditDetails.
  ///
  /// In ar, this message translates to:
  /// **'مطابقة الفواتير: 100% | لا توجد بلاغات نزاع أو شكاوى نشطة | رصيد المحفظة مغطى بالكامل ومطابق لصافي التحصيلات التشغيلية.'**
  String get automatedTaxAuditDetails;

  /// No description provided for @approveAndSendToAdmin.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد و ارسال الطلب للادارة'**
  String get approveAndSendToAdmin;

  /// No description provided for @freezeRequestTemporarily.
  ///
  /// In ar, this message translates to:
  /// **'تجميد مؤقت للطلب'**
  String get freezeRequestTemporarily;

  /// No description provided for @readyForInstantDisbursement.
  ///
  /// In ar, this message translates to:
  /// **'جاهز للصرف'**
  String get readyForInstantDisbursement;

  /// No description provided for @readyForInstantBankingTransfer.
  ///
  /// In ar, this message translates to:
  /// **'معتمد من النظام - جاهز للإرسال البنكي عبر شبكة سريع'**
  String get readyForInstantBankingTransfer;

  /// No description provided for @approveAndIssueBankOrder.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد و اعطاء أمر الصرف البنكي'**
  String get approveAndIssueBankOrder;

  /// No description provided for @temporarilySuspendedForAudit.
  ///
  /// In ar, this message translates to:
  /// **'موقوف مؤقتاً للتحقيق الرقابي'**
  String get temporarilySuspendedForAudit;

  /// No description provided for @grossHeldAmount.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المبلغ المطلوب تحت الحظر (Gross):'**
  String get grossHeldAmount;

  /// No description provided for @estimatedPlatformFee.
  ///
  /// In ar, this message translates to:
  /// **'عمولة المنصة التقديرية'**
  String get estimatedPlatformFee;

  /// No description provided for @netFrozenAmount.
  ///
  /// In ar, this message translates to:
  /// **'الصافي المحتجز للتجميد:'**
  String get netFrozenAmount;

  /// No description provided for @auditReferenceCode.
  ///
  /// In ar, this message translates to:
  /// **'المرجع الرقابي'**
  String get auditReferenceCode;

  /// No description provided for @regulatoryNoticeFromSupervisor.
  ///
  /// In ar, this message translates to:
  /// **'مذكرة إشعار رقابي من مشرف التجار'**
  String get regulatoryNoticeFromSupervisor;

  /// No description provided for @rejectAndNotifyCustomer.
  ///
  /// In ar, this message translates to:
  /// **'الرفض و اشعار العميل'**
  String get rejectAndNotifyCustomer;

  /// No description provided for @freezeRequest.
  ///
  /// In ar, this message translates to:
  /// **'تجميد الطلب'**
  String get freezeRequest;

  /// No description provided for @totalAwaitingApproval.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المبالغ بانتظار الاعتماد'**
  String get totalAwaitingApproval;

  /// No description provided for @remainingForReview.
  ///
  /// In ar, this message translates to:
  /// **'المتبقي للمراجعة'**
  String get remainingForReview;

  /// No description provided for @supervisorWithdrawalsHeaderTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات سحب مستحقات المشرفين ومقدمي الخدمة'**
  String get supervisorWithdrawalsHeaderTitle;

  /// No description provided for @supervisorWithdrawalsHeaderSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قائمة طلبات سحب الأتعاب وعمولات الإشراف وأجور الصيانة المعتمدة للصرف'**
  String get supervisorWithdrawalsHeaderSubtitle;

  /// No description provided for @awaitingApprovalTab.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الاعتماد'**
  String get awaitingApprovalTab;

  /// No description provided for @platformSupervisorsTab.
  ///
  /// In ar, this message translates to:
  /// **'مشرفو المنصة'**
  String get platformSupervisorsTab;

  /// No description provided for @awaitingDisbursementBadge.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الصرف'**
  String get awaitingDisbursementBadge;

  /// No description provided for @totalFeesAndCommissions.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي أتعاب وعمولات الإشراف:'**
  String get totalFeesAndCommissions;

  /// No description provided for @netAmountDueForDisbursement.
  ///
  /// In ar, this message translates to:
  /// **'صافي المبلغ المستحق للصرف:'**
  String get netAmountDueForDisbursement;

  /// No description provided for @disbursementSource.
  ///
  /// In ar, this message translates to:
  /// **'مصدر المستحقات'**
  String get disbursementSource;

  /// No description provided for @complianceAndAuditResult.
  ///
  /// In ar, this message translates to:
  /// **'نتيجة الفحص الآلي لمطابقة الأداء'**
  String get complianceAndAuditResult;

  /// No description provided for @verifiedIban.
  ///
  /// In ar, this message translates to:
  /// **'آيبان موثق'**
  String get verifiedIban;

  /// No description provided for @fieldCompletionDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الإنجاز الميداني'**
  String get fieldCompletionDetails;

  /// No description provided for @temporarilySuspendedBadge.
  ///
  /// In ar, this message translates to:
  /// **'موقوف مؤقتاً'**
  String get temporarilySuspendedBadge;

  /// No description provided for @grossClaimedAmount.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المبلغ المطالب به:'**
  String get grossClaimedAmount;

  /// No description provided for @deductedPlatformFee.
  ///
  /// In ar, this message translates to:
  /// **'عمولة المنصة المستقطعة'**
  String get deductedPlatformFee;

  /// No description provided for @netHeldAmount.
  ///
  /// In ar, this message translates to:
  /// **'صافي المبلغ المحجوز احترازياً:'**
  String get netHeldAmount;

  /// No description provided for @requestStatusProtocol.
  ///
  /// In ar, this message translates to:
  /// **'حالة الطلب: محجوز بموجب بروتوكول حماية الجودة الإشرافي'**
  String get requestStatusProtocol;

  /// No description provided for @regulatoryNoticeFromServicesSupervisor.
  ///
  /// In ar, this message translates to:
  /// **'إشعار رقابي من مشرف الخدمات'**
  String get regulatoryNoticeFromServicesSupervisor;

  /// No description provided for @batchApproval.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد جماعي'**
  String get batchApproval;

  /// No description provided for @samaComplianceNotice.
  ///
  /// In ar, this message translates to:
  /// **'التحويلات تخضع لمعايير البنك المركزي السعودي (SAMA)'**
  String get samaComplianceNotice;

  /// No description provided for @subscriptionOrdersTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الاشتراكات'**
  String get subscriptionOrdersTitle;

  /// No description provided for @financialManagementSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'برواح المازوري - الإدارة المالية'**
  String get financialManagementSubtitle;

  /// No description provided for @financialAuditAndLicenses.
  ///
  /// In ar, this message translates to:
  /// **'الرقابة المالية والتراخيص'**
  String get financialAuditAndLicenses;

  /// No description provided for @subscriptionsAndUpgradesReviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الاشتراكات والترقيات'**
  String get subscriptionsAndUpgradesReviewTitle;

  /// No description provided for @subscriptionsAndUpgradesReviewSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة وتفعيل اشتراكات المتاجر ومزودي الخدمات • برواح المازوري'**
  String get subscriptionsAndUpgradesReviewSubtitle;

  /// No description provided for @currentSubscriptionsCycleSummary.
  ///
  /// In ar, this message translates to:
  /// **'موجز دورة الاشتراكات الجارية'**
  String get currentSubscriptionsCycleSummary;

  /// No description provided for @updatedNow.
  ///
  /// In ar, this message translates to:
  /// **'محدث الآن'**
  String get updatedNow;

  /// No description provided for @pendingSubscriptionFees.
  ///
  /// In ar, this message translates to:
  /// **'رسوم الاشتراكات المعلقة'**
  String get pendingSubscriptionFees;

  /// No description provided for @ordersUnderAudit.
  ///
  /// In ar, this message translates to:
  /// **'طلباً قيد التدقيق'**
  String get ordersUnderAudit;

  /// No description provided for @activatedThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'المفعلة هذا الشهر'**
  String get activatedThisMonth;

  /// No description provided for @revenueGrowth.
  ///
  /// In ar, this message translates to:
  /// **'+24% نمو إيرادات'**
  String get revenueGrowth;

  /// No description provided for @expiredAwaitingRenewal.
  ///
  /// In ar, this message translates to:
  /// **'منتهية بانتظار التجديد'**
  String get expiredAwaitingRenewal;

  /// No description provided for @autoCommercialAlert.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه تجاري آلي'**
  String get autoCommercialAlert;

  /// No description provided for @couriersTab.
  ///
  /// In ar, this message translates to:
  /// **'المناديب'**
  String get couriersTab;

  /// No description provided for @advertisementsTab.
  ///
  /// In ar, this message translates to:
  /// **'الإعلانات'**
  String get advertisementsTab;

  /// No description provided for @corporateAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب الشركات'**
  String get corporateAccount;

  /// No description provided for @subscriptionsHistoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل الاشتراكات والترقيات النشطة وغير النشطة'**
  String get subscriptionsHistoryTitle;

  /// No description provided for @browsePreviousOperations.
  ///
  /// In ar, this message translates to:
  /// **'تصفح تاريخ جميع العمليات السابقة'**
  String get browsePreviousOperations;

  /// No description provided for @openingSubscriptionsRegister.
  ///
  /// In ar, this message translates to:
  /// **'جاري فتح السجل...'**
  String get openingSubscriptionsRegister;

  /// No description provided for @storesAndMerchants.
  ///
  /// In ar, this message translates to:
  /// **'المتاجر والتجار'**
  String get storesAndMerchants;

  /// No description provided for @serviceProviders.
  ///
  /// In ar, this message translates to:
  /// **'مزودو الخدمات'**
  String get serviceProviders;

  /// No description provided for @awaitingCertificationRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات بانتظار المصادقة'**
  String get awaitingCertificationRequests;

  /// No description provided for @sortByNewest.
  ///
  /// In ar, this message translates to:
  /// **'ترتيب حسب الأحدث'**
  String get sortByNewest;

  /// No description provided for @underMatching.
  ///
  /// In ar, this message translates to:
  /// **'قيد المطابقة'**
  String get underMatching;

  /// No description provided for @commercialRegister.
  ///
  /// In ar, this message translates to:
  /// **'س.ت:'**
  String get commercialRegister;

  /// No description provided for @licenseNumber.
  ///
  /// In ar, this message translates to:
  /// **'رخصة رقم:'**
  String get licenseNumber;

  /// No description provided for @premiumMerchantSubscription.
  ///
  /// In ar, this message translates to:
  /// **'اشتراك تاجر مميز'**
  String get premiumMerchantSubscription;

  /// No description provided for @homeServicesProvider.
  ///
  /// In ar, this message translates to:
  /// **'مزود خدمات منزلية'**
  String get homeServicesProvider;

  /// No description provided for @targetedPackageType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الباقة المستهدفة'**
  String get targetedPackageType;

  /// No description provided for @annualGoldenPackage.
  ///
  /// In ar, this message translates to:
  /// **'الباقة الذهبية السنوية'**
  String get annualGoldenPackage;

  /// No description provided for @proServiceProviderPackage.
  ///
  /// In ar, this message translates to:
  /// **'مزود خدمة احترافي'**
  String get proServiceProviderPackage;

  /// No description provided for @taxInclusive15.
  ///
  /// In ar, this message translates to:
  /// **'شامل الضريبة 15%'**
  String get taxInclusive15;

  /// No description provided for @semiAnnualDuration.
  ///
  /// In ar, this message translates to:
  /// **'نصف سنوي (6 أشهر)'**
  String get semiAnnualDuration;

  /// No description provided for @sufficientWalletBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيد كافي بالمحفظة'**
  String get sufficientWalletBalance;

  /// No description provided for @paymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة السداد:'**
  String get paymentMethod;

  /// No description provided for @directBankTransfer.
  ///
  /// In ar, this message translates to:
  /// **'تحويل بنكي مباشر (سداد / الراجحي - حساب الشركات)'**
  String get directBankTransfer;

  /// No description provided for @directDeductionFromEscrow.
  ///
  /// In ar, this message translates to:
  /// **'خصم مباشر من رصيد المحفظة الضامنة (Escrow)'**
  String get directDeductionFromEscrow;

  /// No description provided for @availableBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيد متاح'**
  String get availableBalance;

  /// No description provided for @previewReceiptAndTransferData.
  ///
  /// In ar, this message translates to:
  /// **'معاينة الإيصال وبيانات التحويل'**
  String get previewReceiptAndTransferData;

  /// No description provided for @autoApprovalReady.
  ///
  /// In ar, this message translates to:
  /// **'جاهز للاعتماد التلقائي'**
  String get autoApprovalReady;

  /// No description provided for @rejectWithReason.
  ///
  /// In ar, this message translates to:
  /// **'رفض مع السبب'**
  String get rejectWithReason;

  /// No description provided for @licensesGovernanceTitle.
  ///
  /// In ar, this message translates to:
  /// **'حوكمة اعتماد التراخيص والترقيات'**
  String get licensesGovernanceTitle;

  /// No description provided for @licensesGovernanceDesc.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الباقات يمنح فوراً الصلاحيات التجارية وأولوية الظهور والإعفاءات الرقابية المحددة في النظام المالي لشركة برواح المازوري. تخضع كافة العمليات للتدقيق المستندي والضريبي اللاحق.'**
  String get licensesGovernanceDesc;

  /// No description provided for @certifiedAndDocumentedRecord.
  ///
  /// In ar, this message translates to:
  /// **'سجل معتمد وموثق'**
  String get certifiedAndDocumentedRecord;

  /// No description provided for @pdfReport.
  ///
  /// In ar, this message translates to:
  /// **'تقرير PDF'**
  String get pdfReport;

  /// No description provided for @exportExcel.
  ///
  /// In ar, this message translates to:
  /// **'تصدير Excel'**
  String get exportExcel;

  /// No description provided for @navLiquidity.
  ///
  /// In ar, this message translates to:
  /// **'السيولة'**
  String get navLiquidity;

  /// No description provided for @navWithdrawalOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبات السحب'**
  String get navWithdrawalOrders;

  /// No description provided for @navReconciliation.
  ///
  /// In ar, this message translates to:
  /// **'المطابقة'**
  String get navReconciliation;

  /// No description provided for @navSettlements.
  ///
  /// In ar, this message translates to:
  /// **'التسويات'**
  String get navSettlements;

  /// No description provided for @navCommissions.
  ///
  /// In ar, this message translates to:
  /// **'العمولات'**
  String get navCommissions;

  /// No description provided for @navAudit.
  ///
  /// In ar, this message translates to:
  /// **'التدقيق'**
  String get navAudit;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @profileTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملفك الشخصي'**
  String get profileTitle;

  /// No description provided for @financialDepartment.
  ///
  /// In ar, this message translates to:
  /// **'الإدارة المالية'**
  String get financialDepartment;

  /// No description provided for @encryptedBit256.
  ///
  /// In ar, this message translates to:
  /// **'تشفير bit-256'**
  String get encryptedBit256;

  /// No description provided for @secureApprovedSession.
  ///
  /// In ar, this message translates to:
  /// **'جلسة رقابية آمنة ومصادق عليها'**
  String get secureApprovedSession;

  /// No description provided for @cfoAuditingTitle.
  ///
  /// In ar, this message translates to:
  /// **'CFO ورئيس التدقيق المالي'**
  String get cfoAuditingTitle;

  /// No description provided for @sovereignApprovalPowers.
  ///
  /// In ar, this message translates to:
  /// **'صلاحيات الاعتماد السيادي والمصادقة البنكية'**
  String get sovereignApprovalPowers;

  /// No description provided for @certifiedAuditorAuthority.
  ///
  /// In ar, this message translates to:
  /// **'مدقق مالي معتمد • مفوض التوقيع والمصادقة البنكية المزدوجة لدى مؤسسة برواح المازوري'**
  String get certifiedAuditorAuthority;

  /// No description provided for @officialPhone.
  ///
  /// In ar, this message translates to:
  /// **'الهاتف المعتمد'**
  String get officialPhone;

  /// No description provided for @corporateEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد المؤسسي'**
  String get corporateEmail;

  /// No description provided for @enabledNafath.
  ///
  /// In ar, this message translates to:
  /// **'نفاذ وطني مفعل'**
  String get enabledNafath;

  /// No description provided for @authorizationEffectiveFrom.
  ///
  /// In ar, this message translates to:
  /// **'سريان الاعتماد الرقابي من: 2027م'**
  String get authorizationEffectiveFrom;

  /// No description provided for @activeAndReconciled.
  ///
  /// In ar, this message translates to:
  /// **'نشط ومطابق'**
  String get activeAndReconciled;

  /// No description provided for @duesWalletTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة المستحقات والأتعاب'**
  String get duesWalletTitle;

  /// No description provided for @executiveWalletDescription.
  ///
  /// In ar, this message translates to:
  /// **'حساب الإدارة والرقابة التنفيذية المباشر'**
  String get executiveWalletDescription;

  /// No description provided for @totalAccountingDues.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي رصيد المستحقات المحاسبية'**
  String get totalAccountingDues;

  /// No description provided for @pendingRegulatoryBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيد معلق رقابياً'**
  String get pendingRegulatoryBalance;

  /// No description provided for @awaitingQuarterlyClose.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الإقفال الربع سنوي'**
  String get awaitingQuarterlyClose;

  /// No description provided for @approvedWithoutConditions.
  ///
  /// In ar, this message translates to:
  /// **'معتمد دون شروط'**
  String get approvedWithoutConditions;

  /// No description provided for @approvedPayoutAccount.
  ///
  /// In ar, this message translates to:
  /// **'الحساب المصفي المعتمد للصرف'**
  String get approvedPayoutAccount;

  /// No description provided for @requestOwnerProfitWithdrawal.
  ///
  /// In ar, this message translates to:
  /// **'طلب سحب الأرباح من المالك'**
  String get requestOwnerProfitWithdrawal;

  /// No description provided for @editWithdrawalInformation.
  ///
  /// In ar, this message translates to:
  /// **'تعديل معلومات السحب'**
  String get editWithdrawalInformation;

  /// No description provided for @cfoExclusive.
  ///
  /// In ar, this message translates to:
  /// **'مقتصرة على CFO'**
  String get cfoExclusive;

  /// No description provided for @sovereignControls.
  ///
  /// In ar, this message translates to:
  /// **'التحكم والإجراءات السيادية'**
  String get sovereignControls;

  /// No description provided for @feesAndCommissionsMatrix.
  ///
  /// In ar, this message translates to:
  /// **'مصفوفة الرسوم والعمولات العامة'**
  String get feesAndCommissionsMatrix;

  /// No description provided for @feesAndCommissionsMatrixDesc.
  ///
  /// In ar, this message translates to:
  /// **'ضبط النسب المئوية للمنصة، اقتطاعات بوابات الدفع الإلكترونية، وتعديل تسعير العمليات التعاقدية.'**
  String get feesAndCommissionsMatrixDesc;

  /// No description provided for @exclusivePermission.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية حصرية'**
  String get exclusivePermission;

  /// No description provided for @editMatrix.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المصفوفة'**
  String get editMatrix;

  /// No description provided for @fastSettlementFees.
  ///
  /// In ar, this message translates to:
  /// **'رسوم التسوية السريعة'**
  String get fastSettlementFees;

  /// No description provided for @currentBaseCommission.
  ///
  /// In ar, this message translates to:
  /// **'العمولة الأساسية الحالية'**
  String get currentBaseCommission;

  /// No description provided for @comprehensivePaymentsReports.
  ///
  /// In ar, this message translates to:
  /// **'كشف المدفوعات والإيرادات الشامل'**
  String get comprehensivePaymentsReports;

  /// No description provided for @comprehensivePaymentsReportsDesc.
  ///
  /// In ar, this message translates to:
  /// **'توليد كشوف التدفقات النقدية، تقارير الضريبة العامة المضافة، وحزم التسويات المصرفية المجمعة.'**
  String get comprehensivePaymentsReportsDesc;

  /// No description provided for @exportDetailedExcel.
  ///
  /// In ar, this message translates to:
  /// **'تصدير Excel تفصيلي'**
  String get exportDetailedExcel;

  /// No description provided for @exportApprovedPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF معتمد'**
  String get exportApprovedPdf;

  /// No description provided for @liveDocumented.
  ///
  /// In ar, this message translates to:
  /// **'مباشر • موثق'**
  String get liveDocumented;

  /// No description provided for @auditActivityLog.
  ///
  /// In ar, this message translates to:
  /// **'سجل الرقابة وحركات المدير المالي'**
  String get auditActivityLog;

  /// No description provided for @ownerDisputeSettlementApproval.
  ///
  /// In ar, this message translates to:
  /// **'مصادقة صرف تسوية نزاع مالك'**
  String get ownerDisputeSettlementApproval;

  /// No description provided for @todayAtEleven.
  ///
  /// In ar, this message translates to:
  /// **'اليوم 11:00 ص'**
  String get todayAtEleven;

  /// No description provided for @approveDisputeSettlement.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد صرف تسوية النزاع #CMP-1035 بقيمة 1,200.00 ج.م للعميل د. طارق العمري.'**
  String get approveDisputeSettlement;

  /// No description provided for @referenceCode.
  ///
  /// In ar, this message translates to:
  /// **'المرجع:'**
  String get referenceCode;

  /// No description provided for @validDigitalSignature.
  ///
  /// In ar, this message translates to:
  /// **'توقيع رقمي ساري SHA-256'**
  String get validDigitalSignature;

  /// No description provided for @aggregatedProfitWithdrawal.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد سحب أرباح مجمعة (SARIE)'**
  String get aggregatedProfitWithdrawal;

  /// No description provided for @todayAtNineThirty.
  ///
  /// In ar, this message translates to:
  /// **'اليوم 09:30 ص'**
  String get todayAtNineThirty;

  /// No description provided for @periodicMerchantTransfers.
  ///
  /// In ar, this message translates to:
  /// **'تحويل مستحقات دورية لـ 12 متجر معتمد عبر نظام المدفوعات الفورية بإجمالي 142,500.00 ج.م.'**
  String get periodicMerchantTransfers;

  /// No description provided for @alRajhiBank.
  ///
  /// In ar, this message translates to:
  /// **'مصرف الراجحي'**
  String get alRajhiBank;

  /// No description provided for @executedAndPosted.
  ///
  /// In ar, this message translates to:
  /// **'منفذة بنكياً ومقيدة'**
  String get executedAndPosted;

  /// No description provided for @precautionaryWalletFreeze.
  ///
  /// In ar, this message translates to:
  /// **'تجميد احترازي لمحفظة متجر'**
  String get precautionaryWalletFreeze;

  /// No description provided for @yesterdayAtFourFifteen.
  ///
  /// In ar, this message translates to:
  /// **'أمس 04:15 م'**
  String get yesterdayAtFourFifteen;

  /// No description provided for @suspendMerchantDisbursement.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف عمليات الصرف لمتجر مستلزمات حاسب (#TRD-304) لوجود شبهة نزاع مدفوعات متكرر.'**
  String get suspendMerchantDisbursement;

  /// No description provided for @auditNoticeReference.
  ///
  /// In ar, this message translates to:
  /// **'إشعار التدقيق #771'**
  String get auditNoticeReference;

  /// No description provided for @underInvestigation.
  ///
  /// In ar, this message translates to:
  /// **'قيد التحقيق والتدقيق'**
  String get underInvestigation;

  /// No description provided for @maintenanceCommissionUpdate.
  ///
  /// In ar, this message translates to:
  /// **'تحديث عمولة قطاع الصيانة'**
  String get maintenanceCommissionUpdate;

  /// No description provided for @yesterdayAtOneTwenty.
  ///
  /// In ar, this message translates to:
  /// **'أمس 01:20 م'**
  String get yesterdayAtOneTwenty;

  /// No description provided for @commissionUpdatedByBoard.
  ///
  /// In ar, this message translates to:
  /// **'تعديل نسبة العمولة المحصلة إلى 8.0% بموجب قرار مجلس الإدارة رقم BOD-44/B.'**
  String get commissionUpdatedByBoard;

  /// No description provided for @activeSystemUpdate.
  ///
  /// In ar, this message translates to:
  /// **'تحديث نظامي نافذ'**
  String get activeSystemUpdate;

  /// No description provided for @viewFullAuditActivity.
  ///
  /// In ar, this message translates to:
  /// **'عرض سجل الرقابة والحركات الكامل (342 حركة موثقة)'**
  String get viewFullAuditActivity;

  /// No description provided for @reconciliationEngine.
  ///
  /// In ar, this message translates to:
  /// **'KYC & IBAN VERIFICATION ENGINE'**
  String get reconciliationEngine;

  /// No description provided for @reconciliationImmediateCompliance.
  ///
  /// In ar, this message translates to:
  /// **'امتثال مصرفي فوري'**
  String get reconciliationImmediateCompliance;

  /// No description provided for @reconciliationPageTitle.
  ///
  /// In ar, this message translates to:
  /// **'مطابقة الحسابات البنكية ومكافحة الاحتيال'**
  String get reconciliationPageTitle;

  /// No description provided for @reconciliationAuthorityTitle.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية إشرافية تنفيذية مقيدة'**
  String get reconciliationAuthorityTitle;

  /// No description provided for @reconciliationAuthorityNotice.
  ///
  /// In ar, this message translates to:
  /// **'للاطلاع والتحقق والاعتماد مصرح للمدير المالي حصرياً. تعديل بيانات الحساب البنكية ممنوع بتاتاً من قبل المشرفين الميدانيين.'**
  String get reconciliationAuthorityNotice;

  /// No description provided for @reconciliationGovernmentPortal.
  ///
  /// In ar, this message translates to:
  /// **'بوابة وثائق وربط حكومي'**
  String get reconciliationGovernmentPortal;

  /// No description provided for @reconciliationGovernmentSync.
  ///
  /// In ar, this message translates to:
  /// **'تزامن حي ومباشر مع السجل التجاري والبنك المركزي'**
  String get reconciliationGovernmentSync;

  /// No description provided for @reconciliationConnected.
  ///
  /// In ar, this message translates to:
  /// **'متصل'**
  String get reconciliationConnected;

  /// No description provided for @reconciliationAccountDetails.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المطابقة التفصيلية للحساب'**
  String get reconciliationAccountDetails;

  /// No description provided for @reconciliationCommercialName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم المعتمد في السجل التجاري'**
  String get reconciliationCommercialName;

  /// No description provided for @reconciliationCommercialEntity.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة مدار التقنية لتقنية المعلومات'**
  String get reconciliationCommercialEntity;

  /// No description provided for @reconciliationBeneficiaryName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستفيد في الحساب البنكي'**
  String get reconciliationBeneficiaryName;

  /// No description provided for @reconciliationBeneficiaryEntity.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة مدار التقنية'**
  String get reconciliationBeneficiaryEntity;

  /// No description provided for @reconciliationFinalActions.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات الاعتماد النهائي (حصر صلاحيات المدير المالي):'**
  String get reconciliationFinalActions;

  /// No description provided for @reconciliationApproveAccount.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد الحساب البنكي وإرساله للإدارة'**
  String get reconciliationApproveAccount;

  /// No description provided for @reconciliationApproveSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم اعتماد الحساب البنكي وإرساله للإدارة.'**
  String get reconciliationApproveSuccess;

  /// No description provided for @reconciliationRequestIban.
  ///
  /// In ar, this message translates to:
  /// **'طلب شهادة آيبان حديثة ومختومة'**
  String get reconciliationRequestIban;

  /// No description provided for @reconciliationIbanRequestSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب شهادة آيبان حديثة ومختومة.'**
  String get reconciliationIbanRequestSent;

  /// No description provided for @reconciliationRejectTransfer.
  ///
  /// In ar, this message translates to:
  /// **'رفض وتجميد التحويل للحساب'**
  String get reconciliationRejectTransfer;

  /// No description provided for @reconciliationRejectSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض الطلب وتسجيل سبب الرفض للمراجعة.'**
  String get reconciliationRejectSuccess;

  /// No description provided for @reconciliationComplianceReview.
  ///
  /// In ar, this message translates to:
  /// **'فحص الامتثال المالي - بوابة وثائق الحكومة'**
  String get reconciliationComplianceReview;

  /// No description provided for @reconciliationBusinessName.
  ///
  /// In ar, this message translates to:
  /// **'شركة مدار التقنية للتجارة'**
  String get reconciliationBusinessName;

  /// No description provided for @reconciliationNewAccountRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب اعتماد حساب بنكي رئيسي جديد للصرف الدوري'**
  String get reconciliationNewAccountRequest;

  /// No description provided for @reconciliationAmlScore.
  ///
  /// In ar, this message translates to:
  /// **'مؤشر توافق المعايير الرقابية (AML/CFT)'**
  String get reconciliationAmlScore;

  /// No description provided for @reconciliationAmlMatched.
  ///
  /// In ar, this message translates to:
  /// **'تطابق آمن وفق بروتوكول مكافحة غسل الأموال وتمويل الإرهاب.'**
  String get reconciliationAmlMatched;

  /// No description provided for @reconciliationMatchVerified.
  ///
  /// In ar, this message translates to:
  /// **'مطابق 100%  ✓'**
  String get reconciliationMatchVerified;

  /// No description provided for @reconciliationBankName.
  ///
  /// In ar, this message translates to:
  /// **'مصرف الراجحي'**
  String get reconciliationBankName;

  /// No description provided for @reconciliationIbanLabel.
  ///
  /// In ar, this message translates to:
  /// **'3. رقم الحساب الدولي (IBAN) والجهة البنكية'**
  String get reconciliationIbanLabel;

  /// No description provided for @reconciliationRegistrationLabel.
  ///
  /// In ar, this message translates to:
  /// **'4. السجل التجاري وحالة الصلاحية'**
  String get reconciliationRegistrationLabel;

  /// No description provided for @reconciliationValidUntil.
  ///
  /// In ar, this message translates to:
  /// **'ساري المفعول حتى 1447/06/15هـ'**
  String get reconciliationValidUntil;

  /// No description provided for @reconciliationPreviewDocument.
  ///
  /// In ar, this message translates to:
  /// **'معاينة'**
  String get reconciliationPreviewDocument;

  /// No description provided for @reconciliationDocumentPreviewToast.
  ///
  /// In ar, this message translates to:
  /// **'معاينة مستند doc-iban-5501.pdf'**
  String get reconciliationDocumentPreviewToast;

  /// No description provided for @reconciliationNextAccount.
  ///
  /// In ar, this message translates to:
  /// **'الحساب التالي في قائمة الانتظار'**
  String get reconciliationNextAccount;

  /// No description provided for @reconciliationNextBusiness.
  ///
  /// In ar, this message translates to:
  /// **'متجر السهيلة للعطور'**
  String get reconciliationNextBusiness;

  /// No description provided for @reconciliationNextBank.
  ///
  /// In ar, this message translates to:
  /// **'البنك الأهلي السعودي  •  SA22 1000 **** **** 8819'**
  String get reconciliationNextBank;

  /// No description provided for @reconciliationNameMismatch.
  ///
  /// In ar, this message translates to:
  /// **'حالة المطابقة: اختلاف طفيف في اللقب التجاري (يتطلب مراجعة مستند التفويض والوكالة الشرعية قبل الصرف).'**
  String get reconciliationNameMismatch;

  /// No description provided for @reconciliationAuditAlert.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه تدقيق'**
  String get reconciliationAuditAlert;

  /// No description provided for @reconciliationOpenAudit.
  ///
  /// In ar, this message translates to:
  /// **'فتح ملف التدقيق الكامل للحساب #TRD-6022'**
  String get reconciliationOpenAudit;

  /// No description provided for @withdrawSheetBrand.
  ///
  /// In ar, this message translates to:
  /// **'برواح المازوري للخدمات المالية'**
  String get withdrawSheetBrand;

  /// No description provided for @withdrawSheetTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب سحب الارباح من المالك'**
  String get withdrawSheetTitle;

  /// No description provided for @withdrawSheetAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب الإدارة والرقابة التنفيذية — أ. سليمان الراجحي'**
  String get withdrawSheetAccount;

  /// No description provided for @withdrawSheetInstantAuth.
  ///
  /// In ar, this message translates to:
  /// **'مصادقة نفاذ فوري • سحب لحظي SARIE'**
  String get withdrawSheetInstantAuth;

  /// No description provided for @withdrawSheetRequestId.
  ///
  /// In ar, this message translates to:
  /// **'طلب رقم #WD-8842'**
  String get withdrawSheetRequestId;

  /// No description provided for @withdrawSheetAvailableBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد المتاح الجاهز للصرف الفوري'**
  String get withdrawSheetAvailableBalance;

  /// No description provided for @withdrawSheetMinimumNotice.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للسحب 1,000 ج.م • بدون رسوم تحويل إدارية'**
  String get withdrawSheetMinimumNotice;

  /// No description provided for @withdrawSheetEnterAmount.
  ///
  /// In ar, this message translates to:
  /// **'أدخل المبلغ المطلوب سحبه'**
  String get withdrawSheetEnterAmount;

  /// No description provided for @withdrawSheetSetMaximum.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الحد الأقصى'**
  String get withdrawSheetSetMaximum;

  /// No description provided for @withdrawSheetSelectBank.
  ///
  /// In ar, this message translates to:
  /// **'الحساب البنكي المستلم المعتمد'**
  String get withdrawSheetSelectBank;

  /// No description provided for @withdrawSheetIbanVerified.
  ///
  /// In ar, this message translates to:
  /// **'مدقق IBAN'**
  String get withdrawSheetIbanVerified;

  /// No description provided for @withdrawSheetBankName.
  ///
  /// In ar, this message translates to:
  /// **'مصرف الراجحي'**
  String get withdrawSheetBankName;

  /// No description provided for @withdrawSheetBankStatus.
  ///
  /// In ar, this message translates to:
  /// **'حساب موثق لدى SAMA • نشط ومطابق'**
  String get withdrawSheetBankStatus;

  /// No description provided for @withdrawSheetPrimaryAccount.
  ///
  /// In ar, this message translates to:
  /// **'الحساب الرئيسي'**
  String get withdrawSheetPrimaryAccount;

  /// No description provided for @withdrawSheetSubmitSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم رفع طلب السحب بنجاح'**
  String get withdrawSheetSubmitSuccess;

  /// No description provided for @withdrawSheetConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد ارسال طلب السحب للادارة'**
  String get withdrawSheetConfirm;

  /// No description provided for @withdrawSheetCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء والتراجع'**
  String get withdrawSheetCancel;

  /// No description provided for @withdrawSheetAllAmount.
  ///
  /// In ar, this message translates to:
  /// **'الكل (52,000 ج.م)'**
  String get withdrawSheetAllAmount;

  /// No description provided for @withdrawSheetAmount25k.
  ///
  /// In ar, this message translates to:
  /// **'25,000 ج.م'**
  String get withdrawSheetAmount25k;

  /// No description provided for @withdrawSheetAmount10k.
  ///
  /// In ar, this message translates to:
  /// **'10,000 ج.م'**
  String get withdrawSheetAmount10k;

  /// No description provided for @withdrawSheetAmount5k.
  ///
  /// In ar, this message translates to:
  /// **'5,000 ج.م'**
  String get withdrawSheetAmount5k;

  /// No description provided for @matrixLive.
  ///
  /// In ar, this message translates to:
  /// **'مباشر'**
  String get matrixLive;

  /// No description provided for @matrixCfoPermission.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية سيادية حصرية للمدير المالي (CFO-01)'**
  String get matrixCfoPermission;

  /// No description provided for @matrixIntro.
  ///
  /// In ar, this message translates to:
  /// **'تحديد النسب الرسمية لاقتطاعات المنصة التلقائية وتحديث محرك التسويات والرسوم اللوجستية لكافة العمليات المالية المعتمدة.'**
  String get matrixIntro;

  /// No description provided for @matrixLastUpdate.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث: 01 يناير 2025 بموجب قرار مجلس الإدارة رقم BOD-44/B'**
  String get matrixLastUpdate;

  /// No description provided for @matrixSalesRateTitle.
  ///
  /// In ar, this message translates to:
  /// **'النسبة العامة للمبيعات والمتاجر'**
  String get matrixSalesRateTitle;

  /// No description provided for @matrixRateRange.
  ///
  /// In ar, this message translates to:
  /// **'النطاق: 10.0% - 2.0%'**
  String get matrixRateRange;

  /// No description provided for @matrixCurrentRate.
  ///
  /// In ar, this message translates to:
  /// **'النسبة المطبقة حالياً'**
  String get matrixCurrentRate;

  /// No description provided for @matrixSetTargetRate.
  ///
  /// In ar, this message translates to:
  /// **'ضبط النسبة المستهدفة'**
  String get matrixSetTargetRate;

  /// No description provided for @matrixMinimumRate.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى 2.0%'**
  String get matrixMinimumRate;

  /// No description provided for @matrixReferenceRate.
  ///
  /// In ar, this message translates to:
  /// **'المرجعي 5.0%'**
  String get matrixReferenceRate;

  /// No description provided for @matrixMaximumRate.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى 10.0%'**
  String get matrixMaximumRate;

  /// No description provided for @matrixSalesRateNote.
  ///
  /// In ar, this message translates to:
  /// **'تُطبق على جميع صفقات المتاجر، المنتجات الجديدة، ومبيعات الأجهزة المباشرة دون استثناءات محلية.'**
  String get matrixSalesRateNote;

  /// No description provided for @matrixSettlementFeesTitle.
  ///
  /// In ar, this message translates to:
  /// **'رسوم تسوية المحافظ والاسترداد'**
  String get matrixSettlementFeesTitle;

  /// No description provided for @matrixCurrentSettlementFee.
  ///
  /// In ar, this message translates to:
  /// **'رسم التسوية الحالية'**
  String get matrixCurrentSettlementFee;

  /// No description provided for @matrixFixedInstantFee.
  ///
  /// In ar, this message translates to:
  /// **'رسم ثابت إضافي (تسوية فورية)'**
  String get matrixFixedInstantFee;

  /// No description provided for @matrixCostCoverage.
  ///
  /// In ar, this message translates to:
  /// **'تفصيل التغطية التكلفة:'**
  String get matrixCostCoverage;

  /// No description provided for @matrixDeliveryFleet.
  ///
  /// In ar, this message translates to:
  /// **'أسطول وصلني & الشركاء'**
  String get matrixDeliveryFleet;

  /// No description provided for @matrixCurrentCommission.
  ///
  /// In ar, this message translates to:
  /// **'العمولة المعتمدة حالياً'**
  String get matrixCurrentCommission;

  /// No description provided for @matrixDeliveryPercentage.
  ///
  /// In ar, this message translates to:
  /// **'نسبة مئوية من قيمة التوصيل'**
  String get matrixDeliveryPercentage;

  /// No description provided for @matrixFixedPerShipment.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ مقطوع ثابت لكل شحنة'**
  String get matrixFixedPerShipment;

  /// No description provided for @matrixAccountingReason.
  ///
  /// In ar, this message translates to:
  /// **'المسوغ المحاسبي والإلزامي للرقابة'**
  String get matrixAccountingReason;

  /// No description provided for @matrixCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get matrixCancel;

  /// No description provided for @reconciliationFinanceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الإدارة المالية والحسابات'**
  String get reconciliationFinanceSubtitle;

  /// No description provided for @departmentMerchantsTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة قسم التجار والمتاجر'**
  String get departmentMerchantsTitle;

  /// No description provided for @departmentEscrowTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة المستعمل وعربون «وصلني»'**
  String get departmentEscrowTitle;

  /// No description provided for @departmentServicesTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة طلبات الخدمات والصيانة'**
  String get departmentServicesTitle;

  /// No description provided for @departmentCouriersTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة مناديب التوصيل واللوجستيات'**
  String get departmentCouriersTitle;

  /// No description provided for @departmentActiveStores.
  ///
  /// In ar, this message translates to:
  /// **'المتاجر النشطة'**
  String get departmentActiveStores;

  /// No description provided for @departmentPendingRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات معلقة'**
  String get departmentPendingRequests;

  /// No description provided for @departmentPlatformCommission.
  ///
  /// In ar, this message translates to:
  /// **'عمولة المنصة'**
  String get departmentPlatformCommission;

  /// No description provided for @departmentActiveDeals.
  ///
  /// In ar, this message translates to:
  /// **'صفقات نشطة'**
  String get departmentActiveDeals;

  /// No description provided for @departmentDisputes.
  ///
  /// In ar, this message translates to:
  /// **'نزاعات'**
  String get departmentDisputes;

  /// No description provided for @departmentProtectionFee.
  ///
  /// In ar, this message translates to:
  /// **'رسوم حماية'**
  String get departmentProtectionFee;

  /// No description provided for @departmentServiceProviders.
  ///
  /// In ar, this message translates to:
  /// **'مزودي خدمات'**
  String get departmentServiceProviders;

  /// No description provided for @departmentActiveCouriers.
  ///
  /// In ar, this message translates to:
  /// **'مناديب نشطين'**
  String get departmentActiveCouriers;

  /// No description provided for @departmentPendingEntitlements.
  ///
  /// In ar, this message translates to:
  /// **'مستحقات معلقة'**
  String get departmentPendingEntitlements;

  /// No description provided for @departmentShipmentFee.
  ///
  /// In ar, this message translates to:
  /// **'رسوم شحنة'**
  String get departmentShipmentFee;

  /// No description provided for @departmentAuditedBadge.
  ///
  /// In ar, this message translates to:
  /// **'مدقق ومعتمد'**
  String get departmentAuditedBadge;

  /// No description provided for @departmentTotalBalance.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الرصيد التجميعي المتاح للتسوية والسحب'**
  String get departmentTotalBalance;

  /// No description provided for @departmentWalletSectionTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرقابة وحسابات المتاجر'**
  String get departmentWalletSectionTitle;

  /// No description provided for @departmentSyncStatus.
  ///
  /// In ar, this message translates to:
  /// **'سداد وسريع متزامنان'**
  String get departmentSyncStatus;

  /// No description provided for @departmentGovernanceTitle.
  ///
  /// In ar, this message translates to:
  /// **'حوكمة التسويات والضوابط البنكية (CFO)'**
  String get departmentGovernanceTitle;

  /// No description provided for @departmentLastReconciliation.
  ///
  /// In ar, this message translates to:
  /// **'آخر مطابقة بنكية: اليوم 02:45 م'**
  String get departmentLastReconciliation;

  /// No description provided for @departmentAvailableBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد المتاح للسحب'**
  String get departmentAvailableBalance;

  /// No description provided for @departmentUnderReview.
  ///
  /// In ar, this message translates to:
  /// **'تحت التدقيق والتسوية'**
  String get departmentUnderReview;

  /// No description provided for @departmentMonthlySales.
  ///
  /// In ar, this message translates to:
  /// **'المبيعات المكتملة للشهر'**
  String get departmentMonthlySales;

  /// No description provided for @departmentOperationsUnit.
  ///
  /// In ar, this message translates to:
  /// **'عملية'**
  String get departmentOperationsUnit;

  /// No description provided for @departmentViewHistory.
  ///
  /// In ar, this message translates to:
  /// **'عرض سجل العمليات'**
  String get departmentViewHistory;

  /// No description provided for @departmentInstantSettlement.
  ///
  /// In ar, this message translates to:
  /// **'تسوية سريعة'**
  String get departmentInstantSettlement;

  /// No description provided for @departmentScheduledPayment.
  ///
  /// In ar, this message translates to:
  /// **'دفعة بنكية مجدولة'**
  String get departmentScheduledPayment;

  /// No description provided for @departmentUnderInspection.
  ///
  /// In ar, this message translates to:
  /// **'قيد المعاينة'**
  String get departmentUnderInspection;

  /// No description provided for @departmentInShipping.
  ///
  /// In ar, this message translates to:
  /// **'قيد الشحن'**
  String get departmentInShipping;

  /// No description provided for @departmentWeeklySettlement.
  ///
  /// In ar, this message translates to:
  /// **'تسوية أسبوعية'**
  String get departmentWeeklySettlement;

  /// No description provided for @departmentActiveMatched.
  ///
  /// In ar, this message translates to:
  /// **'نشط ومطابق'**
  String get departmentActiveMatched;

  /// No description provided for @departmentProtectedEscrow.
  ///
  /// In ar, this message translates to:
  /// **'ضمان محفوظ'**
  String get departmentProtectedEscrow;

  /// No description provided for @departmentApprovedProvider.
  ///
  /// In ar, this message translates to:
  /// **'مزود معتمد'**
  String get departmentApprovedProvider;

  /// No description provided for @departmentStrategicPartner.
  ///
  /// In ar, this message translates to:
  /// **'شريك استراتيجي'**
  String get departmentStrategicPartner;

  /// No description provided for @departmentActiveCourier.
  ///
  /// In ar, this message translates to:
  /// **'مندوب نشط'**
  String get departmentActiveCourier;

  /// No description provided for @departmentPendingSuffix.
  ///
  /// In ar, this message translates to:
  /// **'معلق'**
  String get departmentPendingSuffix;

  /// No description provided for @departmentMerchantHorizon.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة الأفق للتقنية والتجارة'**
  String get departmentMerchantHorizon;

  /// No description provided for @departmentStoreElite.
  ///
  /// In ar, this message translates to:
  /// **'متجر الصفوة الذهبي'**
  String get departmentStoreElite;

  /// No description provided for @departmentSparkleJewelry.
  ///
  /// In ar, this message translates to:
  /// **'مجوهرات البريق الراقية'**
  String get departmentSparkleJewelry;

  /// No description provided for @departmentEliteDevices.
  ///
  /// In ar, this message translates to:
  /// **'دار النخبة للأجهزة'**
  String get departmentEliteDevices;

  /// No description provided for @departmentCamryEscrow.
  ///
  /// In ar, this message translates to:
  /// **'سيارة تويوتا كامري 2020'**
  String get departmentCamryEscrow;

  /// No description provided for @departmentIphoneEscrow.
  ///
  /// In ar, this message translates to:
  /// **'آيفون 14 برو ماكس'**
  String get departmentIphoneEscrow;

  /// No description provided for @departmentItqanAc.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة إتقان للتكييف'**
  String get departmentItqanAc;

  /// No description provided for @departmentComprehensiveMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'شركة الصيانة الشاملة'**
  String get departmentComprehensiveMaintenance;

  /// No description provided for @departmentZajelShipping.
  ///
  /// In ar, this message translates to:
  /// **'شركة زاجل للشحن'**
  String get departmentZajelShipping;

  /// No description provided for @departmentWaslniCourier.
  ///
  /// In ar, this message translates to:
  /// **'مندوب أسطول وصلني (محمد أحمد)'**
  String get departmentWaslniCourier;

  /// No description provided for @departmentRecordPrefix.
  ///
  /// In ar, this message translates to:
  /// **'سجل:'**
  String get departmentRecordPrefix;

  /// No description provided for @departmentLicensePrefix.
  ///
  /// In ar, this message translates to:
  /// **'رخصة:'**
  String get departmentLicensePrefix;

  /// No description provided for @departmentEscrowPrefix.
  ///
  /// In ar, this message translates to:
  /// **'عربون تأمين'**
  String get departmentEscrowPrefix;

  /// No description provided for @departmentCourierNumberPrefix.
  ///
  /// In ar, this message translates to:
  /// **'رقم المندوب:'**
  String get departmentCourierNumberPrefix;

  /// No description provided for @departmentAllFilter.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get departmentAllFilter;

  /// No description provided for @departmentHighestBalanceFilter.
  ///
  /// In ar, this message translates to:
  /// **'أعلى رصيد'**
  String get departmentHighestBalanceFilter;

  /// No description provided for @departmentWithdrawalFilter.
  ///
  /// In ar, this message translates to:
  /// **'قيد السحب (8)'**
  String get departmentWithdrawalFilter;

  /// No description provided for @departmentGovernanceNotice.
  ///
  /// In ar, this message translates to:
  /// **'تخضع جميع تحويلات المحفظة لمطابقة يومية تلقائية مع شبكة سريع للمدفوعات الفورية ونظام سداد. ووفقاً لتعليمات البنك المركزي السعودي، تُحجز العمليات المشتبه بها للتدقيق اليدوي من إدارة الامتثال المالي ببرواح المازوري.'**
  String get departmentGovernanceNotice;

  /// No description provided for @matrixScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل مصفوفة نسب الأرباح والرسوم'**
  String get matrixScreenTitle;

  /// No description provided for @matrixDefaultReason.
  ///
  /// In ar, this message translates to:
  /// **'تعديل دوري لمواكبة تحديثات رسوم بوابات الدفع البنكية وتوسعة شبكة التوصيل الميداني'**
  String get matrixDefaultReason;

  /// No description provided for @matrixLastUpdated.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث: 01 يناير 2025 بموجب قرار مجلس الإدارة رقم BOD-44/B'**
  String get matrixLastUpdated;

  /// No description provided for @matrixCfoDescription.
  ///
  /// In ar, this message translates to:
  /// **'تحديد النسب الرسمية لاقتطاعات المنصة التلقائية وتحديث محرك التسويات والرسوم اللوجستية لكافة العمليات المالية المعتمدة.'**
  String get matrixCfoDescription;

  /// No description provided for @matrixAppliedRate.
  ///
  /// In ar, this message translates to:
  /// **'النسبة المطبقة حالياً'**
  String get matrixAppliedRate;

  /// No description provided for @matrixTargetRate.
  ///
  /// In ar, this message translates to:
  /// **'ضبط النسبة المستهدفة'**
  String get matrixTargetRate;

  /// No description provided for @matrixMinimumValue.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى 2.0%'**
  String get matrixMinimumValue;

  /// No description provided for @matrixReferenceValue.
  ///
  /// In ar, this message translates to:
  /// **'المرجعي 5.0%'**
  String get matrixReferenceValue;

  /// No description provided for @matrixMaximumValue.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى 10.0%'**
  String get matrixMaximumValue;

  /// No description provided for @matrixSalesNote.
  ///
  /// In ar, this message translates to:
  /// **'تُطبق على جميع صفقات المتاجر، المنتجات الجديدة، ومبيعات الأجهزة المباشرة دون استثناءات محلية.'**
  String get matrixSalesNote;

  /// No description provided for @matrixCurrentSettlementRate.
  ///
  /// In ar, this message translates to:
  /// **'رسم التسوية الحالية'**
  String get matrixCurrentSettlementRate;

  /// No description provided for @matrixInstantFixedFee.
  ///
  /// In ar, this message translates to:
  /// **'رسم ثابت إضافي (تسوية فورية)'**
  String get matrixInstantFixedFee;

  /// No description provided for @matrixInstantFixedFeeNote.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق رسم مقطوع بقيمة 5.00 ج.م لكل تسوية مستعجلة'**
  String get matrixInstantFixedFeeNote;

  /// No description provided for @matrixCoverageDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفصيل تغطية التكلفة:'**
  String get matrixCoverageDetails;

  /// No description provided for @matrixGatewayCoverage.
  ///
  /// In ar, this message translates to:
  /// **'تغطية مصاريف بوابات الدفع (Mada / Visa / SARIE) بنسبة 0.85%'**
  String get matrixGatewayCoverage;

  /// No description provided for @matrixOperatingMargin.
  ///
  /// In ar, this message translates to:
  /// **'+ هامش تشغيلي وقائي بنسبة 0.40%'**
  String get matrixOperatingMargin;

  /// No description provided for @matrixSettlementNote.
  ///
  /// In ar, this message translates to:
  /// **'تُقتطع تلقائياً عند طلب التسوية السريعة عبر شبكة المدفوعات اللوجستية الفورية واسترداد النزاعات.'**
  String get matrixSettlementNote;

  /// No description provided for @matrixDeliveryTitle.
  ///
  /// In ar, this message translates to:
  /// **'عمولة قطاع التوصيل والنقل والشحن'**
  String get matrixDeliveryTitle;

  /// No description provided for @matrixDeliveryDescription.
  ///
  /// In ar, this message translates to:
  /// **'تُحتسب على كل عملية توصيل ناجحة لمناديب أسطول وصلني والشركات اللوجستية المتعاقدة وتُودع بالمحفظة المركزية.'**
  String get matrixDeliveryDescription;

  /// No description provided for @matrixAuditReasonTitle.
  ///
  /// In ar, this message translates to:
  /// **'المسوغ المحاسبي والإلزامي للرقابة'**
  String get matrixAuditReasonTitle;

  /// No description provided for @matrixAuditReasonPrompt.
  ///
  /// In ar, this message translates to:
  /// **'سبب وموجب تعديل النسب (إلزامي للرقابة والتدقيق المركزي):'**
  String get matrixAuditReasonPrompt;

  /// No description provided for @matrixNotifyUsers.
  ///
  /// In ar, this message translates to:
  /// **'إشعار فوري لجميع التجار والمناديب والمشرفين بتحديث قائمة الأسعار قبل 7 أيام من موعد التطبيق الإلزامي.'**
  String get matrixNotifyUsers;

  /// No description provided for @matrixSaveSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم رفع التعديلات للسجل المالي بنجاح'**
  String get matrixSaveSuccess;

  /// No description provided for @matrixSaveAndSend.
  ///
  /// In ar, this message translates to:
  /// **'حفظ وإرسال مصفوفة النسب رسمياً للإدارة'**
  String get matrixSaveAndSend;

  /// No description provided for @matrixAuditTrailNotice.
  ///
  /// In ar, this message translates to:
  /// **'سيتم قيد هذا الإجراء تلقائياً في سجل التدقيق المالي المركزي SHA-256'**
  String get matrixAuditTrailNotice;

  /// No description provided for @settlementsScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة التسويات'**
  String get settlementsScreenTitle;

  /// No description provided for @settlementsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'برواح المازوري - الإدارة المالية'**
  String get settlementsSubtitle;

  /// No description provided for @settlementBack.
  ///
  /// In ar, this message translates to:
  /// **'العودة'**
  String get settlementBack;

  /// No description provided for @settlementsAuthority.
  ///
  /// In ar, this message translates to:
  /// **'صلاحيات المدير المالي التنفيذي'**
  String get settlementsAuthority;

  /// No description provided for @settlementsPageTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المحافظ الإلكترونية والتسويات'**
  String get settlementsPageTitle;

  /// No description provided for @settlementsPageDescription.
  ///
  /// In ar, this message translates to:
  /// **'تنفيذ حركات النقود المالية المصرح بها مع إرفاق السند القانوني ومحضر النزاع المالي المعتمد.'**
  String get settlementsPageDescription;

  /// No description provided for @settlementsEscrowWallet.
  ///
  /// In ar, this message translates to:
  /// **'محفظة الضمان (Escrow)'**
  String get settlementsEscrowWallet;

  /// No description provided for @settlementsReservedOrders.
  ///
  /// In ar, this message translates to:
  /// **'محجوز لأوامر نشطة'**
  String get settlementsReservedOrders;

  /// No description provided for @settlementsPendingBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيد التسويات المعلقة'**
  String get settlementsPendingBalance;

  /// No description provided for @settlementsReadyRefund.
  ///
  /// In ar, this message translates to:
  /// **'طلب استرداد جاهز للإقفال'**
  String get settlementsReadyRefund;

  /// No description provided for @settlementSheetTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة طلب تسوية'**
  String get settlementSheetTitle;

  /// No description provided for @settlementOffsetMode.
  ///
  /// In ar, this message translates to:
  /// **'مقاصة الرصيد'**
  String get settlementOffsetMode;

  /// No description provided for @settlementRefundMode.
  ///
  /// In ar, this message translates to:
  /// **'استرداد'**
  String get settlementRefundMode;

  /// No description provided for @settlementTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'نوع التسوية'**
  String get settlementTypeLabel;

  /// No description provided for @settlementTypeInstant.
  ///
  /// In ar, this message translates to:
  /// **'التسوية الفورية'**
  String get settlementTypeInstant;

  /// No description provided for @settlementBeneficiaryLabel.
  ///
  /// In ar, this message translates to:
  /// **'المستفيد'**
  String get settlementBeneficiaryLabel;

  /// No description provided for @settlementBeneficiaryAudit.
  ///
  /// In ar, this message translates to:
  /// **'التحقق والتدقيق'**
  String get settlementBeneficiaryAudit;

  /// No description provided for @settlementAmountLabel.
  ///
  /// In ar, this message translates to:
  /// **'قيمة التسوية'**
  String get settlementAmountLabel;

  /// No description provided for @settlementReferenceLabel.
  ///
  /// In ar, this message translates to:
  /// **'المرجع'**
  String get settlementReferenceLabel;

  /// No description provided for @settlementNotesLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات التسوية'**
  String get settlementNotesLabel;

  /// No description provided for @settlementNotesHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل تفاصيل طلب التسوية'**
  String get settlementNotesHint;

  /// No description provided for @settlementPaymentDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الدفع'**
  String get settlementPaymentDetailsTitle;

  /// No description provided for @settlementPaymentMethodLabel.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get settlementPaymentMethodLabel;

  /// No description provided for @settlementPaymentBankTransfer.
  ///
  /// In ar, this message translates to:
  /// **'حوالة بنكية'**
  String get settlementPaymentBankTransfer;

  /// No description provided for @settlementDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get settlementDateLabel;

  /// No description provided for @settlementStatusLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get settlementStatusLabel;

  /// No description provided for @settlementStatusUnderReview.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get settlementStatusUnderReview;

  /// No description provided for @settlementSubmit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الطلب'**
  String get settlementSubmit;

  /// No description provided for @settlementSubmitSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب التسوية بنجاح'**
  String get settlementSubmitSuccess;

  /// No description provided for @addNewSettlement.
  ///
  /// In ar, this message translates to:
  /// **'إضافة تسوية جديدة'**
  String get addNewSettlement;

  /// No description provided for @instantRefundSettlement.
  ///
  /// In ar, this message translates to:
  /// **'استرداد / تسوية فورية'**
  String get instantRefundSettlement;

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @filterInReview.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get filterInReview;

  /// No description provided for @filterApproved.
  ///
  /// In ar, this message translates to:
  /// **'معتمدة'**
  String get filterApproved;

  /// No description provided for @filterDisputed.
  ///
  /// In ar, this message translates to:
  /// **'قيد نزاع'**
  String get filterDisputed;

  /// No description provided for @pendingSettlementRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات التسوية المعلقة'**
  String get pendingSettlementRequests;

  /// No description provided for @settlementRequestOne.
  ///
  /// In ar, this message translates to:
  /// **'طلب'**
  String get settlementRequestOne;

  /// No description provided for @settlementVerifiedBank.
  ///
  /// In ar, this message translates to:
  /// **'حساب بنكي موثق'**
  String get settlementVerifiedBank;

  /// No description provided for @settlementMaintenanceDispute.
  ///
  /// In ar, this message translates to:
  /// **'نزاع صيانة'**
  String get settlementMaintenanceDispute;

  /// No description provided for @settlementFullRefund.
  ///
  /// In ar, this message translates to:
  /// **'استرداد مالي كامل'**
  String get settlementFullRefund;

  /// No description provided for @settlementAge35Minutes.
  ///
  /// In ar, this message translates to:
  /// **'منذ 35 دقيقة'**
  String get settlementAge35Minutes;

  /// No description provided for @settlementApprovedPartner.
  ///
  /// In ar, this message translates to:
  /// **'شريك معتمد - سجل تجاري'**
  String get settlementApprovedPartner;

  /// No description provided for @settlementCommissionCorrection.
  ///
  /// In ar, this message translates to:
  /// **'تصحيح عمولة'**
  String get settlementCommissionCorrection;

  /// No description provided for @settlementCommissionSettlement.
  ///
  /// In ar, this message translates to:
  /// **'تسوية عمولة'**
  String get settlementCommissionSettlement;

  /// No description provided for @settlementAgeTwoHours.
  ///
  /// In ar, this message translates to:
  /// **'منذ ساعتين'**
  String get settlementAgeTwoHours;

  /// No description provided for @settlementIndependentProvider.
  ///
  /// In ar, this message translates to:
  /// **'مزود خدمة مستقل'**
  String get settlementIndependentProvider;

  /// No description provided for @settlementMediationDelivery.
  ///
  /// In ar, this message translates to:
  /// **'تسليم وساطة'**
  String get settlementMediationDelivery;

  /// No description provided for @settlementPenaltyDeduction.
  ///
  /// In ar, this message translates to:
  /// **'خصم جزائي'**
  String get settlementPenaltyDeduction;

  /// No description provided for @settlementAgeToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم 08:30 ص'**
  String get settlementAgeToday;

  /// No description provided for @recentSettlementsTitle.
  ///
  /// In ar, this message translates to:
  /// **'آخر التسويات المنفذة حديثاً'**
  String get recentSettlementsTitle;

  /// No description provided for @bankRefund.
  ///
  /// In ar, this message translates to:
  /// **'استرداد بنكي'**
  String get bankRefund;

  /// No description provided for @settlementCustomerBank.
  ///
  /// In ar, this message translates to:
  /// **'العميل #USR-8810 - بنك البلاد'**
  String get settlementCustomerBank;

  /// No description provided for @settlementToday1130.
  ///
  /// In ar, this message translates to:
  /// **'اليوم 11:30 ص'**
  String get settlementToday1130;

  /// No description provided for @compensationSettlement.
  ///
  /// In ar, this message translates to:
  /// **'تسوية تعويضية'**
  String get compensationSettlement;

  /// No description provided for @settlementProviderCorrection.
  ///
  /// In ar, this message translates to:
  /// **'مزود الخدمة - تصحيح عمولة'**
  String get settlementProviderCorrection;

  /// No description provided for @settlementYesterday0915.
  ///
  /// In ar, this message translates to:
  /// **'أمس 09:15 م'**
  String get settlementYesterday0915;

  /// No description provided for @viewLabel.
  ///
  /// In ar, this message translates to:
  /// **'عرض'**
  String get viewLabel;

  /// No description provided for @viewAllLabel.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAllLabel;

  /// No description provided for @createSettlementToast.
  ///
  /// In ar, this message translates to:
  /// **'إضافة تسوية جديدة'**
  String get createSettlementToast;

  /// No description provided for @frozenScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'إظهار الطلبات المعلقة والمجمدة'**
  String get frozenScreenTitle;

  /// No description provided for @frozenTotalTitle.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المبالغ والعمليات المجمدة احترازياً'**
  String get frozenTotalTitle;

  /// No description provided for @frozenRequestCount.
  ///
  /// In ar, this message translates to:
  /// **'طلبات مجمدة'**
  String get frozenRequestCount;

  /// No description provided for @frozenProtocol.
  ///
  /// In ar, this message translates to:
  /// **'بروتوكول المادة 18 مكافحة الاحتيال'**
  String get frozenProtocol;

  /// No description provided for @frozenAllFilter.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get frozenAllFilter;

  /// No description provided for @frozenMerchantsFilter.
  ///
  /// In ar, this message translates to:
  /// **'تجار ومتاجر'**
  String get frozenMerchantsFilter;

  /// No description provided for @frozenProvidersFilter.
  ///
  /// In ar, this message translates to:
  /// **'مقدمو خدمات'**
  String get frozenProvidersFilter;

  /// No description provided for @frozenSupervisorsFilter.
  ///
  /// In ar, this message translates to:
  /// **'المشرفون'**
  String get frozenSupervisorsFilter;

  /// No description provided for @frozenCouriersFilter.
  ///
  /// In ar, this message translates to:
  /// **'المناديب'**
  String get frozenCouriersFilter;

  /// No description provided for @frozenUsersFilter.
  ///
  /// In ar, this message translates to:
  /// **'المستخدمون'**
  String get frozenUsersFilter;

  /// No description provided for @frozenAdsFilter.
  ///
  /// In ar, this message translates to:
  /// **'الإعلانات'**
  String get frozenAdsFilter;

  /// No description provided for @frozenExport.
  ///
  /// In ar, this message translates to:
  /// **'تصدير بيان الأموال المجمدة (PDF / Excel)'**
  String get frozenExport;

  /// No description provided for @frozenRefresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث حالة الحركات ومزامنة الرقابة اللحظية'**
  String get frozenRefresh;

  /// No description provided for @frozenRequestOneName.
  ///
  /// In ar, this message translates to:
  /// **'تاجر مستلزمات حاسب'**
  String get frozenRequestOneName;

  /// No description provided for @frozenRequestOneSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب سحب أرباح مالي دوري'**
  String get frozenRequestOneSubtitle;

  /// No description provided for @frozenMerchantType.
  ///
  /// In ar, this message translates to:
  /// **'تجار ومتاجر'**
  String get frozenMerchantType;

  /// No description provided for @frozenPrecautionaryStatus.
  ///
  /// In ar, this message translates to:
  /// **'مجمد احترازياً'**
  String get frozenPrecautionaryStatus;

  /// No description provided for @frozenRequestOneReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب التجميد: بلاغ نزاع مفتوح #CMP-1042 مع شبهة تلاعب في عروض ترويجية.'**
  String get frozenRequestOneReason;

  /// No description provided for @frozenSupervisorSaad.
  ///
  /// In ar, this message translates to:
  /// **'أ. سعد العتيبي'**
  String get frozenSupervisorSaad;

  /// No description provided for @frozenTodayFourHours.
  ///
  /// In ar, this message translates to:
  /// **'اليوم • منذ 4 ساعات'**
  String get frozenTodayFourHours;

  /// No description provided for @frozenRestoreAndRelease.
  ///
  /// In ar, this message translates to:
  /// **'إعادة العمل وفك التجميد للصرف'**
  String get frozenRestoreAndRelease;

  /// No description provided for @frozenRejectAndForfeit.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الرفض والمصادرة'**
  String get frozenRejectAndForfeit;

  /// No description provided for @frozenRequestTwoName.
  ///
  /// In ar, this message translates to:
  /// **'ورشة الإتقان للكهرباء'**
  String get frozenRequestTwoName;

  /// No description provided for @frozenAnnualMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'مستحقات عقود صيانة سنوية'**
  String get frozenAnnualMaintenance;

  /// No description provided for @frozenProviderType.
  ///
  /// In ar, this message translates to:
  /// **'مقدمو خدمات'**
  String get frozenProviderType;

  /// No description provided for @frozenRequestTwoReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب التجميد: شكوى عدم اكتمال الصيانة المنزلية'**
  String get frozenRequestTwoReason;

  /// No description provided for @frozenSupervisorAhmed.
  ///
  /// In ar, this message translates to:
  /// **'أ. أحمد حسان'**
  String get frozenSupervisorAhmed;

  /// No description provided for @frozenYesterdayJanuary.
  ///
  /// In ar, this message translates to:
  /// **'أمس • 27 يناير'**
  String get frozenYesterdayJanuary;

  /// No description provided for @frozenPartialFullRelease.
  ///
  /// In ar, this message translates to:
  /// **'فك التجميد الجزئي / الكامل'**
  String get frozenPartialFullRelease;

  /// No description provided for @frozenCustomerRefund.
  ///
  /// In ar, this message translates to:
  /// **'تسوية استرداد للعميل'**
  String get frozenCustomerRefund;

  /// No description provided for @frozenRequestThreeName.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة الأفق للتجارة'**
  String get frozenRequestThreeName;

  /// No description provided for @frozenFastTransferPending.
  ///
  /// In ar, this message translates to:
  /// **'حوالة بنكية سريعة (SARIE) معلقة'**
  String get frozenFastTransferPending;

  /// No description provided for @frozenIbanMismatch.
  ///
  /// In ar, this message translates to:
  /// **'تعارض آيبان'**
  String get frozenIbanMismatch;

  /// No description provided for @frozenRequestThreeReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب التجميد: فشل التحقق الآلي من تطابق اسم المستفيد مع السجل التجاري في البنك المركزي السعودي.'**
  String get frozenRequestThreeReason;

  /// No description provided for @frozenJanuary25.
  ///
  /// In ar, this message translates to:
  /// **'25 يناير 2025'**
  String get frozenJanuary25;

  /// No description provided for @frozenRecheckTransfer.
  ///
  /// In ar, this message translates to:
  /// **'إعادة التحقق وتنشيط الحوالة'**
  String get frozenRecheckTransfer;

  /// No description provided for @frozenRequestIbanCertificate.
  ///
  /// In ar, this message translates to:
  /// **'طلب شهادة آيبان جديدة مختومة من البنك'**
  String get frozenRequestIbanCertificate;

  /// No description provided for @frozenPendingTransferAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المعلق للحوالة:'**
  String get frozenPendingTransferAmount;

  /// No description provided for @frozenHeldAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المحتجز للتجميد:'**
  String get frozenHeldAmount;

  /// No description provided for @frozenRegisteredIban.
  ///
  /// In ar, this message translates to:
  /// **'الآيبان المسجل:'**
  String get frozenRegisteredIban;

  /// No description provided for @frozenGrossTransaction.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المعاملة:'**
  String get frozenGrossTransaction;

  /// No description provided for @frozenAccountNameMismatch.
  ///
  /// In ar, this message translates to:
  /// **'عدم تطابق اسم الحساب'**
  String get frozenAccountNameMismatch;

  /// No description provided for @frozenPlatformFeeDeduction.
  ///
  /// In ar, this message translates to:
  /// **'خصم عمولة المنصة:'**
  String get frozenPlatformFeeDeduction;

  /// No description provided for @frozenSupervisorLabel.
  ///
  /// In ar, this message translates to:
  /// **'مشرف:'**
  String get frozenSupervisorLabel;

  /// No description provided for @frozenThawSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم فك التجميد ونقل الطلب لقائمة المراجعة'**
  String get frozenThawSuccess;

  /// No description provided for @transactionHistoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل العمليات'**
  String get transactionHistoryTitle;

  /// No description provided for @transactionFinancialSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'برواح المازوري - الإدارة المالية'**
  String get transactionFinancialSubtitle;

  /// No description provided for @transactionSupervisedBy.
  ///
  /// In ar, this message translates to:
  /// **'تحت إشراف: أ. سعد العتيبي'**
  String get transactionSupervisedBy;

  /// No description provided for @transactionAvailableBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيد المحفظة المتاح للتسوية'**
  String get transactionAvailableBalance;

  /// No description provided for @transactionTotalWithdrawals.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي السحوبات'**
  String get transactionTotalWithdrawals;

  /// No description provided for @transactionTotalDeposits.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الإيداعات'**
  String get transactionTotalDeposits;

  /// No description provided for @transactionApprovedHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل الحركات المصرفية المعتمدة'**
  String get transactionApprovedHistory;

  /// No description provided for @transactionThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'هذا الشهر (يناير 2025)'**
  String get transactionThisMonth;

  /// No description provided for @transactionAllFilter.
  ///
  /// In ar, this message translates to:
  /// **'الكل (6)'**
  String get transactionAllFilter;

  /// No description provided for @transactionDepositsFilter.
  ///
  /// In ar, this message translates to:
  /// **'عمليات الإيداع (+3)'**
  String get transactionDepositsFilter;

  /// No description provided for @transactionWithdrawalsFilter.
  ///
  /// In ar, this message translates to:
  /// **'عمليات السحب (-3)'**
  String get transactionWithdrawalsFilter;

  /// No description provided for @transactionTodayGroup.
  ///
  /// In ar, this message translates to:
  /// **'اليوم • 28 يناير 2025'**
  String get transactionTodayGroup;

  /// No description provided for @transactionTwoOperations.
  ///
  /// In ar, this message translates to:
  /// **'عمليتان'**
  String get transactionTwoOperations;

  /// No description provided for @transactionDepositSales.
  ///
  /// In ar, this message translates to:
  /// **'إيداع مبيعات نقدية - متجر إلكتروني'**
  String get transactionDepositSales;

  /// No description provided for @transactionNationalGateway.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة مدى • بوابة الدفع الوطنية'**
  String get transactionNationalGateway;

  /// No description provided for @transactionSuccess.
  ///
  /// In ar, this message translates to:
  /// **'ناجح ومكتمل'**
  String get transactionSuccess;

  /// No description provided for @transactionTimeTodayDeposit.
  ///
  /// In ar, this message translates to:
  /// **'02:45 م'**
  String get transactionTimeTodayDeposit;

  /// No description provided for @transactionProfitWithdrawal.
  ///
  /// In ar, this message translates to:
  /// **'سحب أرباح للبنك - مصرف الراجحي'**
  String get transactionProfitWithdrawal;

  /// No description provided for @transactionFastNetwork.
  ///
  /// In ar, this message translates to:
  /// **'آيبان: SA44****5521 • سريع SARIE'**
  String get transactionFastNetwork;

  /// No description provided for @transactionApproved.
  ///
  /// In ar, this message translates to:
  /// **'تحويل معتمد'**
  String get transactionApproved;

  /// No description provided for @transactionTimeTodayWithdrawal.
  ///
  /// In ar, this message translates to:
  /// **'11:15 ص'**
  String get transactionTimeTodayWithdrawal;

  /// No description provided for @transactionYesterdayGroup.
  ///
  /// In ar, this message translates to:
  /// **'أمس • 27 يناير 2025'**
  String get transactionYesterdayGroup;

  /// No description provided for @transactionWaslniDeposit.
  ///
  /// In ar, this message translates to:
  /// **'إيداع طلبات وصلني'**
  String get transactionWaslniDeposit;

  /// No description provided for @transactionAutomatedSettlement.
  ///
  /// In ar, this message translates to:
  /// **'تسوية لوجستية آلية متوافقة'**
  String get transactionAutomatedSettlement;

  /// No description provided for @transactionCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get transactionCompleted;

  /// No description provided for @transactionTimeYesterdayDeposit.
  ///
  /// In ar, this message translates to:
  /// **'06:30 م'**
  String get transactionTimeYesterdayDeposit;

  /// No description provided for @transactionSnbWithdrawal.
  ///
  /// In ar, this message translates to:
  /// **'سحب أرباح - البنك الأهلي'**
  String get transactionSnbWithdrawal;

  /// No description provided for @transactionCorporateVerification.
  ///
  /// In ar, this message translates to:
  /// **'آيبان: SA12****8894 • توثيق مؤسسي'**
  String get transactionCorporateVerification;

  /// No description provided for @transactionCertified.
  ///
  /// In ar, this message translates to:
  /// **'مصدق رقابياً'**
  String get transactionCertified;

  /// No description provided for @transactionTimeYesterdayWithdrawal.
  ///
  /// In ar, this message translates to:
  /// **'09:20 ص'**
  String get transactionTimeYesterdayWithdrawal;

  /// No description provided for @transactionLastWeekGroup.
  ///
  /// In ar, this message translates to:
  /// **'الأسبوع الماضي • 23 يناير 2025'**
  String get transactionLastWeekGroup;

  /// No description provided for @transactionMerchantDisputeDeposit.
  ///
  /// In ar, this message translates to:
  /// **'إيداع تسوية نزاع لصالح التاجر...'**
  String get transactionMerchantDisputeDeposit;

  /// No description provided for @transactionArbitrationDecision.
  ///
  /// In ar, this message translates to:
  /// **'قرار تحكيمي منصة المدفوعات #ARB-209'**
  String get transactionArbitrationDecision;

  /// No description provided for @transactionEffectiveSettlement.
  ///
  /// In ar, this message translates to:
  /// **'تسوية نافذة'**
  String get transactionEffectiveSettlement;

  /// No description provided for @transactionTimeLastWeekDeposit.
  ///
  /// In ar, this message translates to:
  /// **'04:10 م'**
  String get transactionTimeLastWeekDeposit;

  /// No description provided for @transactionWithdrawalReview.
  ///
  /// In ar, this message translates to:
  /// **'طلب سحب أرباح قيد المراجعة الفورية...'**
  String get transactionWithdrawalReview;

  /// No description provided for @transactionAmlReview.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة مطابقة الامتثال المالي (AML)'**
  String get transactionAmlReview;

  /// No description provided for @transactionBankAudit.
  ///
  /// In ar, this message translates to:
  /// **'قيد التدقيق البنكي'**
  String get transactionBankAudit;

  /// No description provided for @transactionTimeLastWeekWithdrawal.
  ///
  /// In ar, this message translates to:
  /// **'01:15 م'**
  String get transactionTimeLastWeekWithdrawal;

  /// No description provided for @transactionHeldBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد المحجوز:'**
  String get transactionHeldBalance;

  /// No description provided for @transactionBalanceAfter.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد بعد الحركة:'**
  String get transactionBalanceAfter;

  /// No description provided for @transactionDownloadStatement.
  ///
  /// In ar, this message translates to:
  /// **'تحميل كشف الحساب المعتمد (PDF)'**
  String get transactionDownloadStatement;

  /// No description provided for @totalRequiredAmount.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي السعر المطلوب'**
  String get totalRequiredAmount;

  /// No description provided for @goldenAnnualPackage.
  ///
  /// In ar, this message translates to:
  /// **'الباقة الذهبية السنوية'**
  String get goldenAnnualPackage;

  /// No description provided for @proServiceProvider.
  ///
  /// In ar, this message translates to:
  /// **'مزود خدمة احترافي'**
  String get proServiceProvider;

  /// No description provided for @vipAnnualPackage.
  ///
  /// In ar, this message translates to:
  /// **'باقة VIP السنوية'**
  String get vipAnnualPackage;

  /// No description provided for @unlimitedDeliveryPackage.
  ///
  /// In ar, this message translates to:
  /// **'باقة التوصيل اللامحدود'**
  String get unlimitedDeliveryPackage;

  /// No description provided for @featuredWeekPackage.
  ///
  /// In ar, this message translates to:
  /// **'إعلان مميز (أسبوع واحد)'**
  String get featuredWeekPackage;

  /// No description provided for @directBankTransferSadad.
  ///
  /// In ar, this message translates to:
  /// **'تحويل بنكي مباشر (سداد / الراجحي)'**
  String get directBankTransferSadad;

  /// No description provided for @directDebitEscrow.
  ///
  /// In ar, this message translates to:
  /// **'خصم مباشر من المحفظة الضامنة (Escrow)'**
  String get directDebitEscrow;

  /// No description provided for @creditCardMada.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة ائتمانية (مدى)'**
  String get creditCardMada;

  /// No description provided for @walletDeduction.
  ///
  /// In ar, this message translates to:
  /// **'خصم من المحفظة'**
  String get walletDeduction;

  /// No description provided for @directBankTransferSnb.
  ///
  /// In ar, this message translates to:
  /// **'تحويل بنكي مباشر (الأهلي)'**
  String get directBankTransferSnb;

  /// No description provided for @availableBalanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'رصيد متاح'**
  String get availableBalanceLabel;

  /// No description provided for @featuredMerchantSubscription.
  ///
  /// In ar, this message translates to:
  /// **'اشتراك تاجر مميز'**
  String get featuredMerchantSubscription;

  /// No description provided for @premiumUser.
  ///
  /// In ar, this message translates to:
  /// **'مستخدم مميز'**
  String get premiumUser;

  /// No description provided for @deliveryCourier.
  ///
  /// In ar, this message translates to:
  /// **'مندوب توصيل'**
  String get deliveryCourier;

  /// No description provided for @commercialAds.
  ///
  /// In ar, this message translates to:
  /// **'إعلانات تجارية'**
  String get commercialAds;

  /// No description provided for @eliteElectronicsStore.
  ///
  /// In ar, this message translates to:
  /// **'متجر النخبة للإلكترونيات'**
  String get eliteElectronicsStore;

  /// No description provided for @maintenanceWorkshop.
  ///
  /// In ar, this message translates to:
  /// **'ورشة الصيانة المتكاملة...'**
  String get maintenanceWorkshop;

  /// No description provided for @vipUserUpgrade.
  ///
  /// In ar, this message translates to:
  /// **'ترقية مستخدم VIP'**
  String get vipUserUpgrade;

  /// No description provided for @fastCourierPackage.
  ///
  /// In ar, this message translates to:
  /// **'باقة المندوب السريع'**
  String get fastCourierPackage;

  /// No description provided for @mainBannerAd.
  ///
  /// In ar, this message translates to:
  /// **'إعلان بانر رئيسي'**
  String get mainBannerAd;

  /// No description provided for @alRajhiBankName.
  ///
  /// In ar, this message translates to:
  /// **'مصرف الراجحي'**
  String get alRajhiBankName;

  /// No description provided for @snbBankName.
  ///
  /// In ar, this message translates to:
  /// **'البنك الأهلي السعودي (SNB)'**
  String get snbBankName;

  /// No description provided for @riyadBankName.
  ///
  /// In ar, this message translates to:
  /// **'بنك الرياض'**
  String get riyadBankName;

  /// No description provided for @madaGatewayName.
  ///
  /// In ar, this message translates to:
  /// **'بوابة سداد و مدى (Mada Gateway)'**
  String get madaGatewayName;

  /// No description provided for @stcPayWalletName.
  ///
  /// In ar, this message translates to:
  /// **'محفظة STC Pay المركزية'**
  String get stcPayWalletName;

  /// No description provided for @operatingAccountType.
  ///
  /// In ar, this message translates to:
  /// **'حساب تشغيلي'**
  String get operatingAccountType;

  /// No description provided for @escrowAccountType.
  ///
  /// In ar, this message translates to:
  /// **'حساب ضمان Escrow'**
  String get escrowAccountType;

  /// No description provided for @electronicPaymentGatewayType.
  ///
  /// In ar, this message translates to:
  /// **'بوابة دفع إلكتروني'**
  String get electronicPaymentGatewayType;

  /// No description provided for @digitalWalletType.
  ///
  /// In ar, this message translates to:
  /// **'محفظة رقمية'**
  String get digitalWalletType;

  /// No description provided for @reconciliationNewCommercialAccountRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب ربط وتوثيق حساب تجاري جديد'**
  String get reconciliationNewCommercialAccountRequest;

  /// No description provided for @reconciliationSupplierAccountRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب ربط حساب مورد معتمد'**
  String get reconciliationSupplierAccountRequest;

  /// No description provided for @reconciliationFreelanceProviderRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب ربط حساب مزود خدمة مستقل'**
  String get reconciliationFreelanceProviderRequest;

  /// No description provided for @reconciliationMatchDescription100.
  ///
  /// In ar, this message translates to:
  /// **'تطابق الاسم التجاري والبنكي موثق بنسبة 100%'**
  String get reconciliationMatchDescription100;

  /// No description provided for @reconciliationMatchDescription96.
  ///
  /// In ar, this message translates to:
  /// **'اختلاف طفيف في اللواحق القانونية للاسم التجاري'**
  String get reconciliationMatchDescription96;

  /// No description provided for @reconciliationMatchDescription89.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة فردية تتطلب شهادة آيبان حديثة مختومة'**
  String get reconciliationMatchDescription89;

  /// No description provided for @reconciliationWarning96.
  ///
  /// In ar, this message translates to:
  /// **'تم رصد اختلاف بين لاحقة السجل والحساب البنكي'**
  String get reconciliationWarning96;

  /// No description provided for @reconciliationWarning89.
  ///
  /// In ar, this message translates to:
  /// **'شهادة الآيبان المرفقة تعود لأكثر من 6 أشهر'**
  String get reconciliationWarning89;

  /// No description provided for @reconciliationCommercialName1.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة التجارة المتقدمة المحدودة'**
  String get reconciliationCommercialName1;

  /// No description provided for @reconciliationBeneficiaryName1.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة التجارة المتقدمة للخدمات والتوكيلات'**
  String get reconciliationBeneficiaryName1;

  /// No description provided for @reconciliationCommercialName2.
  ///
  /// In ar, this message translates to:
  /// **'شركة مدار الرواد للمقاولات العامة'**
  String get reconciliationCommercialName2;

  /// No description provided for @reconciliationBeneficiaryName2.
  ///
  /// In ar, this message translates to:
  /// **'شركة مدار الرواد للتجارة والمقاولات ش.ش.و'**
  String get reconciliationBeneficiaryName2;

  /// No description provided for @reconciliationCommercialName3.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة القمة الرقمية لتقنية المعلومات'**
  String get reconciliationCommercialName3;

  /// No description provided for @reconciliationBeneficiaryName3.
  ///
  /// In ar, this message translates to:
  /// **'فهد سليمان عبد الله العتيبي'**
  String get reconciliationBeneficiaryName3;

  /// No description provided for @reconciliationHijriSuffix.
  ///
  /// In ar, this message translates to:
  /// **'هـ'**
  String get reconciliationHijriSuffix;

  /// No description provided for @reconciliationFreezeRequest.
  ///
  /// In ar, this message translates to:
  /// **'تجميد الطلب'**
  String get reconciliationFreezeRequest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
