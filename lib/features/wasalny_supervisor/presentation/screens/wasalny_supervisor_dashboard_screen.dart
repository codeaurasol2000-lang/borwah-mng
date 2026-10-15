import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/datasources/wasalny_ads_mock_data_source.dart';
import '../../data/repositories/wasalny_ads_repository_impl.dart';
import '../../domain/entities/wasalny_ad.dart';
import '../../domain/entities/wasalny_complaint.dart';
import '../../domain/usecases/get_wasalny_ads_usecase.dart';
import '../../domain/usecases/get_wasalny_complaints_usecase.dart';

class WasalnySupervisorDashboardScreen extends StatefulWidget {
  final ValueChanged<int> onOpenTab;
  final VoidCallback onOpenComplaints;
  final VoidCallback? onOpenReviewCenter;

  const WasalnySupervisorDashboardScreen({
    super.key,
    required this.onOpenTab,
    required this.onOpenComplaints,
    this.onOpenReviewCenter,
  });

  @override
  State<WasalnySupervisorDashboardScreen> createState() =>
      _WasalnySupervisorDashboardScreenState();
}

class _WasalnySupervisorDashboardScreenState
    extends State<WasalnySupervisorDashboardScreen> {
  late Future<_DashboardData> _data;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_DashboardData> _load() async {
    final adsRepository = WasalnyAdsRepositoryImpl(
      dataSource: WasalnyAdsMockDataSource(),
    );
    final results = await Future.wait([
      GetWasalnyAdsUseCase(repository: adsRepository)(),
      sl<GetWasalnyComplaintsUseCase>()(),
    ]);
    return _DashboardData(
      results[0] as List<WasalnyAd>,
      results[1] as List<WasalnyComplaint>,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return FutureBuilder<_DashboardData>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _DashboardMessage(
            message: isArabic ? 'تعذر تحميل الملخص' : 'Could not load overview',
            actionLabel: isArabic ? 'إعادة المحاولة' : 'Try again',
            onAction: () => setState(() => _data = _load()),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        final pendingAds = data.ads.where((ad) =>
            !ad.isArchived &&
            (ad.status == WasalnyAdStatus.pending ||
                ad.status == WasalnyAdStatus.awaitingApproval)).length;
        final activeComplaints = data.complaints.where((complaint) =>
            complaint.status == WasalnyComplaintStatus.underReview).length;
        final escalated = data.complaints.where((complaint) =>
            complaint.status == WasalnyComplaintStatus.escalatedToChief).length;

        return RefreshIndicator(
          onRefresh: () async {
            final refreshed = _load();
            setState(() => _data = refreshed);
            await refreshed;
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Text(
                isArabic ? 'ملخص العمل اليومي' : 'Daily work overview',
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isArabic
                    ? 'تابع الطلبات التي تحتاج إلى مراجعتك من مكان واحد.'
                    : 'See the items that need your attention in one place.',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 18),
              _SummaryTile(
                icon: Icons.pending_actions_outlined,
                color: AppColors.hexFFB9770E,
                title: isArabic ? 'إعلانات بانتظار المراجعة' : 'Ads awaiting review',
                count: pendingAds,
                onTap: () => widget.onOpenTab(3),
              ),
              const SizedBox(height: 10),
              _SummaryTile(
                icon: Icons.report_gmailerrorred_outlined,
                color: AppColors.hexFFB23A48,
                title: isArabic ? 'شكاوى تحتاج إلى متابعة' : 'Complaints to follow up',
                count: activeComplaints,
                onTap: widget.onOpenComplaints,
              ),
              const SizedBox(height: 10),
              _SummaryTile(
                icon: Icons.escalator_warning_outlined,
                color: AppColors.hexFF6656A5,
                title: isArabic ? 'شكاوى مصعّدة لرئيس المشرفين' : 'Escalated to chief supervisor',
                count: escalated,
                onTap: widget.onOpenComplaints,
              ),
              const SizedBox(height: 18),
              _DashboardLink(
                icon: Icons.rule_folder_outlined,
                title: isArabic ? 'مركز متابعة وصلني' : 'Wasalny review center',
                subtitle: isArabic
                    ? 'الإعلانات والشكاوى والأولويات وسجل القرارات'
                    : 'Ads, complaints, priorities, and decision log',
                onTap: widget.onOpenReviewCenter ?? widget.onOpenComplaints,
              ),
              const SizedBox(height: 10),
              _DashboardLink(
                icon: Icons.workspace_premium_outlined,
                title: isArabic ? 'طلبات ترويج المنتجات' : 'Promotion requests',
                subtitle: isArabic ? 'مراجعة المنتجات المميزة وحالة الدفع' : 'Review featured listings and payment status',
                onTap: () => widget.onOpenTab(2),
              ),
              const SizedBox(height: 10),
              _DashboardLink(
                icon: Icons.assignment_outlined,
                title: isArabic ? 'طلبات وصلني' : 'Wasalny requests',
                subtitle: isArabic ? 'متابعة الطلبات والصفقات' : 'Track requests and deals',
                onTap: () => widget.onOpenTab(1),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardData {
  final List<WasalnyAd> ads;
  final List<WasalnyComplaint> complaints;
  const _DashboardData(this.ads, this.complaints);
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final int count;
  final VoidCallback onTap;

  const _SummaryTile({required this.icon, required this.color, required this.title, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.hexFFE7EBEF)),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          leading: CircleAvatar(backgroundColor: color.withOpacity(.10), child: Icon(icon, color: color)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('$count', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ]),
        ),
      );
}

class _DashboardLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _DashboardLink({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: AppColors.primaryDark),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 15),
        ),
      );
}

class _DashboardMessage extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  const _DashboardMessage({required this.message, required this.actionLabel, required this.onAction});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message),
          const SizedBox(height: 10),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ]),
      );
}
