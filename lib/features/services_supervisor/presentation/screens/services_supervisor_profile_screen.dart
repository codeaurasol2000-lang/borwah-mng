import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/services_supervisor_activity_store.dart';
import 'services_supervisor_account_screen.dart';
import 'services_supervisor_wallet_screen.dart';

class ServicesSupervisorProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const ServicesSupervisorProfileScreen({super.key, required this.onLogout});

  @override
  State<ServicesSupervisorProfileScreen> createState() =>
      _ServicesSupervisorProfileScreenState();
}

class _ServicesSupervisorProfileScreenState
    extends State<ServicesSupervisorProfileScreen> {
  static const _accountStorageKey = 'services_supervisor_account_state_v1';

  String? _savedName;
  String? _savedPhone;
  String? _savedCoverage;
  Object? _profileLoadError;

  @override
  void initState() {
    super.initState();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final encoded = preferences.getString(_accountStorageKey);
      final profile = encoded == null
          ? <String, dynamic>{}
          : jsonDecode(encoded) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _savedName = profile['name'] as String?;
        _savedPhone = profile['phone'] as String?;
        _savedCoverage = profile['coverage'] as String?;
        _profileLoadError = null;
      });
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'services supervisor profile',
          context: ErrorDescription('while loading saved profile details'),
        ),
      );
      if (!mounted) return;
      setState(() => _profileLoadError = error);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.servicesProfileLoadError,
            ),
          ),
        );
    }
  }

  Future<void> _openAccountSettings(AppLocalizations l10n) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(l10n.servicesAccountEditProfile),
          ),
          body: ServicesSupervisorAccountScreen(onLogout: widget.onLogout),
        ),
      ),
    );
    if (mounted) await _loadSavedProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
        children: [
          _buildIdentityCard(l10n),
          if (_profileLoadError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.servicesProfileLoadError,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontSize: 11,
                ),
              ),
            ),
          const SizedBox(height: 14),
          _buildDemoDataNotice(l10n),
          const SizedBox(height: 10),
          _buildMetrics(l10n),
          const SizedBox(height: 14),
          const _RecentServicesActions(),
          const SizedBox(height: 14),
          _buildWalletCard(context, l10n),
          const SizedBox(height: 22),
          Text(
            l10n.servicesProfileAdministrationTitle,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          _buildAdministrationCard(context, l10n),
          const SizedBox(height: 18),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: widget.onLogout,
              icon: const Icon(Icons.logout, size: 19),
              label: Text(l10n.servicesProfileLogout),
              style: FilledButton.styleFrom(
                foregroundColor: AppColors.hexFFB42318,
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.servicesProfileFooter,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 9,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 66,
                decoration: BoxDecoration(
                  color: AppColors.hexFFE7EDF4,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primaryDark,
                  size: 36,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _savedName?.isNotEmpty == true
                          ? _savedName!
                          : l10n.servicesProfileName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _InfoBadge(
                      icon: Icons.verified_user_outlined,
                      label: l10n.servicesProfileIdentity,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              _savedCoverage?.isNotEmpty == true
                  ? _savedCoverage!
                  : l10n.servicesProfileCoverage,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
          if (_savedPhone?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                _savedPhone!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, color: AppColors.hexFF16A37A, size: 10),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    l10n.servicesProfileAvailability,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _InfoBadge(
                  icon: Icons.shield_outlined,
                  label: l10n.servicesSupervisorBadgeCode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(AppLocalizations l10n) {
    return _LiveServicesMetrics(isArabic: l10n.localeName.startsWith('ar'));
  }

  Widget _buildDemoDataNotice(AppLocalizations l10n) => Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textPrimary),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.hexFF8A5A00,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.servicesProfileDemoMetricsNotice,
                style: const TextStyle(
                  color: AppColors.hexFF6D4C00,
                  fontSize: 11,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildWalletCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.servicesProfileWalletTitle,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.hexFFA7C8FF,
                size: 25,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              l10n.servicesProfileWalletDescription,
              style: const TextStyle(
                color: AppColors.hexFFB5C7DF,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _WalletBalance(
                  label: l10n.servicesProfileAvailableBalance,
                  amount: '4,850',
                  currency: l10n.servicesProfileCurrency,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WalletBalance(
                  label: l10n.servicesProfilePendingDues,
                  amount: '1,200',
                  currency: l10n.servicesProfileCurrency,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ServicesSupervisorWalletScreen(
                    owner: SupervisorWalletOwner.services,
                  ),
                ),
              ),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: Text(l10n.servicesProfileOpenWallet),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                backgroundColor: AppColors.hexFFA7C8FF,
                alignment: AlignmentDirectional.center,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdministrationCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _AdministrationRow(
            icon: Icons.manage_accounts_outlined,
            title: l10n.servicesAccountEditProfile,
            subtitle: l10n.servicesAccountLocalOnly,
            onTap: () => _openAccountSettings(l10n),
          ),
          const Divider(height: 1, indent: 14, endIndent: 14),
          _AdministrationRow(
            icon: Icons.badge_outlined,
            title: l10n.servicesProfileDelegationTitle,
            subtitle: l10n.servicesProfileDelegationDetail,
            trailing: l10n.servicesProfileActive,
            onTap: () => _showInformation(
              context,
              l10n.servicesProfileDelegationTitle,
              l10n.servicesProfileDelegationDetail,
            ),
          ),
          const Divider(height: 1, indent: 14, endIndent: 14),
          _AdministrationRow(
            icon: Icons.notifications_active_outlined,
            title: l10n.servicesProfileNotificationsTitle,
            subtitle: l10n.servicesProfileNotificationsDetail,
            trailing: l10n.servicesProfileEnabled,
            onTap: () => _showInformation(
              context,
              l10n.servicesProfileNotificationsTitle,
              l10n.servicesProfileNotificationsDetail,
            ),
          ),
          const Divider(height: 1, indent: 14, endIndent: 14),
          _AdministrationRow(
            icon: Icons.history_edu_outlined,
            title: l10n.servicesProfileAuditTitle,
            subtitle: l10n.servicesProfileAuditDetail,
            onTap: () => _showInformation(
              context,
              l10n.servicesProfileAuditTitle,
              l10n.servicesProfileAuditDetail,
            ),
          ),
        ],
      ),
    );
  }

  void _showInformation(BuildContext context, String title, String detail) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(detail),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.productConfirmAction),
          ),
        ],
      ),
    );
  }
}

