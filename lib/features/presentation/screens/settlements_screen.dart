import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class SettlementsScreen extends StatefulWidget {
  const SettlementsScreen({super.key});

  @override
  State<SettlementsScreen> createState() => _SettlementsScreenState();
}

class _SettlementsScreenState extends State<SettlementsScreen> {
  static const _filters = ['الكل', 'قيد المراجعة', 'معتمدة', 'قيد نزاع'];

  static const _requests = [
    _SettlementRequest(
      id: '#SETTL-2024-098',
      name: 'د. طارق العمري',
      description: 'حساب بنكي موثق',
      amount: '1,200.00',
      reference: 'CMP-1035#',
      referenceTitle: 'نزاع صيانة',
      badge: 'استرداد مالي كامل',
      status: 'قيد المراجعة',
      initials: 'ط',
      age: 'منذ 35 دقيقة',
      color: Color(0xFFFFD9D6),
      badgeColor: AppColors.danger,
    ),
    _SettlementRequest(
      id: '#SETTL-2024-102',
      name: 'مؤسسة الضمان العقارية',
      description: 'شريك معتمد - سجل تجاري',
      amount: '485.50',
      reference: 'SYS-882#',
      referenceTitle: 'تصحيح عمولة',
      badge: 'تسوية عمولة',
      status: 'معتمدة',
      initials: 'ض',
      age: 'منذ ساعتين',
      color: Color(0xFFE8F0FF),
      badgeColor: Color(0xFF8AB4FF),
    ),
    _SettlementRequest(
      id: '#SETTL-2024-105',
      name: 'خالد المهيوب',
      description: 'مزود خدمة مستقل',
      amount: '850.00',
      reference: 'PRV-411#',
      referenceTitle: 'تسليم وساطة',
      badge: 'خصم جزائي',
      status: 'قيد نزاع',
      initials: 'خ',
      age: 'اليوم 08:30 ص',
      color: Color(0xFFE9ECEF),
      badgeColor: Color(0xFFFFD9D6),
    ),
  ];

  static const _recentSettlements = [
    _RecentSettlement(
      title: 'استرداد بنكي',
      description: 'العميل #USR-8810 - بنك البلاد',
      amount: '450.00',
      id: '#097',
      time: 'اليوم 11:30 ص',
    ),
    _RecentSettlement(
      title: 'تسوية تعويضية',
      description: 'مزود الخدمة - تصحيح عمولة',
      amount: '120.00',
      id: '#096',
      time: 'أمس 09:15 م',
    ),
  ];

  String _selectedFilter = _filters.first;

