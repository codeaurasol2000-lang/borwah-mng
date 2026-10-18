import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../features/merchants/presentation/screens/merchant_conversation_screen.dart';
import '../../../../features/wasalny_supervisor/data/wasalny_local_event_store.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/product_customer_complaint_local_store.dart';
import '../../domain/entities/product_customer_complaint.dart';
import '../../domain/entities/product_supervisor_audit_entry.dart';
import '../../domain/repositories/product_supervisor_audit_repository.dart';

class ProductSupervisorComplaintsScreen extends StatefulWidget {
  const ProductSupervisorComplaintsScreen({super.key});

  @override
  State<ProductSupervisorComplaintsScreen> createState() =>
      _ProductSupervisorComplaintsScreenState();
}

class _ProductSupervisorComplaintsScreenState
    extends State<ProductSupervisorComplaintsScreen> {
  final _store = ProductCustomerComplaintLocalStore();
  late List<ProductCustomerComplaint> _complaints = _samples();
  bool _loading = true;
  bool _saving = false;
  int _selectedFilter = 0;
  String _query = '';

  List<ProductCustomerComplaint> _samples() {
    final now = DateTime.now();
    return [
      ProductCustomerComplaint(
        id: 'CMP-3148',
        customerName: 'سارة العتيبي',
        customerNameEn: 'Sarah Al-Otaibi',
        customerPhone: '050 555 3148',
        title: 'المنتج لا يطابق وصف الإعلان',
        titleEn: 'Product does not match the listing',
        description: 'وصلتني الساعة بحالة مستخدمة رغم أن الإعلان يذكر أنها جديدة، وأرغب في حل المشكلة أو استرجاع المبلغ.',
        descriptionEn: 'The watch arrived used although the listing described it as new. I would like the issue resolved or a refund.',
        submittedAt: now.subtract(const Duration(hours: 2)),
        productName: 'ساعة آبل الجيل 2 الأصلية',
        productNameEn: 'Apple Watch Series 2',
        productReference: 'AD-98204',
        productPrice: '3,200 ر.س',
        productPriceEn: 'SAR 3,200',
      ),
      ProductCustomerComplaint(
        id: 'CMP-3151',
        customerName: 'عبدالله الحربي',
        customerNameEn: 'Abdullah Al-Harbi',
        customerPhone: '050 555 3151',
        title: 'استفسار عام عن سياسة استرجاع المنتجات',
        titleEn: 'Question about the product return policy',
        description: 'أرغب بمعرفة طريقة تقديم طلب إرجاع لمنتج اشتريته من أحد المتاجر عبر المنصة.',
        descriptionEn: 'I would like to know how to request a return for a product bought through a store on the platform.',
        submittedAt: now.subtract(const Duration(hours: 5)),
      ),
      ProductCustomerComplaint(
        id: 'CMP-3139',
        customerName: 'نورة الشمري',
        customerNameEn: 'Noura Al-Shammari',
        customerPhone: '050 555 3139',
        title: 'عدم الرد بعد إتمام عملية الشراء',
        titleEn: 'No response after completing the purchase',
        description: 'تواصلت مع البائع أكثر من مرة ولم أتلق ردًا بخصوص موعد تسليم المنتج.',
        descriptionEn: 'I contacted the seller several times but have not received a response about the delivery date.',
        submittedAt: now.subtract(const Duration(days: 1)),
        productName: 'كاميرا سوني Alpha A7 IV',
        productNameEn: 'Sony Alpha A7 IV Camera',
        productReference: 'AD-98209',
        productPrice: '8,400 ر.س',
        productPriceEn: 'SAR 8,400',
        status: ProductComplaintStatus.onHold,
        supervisorNote: 'بانتظار إفادة البائع.',
        supervisorNoteEn: 'Waiting for the seller to respond.',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final complaints = await _store.load(initialComplaints: _samples());
      if (mounted) setState(() { _complaints = complaints; _loading = false; });
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'product supervisor complaints',
        context: ErrorDescription('while loading customer complaints'),
      ));
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<bool> _takeAction(
    ProductCustomerComplaint complaint,
    ProductComplaintStatus status, {
    String? note,
    String? noteEn,
  }) async {
    if (_saving) return false;
    setState(() => _saving = true);
    try {
      final updated = _complaints
          .map((item) => item.id == complaint.id
              ? item.copyWith(
                  status: status,
                  supervisorNote: note,
                  supervisorNoteEn: noteEn,
                )
              : item)
          .toList();
      await _store.save(updated);
      await sl<ProductSupervisorAuditRepository>().recordEntry(
        ProductSupervisorAuditEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          actionKey: 'complaint_${status.name}',
          subject: complaint.title,
          details: '${complaint.id} • ${complaint.customerName}${note == null ? '' : ' • $note'}',
          occurredAt: DateTime.now(),
        ),
      );
      if (status == ProductComplaintStatus.escalated) {
        await WasalnyLocalEventStore().publish(WasalnyLocalEvent(
          id: 'product-complaint-escalated-${complaint.id}',
          recipient: 'product_supervisor_chief',
          source: 'products',
          titleAr: 'تصعيد شكوى عميل ${complaint.id}',
          titleEn: 'Customer complaint ${complaint.id} escalated',
          messageAr: '${complaint.title} • ${complaint.customerName}',
          messageEn: '${complaint.titleEn ?? complaint.title} • ${complaint.customerNameEn ?? complaint.customerName}',
          createdAt: DateTime.now(),
        ));
      }
      if (mounted) setState(() => _complaints = updated);
      return true;
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'product supervisor complaints',
        context: ErrorDescription('while saving a complaint action'),
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.productAuditSaveError),
        ));
      }
      return false;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _sendNotice(ProductCustomerComplaint complaint) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    try {
      final message = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.localeName.startsWith('ar') ? 'إشعار نصي للعميل' : 'Text notification'),
          content: TextField(
            controller: controller,
            autofocus: true,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(hintText: l10n.localeName.startsWith('ar') ? 'اكتب رسالة للعميل' : 'Write a message to the customer'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.productCancelAction)),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) Navigator.pop(dialogContext, value);
              },
              child: Text(l10n.localeName.startsWith('ar') ? 'إرسال' : 'Send'),
            ),
          ],
        ),
      );
      if (message == null || !mounted) return;
      await WasalnyLocalEventStore().publish(WasalnyLocalEvent(
        id: 'product-complaint-notice-${complaint.id}-${DateTime.now().microsecondsSinceEpoch}',
        recipient: 'customer',
        source: 'products',
        titleAr: 'تحديث بخصوص شكواك ${complaint.id}',
        titleEn: 'Update on complaint ${complaint.id}',
        messageAr: message,
        messageEn: message,
        createdAt: DateTime.now(),
      ));
      await sl<ProductSupervisorAuditRepository>().recordEntry(
        ProductSupervisorAuditEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          actionKey: 'complaint_customer_notified',
          subject: complaint.customerName,
          details: '${complaint.id} • $message',
          occurredAt: DateTime.now(),
        ),
      );
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.localeName.startsWith('ar') ? 'تم إرسال الإشعار وتسجيله' : 'Notification sent and recorded'),
      ));
    } finally {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final visibleComplaints = _complaints;
    final filters = [
      (isArabic ? 'النشطة' : 'Active', visibleComplaints.where((c) => c.status != ProductComplaintStatus.deleted).length),
      (isArabic ? 'جديدة' : 'New', visibleComplaints.where((c) => c.status == ProductComplaintStatus.open).length),
      (isArabic ? 'قيد المتابعة' : 'In progress', visibleComplaints.where((c) => c.status == ProductComplaintStatus.onHold || c.status == ProductComplaintStatus.escalated).length),
      (isArabic ? 'مغلقة' : 'Closed', visibleComplaints.where((c) => c.status == ProductComplaintStatus.resolved).length),
      (isArabic ? 'الأرشيف' : 'Archive', visibleComplaints.where((c) => c.status == ProductComplaintStatus.deleted).length),
    ];
    final filteredComplaints = visibleComplaints.where((c) {
      final query = _query.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          c.id.toLowerCase().contains(query) ||
          c.titleFor(isArabic).toLowerCase().contains(query) ||
          c.customerNameFor(isArabic).toLowerCase().contains(query) ||
          (c.productNameFor(isArabic)?.toLowerCase().contains(query) ?? false);
      if (!matchesQuery) return false;
      return switch (_selectedFilter) {
        1 => c.status == ProductComplaintStatus.open,
        2 => c.status == ProductComplaintStatus.onHold || c.status == ProductComplaintStatus.escalated,
        3 => c.status == ProductComplaintStatus.resolved,
        4 => c.status == ProductComplaintStatus.deleted,
        _ => c.status != ProductComplaintStatus.deleted,
      };
    }).toList();
    final activeCount = filters[1].$2 + filters[2].$2;
    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primaryDark,
          title: Text(isArabic ? 'شكاوى العملاء' : 'Customer complaints'),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primaryDark, AppColors.hexFF245B75], begin: Alignment.topRight, end: Alignment.bottomLeft),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(children: [
                      Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.white.withValues(alpha: .13), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.support_agent, color: AppColors.white, size: 26)),
                      const SizedBox(width: 13),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(isArabic ? 'مركز معالجة الشكاوى' : 'Complaint resolution center', style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(isArabic ? 'راجع البلاغات وتابع آخر المستجدات' : 'Review reports and track the latest updates', style: TextStyle(color: AppColors.white.withValues(alpha: .78), fontSize: 11)),
                      ])),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: AppColors.white.withValues(alpha: .13), borderRadius: BorderRadius.circular(12)), child: Column(children: [Text('$activeCount', style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text(isArabic ? 'نشطة' : 'Active', style: const TextStyle(color: AppColors.white70, fontSize: 10))])),
                    ]),
                  ),
                  const SizedBox(height: 18),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      for (var index = 0; index < filters.length; index++) ...[
                        if (index > 0) const SizedBox(width: 8),
                        ChoiceChip(
                          label: Text('${filters[index].$1}  ${filters[index].$2}'),
                          selected: _selectedFilter == index,
                          onSelected: (_) => setState(() => _selectedFilter = index),
                          selectedColor: AppColors.primaryDark,
                          backgroundColor: AppColors.white,
                          labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _selectedFilter == index ? AppColors.white : AppColors.textSecondary),
                          side: BorderSide(color: _selectedFilter == index ? AppColors.primaryDark : AppColors.cardBorder),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        ),
                      ],
                    ]),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: isArabic ? 'ابحث برقم الشكوى أو العميل أو المنتج' : 'Search by complaint, customer or product',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (filteredComplaints.isEmpty)
                    Container(padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)), child: Column(children: [Icon(Icons.inbox_outlined, size: 34, color: AppColors.textSecondary.withValues(alpha: .65)), const SizedBox(height: 10), Text(isArabic ? 'لا توجد شكاوى في هذا التصنيف' : 'No complaints in this category', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))]))
                  else for (final complaint in (filteredComplaints..sort((a, b) => a.submittedAt.compareTo(b.submittedAt))))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: _ComplaintCard(
                        complaint: complaint,
                        isArabic: isArabic,
                        onTap: () => Navigator.of(context).push<void>(MaterialPageRoute<void>(
                          builder: (_) => _ComplaintDetailsScreen(
                            complaint: complaint,
                            isArabic: isArabic,
                            saving: _saving,
                            onAction: (item, status, {note, noteEn}) async {
                              final saved = await _takeAction(item, status, note: note, noteEn: noteEn);
                              if (saved && context.mounted) Navigator.of(context).pop();
                            },
                            onNotice: _sendNotice,
                          ),
                        )),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final ProductCustomerComplaint complaint;
  final bool isArabic;
  final VoidCallback onTap;
  const _ComplaintCard({required this.complaint, required this.isArabic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final age = DateTime.now().difference(complaint.submittedAt);
    final ageText = age.inDays > 0
        ? (isArabic ? 'منذ ${age.inDays} يوم' : '${age.inDays}d ago')
        : age.inHours > 0
            ? (isArabic ? 'منذ ${age.inHours} ساعة' : '${age.inHours}h ago')
            : (isArabic ? 'منذ قليل' : 'Just now');
    final accent = complaint.status == ProductComplaintStatus.open
        ? AppColors.infoDark
        : complaint.status == ProductComplaintStatus.onHold || complaint.status == ProductComplaintStatus.escalated
            ? AppColors.hexFFB7791F
            : AppColors.successDark;
    final isUrgent = complaint.status == ProductComplaintStatus.open && age.inHours >= 24;
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 4, height: 74, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(complaint.titleFor(isArabic), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primaryDark))),
                const SizedBox(width: 6),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  _ComplaintStatus(status: complaint.status, isArabic: isArabic),
                  if (isUrgent) ...[
                    const SizedBox(height: 5),
                    _PriorityBadge(isArabic: isArabic),
                  ],
                ]),
              ]),
              const SizedBox(height: 9),
              Wrap(spacing: 12, runSpacing: 6, children: [
                _meta(Icons.confirmation_number_outlined, complaint.id),
                _meta(Icons.person_outline, complaint.customerNameFor(isArabic)),
              ]),
              if (complaint.productName != null) ...[
                const SizedBox(height: 6),
                _meta(Icons.inventory_2_outlined, complaint.productNameFor(isArabic)!),
              ],
              const SizedBox(height: 8),
              Row(children: [Icon(Icons.schedule, size: 12, color: AppColors.textSecondary.withValues(alpha: .8)), const SizedBox(width: 4), Text(ageText, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)), const Spacer(), Icon(isArabic ? Icons.chevron_left : Icons.chevron_right, size: 18, color: AppColors.textSecondary)]),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _meta(IconData icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 13, color: AppColors.textSecondary), const SizedBox(width: 4), Flexible(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)))]);
}

