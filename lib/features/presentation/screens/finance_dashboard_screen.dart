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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 0,
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Color(0xFFF1F5F9),
                child: Icon(Icons.person_outline, color: AppColors.primaryDark),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'برواح المازوري',
                  style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: [
                    const Icon(Icons.verified_outlined, size: 13, color: AppColors.info),
                    const SizedBox(width: 4),
                    Text(
                      'مدقق مالي معتمد',
                      style: TextStyle(color: Colors.blueGrey[400], fontSize: 11),
                    ),
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
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. الجلسة المالية المباشرة والتاريخ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(radius: 4, backgroundColor: AppColors.info),
                              SizedBox(width: 6),
                              Text(
                                'الجلسة المالية المباشرة',
                                style: TextStyle(color: AppColors.info, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            '1446/11/04 هـ - 10:45 ص',
                            style: TextStyle(color: Colors.blueGrey[400], fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        'الرقابة المالية المركزية - برواح المازوري',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'لوحة تحكم المدير المالي | الوردية المالية النشطة ومطابقة السيولة الحية',
                        style: TextStyle(fontSize: 11, color: Colors.blueGrey[500]),
                      ),
                      const SizedBox(height: 14),

                      // 2. بطاقة المسؤول التنفيذي
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified, color: AppColors.primaryDark, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'أ. سليمان الراجحي',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    'المدير المالي التنفيذي',
                                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Text('#CF0-01', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            Icon(Icons.qr_code, size: 18, color: AppColors.primaryDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 3. كارت السيولة الإجمالية المجمعة (الضغط ينقل للشاشة 2)
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BankAccountsScreen()),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDark.withOpacity(0.2),
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
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      'إجمالي السيولة النقدية والضمانات المجمعة',
                                      style: TextStyle(color: Colors.white70, fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white70),
                                ],
                              ),
                              const SizedBox(height: 12),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  CurrencyFormatter.format(data.totalLiquidity),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.white24, height: 20),
                              _buildBankSubRow(
                                'مصرف الراجحي (الحساب التشغيلي الرئيسي)',
                                CurrencyFormatter.format(data.rajhiAccountBalance),
                              ),
                              const SizedBox(height: 8),
                              _buildBankSubRow(
                                'البنك الأهلي السعودي (حساب الضمان Escrow)',
                                CurrencyFormatter.format(data.snbEscrowBalance),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 4. بطاقة طلبات سحب التجار والمستخدمين
                      _buildNavigationCard(
                        context,
                        title: 'طلبات السحب المعلقة قيد المراجعة للتجار والمستخدمين',
                        countText: '${data.pendingMerchantWithdrawalsCount} طلباً',
                        amountText: CurrencyFormatter.format(data.pendingMerchantWithdrawalsAmount),
                        subtitle: 'تحتاج تدقيق ومطابقة فواتير قبل التوقيع',
                        icon: Icons.storefront_outlined,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MerchantWithdrawalsScreen()),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 5. بطاقة طلبات سحب المشرفين والمساعدين
                      _buildNavigationCard(
                        context,
                        title: 'طلبات السحب المعلقة قيد المراجعة للمشرفين و المساعدين',
                        countText: '${data.pendingSupervisorWithdrawalsCount} طلباً',
                        amountText: CurrencyFormatter.format(data.pendingSupervisorWithdrawalsAmount),
                        subtitle: 'تحتاج تدقيق ومطابقة فواتير قبل التوقيع',
                        icon: Icons.supervisor_account_outlined,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SupervisorWithdrawalsScreen()),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 6. بطاقة طلبات الاشتراكات والترقيات
                      _buildNavigationCard(
                        context,
                        title: 'طلبات الاشتراكات والترقيات المعلقة',
                        countText: '${data.pendingSubscriptionsCount} طلباً',
                        amountText: CurrencyFormatter.format(data.pendingSubscriptionsAmount),
                        subtitle: 'ترقيات باقات المتاجر واشتراكات الفنيين بانتظار الاعتماد المالي',
                        icon: Icons.subscriptions_outlined,
                        actionButtonText: 'مراجعة واعتماد الاشتراكات (${data.pendingSubscriptionsCount})',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SubscriptionsScreen()),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 7. مؤشرات المصاريف والعمولات
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              title: "المصاريف التشغيلية",
                              value: "84,320 ر.س",
                              icon: Icons.trending_down,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildMetricTile(
                              title: "عمولات التطبيق",
                              value: "142,650 ر.س",
                              icon: Icons.trending_up,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 8. محافظ الأقسام التشغيلية المباشرة
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "محافظ الأقسام التشغيلية المباشرة",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                            ),
                            const SizedBox(height: 10),
                            _buildWalletRow("محفظة التجار والمتاجر", "1,245,000 ر.س", Icons.store),
                            const Divider(height: 16),
                            _buildWalletRow("محفظة المستعمل وعربون «وصلني»", "840,200 ر.س", Icons.handshake),
                            const Divider(height: 16),
                            _buildWalletRow("محفظة الخدمات والصيانة", "420,150 ر.س", Icons.build),
                            const Divider(height: 16),
                            _buildWalletRow("محفظة مناديب الشحن والتوصيل", "295,800 ر.س", Icons.local_shipping),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 9. مؤشر كفاية السيولة المصرفية الفورية
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.teal.shade100),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.teal, size: 22),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "مؤشر كفاية السيولة المصرفية الفورية",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "آمن ومستقر جداً • نسبة التغطية النقدية: 142.8%",
                                    style: TextStyle(fontSize: 11, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
      ),
    );
  }

  Widget _buildBankSubRow(String title, String amount) {
    return Row(
      children: [
        const CircleAvatar(radius: 3, backgroundColor: Colors.white54),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
        String? actionButtonText,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // 1. الأيقونة أولاً على اليمين
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primaryDark, size: 22),
                ),
                const SizedBox(width: 10),

                // 2. النصوص مغلفة بـ Expanded لمنع Overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            countText,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '($amountText)',
                              style: const TextStyle(fontSize: 11, color: AppColors.info, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 3. السهم في أقصى اليسار (< في اتجاه RTL)
                const Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (actionButtonText != null) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.task_alt, size: 16),
                label: Text(
                  actionButtonText,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletRow(String title, String balance, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryDark),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          balance,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
        ),
      ],
    );
  }
}