  List<_SettlementRequest> get _filteredRequests {
    if (_selectedFilter == 'الكل') return _requests;
    return _requests
        .where((request) => request.status == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          scrolledUnderElevation: 0,
          leading: IconButton(
            tooltip: isArabic ? 'العودة' : 'Back',
            icon: Icon(
              isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
              size: 19,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            children: [
              Text(
                isArabic ? 'إدارة التسويات' : 'Settlements Management',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                isArabic ? 'برواح المازوري - الإدارة المالية' : 'Barwah Mazouri - Finance Management',
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryDark,
                child:
                    Icon(Icons.person_outline, color: Colors.white, size: 17),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildBalances(),
            const SizedBox(height: 14),
            _buildAddSettlementAction(),
            const SizedBox(height: 14),
            _buildFilters(),
            const SizedBox(height: 16),
            _buildRequestsHeader(),
            const SizedBox(height: 8),
            ..._filteredRequests.map(_buildRequestCard),
            const SizedBox(height: 14),
            _buildRecentSettlementsHeader(),
            const SizedBox(height: 8),
            ..._recentSettlements.map(_buildRecentSettlement),
            const SizedBox(height: 8),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: 2,
          selectedItemColor: AppColors.primaryDark,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          elevation: 16,
          onTap: (index) {
            if (index == 4) Navigator.pop(context);
          },
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.history_edu, size: 24),
                label: isArabic ? 'التدقيق' : 'Audit'),
            BottomNavigationBarItem(
                icon: const Icon(Icons.percent, size: 24),
                label: isArabic ? 'العمولات' : 'Commissions'),
            BottomNavigationBarItem(
                icon: const Icon(Icons.sync_alt, size: 24),
                label: isArabic ? 'التسويات' : 'Settlements'),
            BottomNavigationBarItem(
                icon: const Icon(Icons.fact_check_outlined, size: 24),
                label: isArabic ? 'المطابقة' : 'Reconciliation'),
            BottomNavigationBarItem(
                icon: const Icon(Icons.account_balance, size: 24),
                label: isArabic ? 'الرئيسية' : 'Home'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isArabic = AppLocalizations.of(context)!.localeName == 'ar';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user_outlined,
                          color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          isArabic ? 'صلاحيات المدير المالي التنفيذي' : 'Executive CFO Authority',
                          style: const TextStyle(color: Colors.white, fontSize: 9),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                isArabic ? 'سجل #SETTL-2024-098' : 'Record #SETTL-2024-098',
                style: const TextStyle(color: Colors.white70, fontSize: 8),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isArabic ? 'إدارة المحافظ الإلكترونية والتسويات' : 'Digital Wallets & Settlement Management',
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
                color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            isArabic
                ? 'تنفيذ حركات النقود المالية المصرح بها مع إرفاق السند القانوني ومحضر النزاع المالي المعتمد.'
                : 'Execution of approved financial cash movements with attached legal evidence and approved dispute record.',
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(color: Colors.white70, fontSize: 9, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildBalances() {
    return Row(
      children: [
        Expanded(
          child: _buildBalanceCard(
            title: 'محفظة الضمان (Escrow)',
            amount: '148,650.00',
            subtitle: 'محجوز لأوامر نشطة',
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildBalanceCard(
            title: 'رصيد التسويات المعلقة',
            amount: '1,200.00',
            subtitle: 'طلب استرداد جاهز للإقفال',
            icon: Icons.pending_actions,
            color: AppColors.danger,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard({
    required String title,
    required String amount,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 92),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            amount,
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 8, color: AppColors.info),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSettlementAction() {
    return Material(
      color: AppColors.primaryDark,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('إضافة تسوية جديدة')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'إضافة تسوية جديدة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'استرداد / تسوية فورية',
                  style: TextStyle(color: Colors.white70, fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      alignment: WrapAlignment.start,
      children: _filters.map((filter) {
        final isSelected = filter == _selectedFilter;
        return ChoiceChip(
          label: Text(filter),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedFilter = filter),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 9,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: AppColors.surfaceLight,
          selectedColor: AppColors.primaryDark,
          side: BorderSide.none,
          visualDensity: VisualDensity.compact,
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        );
      }).toList(),
    );
  }

  Widget _buildRequestsHeader() {
    return Row(
      children: [
        const Icon(Icons.assignment_outlined, color: AppColors.info, size: 17),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'طلبات التسوية المعلقة',
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark),
          ),
        ),
        Text(
          '${_filteredRequests.length} طلبات',
          style: const TextStyle(fontSize: 9, color: AppColors.info),
        ),
      ],
    );
  }

  Widget _buildRequestCard(_SettlementRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildTag(request.badge, request.badgeColor),
              const SizedBox(width: 5),
              _buildTag(request.status, AppColors.surfaceLight,
                  textColor: AppColors.infoDark),
              const Spacer(),
              Text(
                request.id,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: request.color,
                child: Text(
                  request.initials,
                  style: const TextStyle(
                      color: AppColors.infoDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      request.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark),
                    ),
                    Text(
                      request.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 8, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${request.amount} ر.س',
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark),
                  ),
                  Text(request.age,
                      style:
                          const TextStyle(fontSize: 8, color: AppColors.info)),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: Divider(height: 1, color: AppColors.surfaceLight),
          ),
          Row(
            children: [
              _buildTag('${request.referenceTitle} ${request.reference}',
                  AppColors.surfaceLight,
                  textColor: AppColors.infoDark),
              const Spacer(),
              const Icon(Icons.arrow_back,
                  size: 14, color: AppColors.primaryDark),
              const SizedBox(width: 3),
              const Text('عرض',
                  style: TextStyle(fontSize: 9, color: AppColors.primaryDark)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color,
      {Color textColor = AppColors.primaryDark}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 8, color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildRecentSettlementsHeader() {
    return Row(
      children: [
        const Icon(Icons.history, color: AppColors.info, size: 17),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'آخر التسويات المنفذة حديثاً',
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark),
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, minimumSize: const Size(40, 30)),
          child: const Text('عرض الكل', style: TextStyle(fontSize: 9)),
        ),
      ],
    );
  }

  Widget _buildRecentSettlement(_RecentSettlement settlement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              color: AppColors.info, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(settlement.title,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold)),
                Text(settlement.description,
                    style: const TextStyle(
                        fontSize: 8, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${settlement.amount} ر.س',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold)),
              Text(settlement.time,
                  style: const TextStyle(
                      fontSize: 8, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(width: 5),
          Text(settlement.id,
              style: const TextStyle(fontSize: 8, color: AppColors.info)),
        ],
      ),
    );
  }
}

class _SettlementRequest {
  final String id;
  final String name;
  final String description;
  final String amount;
  final String reference;
  final String referenceTitle;
  final String badge;
  final String status;
  final String initials;
  final String age;
  final Color color;
  final Color badgeColor;

  const _SettlementRequest({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.reference,
    required this.referenceTitle,
    required this.badge,
    required this.status,
    required this.initials,
    required this.age,
    required this.color,
    required this.badgeColor,
  });
}

class _RecentSettlement {
  final String title;
  final String description;
  final String amount;
  final String id;
  final String time;

  const _RecentSettlement({
    required this.title,
    required this.description,
    required this.amount,
    required this.id,
    required this.time,
  });
}
