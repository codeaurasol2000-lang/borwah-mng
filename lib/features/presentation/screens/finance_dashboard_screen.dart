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

class FinanceDashboardScreen extends StatefulWidget {
  const FinanceDashboardScreen({super.key});

  @override
  State<FinanceDashboardScreen> createState() => _FinanceDashboardScreenState();
}

class _FinanceDashboardScreenState extends State<FinanceDashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 100 && _isNavVisible) {
        setState(() {
          _isNavVisible = false;
        });
      } else if (_scrollController.position.pixels <= 100 && !_isNavVisible) {
        setState(() {
          _isNavVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FinanceDashboardCubit(getFinanceSummaryUseCase: sl())..loadDashboardData(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _isNavVisible ? AppBar(
            titleSpacing: 0,
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.surfaceLight,
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
                    const Text(
                      'المدير المالي التنفيذي',
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
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
          ) : null,
          body: BlocBuilder<FinanceDashboardCubit, FinanceDashboardState>(
            builder: (context, state) {
              if (state is FinanceDashboardLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryDark));
              } else if (state is FinanceDashboardLoaded) {
                final data = state.summary;
                return SingleChildScrollView(
                  controller: _scrollController,
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
                          color: AppColors.surfaceHighlight,
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
                                      color: AppColors.surface.withValues(alpha: 0.12),
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

                      // 7. المصاريف والمدفوعات
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.receipt_long, color: AppColors.primaryDark, size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('المصاريف والمدفوعات\nالتشغيلية', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text('58,400', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                                          const SizedBox(width: 4),
                                          const Text('ر.س', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                                          const SizedBox(width: 6),
                                          const Text('إجمالي مدفوعات الشهر', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.circle, size: 6, color: Colors.blue.shade700),
                                      const SizedBox(width: 4),
                                      Text('إدارة\nالصرف', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue.shade700, height: 1.2), textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(color: AppColors.cardBorder, height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('الفواتير ومستحقات التشغيل الجارية', style: TextStyle(fontSize: 11, color: Colors.black87)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue.shade100),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('4 بنود صرف مجدولة', style: TextStyle(fontSize: 10, color: Colors.blue)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F172A),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon: const Icon(Icons.add_circle_outline, size: 16),
                                onPressed: () {},
                                label: const Text('تسجيل بيان دفع جديد / إدارة المصاريف', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 8. مؤشرات العمولات والأرصدة المعلقة
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTileNew(
                              title: "عمولات التطبيق المحصلة هذا الشهر",
                              value: "284,900",
                              icon: Icons.auto_graph,
                              color: Colors.blue.shade700,
                              badgeText: "+14.2%",
                              badgeColor: Colors.blue.shade50,
                              badgeTextColor: Colors.blue.shade700,
                              bottomText: "مقارنة بالشهر السابق (249,450 ر.س)",
                              bottomLink: "صافي الإيراد الرقابي",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
                                  child: const Icon(Icons.gavel, color: Colors.grey, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.circle, size: 6, color: AppColors.danger),
                                          const SizedBox(width: 4),
                                          const Text('أرصدة معلقة تحت التدقيق الرقابي', style: TextStyle(fontSize: 11, color: Colors.black87)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Text('25,400', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                                          const SizedBox(width: 4),
                                          const Text('ر.س', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('3 محافظ', style: TextStyle(fontSize: 10, color: Colors.black87)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text('محافظ مجمدة احترازياً بطلب الإدارة العامة والمشرفين لوجود بلاغات ونزاعات مفتوحة.', style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.4)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 9. محافظ الأقسام التشغيلية المباشرة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.account_balance_wallet, color: AppColors.primaryDark, size: 18),
                              SizedBox(width: 6),
                              Text("محافظ الأقسام التشغيلية المباشرة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                            ],
                          ),
                          Text('4 قطاعات حية', style: TextStyle(fontSize: 11, color: Colors.blue.shade700)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildWalletRowNew("محفظة قسم التجار والمتاجر", "رصيد دوري متاح للتسوية البنكية والسحب", "2,150,000", Icons.storefront),
                      const SizedBox(height: 8),
                      _buildWalletRowNew("محفظة المستعمل وعربون\n«وصلني»", "حساب ضمان وتأمين صفقات نشط\n(Escrow)", "980,000", Icons.handshake_outlined),
                      const SizedBox(height: 8),
                      _buildWalletRowNew("محفظة طلبات الخدمات\nوالصيانة", "مستحقات فنيين معتمدين ومزودي\nالخدمات", "620,000", Icons.build_circle_outlined),
                      const SizedBox(height: 8),
                      _buildWalletRowNew("محفظة مناديب التوصيل\nواللوجستيات", "أجور ومستحقات الشحن والتسليم\nالميداني", "450,000", Icons.local_shipping_outlined),
                      const SizedBox(height: 16),

                      // 10. مؤشر كفاية السيولة المصرفية الفورية
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.shield_outlined, color: AppColors.primaryDark, size: 20),
                                    SizedBox(width: 8),
                                    Text("مؤشر كفاية السيولة المصرفية\nالفورية", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark, height: 1.2)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle_outline, size: 14, color: Colors.blue.shade700),
                                      const SizedBox(width: 4),
                                      Text('آمن ومستقر\nجداً!', style: TextStyle(fontSize: 9, color: Colors.blue.shade700, fontWeight: FontWeight.bold, height: 1.2), textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.primaryDark, width: 6),
                                    ),
                                    child: const Center(child: Text('99.8%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryDark))),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('نسبة تغطية طلبات السحب اليومية', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                        const SizedBox(height: 2),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            const Text('99.8%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                                            const SizedBox(width: 6),
                                            Text('تغطية نقدية فائضة', style: TextStyle(fontSize: 10, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        const Text('الحد الأدنى النظامي المشترط: 85.0%', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(10)),
                              child: const Row(
                                children: [
                                  Icon(Icons.domain_verification, color: AppColors.primaryDark, size: 20),
                                  SizedBox(width: 10),
                                  Expanded(child: Text('التسوية المصرفية التلقائية عبر نظام سداد\n& SARIE:', style: TextStyle(fontSize: 11, color: Colors.black87))),
                                  Text('مكتملة ومطابقة\n100%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 11. لائحة الحوكمة
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.policy_outlined, color: Colors.black87, size: 20),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text('لائحة الحوكمة وتفويض الصلاحيات\nالمالية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.3)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: Colors.white,
                                  child: const Text('بند\n#04- أ', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey), textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'وفق لائحة الحوكمة والسياسات المالية: المشرفون الميدانيون ورؤساء الأقسام لا يملكون أي صلاحية لتعديل الأرصدة أو السحب أو التحويل البنكي. تنفيذ وتوثيق العمليات المالية حصري للمدير المالي المعتمد برقم تفويض مصرفي رسمي.',
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade700, height: 1.5),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Bottom Sticky Buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.check_circle_outline, size: 18),
                          onPressed: () {},
                          label: const Text('مراجعة طلبات السحب العاجلة (14 طلباً جاهزاً للصرف)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryDark,
                            side: const BorderSide(color: Colors.transparent),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                          onPressed: () {},
                          label: const Text('تصدير تقرير السيولة والمركز المالي اليومي (PDF)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isNavVisible ? 70 : 0,
          child: Wrap(
            children: [
              BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primaryDark,
                unselectedItemColor: AppColors.textSecondary,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.primaryDark),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 10, color: AppColors.textSecondary),
                elevation: 10,
                currentIndex: 4, // "الرئيسية" هي النشطة
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history_edu, size: 24),
                    label: 'التدقيق',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.percent, size: 24),
                    label: 'العمولات',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sync_alt, size: 24),
                    label: 'التسويات',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fact_check_outlined, size: 24),
                    label: 'المطابقة',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance, size: 24),
                    label: 'الرئيسية',
                  ),
                ],
              ),
            ],
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
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            countText,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '($amountText)',
                              style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w600),
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
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (actionButtonText != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_outlined, size: 16, color: AppColors.primaryDark),
                    const SizedBox(width: 6),
                    Text(
                      actionButtonText,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isNavVisible ? 70 : 0,
          child: Wrap(
            children: [
              BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primaryDark,
                unselectedItemColor: AppColors.textSecondary,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.primaryDark),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 10, color: AppColors.textSecondary),
                elevation: 10,
                currentIndex: 4,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history_edu, size: 24),
                    label: 'التدقيق',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.percent, size: 24),
                    label: 'العمولات',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sync_alt, size: 24),
                    label: 'التسويات',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fact_check_outlined, size: 24),
                    label: 'المطابقة',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance, size: 24),
                    label: 'الرئيسية',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTileNew({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String bottomText,
    required String bottomLink,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.black87)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(width: 4),
              const Text('ر.س', style: TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bottomText, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(bottomLink, style: TextStyle(fontSize: 11, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletRowNew(String title, String subtitle, String balance, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 9, color: Colors.grey, height: 1.3)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(balance, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const Text('ريال سعودي', style: TextStyle(fontSize: 9, color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );
  }
}