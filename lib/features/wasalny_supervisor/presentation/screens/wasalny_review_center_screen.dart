import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../products/domain/entities/product_supervisor_audit_entry.dart';
import '../../../products/domain/repositories/product_supervisor_audit_repository.dart';
import '../../data/datasources/wasalny_ads_mock_data_source.dart';
import '../../data/repositories/wasalny_ads_repository_impl.dart';
import '../../domain/entities/wasalny_ad.dart';
import '../../domain/entities/wasalny_complaint.dart';
import '../../domain/usecases/get_wasalny_ads_usecase.dart';
import '../../domain/usecases/get_wasalny_complaints_usecase.dart';

class WasalnyReviewCenterScreen extends StatefulWidget {
  final VoidCallback onOpenAds;
  final VoidCallback onOpenComplaints;

  const WasalnyReviewCenterScreen({
    super.key,
    required this.onOpenAds,
    required this.onOpenComplaints,
  });

  @override
  State<WasalnyReviewCenterScreen> createState() =>
      _WasalnyReviewCenterScreenState();
}

class _WasalnyReviewCenterScreenState extends State<WasalnyReviewCenterScreen> {
  late Future<_ReviewCenterData> _data;
  String _kind = 'all';
  String _state = 'pending';
  String _priority = 'all';
  bool _urgentFirst = true;
  bool _showAudit = false;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_ReviewCenterData> _load() async {
    final ads = await GetWasalnyAdsUseCase(
      repository: WasalnyAdsRepositoryImpl(
        dataSource: WasalnyAdsMockDataSource(),
      ),
    )();
    final complaints = await sl<GetWasalnyComplaintsUseCase>()();
    final audit = await sl<ProductSupervisorAuditRepository>().getEntries();
    return _ReviewCenterData(
      ads,
      complaints,
      audit.where((entry) => entry.actionKey.startsWith('wasalny_')).toList(),
    );
  }

  String _age(DateTime date, bool isArabic) {
    final duration = DateTime.now().difference(date);
    if (duration.inMinutes < 60) {
      return isArabic
          ? 'منذ ${duration.inMinutes.clamp(0, 59)} دقيقة'
          : '${duration.inMinutes.clamp(0, 59)} min ago';
    }
    if (duration.inHours < 24) {
      return isArabic
          ? 'منذ ${duration.inHours} ساعة'
          : '${duration.inHours} hr ago';
    }
    return isArabic
        ? 'منذ ${duration.inDays} يوم'
        : '${duration.inDays} days ago';
  }

  bool _isArchived(_ReviewItem item) => item.ad?.isArchived == true ||
      item.complaint?.status == WasalnyComplaintStatus.resolved ||
      item.complaint?.status == WasalnyComplaintStatus.actionTakenBlocked;

  bool _isPending(_ReviewItem item) => item.complaint != null
      ? item.complaint!.status == WasalnyComplaintStatus.underReview ||
          item.complaint!.status == WasalnyComplaintStatus.escalatedToChief
      : !item.ad!.isArchived &&
          (item.ad!.status == WasalnyAdStatus.pending ||
              item.ad!.status == WasalnyAdStatus.awaitingApproval ||
              item.ad!.status == WasalnyAdStatus.editRequested);

