import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/services_supervisor_activity_store.dart';
import '../../data/services_supervisor_work_store.dart';

class ServicesSupervisorDashboardScreen extends StatefulWidget {
  final ValueChanged<int> onOpenPage;
  final int refreshToken;

  const ServicesSupervisorDashboardScreen({
    super.key,
    required this.onOpenPage,
    this.refreshToken = 0,
  });

  @override
  State<ServicesSupervisorDashboardScreen> createState() =>
      _ServicesSupervisorDashboardScreenState();
}

class _ServicesSupervisorDashboardScreenState
    extends State<ServicesSupervisorDashboardScreen> {
  final _workStore = ServicesSupervisorWorkStore();
  final _activityStore = ServicesSupervisorActivityStore();
  ServiceSupervisorOverview? _overview;
  List<ServicesSupervisorActivity> _activities = const [];
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant ServicesSupervisorDashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<Object>([
        _workStore.loadOverview(),
        _activityStore.load(),
      ]);
      if (!mounted) return;
      setState(() {
        _overview = results[0] as ServiceSupervisorOverview;
        _activities = results[1] as List<ServicesSupervisorActivity>;
        _loading = false;
      });
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'services supervisor dashboard',
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final overview = _overview;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          Text(
            isArabic ? 'نظرة عامة على الخدمات' : 'Services overview',
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isArabic
                ? 'تابع الطلبات والشكاوى التي تحتاج إلى إجراء.'
                : 'Track service requests and complaints that need action.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          if (_loading && overview == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_error != null && overview == null)
            _ErrorPanel(
              isArabic: isArabic,
              onRetry: _load,
            )
          else if (overview != null) ...[
            if (_loading) const LinearProgressIndicator(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  isArabic
                      ? 'تعذر تحديث الملخص. اسحب لإعادة المحاولة.'
                      : 'Could not refresh the summary. Pull to retry.',
                  style: const TextStyle(color: AppColors.danger),
                ),
              ),
            _sectionTitle(isArabic ? 'تحتاج إلى متابعة' : 'Needs attention'),
            const SizedBox(height: 9),
            Row(
              children: [
                Expanded(
                  child: _OverviewTile(
                    count: overview.pendingRequests,
                    label: isArabic ? 'طلبات مفتوحة' : 'Open requests',
                    icon: Icons.pending_actions_outlined,
                    color: AppColors.info,
                    onTap: () => widget.onOpenPage(2),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _OverviewTile(
                    count: overview.openComplaints,
                    label: isArabic ? 'شكاوى مفتوحة' : 'Open complaints',
                    icon: Icons.report_gmailerrorred_outlined,
                    color: AppColors.danger,
                    onTap: () => widget.onOpenPage(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                Expanded(
                  child: _OverviewTile(
                    count: overview.overdueRequests,
                    label: isArabic ? 'طلبات تجاوزت ساعة' : 'Requests over 1 hour',
                    icon: Icons.timer_outlined,
                    color: AppColors.warning,
                    onTap: () => widget.onOpenPage(2),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _OverviewTile(
                    count: overview.overdueComplaints,
                    label: isArabic ? 'شكاوى تجاوزت ساعة' : 'Complaints over 1 hour',
                    icon: Icons.schedule_outlined,
                    color: AppColors.danger,
                    onTap: () => widget.onOpenPage(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            _OverviewTile(
              count: overview.escalatedComplaints,
              label: isArabic ? 'شكاوى مصعّدة' : 'Escalated complaints',
              icon: Icons.north_east,
              color: AppColors.danger,
              onTap: () => widget.onOpenPage(3),
            ),
          ],
          const SizedBox(height: 20),
          _sectionTitle(isArabic ? 'آخر الإجراءات' : 'Recent actions'),
          const SizedBox(height: 9),
          if (_activities.isEmpty)
            _EmptyPanel(
              text: isArabic
                  ? 'ستظهر هنا قرارات الطلبات والشكاوى بعد تسجيلها.'
                  : 'Request and complaint decisions will appear here.',
            )
          else
            for (final activity in _activities.take(5))
              _ActivityTile(
                activity: activity,
                isArabic: isArabic,
                onTap: activity.entityType == null
                    ? null
                    : () => widget.onOpenPage(
                          activity.entityType == 'service_request' ? 2 : 3,
                        ),
              ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryDark,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      );
}

class _OverviewTile extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _OverviewTile({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            constraints: const BoxConstraints(minHeight: 88),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$count',
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _ActivityTile extends StatelessWidget {
  final ServicesSupervisorActivity activity;
  final VoidCallback? onTap;
  final bool isArabic;

  const _ActivityTile({
    required this.activity,
    required this.isArabic,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localTime = activity.occurredAt.toLocal();
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(localTime),
    );
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.history, color: AppColors.info),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.subject,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _actionLabel(activity.action, isArabic),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 5),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _actionLabel(String action, bool isArabic) {
    if (isArabic) {
      return switch (action) {
        'request_approved' => 'تم قبول الطلب',
        'request_rejected' => 'تم رفض الطلب',
        'request_reopened' => 'تمت إعادة فتح الطلب',
        'request_provider_assigned' => 'تم إسناد مقدم خدمة',
        'complaint_resolved' => 'تم حل الشكوى',
        'complaint_reopened' => 'أعيد فتح الشكوى',
        'complaint_reassigned' => 'أعيد إسناد الشكوى',
        'complaint_escalated' => 'تم تصعيد الشكوى',
        _ => action.replaceAll('_', ' '),
      };
    }
    return action.replaceAll('_', ' ');
  }
}

class _EmptyPanel extends StatelessWidget {
  final String text;

  const _EmptyPanel({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      );
}

class _ErrorPanel extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onRetry;

  const _ErrorPanel({required this.isArabic, required this.onRetry});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Text(
              isArabic
                  ? 'تعذر تحميل بيانات المتابعة.'
                  : 'Could not load oversight data.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
            ),
          ],
        ),
      );
}
