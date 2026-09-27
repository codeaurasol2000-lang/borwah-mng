import 'finance_remote_data_source.dart';
import '../models/bank_account_model.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../domain/entities/finance_summary_entity.dart';
import '../../domain/entities/subscription_request_entity.dart';
import '../../domain/entities/withdrawal_request_entity.dart';

class FinanceMockDataSource implements FinanceRemoteDataSource {
  @override
  Future<FinanceSummaryEntity> getFinanceSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const FinanceSummaryEntity(
      totalLiquidity: 4850200.00,
      rajhiAccountBalance: 3100000.00,
      snbEscrowBalance: 1750200.00,
      pendingMerchantWithdrawalsCount: 38,
      pendingMerchantWithdrawalsAmount: 142500.00,
      pendingSupervisorWithdrawalsCount: 10,
      pendingSupervisorWithdrawalsAmount: 11500.00,
      pendingSubscriptionsCount: 18,
      pendingSubscriptionsAmount: 64200.00,
      operationalExpenses: 58400.00,
      monthlyCommissionEarned: 284900.00,
      frozenWalletsAmount: 25400.00,
      merchantWalletBalance: 2150000.00,
      wasalnyEscrowWalletBalance: 980000.00,
      servicesWalletBalance: 620000.00,
      deliveryWalletBalance: 450000.00,
      instantLiquidityCoverageRatio: 99.8,
    );
  }

  @override
  Future<List<BankAccountModel>> getBankAccounts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      BankAccountModel(
        id: '1',
        title: 'مصرف الراجحي',
        subTitle: 'الحساب التشغيلي الرئيسي للرواتب والعمليات',
        ibanOrNumber: 'SA44 8000 0001 2345 6789 0001',
        currentBalance: 3100000.00,
        type: AccountType.bank,
        status: 'تحصيل وتوزيع',
      ),
      BankAccountModel(
        id: '2',
        title: 'البنك الأهلي السعودي (SNB)',
        subTitle: 'حساب الضمان والأمانات التجاري (Escrow)',
        ibanOrNumber: 'SA03 1000 0002 9988 7766 5544',
        currentBalance: 1750200.00,
        secondaryBalanceNote: 'تأمين العقود وعربون وصلني',
        type: AccountType.bank,
        status: 'حساب مجمد للأمانات',
      ),
      BankAccountModel(
        id: '3',
        title: 'بنك الرياض',
        subTitle: 'حساب الطوارئ والتسويات البنكية الفورية',
        ibanOrNumber: 'SA71 2000 0003 4455 6677 8899',
        currentBalance: 350000.00,
        type: AccountType.bank,
        status: 'معتمد T+0',
      ),
      BankAccountModel(
        id: '4',
        title: 'محفظة stc pay للأعمال (Enterprise)',
        subTitle: 'رقم المحفظة: 0509988112 • كود التاجر: MER-88402',
        ibanOrNumber: '0509988112',
        currentBalance: 120000.00,
        type: AccountType.eWallet,
        status: 'مربوطة API',
      ),
      BankAccountModel(
        id: '5',
        title: 'محفظة urpay (يورباي للأعمال)',
        subTitle: 'قناة بديلة لدفع المستحقات الفورية والعمولات الصغرى',
        ibanOrNumber: 'UR-88390',
        currentBalance: 65000.00,
        type: AccountType.eWallet,
        status: 'صرف رواتب مساندة',
      ),
    ];
  }

  @override
  Future<List<WithdrawalRequestEntity>> getMerchantWithdrawals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      WithdrawalRequestEntity(
        id: '1',
        requestNumber: 'TRD-8821',
        beneficiaryName: 'متجر الأفق للأجهزة الكهربائية',
        beneficiaryRole: 'معتمد ومطابق عبر النفاذ الموحد',
        beneficiaryType: BeneficiaryType.merchant,
        grossAmount: 32500.00,
        platformFeePercentage: 2.5,
        platformFeeAmount: 812.50,
        netAmount: 31687.50,
        bankName: 'مصرف الراجحي',
        iban: 'SA42 8000 0412 **** **** 4910',
        dateText: 'اليوم، 10:45 ص (منذ ساعتين)',
        status: RequestStatus.pending,
        auditCheckResult: 'مطابقة الفواتير: 100% | لا توجد بلاغات نزاع أو شكاوى نشطة | رصيد المحفظة مغطى بالكامل ومطابق لصافي التحصيلات التشغيلية.',
      ),
      WithdrawalRequestEntity(
        id: '2',
        requestNumber: 'SRV-201',
        beneficiaryName: 'م. أحمد الخالدي',
        beneficiaryRole: 'فني صيانة معتمد | عمولات منجزة',
        beneficiaryType: BeneficiaryType.user,
        grossAmount: 5000.00,
        platformFeePercentage: 4.0,
        platformFeeAmount: 200.00,
        netAmount: 4800.00,
        bankName: 'البنك الأهلي السعودي (SNB)',
        iban: 'SA09 1000 0192 **** **** 1029',
        dateText: 'اليوم، 09:15 ص',
        status: RequestStatus.approved,
        isInstantTransferReady: true,
      ),
      WithdrawalRequestEntity(
        id: '3',
        requestNumber: 'TRD-304',
        beneficiaryName: 'تاجر مستلزمات حاسب',
        beneficiaryRole: 'موقوف مؤقتاً للتحقيق الرقابي',
        beneficiaryType: BeneficiaryType.merchant,
        grossAmount: 18900.00,
        platformFeePercentage: 5.0,
        platformFeeAmount: 945.00,
        netAmount: 17955.00,
        bankName: 'مصرف الإنماء',
        iban: 'SA55 0500 0000 **** **** 3311',
        dateText: 'أمس، 04:30 م',
        status: RequestStatus.underInvestigation,
        alertNotice: 'طلب تجميد سحب صادر من مشرف التجار (Finance Action Request #FAR-102) لوجود شبهة تلاعب في عروض ترويجية وبلاغ نزاع مفتوح #CMP-1042 مع عملاء نهائيين بشأن استرداد مبالغ مشتريات ملغاة.',
      ),
    ];
  }

  @override
  Future<List<WithdrawalRequestEntity>> getSupervisorWithdrawals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      WithdrawalRequestEntity(
        id: '101',
        requestNumber: 'SUP-409',
        beneficiaryName: 'أ. سعد العتيبي',
        beneficiaryRole: 'مشرف تجار معتمد',
        beneficiaryType: BeneficiaryType.supervisor,
        grossAmount: 15000.00,
        platformFeePercentage: 0.0,
        platformFeeAmount: 0.0,
        netAmount: 15000.00,
        bankName: 'مصرف الراجحي',
        iban: 'SA42 8000 0412 **** 5521',
        dateText: 'عمولات إشراف واعتماد عقود التجار المنجزة (شهر أكتوبر)',
        status: RequestStatus.pending,
        auditCheckResult: 'نسبة الامتثال 98.4% | لا توجد بلاغات تظلم معلقة | رصيد المحفظة مغطى بالكامل',
      ),
      WithdrawalRequestEntity(
        id: '102',
        requestNumber: 'SRV-3042',
        beneficiaryName: 'مؤسسة التبريد المتقن (م. خليل إبراهيم)',
        beneficiaryRole: 'مقدم خدمة معتمد',
        beneficiaryType: BeneficiaryType.serviceProvider,
        grossAmount: 10000.00,
        platformFeePercentage: 12.5,
        platformFeeAmount: 1250.00,
        netAmount: 8750.00,
        bankName: 'البنك الأهلي السعودي (SNB)',
        iban: 'SA12 1000 0331 **** 8820',
        dateText: 'أجور إنجاز 14 طلب صيانة وتبريد ميدانية معتمدة من العميل والمشرف',
        status: RequestStatus.approved,
        isInstantTransferReady: true,
      ),
      WithdrawalRequestEntity(
        id: '103',
        requestNumber: 'SRV-188',
        beneficiaryName: 'ورشة الإتقان للكهرباء',
        beneficiaryRole: 'مقدم خدمة صيانة',
        beneficiaryType: BeneficiaryType.serviceProvider,
        grossAmount: 7000.00,
        platformFeePercentage: 11.4,
        platformFeeAmount: 800.00,
        netAmount: 6200.00,
        bankName: 'بنك الرياض',
        iban: 'SA77 2000 0019 **** 1204',
        dateText: 'محجوز بموجب بروتوكول حماية الجودة الإشرافي',
        status: RequestStatus.frozen,
        alertNotice: 'وجود شكوى مفتوحة من عميل (#CMP-1042) لعدم اكتمال أعمال الصيانة بانتظار فحص المشرف وإعادة تقييم الخدمة الميدانية.',
      ),
    ];
  }

  @override
  Future<List<SubscriptionRequestEntity>> getSubscriptions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      SubscriptionRequestEntity(
        id: 'sub_1',
        providerName: 'متجر إلكترونيات النخبة',
        registrationNumber: '101099234',
        categoryName: 'اشتراك تاجر مميز',
        targetPackageName: 'الباقة الذهبية السنوية',
        durationText: 'شامل الضريبة 15%',
        totalAmount: 4800.00,
        paymentMethod: 'تحويل بنكي مباشر (سداد / الراجحي - حساب الشركات)',
        status: 'قيد المطابقة',
        type: SubscriptionType.merchant,
      ),
      SubscriptionRequestEntity(
        id: 'sub_2',
        providerName: 'ورشة الصيانة الشاملة...',
        registrationNumber: '440219',
        categoryName: 'مقدم خدمات منزلية',
        targetPackageName: 'مزود خدمة احترافي',
        durationText: 'نصف سنوي (6 أشهر)',
        totalAmount: 1850.00,
        paymentMethod: 'خصم مباشر من رصيد المحفظة الضامنة (Escrow)',
        status: 'جاهز للاعتماد التلقائي',
        type: SubscriptionType.serviceProvider,
      ),
    ];
  }

  @override
  Future<void> approveWithdrawal(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> freezeWithdrawal(String requestId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}