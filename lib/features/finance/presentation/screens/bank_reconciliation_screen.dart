import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_locale_controller.dart';
import '../../../../core/widgets/finance_dialogs.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/finance_navigation.dart';

class _ReconciliationItem {
  final String id;
  final String commercialName;
  final String beneficiaryName;
  final String iban;
  final String bankName;
  final String crNumber;
  final String crExpiry;
  final String documentName;
  final String amlScore;
  final String requestType;
  final String matchDescription;
  final String warningNote;
  final String? commercialNameEn;
  final String? beneficiaryNameEn;
  final String? bankNameEn;
  final String? crExpiryEn;
  final String? requestTypeEn;
  final String? matchDescriptionEn;
  final String? warningNoteEn;

  const _ReconciliationItem({
    required this.id,
    required this.commercialName,
    required this.beneficiaryName,
    required this.iban,
    required this.bankName,
    required this.crNumber,
    required this.crExpiry,
    required this.documentName,
    required this.amlScore,
    required this.requestType,
    required this.matchDescription,
    this.warningNote = '',
    this.commercialNameEn,
    this.beneficiaryNameEn,
    this.bankNameEn,
    this.crExpiryEn,
    this.requestTypeEn,
    this.matchDescriptionEn,
    this.warningNoteEn,
  });

  String getCommercialName(bool isArabic) =>
      isArabic ? commercialName : (commercialNameEn ?? commercialName);
  String getBeneficiaryName(bool isArabic) =>
      isArabic ? beneficiaryName : (beneficiaryNameEn ?? beneficiaryName);
  String getBankName(bool isArabic) =>
      isArabic ? bankName : (bankNameEn ?? bankName);
  String getCrExpiry(bool isArabic) =>
      isArabic ? crExpiry : (crExpiryEn ?? crExpiry);
  String getRequestType(bool isArabic) =>
      isArabic ? requestType : (requestTypeEn ?? requestType);
  String getMatchDescription(bool isArabic) =>
      isArabic ? matchDescription : (matchDescriptionEn ?? matchDescription);
  String getWarningNote(bool isArabic) =>
      isArabic ? warningNote : (warningNoteEn ?? warningNote);
}

class BankReconciliationScreen extends StatefulWidget {
  final int currentIndex;
  final bool showBottomNavigation;

  const BankReconciliationScreen({
    super.key,
    this.currentIndex = 3,
    this.showBottomNavigation = true,
  });

  @override
  State<BankReconciliationScreen> createState() => _BankReconciliationScreenState();
}

class _BankReconciliationScreenState extends State<BankReconciliationScreen> {
  int _activeRequestIndex = 0;