class _ComplaintDetailsScreen extends StatelessWidget {
  final ProductCustomerComplaint complaint;
  final bool isArabic;
  final bool saving;
  final Future<void> Function(ProductCustomerComplaint, ProductComplaintStatus, {String? note, String? noteEn}) onAction;
  final Future<void> Function(ProductCustomerComplaint) onNotice;
  const _ComplaintDetailsScreen({required this.complaint, required this.isArabic, required this.saving, required this.onAction, required this.onNotice});

  Future<void> _confirmAction(
    BuildContext context,
    bool isArabic, {
    required bool escalation,
    required Future<void> Function(String reason) onConfirm,
  }) async {
    final controller = TextEditingController();
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(escalation
              ? (isArabic ? 'تصعيد الشكوى' : 'Escalate complaint')
              : (isArabic ? 'حذف الشكوى' : 'Remove complaint')),
          content: escalation
              ? TextField(
                  controller: controller,
                  autofocus: true,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'سبب التصعيد' : 'Escalation reason',
                    hintText: isArabic ? 'اكتب ملخصًا يساعد رئيس المشرفين' : 'Add a note for the chief supervisor',
                  ),
                )
              : Text(isArabic
                  ? 'سيتم نقل الشكوى إلى العناصر المحذوفة. يمكنك إعادتها بفتحها من الأرشيف.'
                  : 'This complaint will be removed from the active list. You can reopen it from the archive.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(isArabic ? 'إلغاء' : 'Cancel')),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(escalation
                  ? (isArabic ? 'تصعيد' : 'Escalate')
                  : (isArabic ? 'حذف' : 'Remove')),
            ),
          ],
        ),
      );
      if (confirmed == true && context.mounted) {
        final reason = controller.text.trim().isNotEmpty
            ? controller.text.trim()
            : (isArabic ? 'يتطلب مراجعة رئيس المشرفين' : 'Requires chief supervisor review');
        await onConfirm(escalation
            ? reason
            : (isArabic ? 'أزيلت من قائمة الشكاوى' : 'Removed from complaint list'));
      }
    } finally {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final productOnly = complaint.isProductComplaint;
    final date = DateFormat.yMd(l10n.localeName)
        .add_Hm()
        .format(complaint.submittedAt.toLocal());
    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: AppColors.white, foregroundColor: AppColors.primaryDark, title: Text(isArabic ? 'تفاصيل الشكوى' : 'Complaint details')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(complaint.id, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)), const SizedBox(height: 5), Text(complaint.titleFor(isArabic), style: const TextStyle(fontSize: 15, height: 1.4, fontWeight: FontWeight.bold, color: AppColors.primaryDark))]),
               ), SizedBox(width: 10),
              _ComplaintStatus(status: complaint.status, isArabic: isArabic),
          ]),
          ),
          const SizedBox(height: 12),
          _section(context, Icons.report_problem_outlined, isArabic ? 'بيانات الشكوى' : 'Complaint', [
            _line(isArabic ? 'التفاصيل' : 'Details', complaint.descriptionFor(isArabic)),
            _line(isArabic ? 'العميل' : 'Customer', complaint.customerNameFor(isArabic)),
            _line(isArabic ? 'الهاتف' : 'Phone', complaint.customerPhone),
            _line(isArabic ? 'تاريخ الاستلام' : 'Received', date),
          ]),
          if (productOnly) ...[
            const SizedBox(height: 12),
            _section(context, Icons.inventory_2_outlined, isArabic ? 'المنتج محل الشكوى' : 'Product in complaint', [
              _line(isArabic ? 'اسم المنتج' : 'Product', complaint.productNameFor(isArabic)!),
              _line(isArabic ? 'رقم الإعلان' : 'Ad reference', complaint.productReference ?? '—'),
              _line(isArabic ? 'السعر' : 'Price', isArabic ? complaint.productPrice ?? '—' : complaint.productPriceEn ?? complaint.productPrice ?? '—'),
            ]),
          ],
          const SizedBox(height: 12),
          _section(context, Icons.timeline_outlined, isArabic ? 'سجل المتابعة' : 'Activity timeline', [
              _timelineEntry(context, Icons.mark_email_read_outlined, isArabic ? 'استلام الشكوى' : 'Complaint received', date, AppColors.infoDark),
              const SizedBox(height: 12),
              _ComplaintAuditHistory(complaint: complaint, isArabic: isArabic),
              if (complaint.noteFor(isArabic) != null) ...[
                Padding(padding: const EdgeInsetsDirectional.only(start: 16, top: 5), child: Container(width: 2, height: 12, color: AppColors.cardBorder)),
                _line(isArabic ? 'ملاحظة المشرف' : 'Supervisor note', complaint.noteFor(isArabic)!),
              ],
            ]),
          const SizedBox(height: 18),
          FilledButton.icon(onPressed: saving ? null : () => onNotice(complaint), icon: const Icon(Icons.notifications_active_outlined), label: Text(isArabic ? 'إرسال إشعار نصي للعميل' : 'Send text notification')),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => MerchantConversationScreen(conversationTitle: complaint.customerNameFor(isArabic), conversationParticipants: [isArabic ? 'العميل' : 'Customer', isArabic ? 'مشرف المنتجات' : 'Product supervisor']))),
            icon: const Icon(Icons.chat_outlined),
            label: Text(isArabic ? 'التواصل مع العميل' : 'Contact customer'),
          ),
          const SizedBox(height: 12),
          if (complaint.status == ProductComplaintStatus.open ||
              complaint.status == ProductComplaintStatus.onHold)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(isArabic ? 'الإجراءات' : 'Actions', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: saving ? null : () => onAction(complaint, ProductComplaintStatus.resolved, note: 'تم حل المشكلة', noteEn: 'Issue resolved'),
                  icon: const Icon(Icons.task_alt), label: Text(isArabic ? 'تأكيد حل المشكلة' : 'Mark as resolved'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.hexFF087A58),
                ),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  _action(context, isArabic ? 'تعليق الشكوى' : 'Put on hold', Icons.pause_circle_outline, AppColors.hexFF8A5A00, () => onAction(complaint, ProductComplaintStatus.onHold, note: 'الشكوى معلقة للمتابعة', noteEn: 'Complaint put on hold')),
                  _action(context, isArabic ? 'تصعيد' : 'Escalate', Icons.north_east, AppColors.infoDark, () => _confirmAction(context, isArabic, escalation: true, onConfirm: (reason) => onAction(complaint, ProductComplaintStatus.escalated, note: reason, noteEn: reason))),
                  _action(context, isArabic ? 'حذف' : 'Remove', Icons.delete_outline, AppColors.dangerDark, () => _confirmAction(context, isArabic, escalation: false, onConfirm: (reason) => onAction(complaint, ProductComplaintStatus.deleted, note: reason, noteEn: reason))),
                ]),
              ]),
            ),
          const SizedBox(height: 12),
          if (complaint.status != ProductComplaintStatus.open)
            OutlinedButton.icon(onPressed: saving ? null : () => onAction(complaint, ProductComplaintStatus.open, note: 'أعيد فتح الشكوى', noteEn: 'Complaint reopened'), icon: const Icon(Icons.undo), label: Text(isArabic ? 'إعادة فتح الشكوى' : 'Reopen complaint')),
        ]),
      ),
    );
  }

  Widget _section(BuildContext context, IconData icon, String title, List<Widget> rows) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Row(children: [Icon(icon, color: AppColors.info), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark))]), const SizedBox(height: 10), ...rows]));
  Widget _timelineEntry(BuildContext context, IconData icon, String title, String subtitle, Color color) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withValues(alpha: .10), shape: BoxShape.circle), child: Icon(icon, size: 16, color: color)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary))]))]);
  IconData _timelineIcon(ProductComplaintStatus status) => switch (status) { ProductComplaintStatus.open => Icons.mark_email_read_outlined, ProductComplaintStatus.onHold => Icons.pause_circle_outline, ProductComplaintStatus.resolved => Icons.task_alt, ProductComplaintStatus.escalated => Icons.north_east, ProductComplaintStatus.deleted => Icons.delete_outline };
  String _statusLabel(ProductComplaintStatus status) => switch (status) { ProductComplaintStatus.open => isArabic ? 'مفتوحة' : 'Open', ProductComplaintStatus.onHold => isArabic ? 'معلقة للمتابعة' : 'On hold', ProductComplaintStatus.resolved => isArabic ? 'تم حلها' : 'Resolved', ProductComplaintStatus.escalated => isArabic ? 'تم التصعيد' : 'Escalated', ProductComplaintStatus.deleted => isArabic ? 'محذوفة' : 'Removed' };
  Color _statusColor(ProductComplaintStatus status) => switch (status) { ProductComplaintStatus.open => AppColors.infoDark, ProductComplaintStatus.onHold => AppColors.hexFF8A5A00, ProductComplaintStatus.resolved => AppColors.successDark, ProductComplaintStatus.escalated || ProductComplaintStatus.deleted => AppColors.dangerDark };
  Widget _line(String label, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 92, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))), Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)))]));
  Widget _action(BuildContext context, String label, IconData icon, Color color, VoidCallback action) => ActionChip(avatar: Icon(icon, size: 17, color: color), label: Text(label), onPressed: saving ? null : action);
}