class _LiveServicesMetrics extends StatefulWidget {
  final bool isArabic;
  const _LiveServicesMetrics({required this.isArabic});

  @override
  State<_LiveServicesMetrics> createState() => _LiveServicesMetricsState();
}

class _LiveServicesMetricsState extends State<_LiveServicesMetrics> {
  late Future<List<ServicesSupervisorActivity>> _future;
  final _store = ServicesSupervisorActivityStore();

  @override
  void initState() {
    super.initState();
    _future = _store.load();
  }

  @override
  void didUpdateWidget(covariant _LiveServicesMetrics oldWidget) {
    super.didUpdateWidget(oldWidget);
    _future = _store.load();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ServicesSupervisorActivity>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: 92,
              child: Center(
                child: snapshot.hasError
                    ? Text(widget.isArabic ? 'تعذر تحميل الإحصائيات' : 'Could not load statistics')
                    : const CircularProgressIndicator(),
              ),
            );
          }
          final entries = snapshot.data!;
          final requestDecisions = entries.where((item) =>
              item.action == 'request_approved' || item.action == 'request_rejected').length;
          final escalatedComplaints = entries.where((item) => item.action == 'complaint_escalated').length;
          final resolvedComplaints = entries.where((item) => item.action == 'complaint_resolved').length;
          final metrics = [
            _ProfileMetric(icon: Icons.fact_check_outlined, label: widget.isArabic ? 'إجمالي الإجراءات' : 'Recorded actions', value: '${entries.length}', detail: widget.isArabic ? 'إجراءات محفوظة' : 'Saved actions', color: AppColors.info),
            _ProfileMetric(icon: Icons.task_alt, label: widget.isArabic ? 'طلبات تمت مراجعتها' : 'Requests reviewed', value: '$requestDecisions', detail: widget.isArabic ? 'قبول أو رفض' : 'Approved or rejected', color: AppColors.hexFF16A37A),
            _ProfileMetric(icon: Icons.north_east, label: widget.isArabic ? 'شكاوى مصعّدة' : 'Escalated complaints', value: '$escalatedComplaints', detail: widget.isArabic ? 'إجراءات مسجلة' : 'Recorded actions', color: AppColors.danger),
            _ProfileMetric(icon: Icons.verified_outlined, label: widget.isArabic ? 'شكاوى تم حلها' : 'Complaints resolved', value: '$resolvedComplaints', detail: widget.isArabic ? 'إجراءات مسجلة' : 'Recorded actions', color: AppColors.hexFF16A37A),
          ];
          return LayoutBuilder(builder: (context, constraints) {
            const gap = 9.0;
            final width = (constraints.maxWidth - gap) / 2;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final metric in metrics)
                  SizedBox(width: width, height: 96, child: _MetricCard(metric: metric)),
              ],
            );
          });
        },
      );
}

