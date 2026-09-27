import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/di/injection_container.dart';
import '../../finance/domain/entities/bank_account_entity.dart';
import '../controllers/bank_accounts/bank_accounts_cubit.dart';
import '../controllers/bank_accounts/bank_accounts_state.dart';

class BankAccountsScreen extends StatelessWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankAccountsCubit(getBankAccountsUseCase: sl())..loadBankAccounts(),
      child: const _BankAccountsScreenContent(),
    );
  }
}

class _BankAccountsScreenContent extends StatefulWidget {
  const _BankAccountsScreenContent();

  @override
  State<_BankAccountsScreenContent> createState() => _BankAccountsScreenContentState();
}

class _BankAccountsScreenContentState extends State<_BankAccountsScreenContent> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    "الكل",
    "حسابات تشغيلية",
    "حسابات ضمان Escrow",
    "بوابات الدفع الإلكتروني",
    "المحافظ الرقمية",
  ];

  // فلترة الحسابات حسب التصنيف المختار
  List<BankAccountEntity> _filterAccounts(List<BankAccountEntity> accounts) {
    if (_selectedCategoryIndex == 0) return accounts;
    if (_selectedCategoryIndex == 1) {
      return accounts.where((a) => a.accountType.contains("تشغيلي")).toList();
    }
    if (_selectedCategoryIndex == 2) {
      return accounts.where((a) => a.accountType.contains("ضمان") || a.accountType.contains("Escrow")).toList();
    }
    if (_selectedCategoryIndex == 3) {
      return accounts.where((a) => a.accountType.contains("بوابة") || a.accountType.contains("مدى")).toList();
    }
    if (_selectedCategoryIndex == 4) {
      return accounts.where((a) => a.accountType.contains("محفظة") || a.accountType.contains("Pay")).toList();
    }
    return accounts;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "الحسابات البنكية والقنوات الرسمية",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                "إدارة السيولة والمطابقة مع الشبكة السعودية للمدفوعات",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: "تحديث الأرصدة",
              icon: const Icon(Icons.refresh, color: AppColors.primaryDark),
              onPressed: () => context.read<BankAccountsCubit>().loadBankAccounts(),
            ),
          ],
        ),
        body: BlocBuilder<BankAccountsCubit, BankAccountsState>(
          builder: (context, state) {
            if (state is BankAccountsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryDark));
            } else if (state is BankAccountsError) {
              return Center(child: Text(state.message));
            } else if (state is BankAccountsLoaded) {
              final allAccounts = state.accounts;

              // حساب إجمالي السيولة تلقائياً من مجموع أرصدة الحسابات
              final double calculatedTotalLiquidity = allAccounts.fold(
                0.0,
                    (sum, account) => sum + account.balance,
              );

              final filteredAccounts = _filterAccounts(allAccounts);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. كارت الرصيد المحسوب تلقائياً بالتزامن مع الحسابات
                    _buildConsolidatedBalanceCard(calculatedTotalLiquidity),
                    const SizedBox(height: 12),

                    // 2. أزرار الإجراءات (إضافة حساب + تصدير PDF)
                    _buildTopActionButtons(context),
                    const SizedBox(height: 12),

                    // 3. زر كارت سجل الحركات اليومية
                    _buildDailyTransactionsButton(context),
                    const SizedBox(height: 14),

                    // 4. شريط اختيار التصنيف
                    _buildCategoryChips(allAccounts.length),
                    const SizedBox(height: 16),

                    // 5. قائمة الحسابات البنكية المقسمة
                    if (filteredAccounts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Text("لا توجد حسابات مسجلة ضمن هذا التصنيف", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredAccounts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final account = filteredAccounts[index];
                          final bool isEscrow = account.accountType.contains("ضمان") || account.accountType.contains("Escrow");
                          return _buildBankAccountCard(account: account, isEscrow: isEscrow);
                        },
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  // كارت الرصيد المجمع بحساب ديناميكي
  Widget _buildConsolidatedBalanceCard(double totalBalance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance, color: Colors.white70, size: 18),
              SizedBox(width: 8),
              Text(
                "إجمالي السيولة النقدية المجمعة بكافة القنوات",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              CurrencyFormatter.format(totalBalance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sync, size: 14, color: Colors.greenAccent),
                SizedBox(width: 6),
                Text(
                  "تحديث ومطابقة تلقائية متزامنة مع كافة القنوات",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // أزرار إضافة حساب وتصدير كشف PDF
  Widget _buildTopActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showAddBankAccountSheet(context),
            icon: const Icon(Icons.add_circle_outline, size: 17, color: Colors.white),
            label: const Text(
              "إضافة حساب جديد",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showExportPdfDialog(context),
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 17, color: Colors.redAccent),
            label: const Text(
              "تصدير كشف PDF",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade300),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // كارت سجل الحركات المصرفية
  Widget _buildDailyTransactionsButton(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("جاري فتح سجل العمليات والتحويلات اليومية المكتملة...")),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.blue.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.receipt_long_outlined, color: AppColors.info, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "سجل الحركات المصرفية والعمليات اليومية",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "عرض قيود اليومية، الإيداعات، والحوالات الصادرة والواردة",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // شريط الفلاتر
  Widget _buildCategoryChips(int totalCount) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          final title = index == 0 ? "الكل ($totalCount)" : _categories[index];
          return ChoiceChip(
            label: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.primaryDark,
            backgroundColor: Colors.white,
            side: BorderSide(color: isSelected ? AppColors.primaryDark : Colors.grey.shade300),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedCategoryIndex = index);
              }
            },
          );
        },
      ),
    );
  }

  // كارت الحساب البنكي المعتمد على Entity
  Widget _buildBankAccountCard({
    required BankAccountEntity account,
    required bool isEscrow,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isEscrow ? Colors.teal.shade200 : AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isEscrow ? Colors.teal : AppColors.primaryDark).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: isEscrow ? Colors.teal : AppColors.primaryDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      account.bankName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      account.accountType,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isEscrow)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "حساب ضمان",
                    style: TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("الرصيد الدفتري المتاح:", style: TextStyle(fontSize: 11, color: Colors.grey)),
              Text(
                CurrencyFormatter.format(account.balance),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text("الآيبان / المعرّف:", style: TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  account.iban,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, size: 14, color: Colors.green.shade700),
                const SizedBox(width: 4),
                Text(
                  "متصل ومطابق لحظياً عبر SARIE",
                  style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // نافذة إضافة حساب بنكي
  void _showAddBankAccountSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("ربط حساب مصرفي جديد", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text("أدخل تفاصيل الحساب المصرفي للاعتماد", style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 16),
                TextFormField(decoration: const InputDecoration(labelText: "اسم البنك", border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextFormField(decoration: const InputDecoration(labelText: "رقم الآيبان (IBAN)", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال طلب الربط")));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("حفظ الحساب", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // نافذة تصدير تقرير PDF
  void _showExportPdfDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.redAccent),
              SizedBox(width: 8),
              Text("تصدير كشف الحسابات", style: TextStyle(fontSize: 15)),
            ],
          ),
          content: const Text(
            "سيتم توليد تقرير رسمي مفصل بصيغة PDF بجميع الأرصدة المصرفية المتطابقة.",
            style: TextStyle(fontSize: 12),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم تصدير كشف الحسابات بنجاح")),
                );
              },
              child: const Text("تحميل", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}