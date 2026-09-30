import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/app_localizations.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String title;
  final String id;
  final double availableBalance;

  const TransactionHistoryScreen({
    super.key,
    required this.title,
    required this.id,
    required this.availableBalance,
  });

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter =
      'الكل (6)'; // 'الكل (6)', 'عمليات الإيداع (+3)', 'عمليات السحب (-3)'

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isArabic ? 'سجل العمليات' : 'Transaction History',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                isArabic
                    ? 'برواح المازوري - الإدارة المالية'
                    : 'Barwah Mazouri - Finance Management',
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    // 1. Top Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryExtraDark,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  AppColors.primaryExtraDark.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.business,
                                    color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(widget.id,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10),
                                        textDirection: TextDirection.ltr),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.picture_as_pdf_outlined,
                                    color: Colors.white, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('تحت إشراف : أ. سعد العتيبي',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10),
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: 20),
                          const Text('رصيد المحفظة المتاح للتسوية',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 11)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                CurrencyFormatter.format(
                                    widget.availableBalance,
                                    includeCurrency: false),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    height: 1),
                              ),
                              const SizedBox(width: 4),
                              Text(AppLocalizations.of(context)!.currencySar,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('إجمالي السحوبات',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 10)),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_upward,
                                              color: AppColors.dangerLight,
                                              size: 12),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text('-147,500',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 2),
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .currencySar,
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 9)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('إجمالي الإيداعات',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 10)),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_downward,
                                              color: Colors.greenAccent,
                                              size: 12),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text('+560,300',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 2),
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .currencySar,
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 9)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Section Title and Filter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('سجل الحركات المصرفية المعتمدة',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            children: [
                              Text('هذا الشهر (يناير 2025)',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 4),
                              Icon(Icons.calendar_today_outlined,
                                  size: 12, color: AppColors.primaryDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 3. Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('الكل (6)'),
                          const SizedBox(width: 8),
                          _buildFilterChip('عمليات الإيداع (+3)'),
                          const SizedBox(width: 8),
                          _buildFilterChip('عمليات السحب (-3)'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Group: Today
                    _buildDateHeader('اليوم • 28 يناير 2025', 'عمليتان'),
                    const SizedBox(height: 12),
                    _buildTransactionItem(
                      title: 'إيداع مبيعات نقدية - متجر إلكتروني',
                      subtitle: 'بطاقة مدى • بوابة الدفع الوطنية',
                      amount: '+2,500.00',
                      isPositive: true,
                      status: 'ناجح ومكتمل',
                      ref: '#DEP-99412',
                      time: '02:45 م',
                      balanceAfter: '412,800.00 EGP',
                    ),
                    _buildTransactionItem(
                      title: 'سحب أرباح للبنك - مصرف الراجحي',
                      subtitle: 'آيبان: SA44****5521 • سريع SARIE',
                      amount: '-50,000.00',
                      isPositive: false,
                      status: 'تحويل معتمد',
                      ref: '#WTH-88204',
                      time: '11:15 ص',
                      balanceAfter: '388,300.00 EGP',
                    ),

                    const SizedBox(height: 24),

                    // 5. Group: Yesterday
                    _buildDateHeader('أمس • 27 يناير 2025', 'عمليتان'),
                    const SizedBox(height: 12),
                    _buildTransactionItem(
                      title: 'إيداع طلبات وصلني',
                      subtitle: 'تسوية لوجستية آلية متوافقة',
                      amount: '+8,350.00 EGP',
                      isPositive: true,
                      status: 'مكتمل',
                      ref: '#DEP-99120',
                      time: '06:30 م',
                      balanceAfter: '438,300.00 EGP',
                    ),
                    _buildTransactionItem(
                      title: 'سحب ارباح - البنك الأهلي',
                      subtitle: 'آيبان: SA12****8894 • توثيق مؤسسي',
                      amount: '-35,000.00 EGP',
                      isPositive: false,
                      status: 'مصدق رقابياً',
                      ref: '#WTH-87410',
                      time: '09:20 ص',
                      balanceAfter: '429,950.00 EGP',
                    ),

                    const SizedBox(height: 24),

                    // 6. Group: Last week
                    _buildDateHeader(
                        'الأسبوع الماضي • 23 يناير 2025', 'عمليتان'),
                    const SizedBox(height: 12),
                    _buildTransactionItem(
                      title: 'إيداع تسوية نزاع لصالح التاجر...',
                      subtitle: 'قرار تحكيمي منصة المدفوعات #ARB-209',
                      amount: '+1,200.00 EGP',
                      isPositive: true,
                      status: 'تسوية نافذة',
                      ref: '#DEP-98765',
                      time: '04:10 م',
                      balanceAfter: '464,950.00 EGP',
                      iconOverride: Icons.gavel,
                    ),
                    _buildTransactionItem(
                      title: 'طلب سحب أرباح قيد المراجعة الفورية...',
                      subtitle: 'مراجعة مطابقة الامتثال المالي (AML)',
                      amount: '-12,500.00 EGP',
                      isPositive: false,
                      status: 'قيد التدقيق البنكي',
                      ref: '#WTH-86500',
                      time: '01:15 م',
                      balanceAfter: '12,500.00 EGP',
                      balanceLabel: 'الرصيد المحجوز:',
                      statusColor: Colors.blue.shade50,
                      statusTextColor: Colors.blue.shade800,
                      iconOverride: Icons.assignment_late_outlined,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.security,
                        color: AppColors.primaryDark, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryExtraDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      onPressed: () {},
                      label: const Text('تحميل كشف الحساب المعتمد (PDF)',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String title) {
    bool isSelected = _selectedFilter == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryExtraDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? AppColors.primaryExtraDark
                  : AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected && title == 'الكل (6)')
              const Icon(Icons.list, size: 14, color: Colors.white),
            if (isSelected && title == 'الكل (6)') const SizedBox(width: 4),
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
      ),
    );
  }

  Widget _buildDateHeader(String date, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.circle, size: 6, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(date,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary)),
          ],
        ),
        Text(count,
            style:
                const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required bool isPositive,
    required String status,
    required String ref,
    required String time,
    required String balanceAfter,
    String balanceLabel = 'الرصيد بعد الحركة:',
    Color? statusColor,
    Color? statusTextColor,
    IconData? iconOverride,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                    iconOverride ??
                        (isPositive ? Icons.call_received : Icons.call_made),
                    color: AppColors.textSecondary,
                    size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            height: 1.4)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(amount,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isPositive
                              ? AppColors.infoDark
                              : AppColors.dangerDark),
                      textDirection: TextDirection.ltr),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: statusColor ?? AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(status,
                        style: TextStyle(
                            fontSize: 9,
                            color: statusTextColor ?? AppColors.textSecondary)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.cardBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(ref,
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.textSecondary),
                      textDirection: TextDirection.ltr),
                  const SizedBox(width: 4),
                  const Icon(Icons.circle,
                      size: 4, color: AppColors.cardBorder),
                  const SizedBox(width: 4),
                  Text(time,
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.textSecondary)),
                ],
              ),
              Row(
                children: [
                  Text(balanceLabel,
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.textSecondary)),
                  const SizedBox(width: 4),
                  Text(balanceAfter,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textPrimary)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
