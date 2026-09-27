import '../../domain/entities/subscription_request_entity.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../models/bank_account_model.dart';
import '../models/finance_summary_model.dart';
import 'finance_remote_data_source.dart';

class FinanceMockDataSource implements FinanceRemoteDataSource {
  // القائمة المركزية الموحدة للحسابات البنكية والقنوات الرسمية
  final List<BankAccountModel> _mockBankAccounts = [
    BankAccountModel(
      id: 'acc_01',
      bankName: 'مصرف الراجحي',
      accountRole: 'الحساب التشغيلي الرئيسي للرواتب والموردين',
      accountType: 'حساب تشغيلي',
      iban: 'SA44 8000 0213 6080 1000 9991',
      balance: 3120400.00,
      isVerified: true,
    ),
    BankAccountModel(
      id: 'acc_02',
      bankName: 'البنك الأهلي السعودي (SNB)',
      accountRole: 'حساب الضمان المستقل لعربون «وصلني» والتجار',
      accountType: 'حساب ضمان Escrow',
      iban: 'SA98 1000 0055 4433 2211 0003',
      balance: 1450000.00,
      isVerified: true,
    ),
    BankAccountModel(
      id: 'acc_03',
      bankName: 'بنك الرياض',
      accountRole: 'حساب عمليات الصيانة والتشغيل السريع',
      accountType: 'حساب تشغيلي',
      iban: 'SA12 2000 0001 2345 6789 0002',
      balance: 424800.00,
      isVerified: true,
    ),
    BankAccountModel(
      id: 'acc_04',
      bankName: 'بوابة سداد و مدى (Mada Gateway)',
      accountRole: 'الرصيد المعلق بانتظار التسوية البنكية اليومية',
      accountType: 'بوابة دفع إلكتروني',
      iban: 'Gateway MID: 88401920-SAR',
      balance: 290000.00,
      isVerified: true,
    ),
    BankAccountModel(
      id: 'acc_05',
      bankName: 'محفظة STC Pay المركزية',
      accountRole: 'تحويلات الكاش باك والسحب السريع للفنيين',
      accountType: 'محفظة رقمية',
      iban: 'Enterprise Wallet: 0500011223',
      balance: 100000.00,
      isVerified: true,
    ),
  ];

  @override
  Future<FinanceSummaryModel> getFinanceSummary() async {
    // إرجاع فوري بدون أي تأخير اصطناعي (0 ثانية)
    await Future.delayed(Duration.zero);

    // حساب إجمالي السيولة ديناميكياً بجمع كافة أرصدة الحسابات
    final double calculatedTotalLiquidity = _mockBankAccounts.fold(
      0.0,
          (sum, account) => sum + account.balance,
    );

    final double rajhiBalance = _mockBankAccounts
        .firstWhere(
          (a) => a.bankName.contains('الراجحي'),
      orElse: () => _mockBankAccounts.first,
    )
        .balance;

    final double snbBalance = _mockBankAccounts
        .firstWhere(
          (a) => a.bankName.contains('الأهلي'),
      orElse: () => _mockBankAccounts.first,
    )
        .balance;

    // استدعاء الطلبات الحقيقية من الموك لحساب الأرقام الديناميكية
    final merchantRequests = await getMerchantWithdrawals();
    final supervisorRequests = await getSupervisorWithdrawals();
    final subscriptions = await getSubscriptions();

    final pendingAndFrozenMerchants = merchantRequests.where((req) => req.status == RequestStatus.pending || req.status == RequestStatus.underInvestigation).toList();
    final int merchantCount = pendingAndFrozenMerchants.length;
    final double merchantAmount = pendingAndFrozenMerchants.fold(0.0, (sum, req) => sum + req.netAmount);

    final pendingAndFrozenSupervisors = supervisorRequests.where((req) => req.status == RequestStatus.pending || req.status == RequestStatus.underInvestigation).toList();
    final int supervisorCount = pendingAndFrozenSupervisors.length;
    final double supervisorAmount = pendingAndFrozenSupervisors.fold(0.0, (sum, req) => sum + req.netAmount);

    final pendingSubscriptions = subscriptions.where((req) => req.status == 'قيد المطابقة' || req.status.contains('جاهز')).toList();
    final int subsCount = pendingSubscriptions.length;
    final double subsAmount = pendingSubscriptions.fold(0.0, (sum, req) => sum + req.totalAmount);

    return FinanceSummaryModel(
      totalLiquidity: calculatedTotalLiquidity,
      rajhiAccountBalance: rajhiBalance,
      snbEscrowBalance: snbBalance,
      pendingMerchantWithdrawalsCount: merchantCount,
      pendingMerchantWithdrawalsAmount: merchantAmount,
      pendingSupervisorWithdrawalsCount: supervisorCount,
      pendingSupervisorWithdrawalsAmount: supervisorAmount,
      pendingSubscriptionsCount: subsCount,
      pendingSubscriptionsAmount: subsAmount,
      monthlyExpenses: 84320.00,
      monthlyCommissions: 142650.00,
    );
  }

  @override
  Future<List<BankAccountModel>> getBankAccounts() async {
    // إرجاع الحسابات البنكية فورياً
    await Future.delayed(Duration.zero);
    return _mockBankAccounts;
  }

