import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/app_localizations.dart';
import 'transaction_history_screen.dart';

enum DepartmentType { merchants, usedEscrow, services, couriers }

class DepartmentWalletScreen extends StatelessWidget {
  final DepartmentType type;

  const DepartmentWalletScreen({super.key, required this.type});

  String _screenTitleFor(BuildContext context) {
    final isArabic = AppLocalizations.of(context)!.localeName == 'ar';

    switch (type) {
      case DepartmentType.merchants:
        return isArabic
            ? 'محفظة قسم التجار والمتاجر'
            : 'Merchants & Retail Wallet';
      case DepartmentType.usedEscrow:
        return isArabic
            ? 'محفظة المستعمل وعربون «وصلني»'
            : 'Used Escrow & Waslni Wallet';
      case DepartmentType.services:
        return isArabic
            ? 'محفظة طلبات الخدمات والصيانة'
            : 'Service Requests & Maintenance Wallet';
      case DepartmentType.couriers:
        return isArabic
            ? 'محفظة مناديب التوصيل واللوجستيات'
            : 'Delivery Agents & Logistics Wallet';
    }
  }

  double get _totalBalance {
    switch (type) {
      case DepartmentType.merchants:
        return 2150000.00;
      case DepartmentType.usedEscrow:
        return 980000.00;
      case DepartmentType.services:
        return 620000.00;
      case DepartmentType.couriers:
        return 450000.00;
    }
  }

  Map<String, String> get _stats {
    switch (type) {
      case DepartmentType.merchants:
        return {
          'المتاجر النشطة': '142',
          'طلبات معلقة': '8 (94.5 ألف)',
          'عمولة المنصة': '4.5%',
          'icon1': 'storefront',
        };
      case DepartmentType.usedEscrow:
        return {
          'صفقات نشطة': '85',
          'نزاعات': '3 (12.4 ألف)',
          'رسوم حماية': '1.5%',
          'icon1': 'handshake',
        };
      case DepartmentType.services:
        return {
          'مزودي خدمات': '320',
          'طلبات معلقة': '15 (45.2 ألف)',
          'عمولة المنصة': '8.0%',
          'icon1': 'build',
        };
      case DepartmentType.couriers:
        return {
          'مناديب نشطين': '1,200',
          'مستحقات معلقة': '45 (18 ألف)',
          'رسوم شحنة': '3 EGP',
          'icon1': 'local_shipping',
        };
    }
  }

