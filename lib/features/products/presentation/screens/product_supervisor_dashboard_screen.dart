import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/product_customer_complaint_local_store.dart';
import '../../data/product_promotion_local_store.dart';
import '../../domain/entities/product_customer_complaint.dart';
import '../../domain/entities/product_promotion_request.dart';
import '../../domain/entities/product_review.dart';
import '../../domain/entities/product_supervisor_audit_entry.dart';
import '../../domain/usecases/get_product_reviews_usecase.dart';
import '../../domain/repositories/product_supervisor_audit_repository.dart';

class ProductSupervisorDashboardScreen extends StatefulWidget {
  final ValueChanged<int> onOpenTab;
  final VoidCallback onOpenComplaints;

  const ProductSupervisorDashboardScreen({
    super.key,
    required this.onOpenTab,
    required this.onOpenComplaints,
  });

  @override
  State<ProductSupervisorDashboardScreen> createState() =>
      _ProductSupervisorDashboardScreenState();
}

class _ProductSupervisorDashboardScreenState
    extends State<ProductSupervisorDashboardScreen> {
  late Future<_DashboardData> _data;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_DashboardData> _load() async {
    final results = await Future.wait<Object>([
      sl<GetProductReviewsUseCase>()(),
      ProductPromotionLocalStore().loadExisting(account: 'products'),
      ProductCustomerComplaintLocalStore().loadExisting(),
      sl<ProductSupervisorAuditRepository>().getEntries(),
    ]);
    return _DashboardData(
      reviews: results[0] as List<ProductReview>,
      promotions: results[1] as List<ProductPromotionRequest>,
      complaints: results[2] as List<ProductCustomerComplaint>,
      auditEntries: results[3] as List<ProductSupervisorAuditEntry>,
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
            message: isArabic ? 'تعذر تحميل ملخص الحساب' : 'Could not load the account overview',
            retryLabel: isArabic ? 'إعادة المحاولة' : 'Try again',
            onRetry: () => setState(() => _data = _load()),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        final pendingProducts = data.reviews.where((review) =>
            !review.isFeatured && review.status == ProductReviewStatus.pending).length;
        final pendingPromotions = data.promotions.where((request) =>
            request.status == ProductPromotionStatus.pending).length;
        final openComplaints = data.complaints.where((complaint) =>
            complaint.status == ProductComplaintStatus.open ||
            complaint.status == ProductComplaintStatus.onHold).length;
        final escalatedComplaints = data.complaints.where((complaint) =>
            complaint.status == ProductComplaintStatus.escalated).length;

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
                isArabic ? 'نظرة عامة على العمل' : 'Work overview',
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 6),
              Text(
                isArabic ? 'تابع المهام التي تحتاج إلى إجراء من شاشة واحدة.' : 'Track tasks that need action from one screen.',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 18),
              _DashboardMetric(
                icon: Icons.inventory_2_outlined,
                tint: AppColors.hexFFB9770E,
                label: isArabic ? 'منتجات بانتظار المراجعة' : 'Products awaiting review',
                count: pendingProducts,
                onTap: () => widget.onOpenTab(3),
              ),
              const SizedBox(height: 10),
              _DashboardMetric(
                icon: Icons.workspace_premium_outlined,
                tint: AppColors.hexFF4169A1,
                label: isArabic ? 'طلبات ترويج بانتظار الإجراء' : 'Promotion requests awaiting action',
                count: pendingPromotions,
                onTap: () => widget.onOpenTab(2),
              ),
              const SizedBox(height: 10),
              _DashboardMetric(
                icon: Icons.report_gmailerrorred_outlined,
                tint: AppColors.hexFFB23A48,
                label: isArabic ? 'شكاوى مفتوحة أو معلقة' : 'Open or on-hold complaints',
                count: openComplaints,
                onTap: widget.onOpenComplaints,
              ),
              if (escalatedComplaints > 0) ...[
                const SizedBox(height: 10),
                _DashboardMetric(
                  icon: Icons.north_east,
                  tint: AppColors.hexFF6656A5,
                  label: isArabic ? 'شكاوى مصعّدة' : 'Escalated complaints',
                  count: escalatedComplaints,
                  onTap: widget.onOpenComplaints,
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Text(isArabic ? 'أحدث الإجراءات' : 'Recent actions', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark, fontSize: 16))),
                  TextButton(onPressed: () => widget.onOpenTab(1), child: Text(isArabic ? 'عرض التقارير' : 'View reports')),
                ],
              ),
              if (data.auditEntries.isEmpty)
                _EmptyAudit(isArabic: isArabic)
              else
                ...data.auditEntries.take(4).map((entry) => _AuditRow(entry: entry, isArabic: isArabic)),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardData {
  final List<ProductReview> reviews;
  final List<ProductPromotionRequest> promotions;
  final List<ProductCustomerComplaint> complaints;
  final List<ProductSupervisorAuditEntry> auditEntries;
  const _DashboardData({required this.reviews, required this.promotions, required this.complaints, required this.auditEntries});
}

class _DashboardMetric extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final String label;
  final int count;
  final VoidCallback onTap;
  const _DashboardMetric({required this.icon, required this.tint, required this.label, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: AppColors.hexFFE7EBEF)),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: CircleAvatar(backgroundColor: tint.withOpacity(.10), child: Icon(icon, color: tint)),
          title: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: tint)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ]),
        ),
      );
}

class _AuditRow extends StatelessWidget {
  final ProductSupervisorAuditEntry entry;
  final bool isArabic;
  const _AuditRow({required this.entry, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final date = MaterialLocalizations.of(context).formatShortDate(entry.occurredAt.toLocal());
    final time = TimeOfDay.fromDateTime(entry.occurredAt.toLocal()).format(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: AppColors.cardBorder)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.history, size: 18, color: AppColors.infoDark),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(entry.subject, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
          const SizedBox(height: 3),
          Text(entry.details.isEmpty ? entry.actionKey : entry.details, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text('${isArabic ? 'بواسطة' : 'By'} ${isArabic ? entry.actorName : 'Product supervisor'}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('$date • $time', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ])),
      ]),
    );
  }
}

class _EmptyAudit extends StatelessWidget {
  final bool isArabic;
  const _EmptyAudit({required this.isArabic});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: AppColors.cardBorder)),
        child: Text(isArabic ? 'ستظهر هنا الإجراءات الرقابية المسجلة.' : 'Recorded supervisory actions will appear here.', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
      );
}

class _DashboardMessage extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  const _DashboardMessage({required this.message, required this.retryLabel, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text(message), const SizedBox(height: 8), TextButton(onPressed: onRetry, child: Text(retryLabel))]));
}
