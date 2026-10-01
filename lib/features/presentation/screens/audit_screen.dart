import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/finance_navigation.dart';

class AuditScreen extends StatefulWidget {
  final bool showBottomNavigation;

  const AuditScreen({super.key, this.showBottomNavigation = true});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen>
    with AutomaticKeepAliveClientMixin<AuditScreen> {
  static const _hash = 'FIN-9042-ALMAZOURI-7e2f98aa01';
  static const _filters = [
    ('all', 'الكل (1,420)', 'All (1,420)'),
    ('bank', 'تحويلات بنكية (840)', 'Bank transfers (840)'),
    ('freeze', 'تجميد أرصدة (3)', 'Frozen balances (3)'),
  ];

  static const _events = [
    _AuditEvent(
      group: 'today',
      category: 'bank',
      titleAr: 'تحويل بنكي صادر (سحب أرباح)',
      titleEn: 'Outgoing bank transfer (profit withdrawal)',
      amount: '- 32,500.00 ر.س',
      amountEn: '- SAR 32,500.00',
      amountColor: Color(0xFFD32626),
      timeAr: 'اليوم • 11:00:44',
      timeEn: 'Today • 11:00:44',
      descriptionAr:
          'صرف أرباح معتمدة إلى مؤسسة مدار التقنية (#TRD-8821) عبر مصرف الراجحي.',
      descriptionEn:
          'Approved profits paid to Madar Technology Establishment (#TRD-8821) through Al Rajhi Bank.',
      statusAr: 'مطابقة فورية مع نظام SARIE',
      statusEn: 'Instant reconciliation with SARIE',
      reference: 'TRD-8821',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFF3474B9),
    ),
    _AuditEvent(
      group: 'today',
      category: 'freeze',
      titleAr: 'تجميد سحب مؤقت (Finance Freeze)',
      titleEn: 'Temporary withdrawal freeze (Finance Freeze)',
      amount: '- 18,900.00 ر.س',
      amountEn: '- SAR 18,900.00',
      amountColor: Color(0xFFD32626),
      timeAr: 'اليوم • 10:20:16',
      timeEn: 'Today • 10:20:16',
      descriptionAr:
          'تجميد احترازي فوري لرصيد محفظة التاجر معرض النجوم (#TRD-304) بناءً على إشعار من المشرف الرقابي.',
      descriptionEn:
          'Immediate precautionary freeze on Al-Nujoom store wallet (#TRD-304) following a regulatory supervisor notice.',
      statusAr: 'سبب التجميد: نزاع تجاري مفتوح',
      statusEn: 'Freeze reason: open commercial dispute',
      reference: 'CLEARANCE: SEC-LVL3',
      icon: Icons.lock_outline_rounded,
      color: Color(0xFFD32626),
      isWarning: true,
    ),
    _AuditEvent(
      group: 'today',
      category: 'bank',
      titleAr: 'تسوية استرداد مالي (Refund)',
      titleEn: 'Financial refund settlement (Refund)',
      amount: '+ 1,200.00 ر.س',
      amountEn: '+ SAR 1,200.00',
      amountColor: Color(0xFF376AB0),
      timeAr: 'اليوم • 11:00:44',
      timeEn: 'Today • 11:00:44',
      descriptionAr:
          'قيد تسوية إيداع في محفظة العميل د. طارق العمري (#USR-9022) استجابة لقرار لجنة حسم النزاعات بموجب محضر صيانة #CMP-1035.',
      descriptionEn:
          'Refund posted to Dr. Tareq Al-Omari’s wallet (#USR-9022) following dispute committee decision #CMP-1035.',
      statusAr: 'مصدقة رقميًا من المدير المالي',
      statusEn: 'Digitally signed by the finance director',
      reference: 'CMP-1035',
      icon: Icons.currency_exchange_rounded,
      color: Color(0xFF376AB0),
    ),
    _AuditEvent(
      group: 'yesterday',
      category: 'bank',
      titleAr: 'اعتماد حساب ومطابقة IBAN',
      titleEn: 'Account approval and IBAN match',
      amount: 'ربط حساب',
      amountEn: 'Account linked',
      amountColor: Color(0xFF376AB0),
      timeAr: 'أمس • 16:45:10',
      timeEn: 'Yesterday • 16:45:10',
      descriptionAr:
          'تم اعتماد وتوثيق الآيبان المصرفي لشركة مدار التقنية (#TRD-5501). رقم المطابقة البنكية مطابق 100% مع منصة وثائق للتحقق التجاري.',
      descriptionEn:
          'The bank IBAN for Madar Technology (#TRD-5501) was approved and verified. Bank match confirmed at 100%.',
      statusAr: 'آيبان موثق ✓',
      statusEn: 'Verified IBAN ✓',
      reference: 'SA40209118',
      icon: Icons.account_balance_outlined,
      color: Color(0xFF263E5B),
    ),
    _AuditEvent(
      group: 'yesterday',
      category: 'bank',
      titleAr: 'تحصيل عمولات منصة تلقائي',
      titleEn: 'Automatic platform commission collection',
      amount: '+ 14,820.00 ر.س',
      amountEn: '+ SAR 14,820.00',
      amountColor: Color(0xFF376AB0),
      timeAr: 'أمس • 09:20:00',
      timeEn: 'Yesterday • 09:20:00',
      descriptionAr:
          'قيد إجمالي عمولات منصة دورية عن تداولات وصفقات قسم المبيعات والاستحقاقات، وإيداعها في حساب العوائد التشغيلية للمؤسسة.',
      descriptionEn:
          'Periodic platform commissions from sales and settlement transactions were posted to the establishment operating-revenue account.',
      statusAr: 'منصة موثقة تلقائيًا',
      statusEn: 'Automatically verified platform entry',
      reference: 'COMM-1420',
      icon: Icons.savings_outlined,
      color: Color(0xFF376AB0),
    ),
  ];

