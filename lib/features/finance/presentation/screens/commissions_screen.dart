import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/finance_navigation.dart';

class CommissionsScreen extends StatelessWidget {
  final bool showBottomNavigation;

  const CommissionsScreen({super.key, this.showBottomNavigation = true});

  @override
  Widget build(BuildContext context) {
    return _CommissionsDashboard(showBottomNavigation: showBottomNavigation);
  }

  // ignore: unused_element
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.hexFF0F1F3D, AppColors.hexFF0A142A],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.percent_rounded, color: AppColors.white, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'إجمالي العمولات',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up_rounded,
                        color: AppColors.hexFF7AE7A8, size: 12),
                    SizedBox(width: 4),
                    Text(
                      '+14.2%',
                      style: TextStyle(
                        color: AppColors.hexFF7AE7A8,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontFamily: 'Roboto'),
                children: [
                  TextSpan(
                    text: '284,900',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' ج.م',
                    style: TextStyle(
                      color: AppColors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: _MiniInfo(
                  title: 'العمولات المكتسبة',
                  value: '38,500 ج.م',
                  color: AppColors.hexFF7AE7A8,
                  icon: Icons.savings_rounded,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MiniInfo(
                  title: 'المعاملات',
                  value: '3,245',
                  color: AppColors.hexFFBEE3FF,
                  icon: Icons.receipt_long_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
    final commissionRows = [
      _CommissionRow(
        title: 'مؤسسة الخدمات الرقمية',
        code: '#TXC-OMM-9945',
        amount: '+ 350.00',
        note: 'ارتفعت عن الأسبوع الماضي',
        accent: AppColors.success,
      ),
      _CommissionRow(
        title: 'مؤسسة الخدمات الرقمية',
        code: '#TXC-OMM-9945',
        amount: '+ 1,200.00',
        note: 'زيادة في معاملات ذات الحجم الكبير',
        accent: AppColors.success,
      ),
      _CommissionRow(
        title: 'مؤسسة الخدمات الرقمية',
        code: '#TXC-OMM-9938',
        amount: '+ 175.00',
        note: 'مخفّض مع احتساب العمولات المخصومة',
        accent: AppColors.success,
      ),
      _CommissionRow(
        title: 'مؤسسة الخدمات الرقمية',
        code: '#TXC-OMM-9925',
        amount: '+ 15.00',
        note: 'مؤشر المكتب وتدقيق الاستلام',
        accent: AppColors.success,
      ),
      _CommissionRow(
        title: 'مؤسسة الخدمات الرقمية',
        code: '#TXC-OMM-9924',
        amount: '+ 210.00',
        note: 'زيادة مراجعة أمان المعاملات',
        accent: AppColors.success,
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.person_outline, color: AppColors.white, size: 18),
            ),
          ),
          title: const Text(
            'العمولات',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.notifications_none_rounded, color: AppColors.primaryDark),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 22),
            _buildSectionHeader(),
            const SizedBox(height: 12),
            ...commissionRows.map((row) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CommissionCard(row: row),
                )),
            const SizedBox(height: 18),
            _buildFooterInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.hexFF0F1F3D, AppColors.hexFF0A142A],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.percent_rounded, color: AppColors.white, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'إجمالي العمولات',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up_rounded, color: AppColors.hexFF7AE7A8, size: 12),
                    SizedBox(width: 4),
                    Text(
                      '+14.2%',
                      style: TextStyle(
                        color: AppColors.hexFF7AE7A8,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontFamily: 'Roboto'),
                children: [
                  TextSpan(
                    text: '284,900',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' ج.م',
                    style: TextStyle(
                      color: AppColors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MiniInfo(
                  title: 'العمولات المكتسبة',
                  value: '38,500 ج.م',
                  color: AppColors.hexFF7AE7A8,
                  icon: Icons.savings_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniInfo(
                  title: 'المعاملات',
                  value: '3,245',
                  color: AppColors.hexFFBEE3FF,
                  icon: Icons.receipt_long_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final cards = [
      _StatCard(title: 'عائدات نهاية الشهر', value: '78,350 ج.م', icon: Icons.trending_up_rounded, tone: AppColors.infoLight),
      _StatCard(title: 'عمولات المنصة', value: '142,600 ج.م', icon: Icons.dashboard_rounded, tone: AppColors.surfaceLight),
      _StatCard(title: 'خصم الخدمة', value: '39,150 ج.م', icon: Icons.receipt_long_rounded, tone: AppColors.successLight),
      _StatCard(title: 'إيرادات التجزئة', value: '31,900 ج.م', icon: Icons.bar_chart_rounded, tone: AppColors.warningLight),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) => cards[index],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'آخر العمولات',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'هذا الشهر',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterInfo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.hexFFE5EAF2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'التدقيق المالي',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'العمولات المسجلة تم مراجعتها وتحديثها حسب النسب المعتمدة في القواعد الداخلية.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text(
                'تصدير تقرير العمولات',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  */
}

// ignore: unused_element
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color tone;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: tone,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: AppColors.primaryDark),
              ),
              const Spacer(),
              const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 12, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MiniInfo({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white70,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommissionRow {
  final String title;
  final String code;
  final String amount;
  final String note;
  final Color accent;

  const _CommissionRow({
    required this.title,
    required this.code,
    required this.amount,
    required this.note,
    required this.accent,
  });
}

// ignore: unused_element
class _CommissionCard extends StatelessWidget {
  final _CommissionRow row;

  const _CommissionCard({required this.row});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.monetization_on_rounded,
                color: AppColors.primaryDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  row.code,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  row.note,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: row.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  row.amount,
                  style: TextStyle(
                    color: row.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 12, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommissionsDashboard extends StatefulWidget {
  final bool showBottomNavigation;

  const _CommissionsDashboard({required this.showBottomNavigation});

  @override
  State<_CommissionsDashboard> createState() => _CommissionsDashboardState();
}

class _CommissionsDashboardState extends State<_CommissionsDashboard>
    with AutomaticKeepAliveClientMixin<_CommissionsDashboard> {
  int _periodIndex = 0;
  String _selectedFilter = 'all';

  static const _revenuePeriods = [
    _RevenuePeriodData(
      values: [850, 1250, 980, 1760, 1420, 2100, 1150],
      previousTotal: 8250,
    ),
    _RevenuePeriodData(
      values: [6200, 7400, 5900, 8600, 7200, 9800, 10400],
      previousTotal: 50000,
    ),
    _RevenuePeriodData(
      values: [35000, 38000, 40000, 42000, 43000, 44000, 42900],
      previousTotal: 249450,
    ),
    _RevenuePeriodData(
      values: [82000, 91000, 87500, 96400, 102000, 110000, 108600],
      previousTotal: 612000,
    ),
  ];

  static const _filters = [
    ('all', 'الكل', 'All'),
    ('merchants', 'متاجر وتجار', 'Merchants'),
    ('providers', 'مزودو خدمات', 'Service providers'),
    ('requests', 'طلبات', 'Requests'),
  ];

  static const _transactions = [
    _CommissionTransaction(
      amount: '+ 350.00',
      code: '#TX-COMM-9945',
      filterKey: 'requests',
      status: 'اشتراك وثيقة',
      statusEn: 'Subscription',
      title: 'اشتراك الباقة الذهبية - مؤسسة سهم للتجارة',
      titleEn: 'Gold plan subscription - Sahm Trading',
      description:
          'رسوم تجديد وثيقة الحساب السنوي وحزمة الإعلانات المميزة (350 ج.م رسوم عمولة المنصة)',
      descriptionEn:
          'Annual account renewal and featured ads package (350 Egy platform fee)',
      detail: 'موثقة ومعتمدة بنكيًا عبر Apple Pay • اليوم 12:10 م',
      detailEn: 'Verified through Apple Pay • Today 12:10 PM',
      action: 'إشعار التحصيل',
      actionEn: 'Collection notice',
      icon: Icons.workspace_premium_outlined,
      tone: AppColors.hexFF059669,
    ),
    _CommissionTransaction(
      amount: '+ 1,200.00',
      code: '#TX-COMM-9941',
      filterKey: 'merchants',
      status: 'متجر موثق',
      statusEn: 'Verified store',
      title: 'مؤسسة الأفق للأجهزة الكهربائية',
      titleEn: 'Al-Ofuq Electrical Appliances',
      description: 'عمولة مبيعات منتجات (2.5% من إجمالي مبيعات 48,000 ج.م)',
      descriptionEn: 'Product sales commission (2.5% of 48,000 Egy sales)',
      detail: 'مستقطعة آليًا عند إتمام الدفع الإلكتروني (مدى) • اليوم 11:42 ص',
      detailEn: 'Automatically deducted via Mada • Today 11:42 AM',
      action: 'عرض سند القيد',
      actionEn: 'View journal voucher',
      icon: Icons.verified_outlined,
      tone: AppColors.hexFF059669,
    ),
    _CommissionTransaction(
      amount: '+ 175.00',
      code: '#TX-COMM-9938',
      filterKey: 'providers',
      status: 'خدمات وصيانة',
      statusEn: 'Services & maintenance',
      title: 'مؤسسة التبريد المتقن',
      titleEn: 'Al-Tabreed Al-Mutqan',
      description:
          'عمولة المنصة على خدمات الصيانة المنزلية (12.5% من فاتورة 1,400 ج.م)',
      descriptionEn:
          'Platform commission for home maintenance (12.5% of 1,400 Egy invoice)',
      detail: 'استقطاع تسوية طلب SRV-3042# معتمد من المشرف • اليوم 10:15 ص',
      detailEn: 'Settlement for request #SRV-3042 • Today 10:15 AM',
      action: 'تفاصيل الفاتورة',
      actionEn: 'Invoice details',
      icon: Icons.handyman_outlined,
      tone: AppColors.hexFF2563EB,
    ),
    _CommissionTransaction(
      amount: '+ 15.00',
      code: '#TX-COMM-9925',
      filterKey: 'providers',
      status: 'لوجستي وتوصيل',
      statusEn: 'Delivery & logistics',
      title: 'مندوب معتمد: فيصل الشهري',
      titleEn: 'Verified courier: Faisal Al-Shehri',
      description:
          'رسم تشغيل منصة التوصيل الميداني (10% من مشوار توصيل طلب #ORD-881)',
      descriptionEn:
          'Delivery platform service fee (10% of order #ORD-881 trip)',
      detail:
          'مُحصلة تلقائيًا من محفظة السائق بعد تسليم الشحنة • اليوم 09:30 ص',
      detailEn: 'Collected from courier wallet after delivery • Today 9:30 AM',
      action: 'سند المحفظة',
      actionEn: 'Wallet voucher',
      icon: Icons.local_shipping_outlined,
      tone: AppColors.hexFFB45309,
    ),
    _CommissionTransaction(
      amount: '+ 210.00',
      code: '#TX-COMM-9924',
      filterKey: 'merchants',
      status: 'ضمان وأمان',
      statusEn: 'Escrow & protection',
      title: 'صفقة مستعملة - كاميرا كانون احترافية',
      titleEn: 'Used item sale - Canon professional camera',
      description: 'رسوم وساطة وفحص وضمان وصيانة (5% من قيمة الصفقة 4,200 ج.م)',
      descriptionEn:
          'Brokerage, inspection, and protection fee (5% of 4,200 Egy sale)',
      detail:
          'محررة من حساب الضمان البنكي (Escrow) بعد استلام المشتري • أمس 08:20 م',
      detailEn: 'Released from escrow after buyer receipt • Yesterday 8:20 PM',
      action: 'عقد الوساطة',
      actionEn: 'Brokerage agreement',
      icon: Icons.lock_outline_rounded,
      tone: AppColors.hexFF9333EA,
    ),
  ];

  List<_CommissionTransaction> get _visibleTransactions {
    if (_selectedFilter == 'all') return _transactions;
    return _transactions
        .where((item) => item.filterKey == _selectedFilter)
        .toList();
  }

  String _text(String arabic, String english) =>
      AppLocalizations.of(context)!.localeName == 'ar' ? arabic : english;

  _RevenuePeriodData get _selectedRevenuePeriod =>
      _revenuePeriods[_periodIndex];

  Widget _buildSampleDataNotice() => Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color:  AppColors.textPrimary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:  AppColors.hexFFE8C96A),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 17, color: AppColors.hexFF8A6410),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _text(
                  'الأرقام والحركات هنا توضيحية ثابتة وليست بيانات عمولات مباشرة.',
                  'Amounts and entries shown here are static examples, not live commission data.',
                ),
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.4,
                  color: AppColors.hexFF72540D,
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _copyCommissionReport(bool isArabic) async {
    final rows = <List<String>>[
      ['reference', 'title', 'category', 'amount', 'description', 'detail'],
      ..._visibleTransactions.map((item) => [
            item.code,
            isArabic ? item.title : item.titleEn,
            item.filterKey,
            item.amount,
            isArabic ? item.description : item.descriptionEn,
            isArabic ? item.detail : item.detailEn,
          ]),
    ];
    final csv = rows
        .map((row) => row
            .map((value) => '"${value.replaceAll('"', '""')}"')
            .join(','))
        .join('\n');
    await Clipboard.setData(ClipboardData(text: csv));
    if (!mounted) return;
    AppSnackBar.showSuccess(
      context,
      _text('تم نسخ الحركات الظاهرة بصيغة CSV.',
          'Visible entries copied as CSV.'),
    );
  }

  void _explainBankConnection() {
    AppSnackBar.showInfo(
      context,
      _text(
        'مطابقة كشف البنك غير مفعلة لعدم وجود اتصال بنكي أو استيراد كشف في التطبيق.',
        'Bank-statement matching is unavailable until a bank connection or statement import is configured.',
      ),
    );
  }

  String _formatRevenue(double value) =>
      NumberFormat('#,##0', 'en_US').format(value);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context)!.localeName == 'ar';
    super.build(context);
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: FinanceSwipeNavigation(
        currentIndex: 1,
        enabled: widget.showBottomNavigation,
        child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              children: [
                if (widget.showBottomNavigation) _buildBrandHeader(isArabic),
                const SizedBox(height: 10),
                _buildLiveStatus(isArabic),
                const SizedBox(height: 14),
                Text(
                  _text('صافي الإيراد الرقابي وعمليات التطبيق',
                      'Net controlled revenue and app transactions'),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _text(
                      'عرض توضيحي للإيرادات والعمولات حسب الفترة والقطاع',
                      'Sample view of revenue and commissions by period and sector'),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSampleDataNotice(),
                const SizedBox(height: 12),
                _buildPeriodSelector(isArabic),
                const SizedBox(height: 10),
                _buildRevenueCard(isArabic),
                const SizedBox(height: 24),
                _buildSectionTitle(
                    _text('توزيع الإيراد الرقابي حسب القطاع',
                        'Controlled revenue by sector'),
                    _text('بيانات توضيحية', 'Sample data')),
                const SizedBox(height: 10),
                _buildSectors(isArabic),
                const SizedBox(height: 20),
                _buildFilters(isArabic),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _text('أمثلة على حركات العمولات',
                            'Sample commission entries'),
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.receipt_long_outlined,
                        size: 19, color: AppColors.primaryDark),
                  ],
                ),
                const SizedBox(height: 10),
                ..._visibleTransactions.map(
                  (transaction) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TransactionCard(
                        transaction: transaction, isArabic: isArabic),
                  ),
                ),
                const SizedBox(height: 14),
                _buildAuditPanel(isArabic),
              ],
            ),
          ),
          bottomNavigationBar: widget.showBottomNavigation
              ? _buildBottomNavigation(context)
              : null,
        ),
      ),
    );
  }

  Widget _buildBrandHeader(bool isArabic) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 62,
      color: AppColors.white,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.person_outline, color: AppColors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color:  AppColors.textPrimary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      isArabic
                          ? 'مدقق مالي معتمد'
                          : 'Certified financial auditor',
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.primaryDark)),
                  const SizedBox(width: 4),
                  const Icon(Icons.verified_user_outlined,
                      size: 12, color: AppColors.info),
                ],
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(l10n.appName,
                    style: const TextStyle(
                        fontSize: 17,
                        height: 1.1,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold)),
                Text(l10n.financialDepartment,
                    style: const TextStyle(
                        fontSize: 9, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              width: 29,
              height: 29,
              decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.shield_outlined,
                  color: AppColors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatus(bool isArabic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
          color:  AppColors.hexFFE9ECEF,
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const CircleAvatar(radius: 3, backgroundColor: AppColors.warning),
          const SizedBox(width: 6),
          Text(
            isArabic
                ? 'بيانات توضيحية حسب الفترة المختارة'
                : 'Sample data for selected period',
            style: const TextStyle(fontSize: 10, color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(bool isArabic) {
    final period = _selectedRevenuePeriod;
    final percentage = period.changePercentage;
    final percentageLabel =
        '${percentage >= 0 ? '+' : ''}${percentage.toStringAsFixed(1)}% ↗';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.hexFF0C2140, AppColors.hexFF07172C],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: AppColors.hex2207182D, blurRadius: 14, offset: Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined,
                  size: 18, color: AppColors.white),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(
                      isArabic
                          ? 'إجمالي العمولة التوضيحي'
                          : 'Sample commission total',
                      style: const TextStyle(
                          color: AppColors.white70, fontSize: 11))),
              _pill(percentageLabel,  AppColors.hexFF0E4B4B,
                   AppColors.hexFF61E3B0),
            ],
          ),
          const SizedBox(height: 14),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: _formatRevenue(period.total),
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: isArabic ? ' ج.م' : ' Egy',
                  style: const TextStyle(color: AppColors.white70, fontSize: 15)),
            ]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            _text('دخل العمولات خلال الفترة المختارة',
                'Commission income during selected period'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.hexFF91A9C3, fontSize: 9),
          ),
          SizedBox(
            height: 48,
            child: CustomPaint(
              painter: _TrendPainter(values: period.values),
              child: const SizedBox.expand(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
                color:  AppColors.hexFF263B53,
                borderRadius: BorderRadius.circular(11)),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined,
                    size: 17, color: AppColors.hexFF61E3B0),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                        isArabic
                            ? 'مثال توضيحي لمبلغ ضمان الاستخدام الآمن\nليس رصيدًا حقيقيًا أو التزامًا ماليًا'
                            : 'Sample secure-use guarantee amount\nNot a real balance or financial liability',
                        style: const TextStyle(
                            color: AppColors.white, fontSize: 9, height: 1.4))),
                const SizedBox(width: 8),
                _pill(isArabic ? '38,500 ج.م' : '38,500 Egy',
                     AppColors.hexFF37516A,  AppColors.hexFF61E3B0),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 14, color: AppColors.hexFF21D6A0),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  isArabic
                      ? 'عدد الاستقطاعات في البيانات التوضيحية'
                      : 'Deductions in sample data',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: AppColors.hexFF91A9C3),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  isArabic
                      ? 'السابق: ${_formatRevenue(period.previousTotal)} ج.م'
                      : 'Previous: ${_formatRevenue(period.previousTotal)} Egy',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 9, color: AppColors.hexFF91A9C3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String trailing) {
    return Row(
      children: [
        Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark))),
        Text(trailing,
            style: const TextStyle(fontSize: 9, color: AppColors.info)),
      ],
    );
  }

  Widget _buildSectors(bool isArabic) {
    final currency = isArabic ? 'ج.م' : 'Egy';
    return Column(
      children: [
        Row(children: [
          Expanded(
              child: _SectorCard(
                  title: isArabic
                      ? 'عمولات التجار والمتاجر'
                      : 'Merchant & store commissions',
                  value: '142,600',
                  percentage: '50.1%',
                  icon: Icons.storefront_outlined,
                  color:  AppColors.hexFF173C78,
                  currency: currency)),
          const SizedBox(width: 8),
          Expanded(
              child: _SectorCard(
                  title: isArabic
                      ? 'عمولات الصيانة والخدمات'
                      : 'Maintenance & service commissions',
                  value: '78,350',
                  percentage: '27.5%',
                  icon: Icons.home_repair_service_outlined,
                  color:  AppColors.hexFF315A9A,
                  currency: currency)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
              child: _SectorCard(
                  title: isArabic
                      ? 'حسابات المستفيدين ووطن'
                      : 'Beneficiary accounts & Watan',
                  value: '39,150',
                  percentage: '13.7%',
                  icon: Icons.handshake_outlined,
                  color:  AppColors.hexFF8B27C9,
                  currency: currency)),
          const SizedBox(width: 8),
          Expanded(
              child: _SectorCard(
                  title: isArabic
                      ? 'مندوب التوصيل واللوجستيات'
                      : 'Courier & logistics',
                  value: '24,800',
                  percentage: '8.7%',
                  icon: Icons.local_shipping_outlined,
                  color:  AppColors.hexFFB45309,
                  currency: currency)),
        ]),
        const SizedBox(height: 8),
        _SectorCard(
            title: isArabic
                ? 'اشتراكات الحسابات والترقيات'
                : 'Subscriptions & account upgrades',
            value: '31,900',
            percentage: '11.2%',
            icon: Icons.workspace_premium_outlined,
            color:  AppColors.hexFF059669,
            wide: true,
            currency: currency),
      ],
    );
  }

  Widget _buildPeriodSelector(bool isArabic) {
    final periods = isArabic
        ? ['اليوم', 'هذا الأسبوع', 'هذا الشهر', 'الربع المالي']
        : ['Today', 'This week', 'This month', 'This quarter'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color:  AppColors.hexFFE9ECEF,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: List.generate(periods.length, (index) {
          final selected = index == _periodIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _periodIndex = index),
              child: Container(
                constraints: const BoxConstraints(minHeight: 34),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: selected ? AppColors.white : AppColors.transparent,
                    borderRadius: BorderRadius.circular(9)),
                child: Text(periods[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        color: selected
                            ? AppColors.primaryDark
                            : AppColors.textSecondary)),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFilters(bool isArabic) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: _filters.map((filter) {
          final selected = filter.$1 == _selectedFilter;
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 6),
            child: ChoiceChip(
              label: Text(isArabic ? filter.$2 : filter.$3,
                  style: TextStyle(
                      fontSize: 10,
                      color:
                          selected ? AppColors.white : AppColors.textSecondary)),
              selected: selected,
              showCheckmark: false,
              onSelected: (_) => setState(() => _selectedFilter = filter.$1),
              backgroundColor: AppColors.white,
              selectedColor: AppColors.primaryDark,
              side: BorderSide(
                  color: selected
                      ? AppColors.primaryDark
                      :  AppColors.hexFFE6EAF0),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              visualDensity: VisualDensity.compact,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAuditPanel(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: AppColors.hex12000000, blurRadius: 6, offset: Offset(0, 2))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                      isArabic
                          ? 'التدقيق الحسابي ومطابقة الحساب الوسيط'
                          : 'Accounting audit and escrow reconciliation',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark))),
              Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color:  AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.verified_outlined,
                      color: AppColors.hexFFB45309)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
              isArabic
                  ? 'بيانات هذه الشاشة توضيحية. لا يوجد حاليًا اتصال بكشف البنك أو مصدر مباشر لحركات العمولات.'
                  : 'This screen uses sample data. No bank-statement connection or live commission feed is configured.',
              style: const TextStyle(
                  fontSize: 10, height: 1.6, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => _copyCommissionReport(isArabic),
            icon: const Icon(Icons.download_rounded, size: 17),
            label: Text(isArabic
                ? 'نسخ الحركات الظاهرة بصيغة CSV'
                : 'Copy visible entries as CSV'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.white,
                minimumSize: const Size.fromHeight(42),
                textStyle:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _explainBankConnection,
            icon: const Icon(Icons.compare_arrows_rounded, size: 18),
            label: Text(isArabic
                ? 'حالة اتصال كشف البنك'
                : 'Bank-statement connection status'),
            style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                backgroundColor:  AppColors.surface,
                side: BorderSide.none,
                minimumSize: const Size.fromHeight(42),
                textStyle:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return const FinanceBottomNavigationBar(currentIndex: 1);
  }
}

Widget _pill(String label, Color background, Color foreground) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 132),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
        color: background, borderRadius: BorderRadius.circular(12)),
    child: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: foreground, fontSize: 9, fontWeight: FontWeight.bold),
    ),
  );
}