class _ComplaintStatus extends StatelessWidget {
  final ProductComplaintStatus status;
  final bool isArabic;
  const _ComplaintStatus({required this.status, required this.isArabic});
  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ProductComplaintStatus.open => (isArabic ? 'مفتوحة' : 'Open', AppColors.infoDark),
      ProductComplaintStatus.onHold => (isArabic ? 'معلقة' : 'On hold', AppColors.hexFF8A5A00),
      ProductComplaintStatus.resolved => (isArabic ? 'تم الحل' : 'Resolved', AppColors.successDark),
      ProductComplaintStatus.escalated => (isArabic ? 'مصعّدة' : 'Escalated', AppColors.dangerDark),
      ProductComplaintStatus.deleted => (isArabic ? 'محذوفة' : 'Removed', AppColors.textSecondary),
    };
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: color.withValues(alpha: .10), borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)));
  }
}

class _ComplaintAuditHistory extends StatefulWidget {
  final ProductCustomerComplaint complaint;
  final bool isArabic;
  const _ComplaintAuditHistory({required this.complaint, required this.isArabic});

  @override
  State<_ComplaintAuditHistory> createState() => _ComplaintAuditHistoryState();
}

class _ComplaintAuditHistoryState extends State<_ComplaintAuditHistory> {
  late Future<List<ProductSupervisorAuditEntry>> _entries;