  final List<_ReconciliationItem> _requests = const [
    _ReconciliationItem(
      id: '#TRD-5501',
      commercialName: 'مؤسسة التجارة المتقدمة المحدودة',
      beneficiaryName: 'مؤسسة التجارة المتقدمة للخدمات والتوكيلات',
      iban: 'SA44 8000 0123 6080 1012 3456',
      bankName: 'مصرف الراجحي',
      crNumber: '1010892341',
      crExpiry: '1448/04/15هـ',
      documentName: 'doc-iban-5501.pdf',
      amlScore: '100%',
      requestType: 'طلب ربط وتوثيق حساب تجاري جديد',
      matchDescription: 'تطابق الاسم التجاري والبنكي موثق بنسبة 100%',
      commercialNameEn: 'Advanced Trading Establishment Ltd.',
      beneficiaryNameEn: 'Advanced Trading Est. for Services & Agencies',
      bankNameEn: 'Al Rajhi Bank',
      crExpiryEn: '1448/04/15 AH',
      requestTypeEn: 'New Commercial Account Link & Verification Request',
      matchDescriptionEn: '100% Verified match between commercial and bank name',
    ),
    _ReconciliationItem(
      id: '#TRD-6022',
      commercialName: 'شركة مدار الرواد للمقاولات العامة',
      beneficiaryName: 'شركة مدار الرواد للتجارة والمقاولات ش.ش.و',
      iban: 'SA03 8000 0456 9910 2233 4455',
      bankName: 'البنك الأهلي السعودي (SNB)',
      crNumber: '1010994523',
      crExpiry: '1447/11/20هـ',
      documentName: 'doc-iban-6022.pdf',
      amlScore: '96%',
      requestType: 'طلب ربط حساب مورد معتمد',
      matchDescription: 'اختلاف طفيف في اللواحق القانونية للاسم التجاري',
      warningNote: 'تم رصد اختلاف بين لاحقة السجل والحساب البنكي',
      commercialNameEn: 'Madar Al-Ruwad General Contracting Co.',
      beneficiaryNameEn: 'Madar Al-Ruwad Trading & Contracting LLC',
      bankNameEn: 'Saudi National Bank (SNB)',
      crExpiryEn: '1447/11/20 AH',
      requestTypeEn: 'Approved Supplier Account Link Request',
      matchDescriptionEn: 'Minor variance in legal suffixes of the commercial name',
      warningNoteEn: 'Variance detected between CR suffix and bank account name',
    ),
    _ReconciliationItem(
      id: '#TRD-7108',
      commercialName: 'مؤسسة القمة الرقمية لتقنية المعلومات',
      beneficiaryName: 'فهد سليمان عبد الله العتيبي',
      iban: 'SA12 1000 0987 5544 3322 1100',
      bankName: 'بنك الرياض',
      crNumber: '1010778899',
      crExpiry: '1448/01/10هـ',
      documentName: 'doc-iban-7108.pdf',
      amlScore: '89%',
      requestType: 'طلب ربط حساب مزود خدمة مستقل',
      matchDescription: 'مؤسسة فردية تتطلب شهادة آيبان حديثة مختومة',
      warningNote: 'شهادة الآيبان المرفقة تعود لأكثر من 6 أشهر',
      commercialNameEn: 'Digital Summit IT Establishment',
      beneficiaryNameEn: 'Fahad Sulaiman Abdullah Al-Otaibi',
      bankNameEn: 'Riyad Bank',
      crExpiryEn: '1448/01/10 AH',
      requestTypeEn: 'Freelance Service Provider Account Link Request',
      matchDescriptionEn: 'Sole proprietorship requires a recent stamped IBAN certificate',
      warningNoteEn: 'Attached IBAN certificate is older than 6 months',
    ),
  ];

  _ReconciliationItem get _currentRequest =>
      _requests[_activeRequestIndex % _requests.length];

  _ReconciliationItem get _nextRequest =>
      _requests[(_activeRequestIndex + 1) % _requests.length];

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _advanceToNextRequest() {
    setState(() {
      _activeRequestIndex = (_activeRequestIndex + 1) % _requests.length;
    });
  }

  Future<void> _handleApprove() async {
    final isArabic = AppLocaleController.instance.isArabic;
    final item = _currentRequest;
    final name = item.getCommercialName(isArabic);

    final confirmed = await FinanceDialogs.showApprovalDialog(
      context,
      title: isArabic ? 'اعتماد الحساب البنكي' : 'Approve Bank Account',
      description: isArabic
          ? 'هل ترغب في اعتماد مطابقة الحساب البنكي لـ "$name" (${item.id}) وإرساله فوراً إلى إدارة النظام للمصادقة عليه؟'
          : 'Approve bank match for "$name" (${item.id}) and submit to Admin for final authorization?',
      confirmText: isArabic ? 'اعتماد وإرسال للإدارة' : 'Approve & Send to Admin',
    );

    if (confirmed && mounted) {
      _showActionMessage(isArabic
          ? 'تم اعتماد الحساب البنكي لـ "$name" وإرساله بنجاح إلى الإدارة للمصادقة.'
          : 'Bank account approved and sent to Admin for approval.');
      _advanceToNextRequest();
    }
  }

  void _handleRequestIban() {
    final isArabic = AppLocaleController.instance.isArabic;
    final item = _currentRequest;
    final name = item.getCommercialName(isArabic);
    _showActionMessage(isArabic
        ? 'تم إرسال إشعار للمستخدم "$name" لطلب شهادة آيبان بنكية حديثة مختومة وموثقة.'
        : 'Notification sent to "$name" requesting an updated bank IBAN certificate.');
  }