class _SectorCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final IconData icon;
  final Color color;
  final String currency;
  final bool wide;

  const _SectorCard(
      {required this.title,
      required this.value,
      required this.percentage,
      required this.icon,
      required this.color,
      required this.currency,
      this.wide = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 94),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color:  AppColors.hexFFE9EDF2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, size: 16, color: color)),
              const Spacer(),
              Text(percentage,
                  style: TextStyle(
                      fontSize: 9, color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: Text(title,
                      maxLines: wide ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 9,
                          height: 1.3,
                          color: AppColors.textSecondary))),
              const SizedBox(width: 8),
              Text('$value\n$currency',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 14,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommissionTransaction {
  final String amount;
  final String code;
  final String filterKey;
  final String status;
  final String statusEn;
  final String title;
  final String titleEn;
  final String description;
  final String descriptionEn;
  final String detail;
  final String detailEn;
  final String action;
  final String actionEn;
  final IconData icon;
  final Color tone;

  const _CommissionTransaction(
      {required this.amount,
      required this.code,
      required this.filterKey,
      required this.status,
      required this.statusEn,
      required this.title,
      required this.titleEn,
      required this.description,
      required this.descriptionEn,
      required this.detail,
      required this.detailEn,
      required this.action,
      required this.actionEn,
      required this.icon,
      required this.tone});
}

class _TransactionCard extends StatelessWidget {
  final _CommissionTransaction transaction;
  final bool isArabic;

  const _TransactionCard({required this.transaction, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color:  AppColors.hexFFE9EDF2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: transaction.amount,
                    style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.hexFF00865F,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: isArabic ? '  ج.م' : '  Egy',
                    style: const TextStyle(
                        fontSize: 9, color: AppColors.textSecondary))
              ])),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  transaction.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.hexFF434B55,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: _pill(
                  isArabic ? transaction.status : transaction.statusEn,
                  transaction.tone.withValues(alpha: 0.1),
                  transaction.tone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(isArabic ? transaction.title : transaction.titleEn,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark)),
          const SizedBox(height: 4),
          Text(isArabic ? transaction.description : transaction.descriptionEn,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                  fontSize: 10, height: 1.55, color: AppColors.textSecondary)),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 9),
              child: Divider(height: 1, color: AppColors.hexFFE9EDF2)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(transaction.icon, size: 13, color: transaction.tone),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(
                      isArabic ? transaction.detail : transaction.detailEn,
                      style: const TextStyle(
                          fontSize: 9,
                          height: 1.5,
                          color: AppColors.textSecondary))),
            ],
          ),
          const SizedBox(height: 9),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 28,
              child: ElevatedButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(isArabic
                        ? 'تفاصيل الحركة التوضيحية'
                        : 'Sample transaction details'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(transaction.code),
                        const SizedBox(height: 8),
                        Text(isArabic ? transaction.title : transaction.titleEn),
                        const SizedBox(height: 8),
                        Text(isArabic
                            ? transaction.description
                            : transaction.descriptionEn),
                        const SizedBox(height: 8),
                        Text(isArabic ? transaction.detail : transaction.detailEn),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(isArabic ? 'إغلاق' : 'Close'),
                      ),
                    ],
                  ),
                ),
                icon: const Icon(Icons.receipt_long_outlined, size: 13),
                label: Text(
                    isArabic ? transaction.action : transaction.actionEn,
                    style: const TextStyle(fontSize: 9)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenuePeriodData {
  final List<double> values;
  final double previousTotal;

  const _RevenuePeriodData({
    required this.values,
    required this.previousTotal,
  });

  double get total => values.fold(0, (sum, value) => sum + value);

  double get changePercentage =>
      previousTotal == 0 ? 0 : (total - previousTotal) / previousTotal * 100;
}

class _TrendPainter extends CustomPainter {
  final List<double> values;

  const _TrendPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.isEmpty) return;

    const horizontalInset = 4.0;
    const verticalInset = 5.0;
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final valueRange = maxValue - minValue;
    final points = List<Offset>.generate(values.length, (index) {
      final x = horizontalInset +
          (size.width - horizontalInset * 2) * index / (values.length - 1);
      final normalized =
          valueRange == 0 ? 0.5 : (values[index] - minValue) / valueRange;
      final y =
          verticalInset + (size.height - verticalInset * 2) * (1 - normalized);
      return Offset(x, y);
    });

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final middleX = (previous.dx + current.dx) / 2;
      linePath.quadraticBezierTo(
          middleX, previous.dy, middleX, (previous.dy + current.dy) / 2);
      linePath.quadraticBezierTo(middleX, current.dy, current.dx, current.dy);
    }

    final areaPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();
    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.hex3355A5FF, AppColors.hex0055A5FF],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      linePath,
      Paint()
        ..color =  AppColors.hexFF55A5FF
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawCircle(
        points[i],
        2,
        Paint()..color =  AppColors.hexFF9CCBFF,
      );
    }
    canvas.drawCircle(
      points.last,
      3.2,
      Paint()..color =  AppColors.hexFF2DD4A4,
    );
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.values != values;
}
