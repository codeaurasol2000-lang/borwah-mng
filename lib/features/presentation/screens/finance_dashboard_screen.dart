import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../controllers/dashboard/finance_dashboard_cubit.dart';
import '../controllers/dashboard/finance_dashboard_state.dart';
import 'bank_accounts_screen.dart';
import 'merchant_withdrawals_screen.dart';
import 'supervisor_withdrawals_screen.dart';
import 'subscriptions_screen.dart';

class FinanceDashboardScreen extends StatelessWidget {
  const FinanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FinanceDashboardCubit(getFinanceSummaryUseCase: sl())..loadDashboardData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFFF1F5F9),
              child: Icon(Icons.person_outline, color: AppColors.primaryDark),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('برواح المازوري', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  const Icon(Icons.verified_outlined, size: 13, color: AppColors.info),
                  const SizedBox(width: 4),
                  Text('مدقق مالي معتمد', style: TextStyle(color: Colors.blueGrey[400], fontSize: 11)),
                ],
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.shield_outlined, color: AppColors.primaryDark),
            )
          ],
        ),
        body: BlocBuilder<FinanceDashboardCubit, FinanceDashboardState>(
          builder: (context, state) {
            if (state is FinanceDashboardLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryDark));
            } else if (state is FinanceDashboardLoaded) {
              final data = state.summary;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الجلسة الحية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('1446/11/04 هـ - 10:45 ص', style: TextStyle(color: Colors.blueGrey[400], fontSize: 11)),
                        const Row(
                          children: [
                            Text('الجلسة المالية المباشرة', style: TextStyle(color: AppColors.info, fontSize: 11, fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            CircleAvatar(radius: 4, backgroundColor: AppColors.info),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('الرقابة المالية المركزية - برواح المازوري', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('لوحة تحكم المدير المالي | الوردية المالية النشطة ومطابقة السيولة الحية', style: TextStyle(fontSize: 12, color: Colors.blueGrey[500])),
                    const SizedBox(height: 16),

                    // بطاقة المسؤول
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFEEF2F6), borderRadius: BorderRadius.circular(16)),
                      child: const Row(
                        children: [
                          Icon(Icons.qr_code, size: 18, color: AppColors.primaryDark),
                          SizedBox(width: 6),
                          Text('#CF0-01', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('أ. سليمان الراجحي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('المدير المالي التنفيذي', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            ],
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.verified, color: AppColors.primaryDark),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // كارت السيولة الإجمالية المجمعة (الضغط عليه ينقل للشاشة 2)
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BankAccountsScreen())),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.account_balance, color: Colors.white),
                                ),
                                const Text('إجمالي السيولة النقدية والضمانات المجمعة', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                CurrencyFormatter.format(data.totalLiquidity),
                                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(color: Colors.white24, height: 24),
                            _buildBankSubRow('مصرف الراجحي (الحساب التشغيلي الرئيسي)', CurrencyFormatter.format(data.rajhiAccountBalance)),
                            const SizedBox(height: 8),
                            _buildBankSubRow('البنك الأهلي السعودي (حساب الضمان Escrow)', CurrencyFormatter.format(data.snbEscrowBalance)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // بطاقة طلبات سحب التجار والمستخدمين (ينقل للشاشة 3)
                    _buildNavigationCard(
                      context,
                      title: 'طلبات السحب المعلقة قيد المراجعة للتجار والمستخدمين',
                      countText: '${data.pendingMerchantWithdrawalsCount} طلباً',
                      amountText: CurrencyFormatter.format(data.pendingMerchantWithdrawalsAmount),
                      subtitle: 'تحتاج تدقيق ومطابقة فواتير قبل التوقيع',
                      icon: Icons.storefront_outlined,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MerchantWithdrawalsScreen())),
                    ),
                    const SizedBox(height: 12),

                    // بطاقة طلبات سحب المشرفين والمساعدين (ينقل للشاشة 4)
                    _buildNavigationCard(
                      context,
                      title: 'طلبات السحب المعلقة قيد المراجعة للمشرفين و المساعدين',
                      countText: '${data.pendingSupervisorWithdrawalsCount} طلباً',
                      amountText: CurrencyFormatter.format(data.pendingSupervisorWithdrawalsAmount),
                      subtitle: 'تحتاج تدقيق ومطابقة فواتير قبل التوقيع',
                      icon: Icons.supervisor_account_outlined,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupervisorWithdrawalsScreen())),
                    ),
                    const SizedBox(height: 12),

                    // بطاقة طلبات الاشتراكات والترقيات (ينقل للشاشة 5)
                    _buildNavigationCard(
                      context,
                      title: 'طلبات الاشتراكات والترقيات المعلقة',
                      countText: '${data.pendingSubscriptionsCount} طلباً',
                      amountText: CurrencyFormatter.format(data.pendingSubscriptionsAmount),
                      subtitle: 'ترقيات باقات المتاجر، اشتراكات الفنيين، وتجديد الاشتراكات السنوية بانتظار الاعتماد المالي',
                      icon: Icons.subscriptions_outlined,
                      badgeText: 'جديد • 18 طلباً',
                      actionButtonText: 'مراجعة واعتماد الاشتراكات (${data.pendingSubscriptionsCount})',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionsScreen())),
                    ),
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

  Widget _buildBankSubRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(amount, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        Row(
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(width: 6),
            const CircleAvatar(radius: 3, backgroundColor: Colors.white54),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationCard(
      BuildContext context, {
        required String title,
        required String countText,
        required String amountText,
        required String subtitle,
        required IconData icon,
        required VoidCallback onTap,
        String? badgeText,
        String? actionButtonText,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.arrow_back_ios_new, size: 14, color: AppColors.textSecondary),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('($amountText)', style: const TextStyle(fontSize: 11, color: AppColors.info, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Text(countText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: AppColors.primaryDark),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            if (actionButtonText != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.task_alt, size: 16),
                label: Text(actionButtonText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}