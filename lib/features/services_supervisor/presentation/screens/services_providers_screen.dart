import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../merchants/presentation/screens/merchant_conversation_screen.dart';
import '../../../../l10n/app_localizations.dart';
import 'service_provider_catalog.dart';

class ServicesProvidersScreen extends StatefulWidget {
  const ServicesProvidersScreen({super.key});

  @override
  State<ServicesProvidersScreen> createState() =>
      _ServicesProvidersScreenState();
}

class _ServicesProvidersScreenState extends State<ServicesProvidersScreen> {
  final TextEditingController _searchController = TextEditingController();
  ServiceProviderCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final query = _searchController.text.trim().toLowerCase();
    final visibleProviders = serviceProviders.where((provider) {
      final searchableText = [
        provider.nameAr,
        provider.nameEn,
        provider.tradeAr,
        provider.tradeEn,
        provider.cityAr,
        provider.cityEn,
      ].join(' ').toLowerCase();
      return (_selectedCategory == null ||
              provider.category == _selectedCategory) &&
          (query.isEmpty || searchableText.contains(query));
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        _buildHeader(l10n),
        const SizedBox(height: 14),
        _buildSummary(l10n),
        const SizedBox(height: 14),
        _buildSearch(l10n),
        const SizedBox(height: 10),
        _buildCategoryFilters(l10n),
        const SizedBox(height: 14),
        if (visibleProviders.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              l10n.servicesProvidersEmpty,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          )
        else
          for (final provider in visibleProviders) ...[
            _ProviderCard(
              provider: provider,
              isArabic: isArabic,
              onTap: () => _openProviderDetails(context, provider, isArabic),
            ),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 4),
        _buildGovernanceNote(l10n),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: _SmallBadge(
            label: l10n.servicesProvidersPortalBadge,
            icon: Icons.verified_user_outlined,
            background: const Color(0xFFDDEAFF),
            foreground: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.servicesProvidersTitle,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          l10n.servicesProvidersSubtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            value: '18',
            label: l10n.servicesCertifiedProviders,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            value: '14',
            label: l10n.servicesAvailableNow,
            showDot: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            value: '98.6%',
            label: l10n.servicesCommitmentRate,
          ),
        ),
      ],
    );
  }

  Widget _buildSearch(AppLocalizations l10n) {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: l10n.servicesProvidersSearchHint,
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                tooltip: l10n.servicesProvidersClearSearch,
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.info),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(AppLocalizations l10n) {
    final categories = <({String label, ServiceProviderCategory? category})>[
      (label: l10n.servicesFilterAll, category: null),
      (
        label: l10n.servicesFilterMaintenance,
        category: ServiceProviderCategory.maintenance,
      ),
      (
        label: l10n.servicesFilterElectrical,
        category: ServiceProviderCategory.electrical,
      ),
      (
        label: l10n.servicesFilterMoving,
        category: ServiceProviderCategory.moving
      ),
      (
        label: l10n.servicesProvidersFilterPlumbing,
        category: ServiceProviderCategory.plumbing,
      ),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in categories)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 7),
              child: _CategoryChip(
                label: item.label,
                selected: _selectedCategory == item.category,
                onTap: () => setState(() => _selectedCategory = item.category),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGovernanceNote(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.policy_outlined,
            color: AppColors.primaryDark,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.servicesProvidersGovernanceTitle,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.servicesProvidersGovernanceMessage,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openProviderDetails(
    BuildContext context,
    ServiceProvider provider,
    bool isArabic,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ProviderProfileScreen(
          provider: provider,
          isArabic: isArabic,
        ),
      ),
    );
  }
}

class _ProviderProfileScreen extends StatelessWidget {
  final ServiceProvider provider;
  final bool isArabic;

