import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../controllers/bank_accounts/bank_accounts_cubit.dart';
import '../controllers/bank_accounts/bank_accounts_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/finance_navigation.dart';

class BankAccountsScreen extends StatelessWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BankAccountsCubit(getBankAccountsUseCase: sl())..loadBankAccounts(),
      child: const _BankAccountsScreenContent(),
    );
  }
}

class _BankAccountsScreenContent extends StatefulWidget {
  const _BankAccountsScreenContent();

  @override
  State<_BankAccountsScreenContent> createState() =>
      _BankAccountsScreenContentState();
}

class _BankAccountsScreenContentState
    extends State<_BankAccountsScreenContent> {
  int _selectedCategoryIndex = 0;

  // فلترة الحسابات حسب التصنيف المختار
  List<BankAccountEntity> _filterAccounts(List<BankAccountEntity> accounts) {
    if (_selectedCategoryIndex == 0) return accounts;
    if (_selectedCategoryIndex == 1) {
      return accounts.where((a) => a.accountType.contains("تشغيلي")).toList();
    }
    if (_selectedCategoryIndex == 2) {
      return accounts
          .where((a) =>
              a.accountType.contains("ضمان") ||
              a.accountType.contains("Escrow"))
          .toList();
    }
    if (_selectedCategoryIndex == 3) {
      return accounts
          .where((a) =>
              a.accountType.contains("بوابة") || a.accountType.contains("مدى"))
          .toList();
    }
    if (_selectedCategoryIndex == 4) {
      return accounts
          .where((a) =>
              a.accountType.contains("محفظة") ||
              a.accountType.contains("Pay"))
          .toList();
    }
    return accounts;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: FinancePageAppBar(
          title: l10n.officialBankAccountsAndIban,
          subtitle: l10n.bankAccountsScreenSubtitle,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
          additionalActions: [
            IconButton(
              tooltip: l10n.refreshBalances,
              icon: const Icon(Icons.refresh, color: AppColors.primaryDark),
              onPressed: () =>
                  context.read<BankAccountsCubit>().loadBankAccounts(),
            ),
          ],
        ),
        body: BlocBuilder<BankAccountsCubit, BankAccountsState>(
          builder: (context, state) {
            if (state is BankAccountsLoading) {
              return const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryDark));
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. كارت الرصيد المحسوب تلقائياً بالتزامن مع الحسابات
                    _buildConsolidatedBalanceCard(
                        calculatedTotalLiquidity, l10n),
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
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Text(l10n.noAccountsInCategory,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13)),
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
                          final bool isEscrow =
                              account.accountType.contains("ضمان") ||
                                  account.accountType.contains("Escrow");
                          return _buildBankAccountCard(
                              context: context,
                              account: account,
                              isEscrow: isEscrow);
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
  Widget _buildConsolidatedBalanceCard(
      double totalBalance, AppLocalizations l10n) {
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
          Row(
            children: [
              const Icon(Icons.account_balance, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.totalAggregatedLiquidity,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sync, size: 14, color: Colors.greenAccent),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    l10n.instantBankSyncNote,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
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
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showAddBankAccountSheet(context),
            icon: const Icon(Icons.add_circle_outline,
                size: 17, color: Colors.white),
            label: Text(
              l10n.createBankAccount,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showExportPdfDialog(context),
            icon: const Icon(Icons.picture_as_pdf_outlined,
                size: 17, color: Colors.redAccent),
            label: Text(
              l10n.exportAccountStatementButton,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade300),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // كارت سجل الحركات المصرفية
  Widget _buildDailyTransactionsButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.openDailyLedger)),
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
              color: Colors.blue.withValues(alpha: 0.04),
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
              child: const Icon(Icons.receipt_long_outlined,
                  color: AppColors.info, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.dailyLogLedger,
                    maxLines: 1,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.dailyLedgerDescription,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
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
    final l10n = AppLocalizations.of(context)!;
    final categories = [
      l10n.allTab,
      l10n.operationalAccountsFilter,
      l10n.escrowAccountsFilter,
      l10n.paymentGatewaysFilter,
      l10n.digitalWalletsFilter,
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          final title =
              index == 0 ? "${l10n.allTab} ($totalCount)" : categories[index];
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
            side: BorderSide(
                color:
                    isSelected ? AppColors.primaryDark : Colors.grey.shade300),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
    required BuildContext context,
    required BankAccountEntity account,
    required bool isEscrow,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isEscrow ? Colors.teal.shade200 : AppColors.cardBorder),
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
                  color: (isEscrow ? Colors.teal : AppColors.primaryDark)
                      .withValues(alpha: 0.1),
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.escrowAccountBadge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.availableLedgerBalanceLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    CurrencyFormatter.format(account.balance),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(l10n.ibanOrIdentifierLabel,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  account.iban,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
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
                      Expanded(
                        child: Text(
                          l10n.connectedReconciledViaSarie,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: const Size(0, 32),
                  side: BorderSide(
                      color: AppColors.primaryDark.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.edit_note,
                    size: 16, color: AppColors.primaryDark),
                label: Text(
                  l10n.localeName.startsWith('ar') ? 'تعديل البيانات' : 'Edit Account',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark),
                ),
                onPressed: () => _showEditBankAccountSheet(context, account),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // نافذة تعديل بيانات الحساب البنكي وإرسالها للأدمن
  void _showEditBankAccountSheet(
      BuildContext context, BankAccountEntity account) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    final nameController = TextEditingController(text: account.bankName);
    final ibanController = TextEditingController(text: account.iban);
    final typeController = TextEditingController(text: account.accountType);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                Row(
                  children: [
                    const Icon(Icons.edit_calendar,
                        color: AppColors.primaryDark, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isArabic
                            ? 'تعديل بيانات الحساب البنكي'
                            : 'Edit Bank Account Data',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isArabic
                              ? 'تنبيه: بعد حفظ التعديلات سيتم إرسال أمر التعديل إلى المستخدم الأدمن للموافقة عليه أو رفضه.'
                              : 'Notice: After saving, modifications will be submitted to the Admin user for approval or rejection.',
                          style: TextStyle(
                              fontSize: 11, color: Colors.amber.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.bankNameField,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText:
                        isArabic ? 'نوع الحساب / التصنيف' : 'Account Type',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: ibanController,
                  decoration: InputDecoration(
                    labelText: l10n.ibanField,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: Row(
                          children: [
                            const Icon(Icons.send_outlined,
                                color: AppColors.primaryDark),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isArabic
                                    ? 'تم إرسال طلب التعديل'
                                    : 'Modification Request Sent',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          isArabic
                              ? 'تم إرسال أمر تعديل بيانات الحساب (${nameController.text}) بنجاح إلى المستخدم الأدمن للمصادقة عليه.'
                              : 'Account modification order for (${nameController.text}) was successfully submitted to the Admin user for approval.',
                          style: const TextStyle(fontSize: 12, height: 1.4),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDark,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: Text(isArabic ? 'حسناً' : 'OK',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline,
                      size: 18, color: Colors.white),
                  label: Text(
                    isArabic
                        ? 'حفظ وإرسال التعديل للأدمن'
                        : 'Save & Submit to Admin',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // نافذة إضافة حساب بنكي
  void _showAddBankAccountSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Directionality(
          textDirection:
              l10n.localeName.startsWith('ar') ? TextDirection.rtl : TextDirection.ltr,
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
                Text(l10n.linkBankAccountTitle,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(l10n.enterBankDetailsToApprove,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 16),
                TextFormField(
                    decoration: InputDecoration(
                        labelText: l10n.bankNameField,
                        border: const OutlineInputBorder())),
                const SizedBox(height: 10),
                TextFormField(
                    decoration: InputDecoration(
                        labelText: l10n.ibanField,
                        border: const OutlineInputBorder())),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.bankLinkRequestSent)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.saveAccount,
                      style: const TextStyle(color: Colors.white)),
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
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection:
            l10n.localeName.startsWith('ar') ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text(l10n.exportAccountsTitle,
                  style: const TextStyle(fontSize: 15)),
            ],
          ),
          content: Text(
            l10n.pdfReportExplanation,
            style: const TextStyle(fontSize: 12),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancelAction)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.accountsExportSuccess)),
                );
              },
              child: Text(l10n.download,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
