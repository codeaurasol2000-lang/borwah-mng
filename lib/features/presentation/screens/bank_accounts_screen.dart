import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../finance/domain/entities/bank_account_entity.dart';
import '../../finance/domain/usecases/get_bank_accounts_usecase.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  List<BankAccountEntity> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final result = await sl<GetBankAccountsUseCase>()();
    result.fold(
          (failure) => setState(() => _isLoading = false),
          (data) => setState(() {
        _accounts = data;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalBalance = _accounts.fold(0, (sum, item) => sum + item.currentBalance);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('الحسابات البنكية والمحافظ', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryDark))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة السيولة الموزعة العلوية
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('السيولة الموزعة على القنوات المصرفية', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Row(
                        children: [
                          Text('مطابقة بنكية حية (SARIE)', style: TextStyle(color: AppColors.success, fontSize: 11)),
                          SizedBox(width: 4),
                          CircleAvatar(radius: 3, backgroundColor: AppColors.success),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      CurrencyFormatter.format(totalBalance),
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildChannelPill('3 بنوك رئيسية'),
                      _buildChannelPill('2 إنستاباي InstaPay'),
                      _buildChannelPill('2 محافظ رقمية'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // تبويبات الحسابات
            const Text('الحسابات البنكية الرسمية وحسابات الآيبان', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),

            // قائمة البنوك والمحافظ
            ..._accounts.map((acc) => _buildAccountCard(acc)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelPill(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    );
  }

  Widget _buildAccountCard(BankAccountEntity acc) {
    final bool isWallet = acc.type == AccountType.eWallet;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(acc.status, style: const TextStyle(fontSize: 11, color: AppColors.info, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(acc.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(acc.subTitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: isWallet ? AppColors.purple.withOpacity(0.1) : const Color(0xFFF1F5F9),
                child: Icon(isWallet ? Icons.account_balance_wallet_outlined : Icons.account_balance_outlined,
                    color: isWallet ? AppColors.purple : AppColors.primaryDark),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.format(acc.currentBalance),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
              ),
              const Text('الرصيد الدفتري الحالي', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.copy, size: 15, color: AppColors.textSecondary),
                Text(acc.ibanOrNumber, style: const TextStyle(fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}