import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CommissionsScreen extends StatelessWidget {
  const CommissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.person_outline, color: Colors.white, size: 18),
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
          colors: [Color(0xFF0F1F3D), Color(0xFF0A142A)],
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
              const Icon(Icons.percent_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'إجمالي العمولات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up_rounded, color: Color(0xFF7AE7A8), size: 12),
                    SizedBox(width: 4),
                    Text(
                      '+14.2%',
                      style: TextStyle(
                        color: Color(0xFF7AE7A8),
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
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' ر.س',
                    style: TextStyle(
                      color: Colors.white70,
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
                  value: '38,500 ر.س',
                  color: const Color(0xFF7AE7A8),
                  icon: Icons.savings_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniInfo(
                  title: 'المعاملات',
                  value: '3,245',
                  color: const Color(0xFFBEE3FF),
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
      _StatCard(title: 'عائدات نهاية الشهر', value: '78,350 ر.س', icon: Icons.trending_up_rounded, tone: AppColors.infoLight),
      _StatCard(title: 'عمولات المنصة', value: '142,600 ر.س', icon: Icons.dashboard_rounded, tone: AppColors.surfaceLight),
      _StatCard(title: 'خصم الخدمة', value: '39,150 ر.س', icon: Icons.receipt_long_rounded, tone: AppColors.successLight),
      _StatCard(title: 'إيرادات التجزئة', value: '31,900 ر.س', icon: Icons.bar_chart_rounded, tone: AppColors.warningLight),
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
        color: const Color(0xFFE5EAF2),
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
                foregroundColor: Colors.white,
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
}

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
        color: Colors.white,
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
              const Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: AppColors.textSecondary),
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
        color: Colors.white.withValues(alpha: 0.08),
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
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
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

class _CommissionCard extends StatelessWidget {
  final _CommissionRow row;

  const _CommissionCard({required this.row});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: const Icon(Icons.monetization_on_rounded, color: AppColors.primaryDark, size: 20),
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
                  style: TextStyle(
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
              const Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}