  String _selectedFilter = 'all';

  List<_AuditEvent> get _visibleEvents => _selectedFilter == 'all'
      ? _events
      : _events.where((event) => event.category == _selectedFilter).toList();

  List<_AuditEvent> _eventsForGroup(String group) =>
      _visibleEvents.where((event) => event.group == group).toList();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: FinanceSwipeNavigation(
        currentIndex: 0,
        enabled: widget.showBottomNavigation,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7F9),
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              children: [
                if (widget.showBottomNavigation) _buildBrandHeader(l10n),
                const SizedBox(height: 12),
                _buildHashCard(context, l10n, isArabic),
                const SizedBox(height: 10),
                _buildFilters(isArabic),
                const SizedBox(height: 10),
                _buildSummary(isArabic),
                const SizedBox(height: 14),
                if (_eventsForGroup('today').isNotEmpty) ...[
                  _buildDateHeading(
                    isArabic
                        ? 'اليوم - الأربعاء 24 مايو'
                        : 'Today - Wednesday, May 24',
                    isArabic,
                  ),
                  const SizedBox(height: 8),
                  ..._eventsForGroup('today').map(
                    (event) => _AuditEventCard(
                      event: event,
                      isArabic: isArabic,
                      isLast: event == _eventsForGroup('today').last,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                if (_eventsForGroup('yesterday').isNotEmpty) ...[
                  _buildDateHeading(
                    isArabic
                        ? 'أمس - الثلاثاء 23 مايو'
                        : 'Yesterday - Tuesday, May 23',
                    isArabic,
                  ),
                  const SizedBox(height: 8),
                  ..._eventsForGroup('yesterday').map(
                    (event) => _AuditEventCard(
                      event: event,
                      isArabic: isArabic,
                      isLast: event == _eventsForGroup('yesterday').last,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                _buildDisclosure(isArabic),
                const SizedBox(height: 8),
                _buildExportButton(l10n),
              ],
            ),
          ),
          bottomNavigationBar: widget.showBottomNavigation
              ? const FinanceBottomNavigationBar(currentIndex: 0)
              : null,
        ),
      ),
    );
  }