  List<Map<String, dynamic>> get _listItems {
    switch (type) {
      case DepartmentType.merchants:
        return [
          {
            'title': 'مؤسسة الأفق للتقنية والتجارة',
            'id': 'سجل: 1010892341   #TRD-9041',
            'available': 412800.00,
            'pending': 12500.00,
            'operations': '1,842',
            'bankText': 'تسوية سريعة',
            'bankIcon': Icons.flash_on,
            'status': 'نشط ومطابق',
          },
          {
            'title': 'متجر الصفوة الذهبي',
            'id': 'سجل: 1010459810   #TRD-8820',
            'available': 325400.00,
            'pending': 24000.00,
            'operations': '965',
            'bankText': 'بنك الراجحي',
            'bankIcon': Icons.account_balance,
            'status': 'نشط ومطابق',
          },
          {
            'title': 'مجوهرات البريق الراقية',
            'id': 'سجل: 1010334992   #TRD-7104',
            'available': 184200.00,
            'pending': 58000.00,
            'operations': '420',
            'bankText': 'دفعة بنكية مجدولة',
            'bankIcon': Icons.sync,
            'status': 'نشط ومطابق',
          },
          {
            'title': 'دار النخبة للأجهزة',
            'id': 'سجل: 1010198421   #TRD-6519',
            'available': 98600.00,
            'pending': 0.00,
            'operations': '312',
            'bankText': 'البنك الأهلي',
            'bankIcon': Icons.account_balance,
            'status': 'نشط ومطابق',
          },
        ];
      case DepartmentType.usedEscrow:
        return [
          {
            'title': 'سيارة تويوتا كامري 2020',
            'id': 'عربون تأمين #ESC-1092',
            'available': 5000.00,
            'pending': 0.00,
            'operations': '1',
            'bankText': 'قيد المعاينة',
            'bankIcon': Icons.visibility,
            'status': 'ضمان محفوظ',
          },
          {
            'title': 'آيفون 14 برو ماكس',
            'id': 'عربون تأمين #ESC-3321',
            'available': 500.00,
            'pending': 0.00,
            'operations': '1',
            'bankText': 'قيد الشحن',
            'bankIcon': Icons.local_shipping,
            'status': 'ضمان محفوظ',
          },
        ];
      case DepartmentType.services:
        return [
          {
            'title': 'مؤسسة إتقان للتكييف',
            'id': 'رخصة: 88214   #SRV-901',
            'available': 25400.00,
            'pending': 3200.00,
            'operations': '142',
            'bankText': 'تسوية سريعة',
            'bankIcon': Icons.flash_on,
            'status': 'مزود معتمد',
          },
          {
            'title': 'شركة الصيانة الشاملة',
            'id': 'رخصة: 11029   #SRV-412',
            'available': 18500.00,
            'pending': 0.00,
            'operations': '89',
            'bankText': 'البنك الأهلي',
            'bankIcon': Icons.account_balance,
            'status': 'مزود معتمد',
          },
        ];
      case DepartmentType.couriers:
        return [
          {
            'title': 'شركة زاجل للشحن',
            'id': 'سجل: 40301122   #DEL-551',
            'available': 145000.00,
            'pending': 12000.00,
            'operations': '14,200',
            'bankText': 'تسوية أسبوعية',
            'bankIcon': Icons.calendar_today,
            'status': 'شريك استراتيجي',
          },
          {
            'title': 'مندوب أسطول وصلني (محمد أحمد)',
            'id': 'رقم المندوب: #C-1902',
            'available': 450.00,
            'pending': 120.00,
            'operations': '45',
            'bankText': 'STC Pay',
            'bankIcon': Icons.account_balance_wallet,
            'status': 'مندوب نشط',
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context)!.localeName == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceLight,
              child: Icon(Icons.person_outline, color: AppColors.primaryDark),
            ),
          ),
          title: Text(
            _screenTitleFor(context),
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: AppColors.textPrimary,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // 1. Top Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryExtraDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_balance_wallet,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(_screenTitleFor(context),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Text('مدقق ومعتمد',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 9)),
                              SizedBox(width: 4),
                              Icon(Icons.verified,
                                  color: Colors.blueAccent, size: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('إجمالي الرصيد التجميعي المتاح للتسوية والسحب',
                        style: TextStyle(color: Colors.white60, fontSize: 11)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(_totalBalance,
                              includeCurrency: false),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        ),
                        const SizedBox(width: 6),
                        Text(AppLocalizations.of(context)!.currencySar,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                        height: 1, color: Colors.white.withValues(alpha: 0.1)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_stats.keys.elementAt(0),
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 10)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(_stats.values.elementAt(0),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 4),
                                  Icon(_getIconData(_stats['icon1']!),
                                      color: Colors.white60, size: 14),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_stats.keys.elementAt(1),
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 10)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(_stats.values.elementAt(1).split(' ')[0],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.assignment_late_outlined,
                                      color: Colors.white60, size: 14),
                                ],
                              ),
                              if (_stats.values.elementAt(1).contains('('))
                                Text(
                                    _stats.values.elementAt(1).substring(_stats
                                        .values
                                        .elementAt(1)
                                        .indexOf('(')),
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 9)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(_stats.keys.elementAt(2),
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 10)),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(_stats.values.elementAt(2),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.pie_chart_outline,
                                      color: Colors.white60, size: 14),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.tune, color: AppColors.primaryDark, size: 18),
                      SizedBox(width: 8),
                      Text('الرقابة وحسابات المتاجر',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Text('سداد و سريع متزامنة',
                        style: TextStyle(
                            fontSize: 9, color: AppColors.textSecondary)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('الكل 142', true),
                    const SizedBox(width: 8),
                    _buildFilterChip('أعلى رصيد', false,
                        icon: Icons.trending_up),
                    const SizedBox(width: 8),
                    _buildFilterChip('قيد السحب (8)', false,
                        icon: Icons.hourglass_empty),
                    const SizedBox(width: 8),
                    _buildFilterChip('', false,
                        icon: Icons.lock_outline, isIconOnly: true),
                    const SizedBox(width: 8),
                    _buildFilterChip('', false,
                        icon: Icons.warning_amber_rounded,
                        isIconOnly: true,
                        iconColor: AppColors.danger),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. List Items
              ..._listItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildListItemCard(context, item),
                  )),

              // 5. Bottom Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('حوكمة التسويات والضوابط البنكية (CFO)',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark)),
                        const SizedBox(width: 8),
                        Icon(Icons.verified_user_outlined,
                            color: Colors.blue.shade700, size: 18),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'تخضع جميع تحويلات المحفظة لمطابقة يومية تلقائية مع شبكة "سريع" للمدفوعات الفورية ونظام "سداد"، وفقاً لتعليمات البنك المركزي السعودي يتم حجز العمليات المشتبه بها تلقائياً للتدقيق اليدوي من قبل إدارة الامتثال المالي ببرواح المازوري.',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade700,
                          height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ISO-20022 COMPLIANT',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary),
                            textDirection: TextDirection.ltr),
                        Row(
                          children: [
                            const Text('آخر مطابقة بنكية: اليوم 02:45 م',
                                style: TextStyle(
                                    fontSize: 9,
                                    color: AppColors.textSecondary)),
                            const SizedBox(width: 4),
                            Icon(Icons.circle,
                                size: 6, color: Colors.blue.shade400),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String title, bool isSelected,
      {IconData? icon, bool isIconOnly = false, Color? iconColor}) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: isIconOnly ? 10 : 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryExtraDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color:
                isSelected ? AppColors.primaryExtraDark : AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 14,
                color: iconColor ??
                    (isSelected ? Colors.white : Colors.blue.shade700)),
            if (!isIconOnly) const SizedBox(width: 6),
          ],
          if (!isIconOnly)
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListItemCard(BuildContext context, Map<String, dynamic> item) {
    final isArabic = AppLocalizations.of(context)!.localeName == 'ar';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryExtraDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.storefront,
                        color: Colors.white, size: 20), // Generic icon
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'],
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.security,
                              size: 12, color: Colors.blue),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(item['id'],
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary),
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(item['status'],
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Amounts Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('الرصيد المتاح للسحب',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                                child: Text(
                                    CurrencyFormatter.format(item['available'],
                                        includeCurrency: false),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryExtraDark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 2),
                            Text(AppLocalizations.of(context)!.currencySar,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('تحت التدقيق والتسوية',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                                child: Text(
                                    CurrencyFormatter.format(item['pending'],
                                        includeCurrency: false),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 2),
                            Text(
                                '${AppLocalizations.of(context)!.currencySar} ${isArabic ? 'معلق' : 'pending'}',
                                style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Bottom Info Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text('المبيعات المكتملة للشهر: ${item['operations']} عملية',
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textPrimary)),
                  ],
                ),
                Row(
                  children: [
                    Icon(item['bankIcon'],
                        size: 14, color: Colors.blue.shade700),
                    const SizedBox(width: 4),
                    Text(item['bankText'],
                        style: TextStyle(
                            fontSize: 10, color: Colors.blue.shade700)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryExtraDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.receipt_long, size: 16),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionHistoryScreen(
                        title: item['title'],
                        id: item['id'],
                        availableBalance: item['available'],
                      ),
                    ),
                  );
                },
                label: const Text('عرض سجل العمليات',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'storefront':
        return Icons.storefront;
      case 'handshake':
        return Icons.handshake;
      case 'build':
        return Icons.build;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
