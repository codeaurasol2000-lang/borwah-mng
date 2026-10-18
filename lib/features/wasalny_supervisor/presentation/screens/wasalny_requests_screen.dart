import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/wasalny_local_event_store.dart';
import '../../../products/domain/entities/product_supervisor_audit_entry.dart';
import '../../../products/domain/repositories/product_supervisor_audit_repository.dart';

enum _RequestStage { communication, sold }

enum _RequestStatus { awaitingApproval, underReview, communication, sold }

class _WasalnyRequest {
  final String id;
  final String titleAr;
  final String titleEn;
  final String sellerAr;
  final String sellerEn;
  final String buyerAr;
  final String buyerEn;
  final String sellerPhone;
  final String buyerPhone;
  final String price;
  final String statusNoteAr;
  final String statusNoteEn;
  final String locationAr;
  final String locationEn;
  final String productDetailsAr;
  final String productDetailsEn;
  final String ageAr;
  final String ageEn;
  final _RequestStage stage;
  final _RequestStatus status;
  final IconData icon;
  final Color color;

  const _WasalnyRequest({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.sellerAr,
    required this.sellerEn,
    required this.buyerAr,
    required this.buyerEn,
    required this.sellerPhone,
    required this.buyerPhone,
    required this.price,
    required this.statusNoteAr,
    required this.statusNoteEn,
    required this.locationAr,
    required this.locationEn,
    required this.productDetailsAr,
    required this.productDetailsEn,
    required this.ageAr,
    required this.ageEn,
    required this.stage,
    required this.status,
    required this.icon,
    required this.color,
  });
}