  @override
  Future<List<WithdrawalRequestEntity>> getMerchantWithdrawals() async {
    await Future.delayed(Duration.zero);
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
        alertNotice: null,
        isInstantTransferReady: false,
      ),
      WithdrawalRequestEntity(
        id: '2',
        requestNumber: 'SRV-201',
        beneficiaryName: 'م. أحمد الخالدي',
        beneficiaryRole: 'فني صيانة معتمد | عمولات منجزة',
        beneficiaryType: BeneficiaryType.serviceProvider,
        grossAmount: 5000.00,
        platformFeePercentage: 4.0,
        platformFeeAmount: 200.00,
        netAmount: 4800.00,
        bankName: 'البنك الأهلي السعودي (SNB)',
        iban: '',
        dateText: '',
        status: RequestStatus.approved, // assuming "جاهز للصرف" maps to a state we can display differently, or we can use isInstantTransferReady
        auditCheckResult: null,
        alertNotice: 'معتمد من النظام - جاهز للإرسال البنكي الفوري عبر شبكة سريع',
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
        bankName: '',
        iban: 'المرجع الرقابي\n#FAR-102',
        dateText: '',
        status: RequestStatus.underInvestigation,
        auditCheckResult: null,
        alertNotice: 'طلب تجميد سحب صادر من مشرف التجار (Finance Action Request #FAR-102) لوجود شبهة تلاعب في عروض ترويجية #CMP-1042 مع عملاء النهائيين بشأن استرداد مبالغ مشتريات ملغاة.',
        isInstantTransferReady: false,
      ),
    ];
  }

  @override
  Future<List<WithdrawalRequestEntity>> getSupervisorWithdrawals() async {
    await Future.delayed(Duration.zero);
    return const [
      WithdrawalRequestEntity(
        id: '1',
        requestNumber: '#409-SUP',
        beneficiaryName: 'أ. سعد العتيبي',
        beneficiaryRole: 'مشرف تجار معتمد',
        beneficiaryType: BeneficiaryType.supervisor,
        grossAmount: 15000.00,
        platformFeePercentage: 0.0,
        platformFeeAmount: 0.0,
        netAmount: 15000.00,
        bankName: 'مصرف الراجحي',
        iban: 'SA42 8000 0412 **** 5521',
        dateText: '',
        status: RequestStatus.pending,
        sourceOfFunds: 'عمولات إشراف واعتماد عقود التجار المنجزة (شهر أكتوبر)',
        auditCheckResult: 'نسبة الامتثال 98.4% | لا توجد بلاغات تظلم معلقة | رصيد المحفظة مغطى بالكامل',
        transferMethod: 'تحويل سريع عبر IBAN بنك الراجحي',
        isInstantTransferReady: false,
      ),
      WithdrawalRequestEntity(
        id: '2',
        requestNumber: '#3042-SRV',
        beneficiaryName: 'مؤسسة التبريد المتقن',
        beneficiaryRole: 'مقدم خدمة معتمد\n(م. خليل إبراهيم)',
        beneficiaryType: BeneficiaryType.serviceProvider,
        grossAmount: 10000.00,
        platformFeePercentage: 12.5,
        platformFeeAmount: 1250.00,
        netAmount: 8750.00,
        bankName: 'البنك الأهلي السعودي (SNB)',
        iban: 'آيبان موثق',
        dateText: '',
        status: RequestStatus.approved,
        sourceOfFunds: 'أجور إنجاز 14 طلب صيانة وتبريد ميدانية معتمدة من العميل والمشرف',
        auditCheckResult: null,
        isInstantTransferReady: true,
      ),
      WithdrawalRequestEntity(
        id: '3',
        requestNumber: '#188-SRV',
        beneficiaryName: 'ورشة الإتقان للكهرباء',
        beneficiaryRole: 'مقدم خدمة صيانة',
        beneficiaryType: BeneficiaryType.serviceProvider,
        grossAmount: 7000.00,
        platformFeePercentage: 11.4,
        platformFeeAmount: 800.00,
        netAmount: 6200.00,
        bankName: 'حالة الطلب: محجوز بموجب بروتوكول حماية الجودة الإشرافي',
        iban: '',
        dateText: '',
        status: RequestStatus.underInvestigation,
        sourceOfFunds: null,
        auditCheckResult: null,
        alertNotice: 'وجود شكوى مفتوحة من عميل (#CMP-1042) لعدم اكتمال أعمال الصيانة بانتظار فحص المشرف وإعادة تقييم الخدمة الميدانية.',
        isInstantTransferReady: false,
      ),
    ];
  }

  @override
  Future<List<SubscriptionRequestEntity>> getSubscriptions() async {
    await Future.delayed(Duration.zero);
    return const [
      SubscriptionRequestEntity(
        id: '1',
        providerName: 'متجر إلكترونيات النخبة',
        registrationNumber: '101099234',
        categoryName: 'اشتراك تاجر مميز',
        targetPackageName: 'الباقة الذهبية السنوية',
        durationText: 'شامل الضريبة 15%', // Use this field for the bottom text under amount
        totalAmount: 4800.00,
        paymentMethod: 'تحويل بنكي مباشر (سداد / الراجحي)',
        status: 'قيد المطابقة',
        type: SubscriptionType.merchant,
      ),
      SubscriptionRequestEntity(
        id: '2',
        providerName: 'ورشة الصيانة الشاملة...',
        registrationNumber: '440219',
        categoryName: 'مقدم خدمات منزلية',
        targetPackageName: 'مزود خدمة احترافي',
        durationText: 'نصف سنوي (6 أشهر)',
        totalAmount: 1850.00,
        paymentMethod: 'خصم مباشر من رصيد المحفظة الضامنة (Escrow)',
        status: 'جاهز للاعتماد التلقائي',
        type: SubscriptionType.serviceProvider,
        availableBalance: 'رصيد متاح 6,400 ر.س',
      ),
    ];
  }

  @override
  Future<void> approveWithdrawal(String requestId) async {}

  @override
  Future<void> freezeWithdrawal(String requestId, String reason) async {}
}