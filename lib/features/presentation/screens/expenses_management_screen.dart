import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../controllers/bank_accounts/bank_accounts_cubit.dart';
import '../controllers/bank_accounts/bank_accounts_state.dart';

class ExpensesManagementScreen extends StatelessWidget {
  const ExpensesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankAccountsCubit(getBankAccountsUseCase: sl())..loadBankAccounts(),
      child: const _ExpensesManagementScreenContent(),
    );
  }
}

class _ExpensesManagementScreenContent extends StatefulWidget {
  const _ExpensesManagementScreenContent();

  @override
  State<_ExpensesManagementScreenContent> createState() => _ExpensesManagementScreenState();
}

class _ExpensesManagementScreenState extends State<_ExpensesManagementScreenContent> {
  final TextEditingController _amountController = TextEditingController(text: '14,500.00');
  final TextEditingController _reasonController = TextEditingController();
  String _selectedPaymentMethod = 'rajhi'; // Default selected

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0.5,
          scrolledUnderElevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceLight,
              child: Icon(Icons.person_outline, color: AppColors.primaryDark),
            ),
          ),
          title: const Text(
            'المصاريف والمدفوعات',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: AppColors.textPrimary, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Amount Card
              _buildSectionCard(
                icon: Icons.payments_outlined,
                title: 'المبلغ المطلوب دفعه وصرفه',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('ر.س', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Payment Method Card
              _buildSectionCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'الحساب وقناة الدفع للخصم المباشر',
                child: BlocBuilder<BankAccountsCubit, BankAccountsState>(
                  builder: (context, state) {
                    if (state is BankAccountsLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primaryDark));
                    } else if (state is BankAccountsLoaded) {
                      final accounts = state.accounts;
                      if (accounts.isEmpty) {
                        return const Center(child: Text('لا توجد حسابات متاحة'));
                      }
                      
                      // Select first by default if not set
                      if (!accounts.any((a) => a.id == _selectedPaymentMethod)) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _selectedPaymentMethod = accounts.first.id;
                          });
                        });
                      }

                      return Column(
                        children: accounts.map((account) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _buildPaymentOption(
                              id: account.id,
                              title: account.bankName,
                              subtitle: account.iban,
                              balanceLabel: account.accountType.contains('ضمان') ? 'رصيد حساب الضمان:' : 'الرصيد الدفتري الحالي:',
                              balanceValue: '${CurrencyFormatter.format(account.balance)} ر.س',
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              const SizedBox(height: 16),

              // 3. Document Category Card
              _buildSectionCard(
                icon: Icons.assignment_outlined,
                title: 'تصنيف المصروف والمستندات المؤيدة',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('سبب سحب وصرف المصروف تفصيلياً', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reasonController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'ادخل بيان تفصيلي بالمصروف',
                        hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('مرفق الفاتورة الضريبية والمستند المؤيد', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.attach_file, color: AppColors.info, size: 16),
                          const SizedBox(width: 8),
                          Text('ارفاق صورة المستند ان وجدت', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Governance Alert
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.gavel, color: AppColors.textSecondary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('حوكمة الصرف المالي المشدد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text(
                            'تخضع هذه العملية للرقابة المستندية والمطابقة البنكية الآلية، ويتم توثيق أمر الصرف في سجل التدقيق المالي برقم تتبع مشفر وتتطلب تأكيد التوقيع الرقمي المباشر للمدير المالي (CFO).',
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. Actions
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.fingerprint, size: 18),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم اعتماد أمر الدفع بنجاح')));
                  Navigator.pop(context);
                },
                label: const Text('اعتماد أمر الدفع و ارساله للادارة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  backgroundColor: AppColors.surfaceLight,
                  side: const BorderSide(color: Colors.transparent),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء وتراجع عن الأمر', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.info, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required String balanceLabel,
    required String balanceValue,
  }) {
    bool isSelected = _selectedPaymentMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue.shade200 : Colors.transparent),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? AppColors.textPrimary : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary), textDirection: TextDirection.ltr, textAlign: TextAlign.right),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(balanceLabel, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      const SizedBox(width: 4),
                      Text(balanceValue, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.primaryDark : AppColors.textMuted, width: isSelected ? 6 : 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