  bool _isUrgent(_ReviewItem item) =>
      item.complaint?.status == WasalnyComplaintStatus.escalatedToChief ||
      (item.ad != null &&
          !item.ad!.isArchived &&
          (item.ad!.status == WasalnyAdStatus.pending ||
              item.ad!.status == WasalnyAdStatus.awaitingApproval));

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isArabic ? 'مركز متابعة وصلني' : 'Wasalny review center'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryDark,
      ),
      body: FutureBuilder<_ReviewCenterData>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isArabic
                      ? 'تعذر تحميل مركز المتابعة'
                      : 'Could not load the review center'),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () => setState(() => _data = _load()),
                    child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final items = <_ReviewItem>[
            ...data.ads.map(_ReviewItem.forAd),
            ...data.complaints.map(_ReviewItem.forComplaint),
          ].where((item) {
            if (_kind == 'ad' && item.ad == null) return false;
            if (_kind == 'complaint' && item.complaint == null) return false;
            if (_priority == 'urgent' && !_isUrgent(item)) return false;
            if (_priority == 'normal' && _isUrgent(item)) return false;
            if (_state == 'pending' && !_isPending(item)) return false;
            if (_state == 'active' && _isArchived(item)) return false;
            if (_state == 'archive' && !_isArchived(item)) return false;
            return true;
          }).toList()
            ..sort((first, second) {
              final urgent = _urgentFirst
                  ? (_isUrgent(second) ? 1 : 0)
                      .compareTo(_isUrgent(first) ? 1 : 0)
                  : (_isUrgent(first) ? 1 : 0)
                      .compareTo(_isUrgent(second) ? 1 : 0);
              return urgent != 0 ? urgent : second.ageMinutes.compareTo(first.ageMinutes);
            });

          final pendingAds = data.ads.where((ad) =>
              !ad.isArchived &&
              (ad.status == WasalnyAdStatus.pending ||
                  ad.status == WasalnyAdStatus.awaitingApproval)).length;
          final activeComplaints = data.complaints.where((complaint) =>
              complaint.status == WasalnyComplaintStatus.underReview ||
              complaint.status == WasalnyComplaintStatus.escalatedToChief).length;

          return RefreshIndicator(
            onRefresh: () async {
              final next = _load();
              setState(() => _data = next);
              await next;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _CountCard(
                        title: isArabic ? 'إعلانات جديدة' : 'New ads',
                        count: pendingAds,
                        icon: Icons.campaign_outlined,
                        color: AppColors.hexFFB9770E,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _CountCard(
                        title: isArabic ? 'شكاوى نشطة' : 'Active complaints',
                        count: activeComplaints,
                        icon: Icons.report_gmailerrorred_outlined,
                        color: AppColors.hexFFB23A48,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isArabic ? 'قائمة المراجعة الموحدة' : 'Unified review queue',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  children: [
                    _chip('all', isArabic ? 'الكل' : 'All', _kind,
                        (value) => setState(() => _kind = value)),
                    _chip('ad', isArabic ? 'الإعلانات' : 'Ads', _kind,
                        (value) => setState(() => _kind = value)),
                    _chip('complaint', isArabic ? 'الشكاوى' : 'Complaints', _kind,
                        (value) => setState(() => _kind = value)),
                  ],
                ),
                Wrap(
                  spacing: 7,
                  children: [
                    _chip('all', isArabic ? 'كل الأولويات' : 'All priorities',
                        _priority, (value) => setState(() => _priority = value)),
                    _chip('urgent', isArabic ? 'عاجل' : 'Urgent', _priority,
                        (value) => setState(() => _priority = value)),
                    _chip('normal', isArabic ? 'عادي' : 'Normal', _priority,
                        (value) => setState(() => _priority = value)),
                  ],
                ),
                Wrap(
                  spacing: 7,
                  children: [
                    _chip('pending', isArabic ? 'تحتاج مراجعة' : 'Needs review', _state,
                        (value) => setState(() => _state = value)),
                    _chip('active', isArabic ? 'النشطة' : 'Active', _state,
                        (value) => setState(() => _state = value)),
                    _chip('archive', isArabic ? 'الأرشيف' : 'Archive', _state,
                        (value) => setState(() => _state = value)),
                    _chip('all', isArabic ? 'كل الحالات' : 'All states', _state,
                        (value) => setState(() => _state = value)),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _urgentFirst = !_urgentFirst),
                    icon: const Icon(Icons.priority_high),
                    label: Text(isArabic
                        ? _urgentFirst
                            ? 'الأولوية العادية أولاً'
                            : 'العاجل أولاً'
                        : _urgentFirst
                            ? 'Normal priority first'
                            : 'Urgent first'),
                  ),
                ),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      isArabic ? 'لا توجد طلبات بهذا التصنيف.' : 'No items match this filter.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ...items.map((item) => _ReviewItemCard(
                      item: item,
                      isArabic: isArabic,
                      ageLabel: item.complaint == null
                          ? _age(item.createdAt, isArabic)
                          : isArabic
                              ? item.complaint!.timeAgoAr
                              : item.complaint!.timeAgoEn,
                      urgent: _isUrgent(item),
                      onTap: item.ad != null
                          ? widget.onOpenAds
                          : widget.onOpenComplaints,
                    )),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(isArabic ? 'سجل القرارات' : 'Decision log',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _showAudit = !_showAudit),
                      child: Text(_showAudit
                          ? (isArabic ? 'إخفاء' : 'Hide')
                          : (isArabic ? 'عرض الكل' : 'View all')),
                    ),
                  ],
                ),
                if (_showAudit && data.audit.isEmpty)
                  Text(isArabic ? 'لا توجد إجراءات مسجلة.' : 'No recorded actions.'),
                if (_showAudit)
                  ...data.audit.map((entry) => _AuditTile(
                        entry: entry,
                        isArabic: isArabic,
                      )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String value, String label, String selected,
      ValueChanged<String> onSelected) => ChoiceChip(
        label: Text(label),
        selected: value == selected,
        onSelected: (_) => onSelected(value),
        selectedColor: AppColors.primaryDark,
        labelStyle: TextStyle(
          color: value == selected ? AppColors.white : AppColors.textSecondary,
          fontSize: 11,
        ),
      );
}

class _ReviewCenterData {
  final List<WasalnyAd> ads;
  final List<WasalnyComplaint> complaints;
  final List<ProductSupervisorAuditEntry> audit;