  Future<void> _handleFreeze() async {
    final isArabic = AppLocaleController.instance.isArabic;
    final item = _currentRequest;
    final name = item.getCommercialName(isArabic);

    final confirmed = await FinanceDialogs.showFreezeDialog(
      context,
      requestTitle: '$name (${item.id})',
    );

    if (confirmed && mounted) {
      _showActionMessage(isArabic
          ? 'تم تجميد الطلب احترازياً وإدراجه في شاشة الأرصدة المعلقة والمجمدة تحت التدقيق الرقابي.'
          : 'Request frozen and forwarded to frozen & audit review list.');
      _advanceToNextRequest();
    }
  }

  Future<void> _handleReject() async {
    final isArabic = AppLocaleController.instance.isArabic;
    final item = _currentRequest;
    final name = item.getCommercialName(isArabic);

    final reason = await FinanceDialogs.showRejectionDialog(
      context,
      title: isArabic ? 'رفض طلب ربط الحساب البنكي' : 'Reject Bank Link Request',
      hint: isArabic ? 'أدخل سبب عدم مطابقة الحساب البنكي بالتفصيل...' : 'Enter rejection reason...',
    );

    if (reason != null && mounted) {
      _showActionMessage(isArabic
          ? 'تم رفض طلب "$name" بنجاح وتحويل سبب الرفض ("$reason") إلى رئيس المشرفين لمراجعته.'
          : 'Request for "$name" rejected and reason forwarded to Head of Supervisors.');
      _advanceToNextRequest();
    }
  }

