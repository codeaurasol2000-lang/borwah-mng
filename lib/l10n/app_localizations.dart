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
  /// **'مقارنة بالشهر السابق (249,450 ر.س)'**
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
  /// **'مقدم خدمات منزلية'**
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
  /// **'رصيد كافٍ في المحفظة'**
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
  /// **'اعتماد صرف تسوية النزاع #CMP-1035 بقيمة 1,200.00 ر.س للعميل د. طارق العمري.'**
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
  /// **'تحويل مستحقات دورية لـ 12 متجر معتمد عبر نظام المدفوعات الفورية بإجمالي 142,500.00 ر.س.'**
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