  const _ReviewCenterData(this.ads, this.complaints, this.audit);
}

class _ReviewItem {
  final WasalnyAd? ad;
  final WasalnyComplaint? complaint;
  final DateTime createdAt;
  final int ageMinutes;

  _ReviewItem.forAd(WasalnyAd value)
      : ad = value,
        complaint = null,
        createdAt = value.submittedAt,
        ageMinutes = DateTime.now().difference(value.submittedAt).inMinutes;

  _ReviewItem.forComplaint(WasalnyComplaint value)
      : ad = null,
        complaint = value,
        createdAt = DateTime.now(),
        ageMinutes = _parseAgeMinutes(value.timeAgoEn);
}

int _parseAgeMinutes(String age) {
  if (age.toLowerCase().contains('yesterday')) return 1440;
  final match = RegExp(r'(\d+)').firstMatch(age);
  if (match == null) return 0;
  final amount = int.parse(match.group(1)!);
  final normalized = age.toLowerCase();
  if (normalized.contains('day')) return amount * 1440;
  if (normalized.contains('hour')) return amount * 60;
  return amount;
}

class _CountCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _CountCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$count',
                      style: TextStyle(
                          fontSize: 19,
                          color: color,
                          fontWeight: FontWeight.bold)),
                  Text(title,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ReviewItemCard extends StatelessWidget {
  final _ReviewItem item;
  final bool isArabic;
  final String ageLabel;
  final bool urgent;
  final VoidCallback onTap;

  const _ReviewItemCard({
    required this.item,
    required this.isArabic,
    required this.ageLabel,
    required this.urgent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ad = item.ad;
    final complaint = item.complaint;
    final title = ad != null
        ? isArabic ? ad.titleAr : ad.titleEn
        : isArabic ? complaint!.titleAr : complaint!.titleEn;
    final subtitle = ad != null
        ? '${isArabic ? ad.sellerNameAr : ad.sellerNameEn} · ${ad.reference}'
        : '${isArabic ? complaint!.itemTitleAr : complaint!.itemTitleEn} · ${complaint.id}';
    final status = ad != null
        ? _adStatusLabel(ad.status, isArabic)
        : _complaintStatusLabel(complaint!.status, isArabic);
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: urgent
              ? AppColors.textPrimary
              : AppColors.hexFFEDF2F7,
          child: Icon(
            ad != null ? Icons.campaign_outlined : Icons.report_outlined,
            color: urgent ? AppColors.hexFFB9770E : AppColors.primaryDark,
          ),
        ),
        title: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
        subtitle: Text('$subtitle\n$status · $ageLabel',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, height: 1.5)),
        isThreeLine: true,
        trailing: urgent
            ? const Icon(Icons.priority_high, color: AppColors.hexFFB9770E)
            : Icon(isArabic ? Icons.chevron_left : Icons.chevron_right),
      ),
    );
  }

  String _adStatusLabel(WasalnyAdStatus status, bool isArabic) => switch (status) {
        WasalnyAdStatus.pending => isArabic ? 'قيد المراجعة' : 'Pending review',
        WasalnyAdStatus.awaitingApproval =>
          isArabic ? 'بانتظار الاعتماد' : 'Awaiting approval',
        WasalnyAdStatus.approved => isArabic ? 'مقبول' : 'Approved',
        WasalnyAdStatus.hidden => isArabic ? 'مخفي' : 'Hidden',
        WasalnyAdStatus.rejected => isArabic ? 'مرفوض' : 'Rejected',
        WasalnyAdStatus.suspended => isArabic ? 'موقوف' : 'Suspended',
        WasalnyAdStatus.editRequested =>
          isArabic ? 'مطلوب تعديل' : 'Edit requested',
      };

  String _complaintStatusLabel(
    WasalnyComplaintStatus status,
    bool isArabic,
  ) => switch (status) {
        WasalnyComplaintStatus.underReview =>
          isArabic ? 'قيد المتابعة' : 'Under review',
        WasalnyComplaintStatus.escalatedToChief =>
          isArabic ? 'مصعّدة لرئيس المشرفين' : 'Escalated to chief',
        WasalnyComplaintStatus.actionTakenBlocked =>
          isArabic ? 'تم اتخاذ إجراء' : 'Action taken',
        WasalnyComplaintStatus.resolved => isArabic ? 'تم الحل' : 'Resolved',
      };
}

class _AuditTile extends StatelessWidget {
  final ProductSupervisorAuditEntry entry;
  final bool isArabic;

  const _AuditTile({required this.entry, required this.isArabic});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.history, color: AppColors.primaryDark, size: 19),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.subject,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${entry.actionKey} · ${entry.details}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                  Text(
                    '${entry.actorName} · ${entry.occurredAt.toLocal()}',
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