  void _previewDocument(_ReconciliationItem item) {
    final isArabic = AppLocaleController.instance.isArabic;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: AppColors.info, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.documentName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified, color: AppColors.infoDark, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? 'شهادة آيبان بنكية رسمية' : 'Official IBAN Certificate',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(
                    '${isArabic ? 'المصرف المصدر:' : 'Issuing Bank:'} ${item.getBankName(isArabic)}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isArabic ? 'المستفيد:' : 'Beneficiary:'} ${item.getBeneficiaryName(isArabic)}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'IBAN: ${item.iban}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isArabic ? 'السجل التجاري:' : 'CR Number:'} ${item.crNumber}',
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إغلاق' : 'Close', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: FinanceSwipeNavigation(
        currentIndex: widget.currentIndex,
        enabled: widget.showBottomNavigation,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6F8),
          appBar: widget.showBottomNavigation
              ? AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  leading: const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryDark,
                      child: Icon(Icons.shield_outlined,
                          color: Colors.white, size: 19),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appName,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.reconciliationFinanceSubtitle,
                        style: const TextStyle(
                            fontSize: 9, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  actions: const [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.primaryDark,
                        child: Icon(Icons.person_outline,
                            color: Colors.white, size: 17),
                      ),
                    ),
                  ],
                )
              : null,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              _buildScreenHeading(context),
              const SizedBox(height: 12),
              _buildAuthorityBanner(context),
              const SizedBox(height: 12),
              _buildGovernmentConnection(context),
              const SizedBox(height: 14),
              _buildAccountCard(context),
              const SizedBox(height: 14),
              _buildNextAccountCard(context),
            ],
          ),
          bottomNavigationBar: widget.showBottomNavigation
              ? _buildBottomNavigation(context)
              : null,
        ),
      ),
    );
  }

  Widget _buildScreenHeading(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.reconciliationEngine,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 8, color: AppColors.infoDark),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user_outlined,
                      size: 11, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    l10n.reconciliationImmediateCompliance,
                    style: const TextStyle(
                        fontSize: 8, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.circle, size: 9, color: AppColors.info),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          l10n.reconciliationPageTitle,
          textAlign: l10n.localeName.startsWith('ar') ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
              fontSize: 19,
              height: 1.35,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark),
        ),
      ],
    );
  }

  Widget _buildAuthorityBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.gavel, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: l10n.localeName.startsWith('ar')
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reconciliationAuthorityTitle,
                  textAlign: l10n.localeName.startsWith('ar')
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.reconciliationAuthorityNotice,
                  textAlign: l10n.localeName.startsWith('ar')
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 9, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.gavel, color: Colors.white, size: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildGovernmentConnection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_outlined,
              color: AppColors.primaryDark, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: l10n.localeName.startsWith('ar')
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(l10n.reconciliationGovernmentPortal,
                    style:
                        const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text(l10n.reconciliationGovernmentSync,
                    style:
                        const TextStyle(fontSize: 8, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _statusPill(l10n.reconciliationConnected, const Color(0xFFDCE8FF),
              AppColors.infoDark),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final item = _currentRequest;
    final isArabic = l10n.localeName.startsWith('ar');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAccountIdentity(context, item),
          const SizedBox(height: 14),
          _buildComplianceScore(context, item),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.checklist, color: AppColors.info, size: 17),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.reconciliationAccountDetails,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMatchedName(
            context,
            index: '1',
            title: l10n.reconciliationCommercialName,
            value: item.getCommercialName(isArabic),
          ),
          const SizedBox(height: 7),
          _buildMatchedName(
            context,
            index: '2',
            title: l10n.reconciliationBeneficiaryName,
            value: item.getBeneficiaryName(isArabic),
          ),
          const SizedBox(height: 7),
          _buildIbanRow(context, item),
          const SizedBox(height: 7),
          _buildCommercialRegistrationRow(context, item),
          const SizedBox(height: 7),
          _buildDocumentRow(context, item),
          const SizedBox(height: 14),
          Text(
            l10n.reconciliationFinalActions,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          // Action 1: اعتماد وإرسال للإدارة للمصادقة
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _handleApprove,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.verified_outlined, size: 18),
              label: Text(
                l10n.reconciliationApproveAccount,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Action 2: طلب شهادة آيبان حديثة
          SizedBox(
            height: 40,
            child: OutlinedButton.icon(
              onPressed: _handleRequestIban,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                backgroundColor: const Color(0xFFEFF1F3),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.edit_document, size: 16),
              label: Text(l10n.reconciliationRequestIban,
                  style: const TextStyle(fontSize: 10)),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              // Action 3: تجميد الطلب مؤقتاً
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: _handleFreeze,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.warning,
                      backgroundColor: const Color(0xFFFFF9E6),
                      side: const BorderSide(color: AppColors.warning, width: 0.8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.pause_circle_outline, size: 15),
                    label: Text(
                      isArabic ? 'تجميد الطلب' : 'Freeze Request',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Action 4: رفض الطلب مع ذكر السبب
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextButton.icon(
                    onPressed: _handleReject,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.dangerDark,
                      backgroundColor: const Color(0xFFFFE0DE),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.block, size: 15),
                    label: Text(l10n.reconciliationRejectTransfer,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountIdentity(BuildContext context, _ReconciliationItem item) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _statusPill(l10n.reconciliationComplianceReview,
                const Color(0xFFE4ECFF), AppColors.infoDark),
            const Spacer(),
            _statusPill(item.id, AppColors.primaryDark, Colors.white),
          ],
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Color(0xFFF5F6F7),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              const Icon(Icons.apartment, color: AppColors.primaryDark, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(item.getCommercialName(isArabic),
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark)),
                    const SizedBox(height: 2),
                    Text(item.getRequestType(isArabic),
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                            fontSize: 9, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComplianceScore(BuildContext context, _ReconciliationItem item) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          color: Color(0xFFF0F2F4),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined,
                  color: AppColors.primaryDark, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.reconciliationAmlScore,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark),
                ),
              ),
              const SizedBox(width: 8),
              Text(item.amlScore,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 1,
              minHeight: 9,
              backgroundColor: Colors.white,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(Icons.check_circle_outline, color: AppColors.info, size: 13),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  item.getMatchDescription(isArabic),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(fontSize: 8, color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchedName(
    BuildContext context, {
    required String index,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: const BoxDecoration(
          color: Color(0xFFF0F2F4),
          borderRadius: BorderRadius.all(Radius.circular(9))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                child: _statusPill(
                    AppLocalizations.of(context)!.reconciliationMatchVerified,
                    const Color(0xFFDDE3E8),
                    AppColors.infoDark),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text('$index. $title',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontSize: 8, color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(value,
              textAlign: TextAlign.end,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.primaryDark)),
        ],
      ),
    );
  }

  Widget _buildIbanRow(BuildContext context, _ReconciliationItem item) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
          color: const Color(0xFFF0F2F4),
          borderRadius: BorderRadius.circular(9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                child: _statusPill(item.getBankName(isArabic), AppColors.surfaceLight,
                    AppColors.primaryDark),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.reconciliationIbanLabel,
                  textAlign: isArabic ? TextAlign.left : TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 8, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.copy_outlined, color: AppColors.info, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.iban,
                    textAlign: TextAlign.end,
                    textDirection: TextDirection.ltr,
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommercialRegistrationRow(
      BuildContext context, _ReconciliationItem item) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFF0F2F4),
          borderRadius: BorderRadius.circular(9)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(l10n.reconciliationRegistrationLabel,
                    style:
                        const TextStyle(fontSize: 8, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(item.crNumber,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: _statusPill('${l10n.reconciliationValidUntil} ${item.getCrExpiry(isArabic)}',
                const Color(0xFFE0E4E7), AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(BuildContext context, _ReconciliationItem item) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFFF0F2F4),
          borderRadius: BorderRadius.circular(9)),
      child: Row(
        children: [
          Flexible(
            child: OutlinedButton.icon(
              onPressed: () => _previewDocument(item),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                backgroundColor: Colors.white,
                side: BorderSide.none,
                minimumSize: const Size(60, 34),
                padding: const EdgeInsets.symmetric(horizontal: 6),
              ),
              icon: const Icon(Icons.visibility_outlined, size: 14),
              label: Text(
                l10n.reconciliationPreviewDocument,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.documentName,
              textDirection: TextDirection.ltr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: const Color(0xFFE0E4E7),
                borderRadius: BorderRadius.circular(7)),
            child: const Icon(Icons.picture_as_pdf_outlined,
                color: AppColors.info, size: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAccountCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final item = _nextRequest;
    final isArabic = l10n.localeName.startsWith('ar');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.pending_actions,
                  color: AppColors.textSecondary, size: 17),
              const SizedBox(width: 6),
              Expanded(
                child: Text(l10n.reconciliationNextAccount,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark)),
              ),
              _statusPill(item.id, const Color(0xFFE8EAEC),
                  AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 16),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(item.getCommercialName(isArabic),
                          textAlign: isArabic ? TextAlign.right : TextAlign.left,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark)),
                      const SizedBox(height: 4),
                      Text('${item.getBankName(isArabic)} - ${item.iban}',
                          textAlign: isArabic ? TextAlign.right : TextAlign.left,
                          style: const TextStyle(
                              fontSize: 8, color: AppColors.textSecondary)),
                      const SizedBox(height: 5),
                      Text(item.getMatchDescription(isArabic),
                          textAlign: isArabic ? TextAlign.right : TextAlign.left,
                          style: const TextStyle(
                              fontSize: 8,
                              color: AppColors.textSecondary,
                              height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                _statusPill(l10n.reconciliationAuditAlert,
                    const Color(0xFFFFE0DE), AppColors.dangerDark),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9),
              onTap: _advanceToNextRequest,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFFE9ECEF),
                    borderRadius: BorderRadius.circular(9)),
                child: Row(
                  children: [
                    Icon(
                      isArabic ? Icons.arrow_back : Icons.arrow_forward,
                      size: 14,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isArabic ? 'الانتقال إلى تدقيق هذا الطلب الآن' : 'Switch to this request now',
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(fontSize: 9, color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return FinanceBottomNavigationBar(currentIndex: widget.currentIndex);
  }

  Widget _statusPill(String label, Color background, Color foreground) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 210),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(18)),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 8, color: foreground, fontWeight: FontWeight.w600),
      ),
    );
  }
}
