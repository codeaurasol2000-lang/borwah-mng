import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../products/domain/entities/product_supervisor_audit_entry.dart';
import '../../../products/domain/repositories/product_supervisor_audit_repository.dart';

class WasalnyReportsScreen extends StatefulWidget {
  const WasalnyReportsScreen({super.key});

  @override
  State<WasalnyReportsScreen> createState() => _WasalnyReportsScreenState();
}

class _WasalnyReportsScreenState extends State<WasalnyReportsScreen> {
  List<ProductSupervisorAuditEntry> _entries = const [];
  bool _loading = true;
  Object? _error;
  int _selectedDays = 30;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final entries = await sl<ProductSupervisorAuditRepository>().getEntries();
      if (!mounted) return;
      setState(() {
        _entries = entries.where((entry) => entry.actionKey.startsWith('wasalny_')).toList();
        _loading = false;
      });
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'Wasalny reports',
        context: ErrorDescription('while loading audit data'),
      ));
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final cutoff = DateTime.now().subtract(Duration(days: _selectedDays));
    final entries = _entries.where((entry) => !entry.occurredAt.isBefore(cutoff)).toList();
    final adActions = entries.where((entry) => entry.actionKey.startsWith('wasalny_ad_')).toList();
    final complaintActions = entries.where((entry) => entry.actionKey.startsWith('wasalny_complaint_')).toList();
    final approvedAds = adActions.where((entry) => entry.actionKey.endsWith('_approved')).length;
    final resolvedComplaints = complaintActions.where((entry) => entry.actionKey.endsWith('_resolved')).length;
    final escalatedComplaints = complaintActions.where((entry) => entry.actionKey.endsWith('_escalated')).length;

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primaryDark,
          title: Text(l10n.productReportsTab),
          actions: [IconButton(onPressed: _load, tooltip: isArabic ? 'تحديث' : 'Refresh', icon: const Icon(Icons.refresh))],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: FilledButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: Text(l10n.retryLoadMerchants)))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        l10n.wasalnyReportOverview,
                        style: const TextStyle(color: AppColors.primaryDark, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isArabic ? 'ملخص الإجراءات الرقابية المسجلة' : 'Summary of recorded supervisory actions',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      SegmentedButton<int>(
                        segments: [
                          ButtonSegment(value: 7, label: Text(isArabic ? '7 أيام' : '7 days')),
                          ButtonSegment(value: 30, label: Text(isArabic ? '30 يومًا' : '30 days')),
                          ButtonSegment(value: 90, label: Text(isArabic ? '90 يومًا' : '90 days')),
                        ],
                        selected: {_selectedDays},
                        onSelectionChanged: (value) => setState(() => _selectedDays = value.first),
                      ),
                      const SizedBox(height: 14),
                      _ReportMetric(
                        icon: Icons.fact_check_outlined,
                        label: isArabic ? 'إجمالي الإجراءات' : 'Total actions',
                        value: '${entries.length}',
                        detail: isArabic ? 'خلال آخر $_selectedDays يومًا' : 'In the last $_selectedDays days',
                      ),
                      _ReportMetric(
                        icon: Icons.inventory_2_outlined,
                        label: isArabic ? 'قرارات الإعلانات' : 'Ad decisions',
                        value: '${adActions.length}',
                        detail: isArabic ? 'منها $approvedAds إعلانًا تمت الموافقة عليه' : '$approvedAds listings approved',
                      ),
                      _ReportMetric(
                        icon: Icons.support_agent_outlined,
                        label: isArabic ? 'إجراءات الشكاوى' : 'Complaint actions',
                        value: '${complaintActions.length}',
                        detail: isArabic ? '$resolvedComplaints محلولة • $escalatedComplaints مصعّدة' : '$resolvedComplaints resolved • $escalatedComplaints escalated',
                      ),
                      if (entries.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Text(isArabic ? 'لا توجد إجراءات مسجلة في هذه الفترة' : 'No actions recorded in this period', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
                        ),
                    ],
                  ),
      ),
    );
  }
}

class _ReportMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String detail;

  const _ReportMetric({required this.icon, required this.label, required this.value, required this.detail});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.cardBorder)),
        child: Row(children: [
          CircleAvatar(backgroundColor: AppColors.surfaceLight, child: Icon(icon, color: AppColors.primaryDark)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.w800)),
            Text(detail, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ])),
        ]),
      );
}