class _ProfileMetric {
  final IconData icon;
  final String label;
  final String value;
  final String detail;
  final Color color;

  const _ProfileMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
    required this.color,
  });
}

class _MetricCard extends StatelessWidget {
  final _ProfileMetric metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(metric.icon, size: 15, color: metric.color),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              metric.value,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            metric.detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: metric.color, fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class _WalletBalance extends StatelessWidget {
  final String label;
  final String amount;
  final String currency;

  const _WalletBalance({
    required this.label,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.hexFF0A2849,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.hexFFD1DCEB,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            amount,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            currency,
            style: const TextStyle(
              color: AppColors.hexFFB5C7DF,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 170),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.hexFFEAF0F7,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.info, size: 12),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdministrationRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback onTap;

  const _AdministrationRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryDark, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.hexFF16A37A,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 6),
                _InfoBadge(icon: Icons.check_circle_outline, label: trailing!),
              ] else
                const Icon(Icons.chevron_left,
                    color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.cardBorder),
  );
}

class _RecentServicesActions extends StatefulWidget {
  const _RecentServicesActions();

  @override
  State<_RecentServicesActions> createState() => _RecentServicesActionsState();
}

class _RecentServicesActionsState extends State<_RecentServicesActions> {
  late Future<List<ServicesSupervisorActivity>> _activities;
  final _store = ServicesSupervisorActivityStore();

  @override
  void initState() {
    super.initState();
    _activities = _store.load();
  }

  @override
  void didUpdateWidget(covariant _RecentServicesActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    _activities = _store.load();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context)!.localeName.startsWith('ar');
    return FutureBuilder<List<ServicesSupervisorActivity>>(
      future: _activities,
      builder: (context, snapshot) {
        final entries = snapshot.data ?? const <ServicesSupervisorActivity>[];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                const Icon(Icons.history_edu_outlined, color: AppColors.primaryDark, size: 19),
                const SizedBox(width: 8),
                Expanded(child: Text(isArabic ? 'أحدث الإجراءات الرقابية' : 'Recent supervisory actions', style: const TextStyle(color: AppColors.primaryDark, fontSize: 14, fontWeight: FontWeight.w800))),
              ]),
              const SizedBox(height: 10),
              if (snapshot.connectionState != ConnectionState.done)
                const LinearProgressIndicator(minHeight: 2)
              else if (snapshot.hasError)
                Text(isArabic ? 'تعذر تحميل سجل الإجراءات.' : 'Could not load the action log.', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))
              else if (entries.isEmpty)
                Text(isArabic ? 'ستظهر هنا قرارات الطلبات والشكاوى.' : 'Request and complaint decisions will appear here.', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))
              else
                for (final entry in entries.take(4))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.check_circle_outline, size: 16, color: AppColors.infoDark),
                      const SizedBox(width: 8),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_actionLabel(entry.action, isArabic), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text(entry.subject, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        Text('${MaterialLocalizations.of(context).formatShortDate(entry.occurredAt.toLocal())} • ${TimeOfDay.fromDateTime(entry.occurredAt.toLocal()).format(context)}', style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                      ])),
                    ]),
                  ),
            ],
          ),
        );
      },
    );
  }

  String _actionLabel(String action, bool isArabic) => switch (action) {
        'request_approved' => isArabic ? 'تم اعتماد طلب خدمة' : 'Service request approved',
        'request_rejected' => isArabic ? 'تم رفض طلب خدمة' : 'Service request rejected',
        'request_reopened' => isArabic ? 'تمت إعادة فتح طلب خدمة' : 'Service request reopened',
        'request_provider_assigned' => isArabic ? 'تم إسناد الطلب إلى مزود' : 'Request assigned to a provider',
        'complaint_reassigned' => isArabic ? 'تمت إعادة إسناد شكوى' : 'Complaint reassigned',
        'complaint_escalated' => isArabic ? 'تم تصعيد شكوى' : 'Complaint escalated',
        'complaint_resolved' => isArabic ? 'تم حل الشكوى' : 'Complaint resolved',
        'complaint_reopened' => isArabic ? 'تمت إعادة فتح الشكوى' : 'Complaint reopened',
        _ => action,
      };
}