const _sampleRequests = <_WasalnyRequest>[
  _WasalnyRequest(
    id: 'W-1042',
    titleAr: 'كاميرا كانون EOS R6 (نظيفة جداً)',
    titleEn: 'Canon EOS R6 camera (excellent condition)',
    sellerAr: 'عبد الرحمن الشمري',
    sellerEn: 'Abdulrahman Al-Shammari',
    buyerAr: 'فهد العتيبي',
    buyerEn: 'Fahad Al-Otaibi',
    sellerPhone: '050 000 1042',
    buyerPhone: '050 000 2042',
    price: '6,400',
    statusNoteAr: 'بيانات التواصل بين الطرفين محمية',
    statusNoteEn: 'Contact details between both parties are protected',
    locationAr: 'الرياض - حي النرجس',
    locationEn: 'Riyadh - Al Narjis',
    productDetailsAr:
        'كاميرا بحالة ممتازة مع عدسة أصلية وبطاريتين وشاحن. تمت مراجعة بيانات الطلب.',
    productDetailsEn:
        'Excellent-condition camera with an original lens, two batteries, and charger. Request details have been reviewed.',
    ageAr: 'منذ ساعتين',
    ageEn: '2 hours ago',
    stage: _RequestStage.communication,
    status: _RequestStatus.communication,
    icon: Icons.camera_alt_outlined,
    color: AppColors.hexFF253B54,
  ),
  _WasalnyRequest(
    id: 'W-1038',
    titleAr: 'جهاز بلايستيشن 5 مع 5 ألعاب أصلية',
    titleEn: 'PlayStation 5 with 5 original games',
    sellerAr: 'محمد الدوسري',
    sellerEn: 'Mohammed Al-Dosari',
    buyerAr: 'سلطان الحربي',
    buyerEn: 'Sultan Al-Harbi',
    sellerPhone: '050 000 1038',
    buyerPhone: '050 000 2038',
    price: '1,850',
    statusNoteAr: 'تم استلام الشحنة في مستودع الفحص',
    statusNoteEn: 'The shipment arrived at the inspection depot',
    locationAr: 'مركز فحص شمال الرياض - المحطة',
    locationEn: 'North Riyadh inspection center - station',
    productDetailsAr:
        'جهاز بلايستيشن 5 مع خمسة ألعاب أصلية وجميع الملحقات المذكورة في الإعلان.',
    productDetailsEn:
        'PlayStation 5 with five original games and all accessories listed in the advertisement.',
    ageAr: 'منذ 4 ساعات',
    ageEn: '4 hours ago',
    stage: _RequestStage.communication,
    status: _RequestStatus.underReview,
    icon: Icons.sports_esports_outlined,
    color: AppColors.hexFF5D8097,
  ),
  _WasalnyRequest(
    id: 'W-1031',
    titleAr: 'ماك بوك برو M2 شاشة 14 إنش',
    titleEn: 'MacBook Pro M2, 14-inch display',
    sellerAr: 'تركي العتيبي',
    sellerEn: 'Turki Al-Otaibi',
    buyerAr: 'عبد الله القحطاني',
    buyerEn: 'Abdullah Al-Qahtani',
    sellerPhone: '050 000 1031',
    buyerPhone: '050 000 2031',
    price: '5,200',
    statusNoteAr: 'بانتظار موافقة الطرفين على الشروط والسداد',
    statusNoteEn: 'Waiting for both parties to agree to terms and payment',
    locationAr: 'التواصل بين البائع والمشتري',
    locationEn: 'Seller and buyer coordination',
    productDetailsAr:
        'ماك بوك برو بمعالج M2 وشاشة 14 إنش. الطلب بانتظار موافقة الطرفين على تفاصيل الصفقة.',
    productDetailsEn:
        'MacBook Pro with an M2 chip and 14-inch display. The request is awaiting both parties’ approval of the deal details.',
    ageAr: 'منذ 6 ساعات',
    ageEn: '6 hours ago',
    stage: _RequestStage.communication,
    status: _RequestStatus.awaitingApproval,
    icon: Icons.laptop_mac_outlined,
    color: AppColors.hexFF796B56,
  ),
  _WasalnyRequest(
    id: 'W-1024',
    titleAr: 'آيفون 15 برو سعة 256 جيجابايت',
    titleEn: 'iPhone 15 Pro, 256 GB',
    sellerAr: 'نواف المطيري',
    sellerEn: 'Nawaf Al-Mutairi',
    buyerAr: 'سعود الدخيل',
    buyerEn: 'Saud Al-Dakhil',
    sellerPhone: '050 000 1024',
    buyerPhone: '050 000 2024',
    price: '3,750',
    statusNoteAr: 'تم البيع وإتمام التسليم بنجاح',
    statusNoteEn: 'Sold and delivered successfully',
    locationAr: 'الرياض',
    locationEn: 'Riyadh',
    productDetailsAr:
        'آيفون 15 برو سعة 256 جيجابايت. تم البيع وإتمام التسليم بنجاح.',
    productDetailsEn:
        'iPhone 15 Pro, 256 GB. Sold and delivered successfully.',
    ageAr: 'منذ يوم',
    ageEn: '1 day ago',
    stage: _RequestStage.sold,
    status: _RequestStatus.sold,
    icon: Icons.phone_iphone_outlined,
    color: AppColors.hexFF51627A,
  ),
];

class WasalnyRequestsScreen extends StatefulWidget {
  const WasalnyRequestsScreen({super.key});

  @override
  State<WasalnyRequestsScreen> createState() => _WasalnyRequestsScreenState();
}

class _WasalnyRequestsScreenState extends State<WasalnyRequestsScreen> {
  _RequestStage? _selectedStage;
  final Set<String> _revealedRequestIds = {};

  @override
  void initState() {
    super.initState();
    _loadRevealedRequests();
  }

