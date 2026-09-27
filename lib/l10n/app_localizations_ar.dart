// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'برواح المازوري';

  @override
  String get appSubtitle => 'نظام الإدارة والإشراف الميداني';

  @override
  String get secureLoginPortal => 'بوابة تسجيل دخول آمنة ومشفّرة';

  @override
  String get workEmail => 'البريد الإلكتروني الوظيفي';

  @override
  String get password => 'كلمة المرور';

  @override
  String get roleAccessNotice =>
      'يتم تحديد واجهة العمل وصلاحيات النظام تلقائياً حسب الرتبة الإشرافية فور التحقق.';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get requestAccessReset => 'طلب استعادة الوصول عبر المسؤول التقني';

  @override
  String get restrictedAccessFooter => 'هذا التطبيق مخصص للإدارة والمشرفين فقط';

  @override
  String get copyrightNotice =>
      'الإصدار 3.4.0 (داخلي) • جميع الحقوق محفوظة لشركة برواح المازوري';

  @override
  String get certifiedFinancialAuditor => 'مدقق مالي معتمد';

  @override
  String get liveFinancialSession => 'الجلسة المالية المباشرة';

  @override
  String get financialControlTitle =>
      'الرقابة المالية المركزية - برواح المازوري';

  @override
  String get cfoControlPanelSubtitle =>
      'لوحة تحكم المدير المالي | الوردية المالية النشطة ومطابقة السيولة الحية';

  @override
  String get cfoName => 'أ. سليمان الراجحي';

  @override
  String get cfoRole => 'المدير المالي التنفيذي';

  @override
  String get cfoBadgeCode => '#CF0-01';

  @override
  String get currencySar => 'ر.س';

  @override
  String get totalAggregatedLiquidity =>
      'إجمالي السيولة النقدية والضمانات المجمعة';

  @override
  String get alRajhiMainOperating => 'مصرف الراجحي (الحساب التشغيلي الرئيسي)';

  @override
  String get snbEscrowAccount => 'البنك الأهلي السعودي (حساب الضمان Escrow)';

  @override
  String get pendingMerchantWithdrawalsTitle =>
      'طلبات السحب المعلقة قيد المراجعة للتجار والمستخدمين';

  @override
  String get pendingSupervisorWithdrawalsTitle =>
      'طلبات السحب المعلقة قيد المراجعة للمشرفين و المساعدين';

  @override
  String get auditInvoiceNote => 'تحتاج تدقيق ومطابقة فواتير قبل التوقيع';

  @override
  String get pendingSubscriptionsTitle => 'طلبات الاشتراكات والترقيات المعلقة';

  @override
  String get pendingSubscriptionsSubtitle =>
      'ترقيات باقات المتاجر، اشتراكات الفنيين، وتجديد الاشتراكات السنوية بانتظار الاعتماد المالي';

  @override
  String get reviewSubscriptionsAction => 'مراجعة واعتماد الاشتراكات';

  @override
  String get operationalExpenses => 'المصاريف والمدفوعات التشغيلية';

  @override
  String get monthlyTotalExpenses => 'إجمالي مدفوعات الشهر';

  @override
  String get expenseManagement => 'إدارة الصرف';

  @override
  String get scheduledDisbursementItems => '4 بنود صرف مجدولة';

  @override
  String get recordNewPayment => 'تسجيل بيان دفع جديد / إدارة المصاريف';

  @override
  String get monthlyEarnedCommissions => 'عمولات التطبيق المحصلة هذا الشهر';

  @override
  String get netRegulatoryRevenue => 'صافي الإيراد الرقابي';

  @override
  String get comparedToLastMonth => 'مقارنة بالشهر السابق (249,450 ر.س)';

  @override
  String get balancesUnderRegulatoryAudit => 'أرصدة معلقة تحت التدقيق الرقابي';

  @override
  String get frozenWalletsNote =>
      'محافظ مجمدة احترازياً بطلب الإدارة العامة والمشرفين لوجود بلاغات ونزاعات مفتوحة.';

  @override
  String get operationalDepartmentsWallets =>
      'محافظ الأقسام التشغيلية المباشرة';

  @override
  String get activeSectorsCount => '4 قطاعات حية';

  @override
  String get merchantsWalletTitle => 'محفظة قسم التجار والمتاجر';

  @override
  String get merchantsWalletDesc => 'رصيد دوري متاح للتسوية البنكية والسحب';

  @override
  String get usedAndEscrowWalletTitle => 'محفظة المستعمل وعربون «وصلني»';

  @override
  String get usedAndEscrowWalletDesc => 'حساب ضمان وتأمين صفقات نشط (Escrow)';

  @override
  String get servicesMaintenanceWalletTitle => 'محفظة طلبات الخدمات والصيانة';

  @override
  String get servicesMaintenanceWalletDesc =>
      'مستحقات فنيين معتمدين ومزودي الخدمات';

  @override
  String get deliveryLogisticsWalletTitle => 'محفظة مناديب التوصيل واللوجستيات';

  @override
  String get deliveryLogisticsWalletDesc =>
      'أجور ومستحقات الشحن والتسليم الميداني';

  @override
  String get instantLiquidityAdequacyRatio =>
      'مؤشر كفاية السيولة المصرفية الفورية';

  @override
  String get verySafeAndStable => 'آمن ومستقر جداً';

  @override
  String get dailyWithdrawalCoverageRatio => 'نسبة تغطية طلبات السحب اليومية';

  @override
  String get excessCashCoverage => 'تغطية نقدية فائضة';

  @override
  String get statutoryMinimumRequirement =>
      'الحد الأدنى النظامي المشترط: 85.0%';

  @override
  String get autoBankingSettlement =>
      'التسوية المصرفية التلقائية عبر نظام سداد & SARIE: مكتملة ومطابقة 100%';

  @override
  String get governancePolicyNotice =>
      'وفق لائحة الحوكمة والسياسات المالية: المشرفون الميدانيون ورؤساء الأقسام لا يملكون أي صلاحية لتعديل الأرصدة أو السحب أو التحويل البنكي. تنفيذ وتوثيق العمليات المالية حصري للمدير المالي المعتمد برقم تفويض مصرفي رسمي.';

  @override
  String get governancePolicyClause => 'بند #04 - أ';

  @override
  String get urgentWithdrawalsAction =>
      'مراجعة طلبات السحب العاجلة (14 طلباً جاهزاً للصرف)';

  @override
  String get exportDailyReportPdf =>
      'تصدير تقرير السيولة والمركز المالي اليومي (PDF)';

  @override
  String get liquidityDistributedOnChannels =>
      'السيولة الموزعة على القنوات المصرفية';

  @override
  String get liveBankingReconciliation =>
      'مطابقة بنكية حية (SARI/SARIE نشط 100%)';

  @override
  String get instantSync => 'تزامن فوري';

  @override
  String get mainBanksCount => '3 بنوك رئيسية';

  @override
  String get instaPayCount => '2 إنستاباي InstaPay';

  @override
  String get digitalWalletsCount => '2 محافظ رقمية';

  @override
  String get officialBankAccountsAndIban =>
      'الحسابات البنكية الرسمية وحسابات الآيبان';

  @override
  String get accountsCount => '3 حسابات';

  @override
  String get collectionAndDistribution => 'تحصيل وتوزيع';

  @override
  String get sadadAndSarie => 'سداد & SARIE';

  @override
  String get frozenEscrowAccount => 'حساب مجمد للأمانات';

  @override
  String get emergencyAccount => 'حساب الطوارئ والتسويات البنكية الفورية';

  @override
  String get approvedT0 => 'معتمد T+0';

  @override
  String get dailyLedgerBalance => 'الرصيد الدفتري الحالي';

  @override
  String get ibanNumber => 'رقم الآيبان (IBAN)';

  @override
  String get internalAccountNumber => 'رقم الحساب الداخلي';

  @override
  String get dailyLogLedger => 'سجل الحركات اليومية';

  @override
  String get reviewHeldEscrow => 'مراجعة المحتجزات';

  @override
  String get reconciliationDisputesNote =>
      'خاضع للمطابقة المالية الآلية مع بوابة النزاعات';

  @override
  String get approvedEWallets => 'المحافظ الإلكترونية المعتمدة (E-Wallets)';

  @override
  String get walletsCount => 'محفظتان';

  @override
  String get stcPayEnterprise => 'محفظة stc pay للأعمال (Enterprise)';

  @override
  String get apiConnected => 'مربوطة API';

  @override
  String get actualWalletBalance => 'الرصيد الفعلي في المحفظة';

  @override
  String get withdrawalFeesFree => 'رسوم السحب: مجاناً (اتفاقية شركات)';

  @override
  String get urpayBusiness => 'محفظة urpay (يورباي للأعمال)';

  @override
  String get activeStatus => 'نشطة';

  @override
  String get salarySupportDisbursement => 'صرف رواتب مساندة';

  @override
  String get feedWalletBalance => 'تغذية رصيد المحفظة';

  @override
  String get bankingGovernanceAuthNote =>
      'تعديل أو سحب أو إلغاء ربط أي قناة مصرفية يخضع لمعايير الأمن المالي المشدد، ويتطلب مصادقة ثنائية عبر منصة نفاذ (2FA) ومصادقة التوقيع الإلكتروني المشفر (SHA-256) للمدير المالي التنفيذي.';

  @override
  String get addNewBankAccount => 'إضافة حساب بنكي أو قناة دفع جديدة';

  @override
  String get exportAccountsStatementPdf => 'تصدير بيان الحسابات (PDF)';

  @override
  String get exportDetailedStatementExcel => 'بيان تفصيلي (Excel)';

  @override
  String get bankingAndCashSurveillanceGateway =>
      'بوابة الصرف والرقابة النقدية';

  @override
  String get merchantWithdrawalsHeaderTitle =>
      'طلبات سحب مستحقات التجار و المستخدمين و المناديب';

  @override
  String get merchantWithdrawalsHeaderSubtitle =>
      'قائمة طلبات السحب النقدي المعتمدة للمتاجر والمزودين';

  @override
  String get pendingRequests => 'الطلبات المعلقة';

  @override
  String get underRegulatoryHold => 'تحت الاحتراز';

  @override
  String get regulatoryFreeze => 'تجميد رقابي';

  @override
  String get allTab => 'الكل';

  @override
  String get merchantsTab => 'التجار';

  @override
  String get usersTab => 'المستخدمين';

  @override
  String get verifiedViaNafath => 'معتمد ومطابق عبر النفاذ الموحد';

  @override
  String get underReviewStatus => 'قيد المراجعة';

  @override
  String get grossAmount => 'إجمالي المبلغ المطلوب (Gross):';

  @override
  String get platformFee => 'عمولة المنصة والخدمات';

  @override
  String get netTransferredAmount => 'صافي المبلغ المحول للحساب البنكي:';

  @override
  String get receivingBank => 'المصرف المستلم:';

  @override
  String get submissionDate => 'تاريخ تقديم الطلب:';

  @override
  String get automatedTaxAuditResult =>
      'نتيجة الفحص الآلي للمطابقة الضريبية والمحفظة';

  @override
  String get automatedTaxAuditDetails =>
      'مطابقة الفواتير: 100% | لا توجد بلاغات نزاع أو شكاوى نشطة | رصيد المحفظة مغطى بالكامل ومطابق لصافي التحصيلات التشغيلية.';

  @override
  String get approveAndSendToAdmin => 'اعتماد و ارسال الطلب للادارة';

  @override
  String get freezeRequestTemporarily => 'تجميد مؤقت للطلب';

  @override
  String get readyForInstantDisbursement => 'جاهز للصرف';

  @override
  String get readyForInstantBankingTransfer =>
      'معتمد من النظام - جاهز للإرسال البنكي عبر شبكة سريع';

  @override
  String get approveAndIssueBankOrder => 'اعتماد و اعطاء أمر الصرف البنكي';

  @override
  String get temporarilySuspendedForAudit => 'موقوف مؤقتاً للتحقيق الرقابي';

  @override
  String get grossHeldAmount => 'إجمالي المبلغ المطلوب تحت الحظر (Gross):';

  @override
  String get estimatedPlatformFee => 'عمولة المنصة التقديرية';

  @override
  String get netFrozenAmount => 'الصافي المحتجز للتجميد:';

  @override
  String get auditReferenceCode => 'المرجع الرقابي';

  @override
  String get regulatoryNoticeFromSupervisor =>
      'مذكرة إشعار رقابي من مشرف التجار';

  @override
  String get rejectAndNotifyCustomer => 'الرفض و اشعار العميل';

  @override
  String get freezeRequest => 'تجميد الطلب';

  @override
  String get totalAwaitingApproval => 'إجمالي المبالغ بانتظار الاعتماد';

  @override
  String get remainingForReview => 'المتبقي للمراجعة';

  @override
  String get supervisorWithdrawalsHeaderTitle =>
      'طلبات سحب مستحقات المشرفين ومقدمي الخدمة';

  @override
  String get supervisorWithdrawalsHeaderSubtitle =>
      'قائمة طلبات سحب الأتعاب وعمولات الإشراف وأجور الصيانة المعتمدة للصرف';

  @override
  String get awaitingApprovalTab => 'بانتظار الاعتماد';

  @override
  String get platformSupervisorsTab => 'مشرفو المنصة';

  @override
  String get awaitingDisbursementBadge => 'بانتظار الصرف';

  @override
  String get totalFeesAndCommissions => 'إجمالي أتعاب وعمولات الإشراف:';

  @override
  String get netAmountDueForDisbursement => 'صافي المبلغ المستحق للصرف:';

  @override
  String get disbursementSource => 'مصدر المستحقات';

  @override
  String get complianceAndAuditResult => 'نتيجة الفحص الآلي لمطابقة الأداء';

  @override
  String get verifiedIban => 'آيبان موثق';

  @override
  String get fieldCompletionDetails => 'تفاصيل الإنجاز الميداني';

  @override
  String get temporarilySuspendedBadge => 'موقوف مؤقتاً';

  @override
  String get grossClaimedAmount => 'إجمالي المبلغ المطالب به:';

  @override
  String get deductedPlatformFee => 'عمولة المنصة المستقطعة';

  @override
  String get netHeldAmount => 'صافي المبلغ المحجوز احترازياً:';

  @override
  String get requestStatusProtocol =>
      'حالة الطلب: محجوز بموجب بروتوكول حماية الجودة الإشرافي';

  @override
  String get regulatoryNoticeFromServicesSupervisor =>
      'إشعار رقابي من مشرف الخدمات';

  @override
  String get batchApproval => 'اعتماد جماعي';

  @override
  String get samaComplianceNotice =>
      'التحويلات تخضع لمعايير البنك المركزي السعودي (SAMA)';

  @override
  String get subscriptionOrdersTitle => 'طلبات الاشتراكات';

  @override
  String get financialManagementSubtitle => 'برواح المازوري - الإدارة المالية';

  @override
  String get financialAuditAndLicenses => 'الرقابة المالية والتراخيص';

  @override
  String get subscriptionsAndUpgradesReviewTitle =>
      'طلبات الاشتراكات والترقيات';

  @override
  String get subscriptionsAndUpgradesReviewSubtitle =>
      'مراجعة وتفعيل اشتراكات المتاجر ومزودي الخدمات • برواح المازوري';

  @override
  String get currentSubscriptionsCycleSummary => 'موجز دورة الاشتراكات الجارية';

  @override
  String get updatedNow => 'محدث الآن';

  @override
  String get pendingSubscriptionFees => 'رسوم الاشتراكات المعلقة';

  @override
  String get ordersUnderAudit => 'طلباً قيد التدقيق';

  @override
  String get activatedThisMonth => 'المفعلة هذا الشهر';

  @override
  String get revenueGrowth => '+24% نمو إيرادات';

  @override
  String get expiredAwaitingRenewal => 'منتهية بانتظار التجديد';

  @override
  String get autoCommercialAlert => 'تنبيه تجاري آلي';

  @override
  String get storesAndMerchants => 'المتاجر والتجار';

  @override
  String get serviceProviders => 'مزودو الخدمات';

  @override
  String get awaitingCertificationRequests => 'طلبات بانتظار المصادقة';

  @override
  String get sortByNewest => 'ترتيب حسب الأحدث';

  @override
  String get underMatching => 'قيد المطابقة';

  @override
  String get commercialRegister => 'س.ت:';

  @override
  String get licenseNumber => 'رخصة رقم:';

  @override
  String get premiumMerchantSubscription => 'اشتراك تاجر مميز';

  @override
  String get homeServicesProvider => 'مقدم خدمات منزلية';

  @override
  String get targetedPackageType => 'نوع الباقة المستهدفة';

  @override
  String get annualGoldenPackage => 'الباقة الذهبية السنوية';

  @override
  String get proServiceProviderPackage => 'مزود خدمة احترافي';

  @override
  String get taxInclusive15 => 'شامل الضريبة 15%';

  @override
  String get semiAnnualDuration => 'نصف سنوي (6 أشهر)';

  @override
  String get sufficientWalletBalance => 'رصيد كافٍ في المحفظة';

  @override
  String get paymentMethod => 'طريقة السداد:';

  @override
  String get directBankTransfer =>
      'تحويل بنكي مباشر (سداد / الراجحي - حساب الشركات)';

  @override
  String get directDeductionFromEscrow =>
      'خصم مباشر من رصيد المحفظة الضامنة (Escrow)';

  @override
  String get availableBalance => 'رصيد متاح';

  @override
  String get previewReceiptAndTransferData => 'معاينة الإيصال وبيانات التحويل';

  @override
  String get autoApprovalReady => 'جاهز للاعتماد التلقائي';

  @override
  String get rejectWithReason => 'رفض مع السبب';

  @override
  String get licensesGovernanceTitle => 'حوكمة اعتماد التراخيص والترقيات';

  @override
  String get licensesGovernanceDesc =>
      'تفعيل الباقات يمنح فوراً الصلاحيات التجارية وأولوية الظهور والإعفاءات الرقابية المحددة في النظام المالي لشركة برواح المازوري. تخضع كافة العمليات للتدقيق المستندي والضريبي اللاحق.';

  @override
  String get certifiedAndDocumentedRecord => 'سجل معتمد وموثق';

  @override
  String get pdfReport => 'تقرير PDF';

  @override
  String get exportExcel => 'تصدير Excel';

  @override
  String get navLiquidity => 'السيولة';

  @override
  String get navWithdrawalOrders => 'طلبات السحب';

  @override
  String get navReconciliation => 'المطابقة';

  @override
  String get navSettlements => 'التسويات';

  @override
  String get navCommissions => 'العمولات';

  @override
  String get navAudit => 'التدقيق';

  @override
  String get navHome => 'الرئيسية';
}
