import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/datasources/finance_supervisor_payout_details_store.dart';
import 'audit_screen.dart';
import 'edit_matrix_screen.dart';
import 'finance_supervisor_payout_details_screen.dart';
import 'widgets/withdraw_bottom_sheet.dart';
import '../widgets/finance_navigation.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _profileImageKey = 'finance_supervisor_profile_image_path_v1';
  final _imagePicker = ImagePicker();
  String? _profileImagePath;
  FinanceSupervisorPayoutDetails? _payoutDetails;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadPayoutDetails();
  }

  Future<void> _loadPayoutDetails() async {
    try {
      final details = await FinanceSupervisorPayoutDetailsStore().load();
      if (mounted) setState(() => _payoutDetails = details);
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance supervisor profile',
        context: ErrorDescription('while loading personal payout details'),
      ));
    }
  }

  Future<void> _loadProfileImage() async {
    final preferences = await SharedPreferences.getInstance();
    final path = preferences.getString(_profileImageKey);
    if (!mounted) return;
    setState(() {
      _profileImagePath = path != null && File(path).existsSync() ? path : null;
    });
  }

  Future<void> _pickProfileImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (image == null || !mounted) return;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_profileImageKey, image.path);
    if (!mounted) return;
    setState(() => _profileImagePath = image.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: l10n.localeName.startsWith('ar')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: FinancePageAppBar(
          title: l10n.profileTitle,
          subtitle: l10n.financialDepartment,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // Security Banner
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.grey300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle,
                                size: 6, color: AppColors.blue700),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(l10n.encryptedBit256,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.secureApprovedSession,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.verified_user_outlined,
                                color: AppColors.white, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 1. Profile Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryExtraDark,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text('#CFO-01',
                                          style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                          textDirection: TextDirection.ltr),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                        child: Text(l10n.cfoName,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(l10n.cfoRole,
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.info)),
                                const SizedBox(height: 4),
                                Text(l10n.cfoAuditingTitle,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textSecondary),
                                    textDirection: TextDirection.ltr),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              GestureDetector(
                                onTap: _pickProfileImage,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: _profileImagePath == null
                                            ? const Icon(Icons.account_circle,
                                                size: 60, color: AppColors.grey)
                                            : Image.file(
                                                File(_profileImagePath!),
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    const Icon(
                                                  Icons.account_circle,
                                                  size: 60,
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors.black
                                              .withValues(alpha: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.camera_alt,
                                            color: AppColors.white, size: 24),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryExtraDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.shield_outlined,
                                      color: AppColors.white, size: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:  AppColors.textPrimary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(l10n.sovereignApprovalPowers,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary),
                                      textAlign: TextAlign.end)),
                              const SizedBox(width: 8),
                              Icon(Icons.account_balance,
                                  size: 16, color: AppColors.blue700),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(l10n.certifiedAuditorAuthority,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  height: 1.4),
                              textAlign: TextAlign.end),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildContactBox(l10n.officialPhone,
                                '+201014189187', Icons.phone_android, false),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildContactBox(
                                l10n.corporateEmail,
                                's.alrajhi@almazouri.sa',
                                Icons.email_outlined,
                                true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.fingerprint,
                                    color: AppColors.info, size: 16),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(l10n.enabledNafath,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.blue700,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(l10n.authorizationEffectiveFrom,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Wallet Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryExtraDark,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color:
                            AppColors.primaryExtraDark.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.blue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.circle,
                                      size: 6, color: AppColors.white),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                        l10n.localeName.startsWith('ar')
                                            ? 'حساب شخصي'
                                            : 'Personal account',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: AppColors.white, fontSize: 10)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(l10n.duesWalletTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2),
                                    textAlign: TextAlign.end),
                                const SizedBox(height: 4),
                                Text(
                                    l10n.localeName.startsWith('ar')
                                        ? 'محفظة المستحقات الشخصية للمشرف المالي'
                                        : 'Finance supervisor personal dues wallet',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: AppColors.white60, fontSize: 10),
                                    textAlign: TextAlign.end),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: AppColors.white,
                                size: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        l10n.localeName.startsWith('ar')
                            ? 'إجمالي مستحقاتك الشخصية'
                            : 'Your total personal dues',
                        style: const TextStyle(
                            color: AppColors.white70, fontSize: 11)),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('68,500.00',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  height: 1)),
                          const SizedBox(width: 4),
                          Text(l10n.currencyEgy,
                              style: const TextStyle(
                                  color: AppColors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            l10n.localeName.startsWith('ar')
                                                ? 'مستحقاتك المعلقة'
                                                : 'Your pending dues',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: AppColors.white70,
                                                fontSize: 10)),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(Icons.circle,
                                          size: 6,
                                          color: AppColors.blueGrey400),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Flexible(
                                        child: Text('16,500.00',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(l10n.currencyEgy,
                                          style: const TextStyle(
                                              color: AppColors.white70,
                                              fontSize: 9)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                      l10n.localeName.startsWith('ar')
                                          ? 'بانتظار الإقفال الربع سنوي'
                                          : 'Awaiting quarterly close',
                                      style: const TextStyle(
                                          color: AppColors.white54, fontSize: 9)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            l10n.localeName.startsWith('ar')
                                                ? 'متاح لطلب السحب'
                                                : 'Available for withdrawal request',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: AppColors.white70,
                                                fontSize: 10)),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(Icons.circle,
                                          size: 6, color: AppColors.blue200),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Flexible(
                                        child: Text('52,000.00',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(l10n.currencyEgy,
                                          style: const TextStyle(
                                              color: AppColors.white70,
                                              fontSize: 9)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                      l10n.localeName.startsWith('ar')
                                          ? 'الصرف بعد اعتماد الإدارة'
                                          : 'Payout after management approval',
                                      style: const TextStyle(
                                          color: AppColors.white54, fontSize: 9)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.remove_red_eye_outlined,
                              color: AppColors.white70, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    l10n.localeName.startsWith('ar')
                                        ? 'حسابك الشخصي للسحب'
                                        : 'Your personal payout account',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: AppColors.white60, fontSize: 9)),
                                Text(
                                    _payoutDetails?.isComplete == true
                                        ? _payoutDetails!.maskedIban
                                        : (l10n.localeName.startsWith('ar')
                                            ? 'لم تُسجل بيانات سحب شخصية'
                                            : 'Personal payout details not set'),
                                    style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2),
                                    textDirection: TextDirection.ltr),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                                _payoutDetails?.bankName.isNotEmpty == true
                                    ? _payoutDetails!.bankName.toUpperCase()
                                    : '--',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColors.primaryExtraDark,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.white.withValues(alpha: 0.15),
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.arrow_circle_left_outlined,
                                  size: 18),
                              onPressed: () {
                                showWithdrawBottomSheet(
                                  context,
                                  payoutDetails: _payoutDetails,
                                );
                              },
                              label: Text(
                                  l10n.localeName.startsWith('ar')
                                      ? 'طلب سحب مستحقاتي الشخصية'
                                      : 'Request personal dues withdrawal',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.white.withValues(alpha: 0.15),
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.arrow_circle_left_outlined,
                                  size: 18),
                              onPressed: () async {
                                await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute<bool>(
                                    builder: (_) =>
                                        const FinanceSupervisorPayoutDetailsScreen(),
                                  ),
                                );
                                await _loadPayoutDetails();
                              },
                              label: Text(
                                  l10n.localeName.startsWith('ar')
                                      ? 'تعديل بيانات السحب الشخصية'
                                      : 'Edit personal payout details',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(l10n.cfoExclusive,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(l10n.sovereignControls,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.tune,
                            color: AppColors.primaryDark, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Matrix Settings
              _buildSettingCard(
                title: l10n.feesAndCommissionsMatrix,
                subtitle: l10n.feesAndCommissionsMatrixDesc,
                icon: Icons.account_tree_outlined,
                badgeText: l10n.exclusivePermission,
                content: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryExtraDark,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.edit, size: 14),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const EditMatrixScreen()),
                          );
                        },
                        label: Text(l10n.editMatrix,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                height: 1.2),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(l10n.fastSettlementFees,
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSecondary,
                                  height: 1.2),
                              textAlign: TextAlign.end),
                          const SizedBox(height: 4),
                          Text('1.25%',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue700)),
                        ],
                      ),
                    ),
                    Container(
                        width: 1,
                        height: 40,
                        color: AppColors.cardBorder,
                        margin: const EdgeInsets.symmetric(horizontal: 12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(l10n.currentBaseCommission,
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSecondary,
                                  height: 1.2),
                              textAlign: TextAlign.end),
                          const SizedBox(height: 4),
                          const Text('4.50%',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 5. Reports Card
              _buildSettingCard(
                title: l10n.comprehensivePaymentsReports,
                subtitle: l10n.comprehensivePaymentsReportsDesc,
                icon: Icons.bar_chart_outlined,
                content: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.grid_on_outlined, size: 16),
                        onPressed: () {},
                        label: Text(l10n.exportDetailedExcel,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        icon:
                            const Icon(Icons.picture_as_pdf_outlined, size: 16),
                        onPressed: () {},
                        label: Text(l10n.exportApprovedPdf,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 6. Timeline Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(l10n.liveDocumented,
                        style: const TextStyle(
                            fontSize: 9, color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(l10n.auditActivityLog,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.history,
                            color: AppColors.primaryDark, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 7. Timeline List
              _buildTimelineItem(
                context: context,
                title: l10n.ownerDisputeSettlementApproval,
                time: l10n.todayAtEleven,
                description: l10n.approveDisputeSettlement,
                icon: Icons.verified_user_outlined,
                iconColor: AppColors.primaryDark,
                bgColor: AppColors.blue50,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text('${l10n.referenceCode} #SIG-9082',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 9, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(l10n.validDigitalSignature,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.blue700,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.key,
                                size: 10, color: AppColors.blue700),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTimelineItem(
                context: context,
                title: l10n.aggregatedProfitWithdrawal,
                time: l10n.todayAtNineThirty,
                description: l10n.periodicMerchantTransfers,
                icon: Icons.payments_outlined,
                iconColor: AppColors.textPrimary,
                bgColor: AppColors.surfaceLight,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(l10n.alRajhiBank,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 9, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.grey300),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(l10n.executedAndPosted,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textPrimary)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.check_circle_outline,
                                size: 10, color: AppColors.success),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTimelineItem(
                context: context,
                title: l10n.precautionaryWalletFreeze,
                time: l10n.yesterdayAtFourFifteen,
                description: l10n.suspendMerchantDisbursement,
                icon: Icons.lock_outline,
                iconColor: AppColors.danger,
                bgColor: AppColors.dangerLight,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(l10n.auditNoticeReference,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 9, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.dangerLight,
                            border: Border.all(color: AppColors.dangerBorder),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(l10n.underInvestigation,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.danger,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.gavel,
                                size: 10, color: AppColors.danger),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTimelineItem(
                context: context,
                title: l10n.maintenanceCommissionUpdate,
                time: l10n.yesterdayAtOneTwenty,
                description: l10n.commissionUpdatedByBoard,
                icon: Icons.percent,
                iconColor: AppColors.blue700,
                bgColor: AppColors.blue50,
                isLast: true,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(l10n.activeSystemUpdate,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textPrimary)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.check_box_outlined,
                                size: 10, color: AppColors.textPrimary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardBorder,
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AuditScreen(
                        showBottomNavigation: false,
                      ),
                    ),
                  ),
                  label: Text(l10n.viewFullAuditActivity,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmSignOut(context, l10n),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(l10n.logout),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.dangerBorder),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(
      BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.logoutCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.logoutConfirm,
                style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    widget.onLogout();
  }

  Widget _buildContactBox(
      String title, String value, IconData icon, bool obscure) {
    return _ObscureContactBox(
        title: title, value: value, icon: icon, obscureInit: obscure);
  }

  Widget _buildSettingCard(
      {required String title,
      required String subtitle,
      required IconData icon,
      String? badgeText,
      required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (badgeText != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppColors.blue50,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(badgeText,
                      style: TextStyle(
                          fontSize: 9,
                          color: AppColors.blue700,
                          fontWeight: FontWeight.bold)),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                        textAlign: TextAlign.end),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 20, color: AppColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(subtitle,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        height: 1.4),
                    textAlign: TextAlign.end),
              ),
              const SizedBox(width: 44), // To align with the text above
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required String title,
    required String time,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    Widget? bottomWidget,
    bool isLast = false,
  }) {
    final isArabic = AppLocalizations.of(context)!.localeName == 'ar';
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign:
                                isArabic ? TextAlign.left : TextAlign.right,
                            style: const TextStyle(
                                fontSize: 9, color: AppColors.textSecondary)),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        flex: 2,
                        child: Text(title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign:
                                isArabic ? TextAlign.right : TextAlign.left,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          height: 1.4),
                      textAlign: TextAlign.end),
                  if (bottomWidget != null) ...[
                    const SizedBox(height: 8),
                    bottomWidget,
                  ],
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration:
                    BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: AppColors.cardBorder,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ObscureContactBox extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool obscureInit;
  const _ObscureContactBox(
      {required this.title,
      required this.value,
      required this.icon,
      required this.obscureInit});
  @override
  State<_ObscureContactBox> createState() => _ObscureContactBoxState();
}

class _ObscureContactBoxState extends State<_ObscureContactBox> {
  late bool _isObscured;
  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureInit;
  }

  @override
  Widget build(BuildContext context) {
    String displayValue = widget.value;
    if (_isObscured && widget.value.contains('@')) {
      final parts = widget.value.split('@');
      if (parts[0].length > 2) {
        displayValue = '${parts[0].substring(0, 2)}***@${parts[1]}';
      } else {
        displayValue = '***@${parts[1]}';
      }
    }
    return GestureDetector(
      onTap: () {
        if (widget.obscureInit) {
          setState(() {
            _isObscured = !_isObscured;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      displayValue,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                      textDirection:
                          AppLocalizations.of(context)!.localeName == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(widget.icon, size: 18, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }
}