  Widget _buildBrandHeader(AppLocalizations l10n) {
    return SizedBox(
      height: 66,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.person_outline, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Text(l10n.certifiedFinancialAuditor,
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.textSecondary)),
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
                        fontSize: 16,
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
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield_outlined,
                  size: 19, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHashCard(
      BuildContext context, AppLocalizations l10n, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF102B4B), Color(0xFF071A31)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A071A31), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline, color: Colors.white70, size: 13),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  isArabic
                      ? 'بروتوكول الرقابة المزدوجة FIN-402'
                      : 'Dual-control protocol FIN-402',
                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                ),
              ),
              _pill(l10n.liveDocumented, const Color(0xFF263E59), Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isArabic
                ? 'سجل التدقيق المالي المركزي'
                : 'Central financial audit log',
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF07182F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isArabic
                            ? 'بصمة الكتلة التشفيرية (Block Hash)'
                            : 'Cryptographic block hash',
                        style:
                            const TextStyle(color: Colors.white70, fontSize: 9),
                      ),
                    ),
                    const Icon(Icons.fingerprint,
                        color: Colors.white60, size: 14),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        _hash,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'monospace'),
                      ),
                    ),
                    IconButton(
                      tooltip: isArabic ? 'نسخ البصمة' : 'Copy hash',
                      visualDensity: VisualDensity.compact,
                      constraints:
                          const BoxConstraints.tightFor(width: 30, height: 30),
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        await Clipboard.setData(
                            const ClipboardData(text: _hash));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isArabic
                                ? 'تم نسخ بصمة السجل.'
                                : 'Audit hash copied.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded,
                          size: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.circle, size: 7, color: Color(0xFF26D69A)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  isArabic
                      ? 'سجل نهائي مشفر للقراءة فقط (Read-Only) • معتمد رسميًا'
                      : 'Final encrypted read-only record • officially certified',
                  style: const TextStyle(color: Colors.white70, fontSize: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(bool isArabic) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: _filters.map((filter) {
          final selected = _selectedFilter == filter.$1;
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 6),
            child: ChoiceChip(
              label: Text(isArabic ? filter.$2 : filter.$3),
              selected: selected,
              onSelected: (_) => setState(() => _selectedFilter = filter.$1),
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              labelStyle: TextStyle(
                  fontSize: 9,
                  color: selected ? Colors.white : AppColors.textSecondary),
              backgroundColor: Colors.white,
              selectedColor: AppColors.primaryDark,
              side: BorderSide.none,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummary(bool isArabic) {
    return Row(
      children: [
        Expanded(
          child: _AuditMetric(
            icon: Icons.pending_actions_outlined,
            title: isArabic ? 'عمليات اليوم' : 'Today’s operations',
            value: isArabic ? '24 قيد' : '24 pending',
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: _AuditMetric(
            icon: Icons.account_balance_wallet_outlined,
            title: isArabic ? 'إجمالي السيولة' : 'Total liquidity',
            value: '68.4K ${isArabic ? 'ر.س' : 'SAR'}',
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: _AuditMetric(
            icon: Icons.fact_check_outlined,
            title: isArabic ? 'حالة المطابقة' : 'Reconciliation',
            value: isArabic ? '100% تطابق' : '100% matched',
          ),
        ),
      ],
    );
  }

  Widget _buildDateHeading(String label, bool isArabic) {
    return Row(
      children: [
        const Icon(Icons.calendar_month_outlined,
            size: 14, color: AppColors.info),
        const SizedBox(width: 6),
        Expanded(child: Divider(color: Colors.blueGrey.shade100)),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 10,
                color: AppColors.infoDark,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDisclosure(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E8EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.gavel_rounded, size: 17, color: AppColors.info),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isArabic
                  ? 'يتم تصدير نسخة مشفرة من هذا السجل آليًا وبشكل يومي ومباشر لمكتب الملك وصندوق الحسابات القانونيين المعتمدين، ولا يمكن التراجع عنه أو محوه إلى أي سجل في هذه المنظومة.'
                  : 'An encrypted copy of this log is automatically delivered daily to the approved legal accounting office and cannot be altered or deleted.',
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 9, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(AppLocalizations l10n) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.download_rounded, size: 17),
      label: Text(
        l10n.localeName == 'ar'
            ? 'تصدير السجل الكامل بصيغة Excel / PDF مشفر'
            : 'Export complete encrypted log as Excel / PDF',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(44),
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
      ),
    );
  }
}

class _AuditMetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _AuditMetric({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          Icon(icon, size: 14, color: AppColors.info),
          const SizedBox(height: 3),
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 8, color: AppColors.textSecondary)),
          const SizedBox(height: 3),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AuditEvent {
  final String group;
  final String category;
  final String titleAr;
  final String titleEn;
  final String amount;
  final String amountEn;
  final Color amountColor;
  final String timeAr;
  final String timeEn;
  final String descriptionAr;
  final String descriptionEn;
  final String statusAr;
  final String statusEn;
  final String reference;
  final IconData icon;
  final Color color;
  final bool isWarning;

  const _AuditEvent({
    required this.group,
    required this.category,
    required this.titleAr,
    required this.titleEn,
    required this.amount,
    required this.amountEn,
    required this.amountColor,
    required this.timeAr,
    required this.timeEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.statusAr,
    required this.statusEn,
    required this.reference,
    required this.icon,
    required this.color,
    this.isWarning = false,
  });
}

class _AuditEventCard extends StatelessWidget {
  final _AuditEvent event;
  final bool isArabic;
  final bool isLast;

  const _AuditEventCard({
    required this.event,
    required this.isArabic,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE9EDF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: event.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(event.icon, size: 16, color: event.color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isArabic ? event.titleAr : event.titleEn,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isArabic ? event.timeAr : event.timeEn,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 9),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? event.amount : event.amountEn,
                textAlign: TextAlign.left,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                    color: event.amountColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isArabic ? event.descriptionAr : event.descriptionEn,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 10, height: 1.5),
                ),
                if (event.isWarning) ...[
                  const SizedBox(height: 7),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE9E7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            size: 13, color: AppColors.danger),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            isArabic ? event.statusAr : event.statusEn,
                            style: const TextStyle(
                                color: AppColors.danger, fontSize: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.reference,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                            color: AppColors.infoDark,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(
                      event.isWarning
                          ? Icons.gavel_rounded
                          : Icons.verified_user_outlined,
                      size: 11,
                      color:
                          event.isWarning ? AppColors.danger : AppColors.info,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        event.isWarning
                            ? (isArabic
                                ? 'جهة النظر: دائرة الامتثال'
                                : 'Reviewed by compliance')
                            : (isArabic ? event.statusAr : event.statusEn),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: event.isWarning
                              ? AppColors.textSecondary
                              : AppColors.successDark,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _pill(String label, Color background, Color foreground) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(label,
        style: TextStyle(
            color: foreground, fontSize: 8, fontWeight: FontWeight.w600)),
  );
}