  const _ProviderProfileScreen({
    required this.provider,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = isArabic ? provider.nameAr : provider.nameEn;
    final trade = isArabic ? provider.tradeAr : provider.tradeEn;
    final city = isArabic ? provider.cityAr : provider.cityEn;
    final feature = isArabic ? provider.featureAr : provider.featureEn;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDark,
        title: Text(
          l10n.servicesProviderProfileTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _buildAvailability(l10n),
          const SizedBox(height: 12),
          _buildIdentity(context, l10n, name),
          const SizedBox(height: 18),
          _buildSectionTitle(l10n.servicesProvidersCompletedTasks),
          const SizedBox(height: 10),
          _buildMetrics(l10n),
          const SizedBox(height: 20),
          _buildSectionTitle(l10n.servicesProviderProfileCertifications),
          const SizedBox(height: 10),
          _buildCertifications(l10n),
          const SizedBox(height: 20),
          _buildSectionTitle(l10n.servicesProviderProfileSpecialties),
          const SizedBox(height: 10),
          _buildSpecialties(l10n, trade, feature, city),
          const SizedBox(height: 20),
          _buildSectionTitle(l10n.servicesProviderProfileRecentTasks),
          const SizedBox(height: 10),
          for (var index = 0; index < 3; index++) ...[
            _RecentTaskCard(
              title: trade,
              details: l10n.servicesProviderProfileTaskDetail,
              rating: provider.rating,
              index: index,
            ),
            const SizedBox(height: 9),
          ],
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.servicesProvidersSampleProfileNotice,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailability(AppLocalizations l10n) {
    final statusLabel = provider.available
        ? l10n.servicesProvidersAvailable
        : l10n.servicesProvidersBusy;
    final statusColor =
        provider.available ? AppColors.successDark : AppColors.warning;

    return Row(
      children: [
        Icon(Icons.circle, size: 10, color: statusColor),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            statusLabel,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _ProfileBadge(
          label: provider.featured
              ? l10n.servicesProviderProfileFeatured
              : l10n.servicesProviderProfileVerified,
          icon: Icons.verified,
        ),
      ],
    );
  }

  Widget _buildIdentity(
    BuildContext context,
    AppLocalizations l10n,
    String name,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _ProviderIcon(icon: provider.icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.servicesProviderProfileRegistryNumber} #${provider.id}',
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
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.info,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.servicesProviderProfileVerified,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _callProvider(context, l10n),
                  icon: const Icon(Icons.call_outlined, size: 17),
                  label: Text(l10n.servicesProviderProfileCall),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          MerchantConversationScreen(conversationTitle: name),
                    ),
                  ),
                  icon: const Icon(Icons.chat_outlined, size: 17),
                  label: Text(l10n.servicesProviderProfileChat),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _callProvider(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    try {
      final launched =
          await launchUrl(Uri(scheme: 'tel', path: provider.phone));
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.servicesProviderProfileCallUnavailable)),
        );
      }
    } on PlatformException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.servicesProviderProfileCallUnavailable)),
        );
      }
    }
  }

  Widget _buildMetrics(AppLocalizations l10n) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.55,
      children: [
        _ProviderMetric(
          icon: Icons.task_alt_outlined,
          label: l10n.servicesProvidersCompletedTasks,
          value: provider.taskCount,
          detail: l10n.servicesProviderProfileCompletedTasksDetail,
        ),
        _ProviderMetric(
          icon: Icons.star_outline_rounded,
          label: l10n.servicesProvidersRating,
          value: provider.rating,
          detail: l10n.servicesProviderProfileRatingDetail,
        ),
        _ProviderMetric(
          icon: Icons.speed_outlined,
          label: l10n.servicesProvidersCommitment(provider.completionRate),
          value: provider.completionRate,
          detail: l10n.servicesProviderProfileCommitmentDetail,
        ),
        _ProviderMetric(
          icon: Icons.access_time,
          label: l10n.servicesProviderProfileResponseTime,
          value: provider.responseTime,
          detail: l10n.servicesProviderProfileMinutes,
        ),
      ],
    );
  }

  Widget _buildCertifications(AppLocalizations l10n) {
    return _ProfilePanel(
      children: [
        _ProfileRow(
          icon: Icons.business_outlined,
          label: l10n.servicesProvidersCommercialRegister,
          value: provider.verified
              ? l10n.servicesProviderProfileVerified
              : l10n.servicesProviderProfileNeedsReview,
        ),
        _ProfileRow(
          icon: Icons.workspace_premium_outlined,
          label: l10n.servicesProvidersLicense,
          value: provider.verified
              ? l10n.servicesProviderProfileVerified
              : l10n.servicesProviderProfileNeedsReview,
        ),
      ],
    );
  }

  Widget _buildSpecialties(
    AppLocalizations l10n,
    String trade,
    String feature,
    String city,
  ) {
    return _ProfilePanel(
      children: [
        _ProfileRow(
          icon: Icons.home_repair_service_outlined,
          label: l10n.servicesProvidersSpecialty,
          value: trade,
        ),
        _ProfileRow(
          icon: Icons.tune,
          label: l10n.servicesProvidersRegisteredSkills,
          value: feature,
        ),
        _ProfileRow(
          icon: Icons.location_on_outlined,
          label: l10n.servicesProvidersCoverage,
          value: city,
        ),
        _ProfileRow(
          icon: Icons.groups_outlined,
          label: l10n.servicesProviderProfileFieldTeam,
          value: l10n.servicesProviderProfileApprovedTeam,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.primaryDark,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ProviderMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String detail;

  const _ProviderMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.info, size: 17),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePanel extends StatelessWidget {
  final List<Widget> children;

  const _ProfilePanel({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ProfileBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDDEAFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryDark, size: 13),
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

class _RecentTaskCard extends StatelessWidget {
  final String title;
  final String details;
  final String rating;
  final int index;

  const _RecentTaskCard({
    required this.title,
    required this.details,
    required this.rating,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _ProfileBadge(
                label: l10n.servicesProviderProfileTaskCompleted,
                icon: Icons.check_circle_outline,
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            '#SRV-${3042 - index}',
            style: const TextStyle(
              color: AppColors.info,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            details,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.info, size: 14),
              const SizedBox(width: 4),
              Text(
                rating,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                l10n.servicesProviderProfileTaskRecord,
                style: const TextStyle(
                  color: AppColors.info,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final ServiceProvider provider;
  final bool isArabic;
  final VoidCallback onTap;

  const _ProviderCard({
    required this.provider,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = isArabic ? provider.nameAr : provider.nameEn;
    final trade = isArabic ? provider.tradeAr : provider.tradeEn;
    final city = isArabic ? provider.cityAr : provider.cityEn;
    final feature = isArabic ? provider.featureAr : provider.featureEn;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFF0F1F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _ProviderIcon(icon: provider.icon),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _SmallBadge(
                label: provider.available
                    ? l10n.servicesProvidersAvailable
                    : l10n.servicesProvidersBusy,
                icon: Icons.circle,
                background: provider.available
                    ? AppColors.successLight
                    : AppColors.surfaceLight,
                foreground: provider.available
                    ? AppColors.successDark
                    : AppColors.textSecondary,
              ),
            ],
          ),
          if (provider.featured) ...[
            const SizedBox(height: 5),
            const Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Icon(
                Icons.verified,
                color: AppColors.infoDark,
                size: 17,
              ),
            ),
          ],
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 54),
            child: Text(
              trade,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.infoDark,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 6,
            alignment: WrapAlignment.end,
            children: [
              if (provider.verified)
                _SmallBadge(
                  label: l10n.servicesProvidersCommercialRegister,
                  icon: Icons.assignment_turned_in_outlined,
                  background: const Color(0xFFEAF1FF),
                  foreground: AppColors.primaryDark,
                ),
              _SmallBadge(
                label: l10n.servicesProvidersLicense,
                icon: Icons.workspace_premium_outlined,
                background: AppColors.surfaceLight,
                foreground: AppColors.textSecondary,
              ),
              _SmallBadge(
                label: l10n.servicesProvidersServiceTerms,
                icon: Icons.speed_outlined,
                background: const Color(0xFFDDF6ED),
                foreground: AppColors.successDark,
              ),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ProviderFact(
                        icon: Icons.location_on_outlined,
                        text: city,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _ProviderFact(
                      icon: Icons.star_rounded,
                      text: provider.rating,
                      trailing: true,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      l10n.servicesProvidersTasksCount(provider.taskCount),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        feature,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.infoDark,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if (provider.category == ServiceProviderCategory.moving)
                      _SmallBadge(
                        label: l10n.servicesProvidersExecutionWindow,
                        icon: Icons.access_time,
                        background: const Color(0xFFE8EAEC),
                        foreground: AppColors.textSecondary,
                      )
                    else
                      _SmallBadge(
                        label: l10n.servicesProvidersCommitment(
                          provider.completionRate,
                        ),
                        icon: Icons.bolt_outlined,
                        background: const Color(0xFFDDF6ED),
                        foreground: AppColors.successDark,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 46,
            child: FilledButton.icon(
              key: ValueKey('provider_profile_${provider.id}'),
              onPressed: onTap,
              icon: const Icon(Icons.assignment_turned_in_outlined, size: 18),
              label: Text(l10n.servicesProvidersViewProfile),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
  final bool showDot;

  const _SummaryCard({
    required this.value,
    required this.label,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFF0F1F3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showDot) ...[
                const Icon(Icons.circle, color: AppColors.success, size: 8),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryDark : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primaryDark : AppColors.cardBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProviderIcon extends StatelessWidget {
  final IconData icon;

  const _ProviderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.infoDark, size: 23),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  const _SmallBadge({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderFact extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool trailing;

  const _ProviderFact({
    required this.icon,
    required this.text,
    this.trailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trailing) ...[
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 3),
        ],
        Icon(
          icon,
          color: trailing ? const Color(0xFFF6A900) : AppColors.textSecondary,
          size: 14,
        ),
        if (!trailing) ...[
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.infoDark, size: 18),
          const SizedBox(width: 8),
          SizedBox(
            width: 105,
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
                color: AppColors.primaryDark,
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