  Future<void> _loadRevealedRequests() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _revealedRequestIds.addAll(
          preferences.getStringList('wasalny_revealed_request_ids') ?? const [],
        );
      });
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'Wasalny requests',
          context: ErrorDescription('while loading revealed contact requests'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final requests = _sampleRequests
        .where((request) =>
            _selectedStage == null || request.stage == _selectedStage)
        .toList();
    final communicationCount = _sampleRequests
        .where((request) => request.stage == _RequestStage.communication)
        .length;
    final soldCount = _sampleRequests
        .where((request) => request.stage == _RequestStage.sold)
        .length;
    final completionRate = _sampleRequests.isEmpty
        ? 0
        : (soldCount * 100 / _sampleRequests.length).round();

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _SafetyBanner(l10n: l10n),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  value: '$completionRate%',
                  label: l10n.wasalnyRequestsCompletionRate,
                  icon: Icons.trending_up_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryCard(
                  value: '${_sampleRequests.length - soldCount}',
                  label: l10n.wasalnyRequestsActiveDeals,
                  icon: Icons.handshake_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StageChip(
                  label: l10n.wasalnyRequestsAll,
                  count: _sampleRequests.length,
                  selected: _selectedStage == null,
                  onTap: () => setState(() => _selectedStage = null),
                ),
                _StageChip(
                  label: l10n.wasalnyRequestsCommunication,
                  count: communicationCount,
                  selected: _selectedStage == _RequestStage.communication,
                  onTap: () => setState(
                    () => _selectedStage = _RequestStage.communication,
                  ),
                ),
                _StageChip(
                  label: l10n.wasalnyRequestsSold,
                  count: soldCount,
                  selected: _selectedStage == _RequestStage.sold,
                  onTap: () =>
                      setState(() => _selectedStage = _RequestStage.sold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (requests.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Text(
                l10n.wasalnyRequestsEmpty,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          for (final request in requests) ...[
            _RequestCard(
              request: request,
              l10n: l10n,
              isArabic: isArabic,
              isRevealed: _revealedRequestIds.contains(request.id),
              onPreview: () => _showRequestDetails(
                request,
                l10n,
                isArabic,
                _revealedRequestIds.contains(request.id),
              ),
              onReveal: () => _confirmReveal(request, l10n),
              onHideData: () => _hideContactDetails(request, l10n, isArabic),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmReveal(
    _WasalnyRequest request,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.lock_open_outlined),
        title: Text(l10n.wasalnyRequestsRevealTitle),
        content: Text(l10n.wasalnyRequestsRevealConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.wasalnyRequestsRevealAction),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final disclosureKey = _monthlyDisclosureKey(request);
      final preferences = await SharedPreferences.getInstance();
      final disclosureCount = preferences.getInt(disclosureKey) ?? 0;
      if (disclosureCount >= 2) {
        await _publishBuyerNotice(
          request,
          'limit',
          l10n.wasalnyRequestsMonthlyLimitMessage,
          'This buyer reached the monthly contact disclosure limit. An in-app subscription is required.',
          disclosureCount,
        );
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.workspace_premium_outlined),
            title: Text(l10n.wasalnyRequestsMonthlyLimitTitle),
            content: Text(l10n.wasalnyRequestsMonthlyLimitMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancelAction),
              ),
            ],
          ),
        );
        return;
      }
      final recorded = await _recordContactAudit(
        request: request,
        actionKey: 'wasalny_request_contact_revealed',
        l10n: l10n,
        isArabic: l10n.localeName.startsWith('ar'),
      );
      if (!recorded || !mounted) return;
      try {
        await preferences.setInt(disclosureKey, disclosureCount + 1);
        final revealed =
            preferences.getStringList('wasalny_revealed_request_ids') ??
                <String>[];
        if (!revealed.contains(request.id)) revealed.add(request.id);
        await preferences.setStringList(
          'wasalny_revealed_request_ids',
          revealed,
        );
      } catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'Wasalny requests',
            context: ErrorDescription('while saving contact disclosure usage'),
          ),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.productAuditSaveError)),
          );
        }
        return;
      }
      await _publishBuyerNotice(
        request,
        'revealed',
        'تمت الموافقة على إظهار بيانات التواصل',
        'Your contact details were approved for disclosure. Two requests per month are included; additional requests require an in-app subscription.',
        disclosureCount + 1,
      );
      setState(() => _revealedRequestIds.add(request.id));
    }
  }

  Future<void> _publishBuyerNotice(
    _WasalnyRequest request,
    String eventType,
    String messageAr,
    String messageEn,
    int requestCount,
  ) async {
    final buyerId = request.buyerPhone.replaceAll(RegExp(r'\D'), '');
    final now = DateTime.now();
    final month = '${now.year}${now.month.toString().padLeft(2, '0')}';
    try {
      await WasalnyLocalEventStore().publish(
        WasalnyLocalEvent(
          id: 'buyer-$eventType-$buyerId-$month-$requestCount',
          recipient: 'buyer:$buyerId',
          source: 'wasalny',
          titleAr: eventType == 'limit'
              ? 'يتطلب طلب إظهار البيانات اشتراكاً'
              : 'تم تحديث طلب إظهار البيانات',
          titleEn: eventType == 'limit'
              ? 'Contact disclosure requires a subscription'
              : 'Contact disclosure request updated',
          messageAr: messageAr,
          messageEn: messageEn,
          createdAt: now,
        ),
      );
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'Wasalny requests',
          context: ErrorDescription('while notifying the buyer locally'),
        ),
      );
    }
  }

  String _monthlyDisclosureKey(_WasalnyRequest request) {
    final now = DateTime.now();
    final month = '${now.year}${now.month.toString().padLeft(2, '0')}';
    final phone = request.buyerPhone.replaceAll(RegExp(r'\D'), '');
    return 'wasalny_buyer_disclosures_${phone}_$month';
  }

  Future<void> _hideContactDetails(
    _WasalnyRequest request,
    AppLocalizations l10n,
    bool isArabic,
  ) async {
    final recorded = await _recordContactAudit(
      request: request,
      actionKey: 'wasalny_request_contact_hidden',
      l10n: l10n,
      isArabic: isArabic,
    );
    if (!recorded || !mounted) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      final revealed =
          preferences.getStringList('wasalny_revealed_request_ids') ?? <String>[];
      revealed.remove(request.id);
      await preferences.setStringList('wasalny_revealed_request_ids', revealed);
      if (mounted) setState(() => _revealedRequestIds.remove(request.id));
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'Wasalny requests',
          context: ErrorDescription('while hiding contact details'),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.productAuditSaveError)),
        );
      }
    }
  }

  Future<bool> _recordContactAudit({
    required _WasalnyRequest request,
    required String actionKey,
    required AppLocalizations l10n,
    required bool isArabic,
  }) async {
    try {
      final now = DateTime.now();
      await sl<ProductSupervisorAuditRepository>().recordEntry(
        ProductSupervisorAuditEntry(
          id: now.microsecondsSinceEpoch.toString(),
          actionKey: actionKey,
          subject: isArabic ? request.titleAr : request.titleEn,
          details: request.id,
          occurredAt: now,
        ),
      );
      return true;
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'Wasalny requests',
          context: ErrorDescription('while recording a contact disclosure'),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.productAuditSaveError)),
        );
      }
      return false;
    }
  }

  Future<void> _showRequestDetails(
    _WasalnyRequest request,
    AppLocalizations l10n,
    bool isArabic,
    bool isRevealed,
  ) {
    final title = isArabic ? request.titleAr : request.titleEn;
    final note = isArabic ? request.statusNoteAr : request.statusNoteEn;
    final location = isArabic ? request.locationAr : request.locationEn;
    final seller = isArabic ? request.sellerAr : request.sellerEn;
    final buyer = isArabic ? request.buyerAr : request.buyerEn;
    final productDetails =
        isArabic ? request.productDetailsAr : request.productDetailsEn;
    final status = _requestStatusLabel(request.status, l10n);
    final contactProtection = isArabic
        ? 'بيانات التواصل محمية حتى تأكيد إظهارها'
        : 'Contact details are protected until revealed';

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.wasalnyRequestsPreviewTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _StatusPill(
                      label: status,
                      icon: _requestStatusIcon(request.status),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _RequestPhotoGallery(request: request, title: title),
                const SizedBox(height: 18),
                _DetailsSection(
                  title: isArabic ? 'بيانات المنتج' : 'Product details',
                  icon: Icons.inventory_2_outlined,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      productDetails,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _DetailLine(
                      label: l10n.wasalnyRequestsEstimatedValue,
                      value: '${request.price} ${l10n.productWalletCurrency}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _DetailsSection(
                  title: isArabic ? 'معلومات الطلب' : 'Request information',
                  icon: Icons.receipt_long_outlined,
                  children: [
                    _DetailLine(
                      label: l10n.wasalnyRequestsOrderNumber,
                      value: request.id,
                    ),
                    _DetailLine(
                      label: l10n.wasalnyRequestsCurrentStatus,
                      value: '$status — $note',
                    ),
                    _DetailLine(
                      label: l10n.wasalnyRequestsLocation,
                      value: location,
                    ),
                    _DetailLine(
                      label: isArabic ? 'تاريخ الطلب' : 'Request age',
                      value: isArabic ? request.ageAr : request.ageEn,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _DetailsSection(
                  title: isArabic ? 'أطراف الطلب' : 'People in this request',
                  icon: Icons.people_outline,
                  children: [
                    _PersonDetails(
                      role: l10n.wasalnyRequestsSeller,
                      name: seller,
                      phone: isRevealed ? request.sellerPhone : null,
                      protectedLabel: contactProtection,
                      icon: Icons.storefront_outlined,
                    ),
                    const SizedBox(height: 10),
                    _PersonDetails(
                      role: l10n.wasalnyRequestsBuyer,
                      name: buyer,
                      phone: isRevealed ? request.buyerPhone : null,
                      protectedLabel: contactProtection,
                      icon: Icons.person_outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SafetyBanner extends StatelessWidget {
  final AppLocalizations l10n;

  const _SafetyBanner({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.hexFF18375C, AppColors.hexFF08213E],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.hex1A000000,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.wasalnyRequestsSafetyTitle,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  l10n.wasalnyRequestsSafetyDescription,
                  style: const TextStyle(
                    color: AppColors.hexFFD6E1EF,
                    height: 1.5,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 3),
              Icon(icon, color: AppColors.primaryDark, size: 15),
            ],
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _StageChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _StageChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.white.withValues(alpha: 0.18)
                    : AppColors.hexFFE4E6E9,
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: selected ? AppColors.white : AppColors.textSecondary,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primaryDark,
        labelStyle: TextStyle(
          color: selected ? AppColors.white : AppColors.textSecondary,
          fontSize: 10,
        ),
        side: BorderSide.none,
        visualDensity: VisualDensity.compact,
        showCheckmark: false,
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final _WasalnyRequest request;
  final AppLocalizations l10n;
  final bool isArabic;
  final bool isRevealed;
  final VoidCallback onPreview;
  final VoidCallback onReveal;
  final VoidCallback onHideData;

  const _RequestCard({
    required this.request,
    required this.l10n,
    required this.isArabic,
    required this.isRevealed,
    required this.onPreview,
    required this.onReveal,
    required this.onHideData,
  });

  @override
  Widget build(BuildContext context) {
    final title = isArabic ? request.titleAr : request.titleEn;
    final seller = isArabic ? request.sellerAr : request.sellerEn;
    final buyer = isArabic ? request.buyerAr : request.buyerEn;
    final statusNote = isArabic ? request.statusNoteAr : request.statusNoteEn;
    final location = isArabic ? request.locationAr : request.locationEn;
    final age = isArabic ? request.ageAr : request.ageEn;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.hex10000000,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatusPill(
                label: _requestStatusLabel(request.status, l10n),
                icon: _requestStatusIcon(request.status),
              ),
              const Spacer(),
              Text(
                age,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${l10n.wasalnyRequestsEstimatedValue}: ${request.price} ${l10n.productWalletCurrency}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: request.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(request.icon, color: AppColors.white, size: 32),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _PersonPill(
                  role: l10n.wasalnyRequestsSeller,
                  name: seller,
                  icon: Icons.storefront_outlined,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _PersonPill(
                  role: l10n.wasalnyRequestsBuyer,
                  name: buyer,
                  icon: Icons.person_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (request.status != _RequestStatus.sold) ...[
            Row(
              children: [
                Expanded(
                  child: _CardButton(
                    label: isRevealed
                        ? l10n.wasalnyRequestsHideData
                        : l10n.wasalnyRequestsRevealAction,
                    icon: isRevealed
                        ? Icons.lock_outline
                        : Icons.lock_open_outlined,
                    background: AppColors.primaryDark,
                    foreground: AppColors.white,
                    onPressed: isRevealed ? onHideData : onReveal,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _CardButton(
                    label: l10n.wasalnyRequestsPreviewAction,
                    icon: Icons.visibility_outlined,
                    background: AppColors.hexFFEDEFF1,
                    foreground: AppColors.primaryDark,
                    onPressed: onPreview,
                  ),
                ),
              ],
            ),
          ],
          if (isRevealed) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _PhonePill(
                    label: l10n.wasalnyRequestsSeller,
                    phone: request.sellerPhone,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _PhonePill(
                    label: l10n.wasalnyRequestsBuyer,
                    phone: request.buyerPhone,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.hexFFE9EAEC,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  isRevealed ? Icons.lock_open_outlined : Icons.lock_outline,
                  size: 15,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isRevealed ? '$statusNote • $location' : statusNote,
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
          ),
        ],
      ),
    );
  }

}

String _requestStatusLabel(_RequestStatus status, AppLocalizations l10n) =>
    switch (status) {
      _RequestStatus.awaitingApproval => l10n.wasalnyRequestsAwaitingApproval,
      _RequestStatus.underReview => l10n.wasalnyRequestsUnderReview,
      _RequestStatus.communication => l10n.wasalnyRequestsCommunication,
      _RequestStatus.sold => l10n.wasalnyRequestsSold,
    };

IconData _requestStatusIcon(_RequestStatus status) => switch (status) {
      _RequestStatus.awaitingApproval => Icons.hourglass_top_rounded,
      _RequestStatus.underReview => Icons.manage_search_outlined,
      _RequestStatus.communication => Icons.chat_bubble_outline,
      _RequestStatus.sold => Icons.handshake_outlined,
    };

class _StatusPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatusPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.hexFFDCE8FF,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primaryDark),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonPill extends StatelessWidget {
  final String role;
  final String name;
  final IconData icon;

  const _PersonPill({
    required this.role,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.hexFFE9EAEC,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryDark, size: 15),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 8,
                  ),
                ),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestPhotoGallery extends StatelessWidget {
  final _WasalnyRequest request;
  final String title;

  const _RequestPhotoGallery({required this.request, required this.title});

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context)!.localeName.startsWith('ar');
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (context, index) => Container(
          width: 148,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                request.color.withValues(alpha: 0.72),
                request.color,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  request.icon,
                  color: AppColors.white.withValues(alpha: 0.92),
                  size: 66,
                ),
              ),
              PositionedDirectional(
                top: 8,
                start: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.32),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${isArabic ? 'صورة' : 'Photo'} ${index + 1}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                start: 8,
                end: 8,
                bottom: 8,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryDark, size: 18),
              const SizedBox(width: 7),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _PersonDetails extends StatelessWidget {
  final String role;
  final String name;
  final String? phone;
  final String protectedLabel;
  final IconData icon;

  const _PersonDetails({
    required this.role,
    required this.name,
    required this.phone,
    required this.protectedLabel,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryDark, size: 19),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                role,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                phone ?? protectedLabel,
                textDirection: phone == null ? null : ui.TextDirection.ltr,
                style: TextStyle(
                  color: phone == null
                      ? AppColors.textSecondary
                      : AppColors.primaryDark,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhonePill extends StatelessWidget {
  final String label;
  final String phone;

  const _PhonePill({required this.label, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        '$label: $phone',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.primaryDark,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  const _CardButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foreground, size: 16),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