  @override
  void initState() {
    super.initState();
    _entries = sl<ProductSupervisorAuditRepository>().getEntries();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ProductSupervisorAuditEntry>>(
        future: _entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LinearProgressIndicator(minHeight: 2);
          }
          if (snapshot.hasError) {
            return Text(widget.isArabic ? 'تعذر تحميل سجل الإجراءات' : 'Could not load the action history');
          }
          final entries = (snapshot.data ?? const <ProductSupervisorAuditEntry>[])
              .where((entry) => entry.details.contains(widget.complaint.id))
              .toList();
          if (entries.isEmpty) {
            return Text(widget.isArabic ? 'لا توجد إجراءات سابقة مسجلة.' : 'No previous actions have been recorded.', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary));
          }
          return Column(children: entries.take(8).map((entry) {
            final date = DateFormat.yMd(Localizations.localeOf(context).toLanguageTag())
                .add_Hm()
                .format(entry.occurredAt.toLocal());
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.history, size: 16, color: AppColors.infoDark),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(entry.actionKey.replaceAll('_', ' '), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                  Text(entry.details, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  Text(widget.isArabic ? 'بواسطة ${entry.actorName}' : 'By Product supervisor', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                  Text(date, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                ])),
              ]),
            );
          }).toList());
        },
      );
}

class _PriorityBadge extends StatelessWidget {
  final bool isArabic;
  const _PriorityBadge({required this.isArabic});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.dangerDark.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isArabic ? 'أولوية عالية' : 'High priority',
          style: const TextStyle(
            color: AppColors.dangerDark,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
