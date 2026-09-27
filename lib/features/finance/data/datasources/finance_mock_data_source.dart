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
    // الناتج المبدئي = 3,120,400 + 1,450,000 + 424,800 + 290,000 + 100,000 = 5,385,200.00
    final double calculatedTotalLiquidity = _mockBankAccounts.fold(
      0.0,
          (sum, account) => sum + account.balance,
    );

    // استخراج أرصدة الحسابات المميزة برمجياً بدلاً من كتابتها يدوياً
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

    return FinanceSummaryModel(
      totalLiquidity: calculatedTotalLiquidity,
      rajhiAccountBalance: rajhiBalance,
      snbEscrowBalance: snbBalance,
      pendingMerchantWithdrawalsCount: 14,
      pendingMerchantWithdrawalsAmount: 84250.00,
      pendingSupervisorWithdrawalsCount: 8,
      pendingSupervisorWithdrawalsAmount: 24600.00,
      pendingSubscriptionsCount: 18,
      pendingSubscriptionsAmount: 36000.00,
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
    return [];
  }

  @override
  Future<List<WithdrawalRequestEntity>> getSupervisorWithdrawals() async {
    return [];
  }

  @override
  Future<List<SubscriptionRequestEntity>> getSubscriptions() async {
    return [];
  }

  @override
  Future<void> approveWithdrawal(String requestId) async {}

  @override
  Future<void> freezeWithdrawal(String requestId, String reason) async {}
}