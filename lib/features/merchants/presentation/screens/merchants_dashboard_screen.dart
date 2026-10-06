import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/merchants_cubit.dart';
import '../controllers/merchants_state.dart';
import 'merchant_details_screen.dart';
import '../widgets/merchant_card.dart';
import '../widgets/merchant_search_filter_bar.dart';
import '../widgets/supervisor_app_bar.dart';
import '../widgets/supervisor_header_card.dart';

class MerchantsDashboardScreen extends StatefulWidget {
  final bool showAppBar;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLinkNewMerchant;

  const MerchantsDashboardScreen({
    super.key,
    this.showAppBar = true,
    this.onNotificationTap,
    this.onProfileTap,
    this.onLinkNewMerchant,
  });

  @override
  State<MerchantsDashboardScreen> createState() =>
      _MerchantsDashboardScreenState();
}

class _MerchantsDashboardScreenState extends State<MerchantsDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: widget.showAppBar
          ? SupervisorAppBar(
              onNotificationTap: widget.onNotificationTap,
              onProfileTap: widget.onProfileTap,
            )
          : null,
      body: BlocBuilder<MerchantsCubit, MerchantsState>(
        builder: (context, state) {
          if (state is MerchantsLoading || state is MerchantsInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF07192F),
              ),
            );
          }

          if (state is MerchantsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.danger, size: 48),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<MerchantsCubit>().loadMerchants(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF07192F),
                      ),
                      child: const Text('إعادة المحاولة',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final loadedState = state as MerchantsLoaded;

          return RefreshIndicator(
            color: const Color(0xFF07192F),
            onRefresh: () => context.read<MerchantsCubit>().loadMerchants(),
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  children: [
                    // 1. Supervisor Welcome & Stats Header Card
                    SupervisorHeaderCard(stats: loadedState.stats),

                    const SizedBox(height: 16),

                    // 2. Search & Category Filters Bar
                    MerchantSearchFilterBar(
                      searchController: _searchController,
                      stats: loadedState.stats,
                      selectedFilterIndex: loadedState.selectedFilterIndex,
                      onSearchChanged: (query) =>
                          context.read<MerchantsCubit>().searchMerchants(query),
                      onClearSearch: () {
                        _searchController.clear();
                        context.read<MerchantsCubit>().searchMerchants('');
                      },
                      onFilterSelected: (index) =>
                          context.read<MerchantsCubit>().setFilterIndex(index),
                    ),

                    const SizedBox(height: 16),

                    // 3. Section Header: [Stores Under Supervision] [5 of 18] [Recently Active]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Recently Active sort button
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('تم ترتيب القائمة حسب الأحدث نشاطاً'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.swap_vert,
                                    size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.recentlyActiveSort,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Section Title & Badge
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  l10n.storesRatio(
                                    loadedState.filteredMerchants.length
                                        .toString(),
                                    loadedState.allMerchants.length.toString(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  l10n.registeredStoresSection,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // 4. Merchants List
                    if (loadedState.filteredMerchants.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.storefront_outlined,
                                  size: 48, color: AppColors.textMuted),
                              const SizedBox(height: 12),
                              Text(
                                l10n.noMerchantsFound,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...loadedState.filteredMerchants.map(
                        (merchant) => MerchantCard(
                          merchant: merchant,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    MerchantDetailsScreen(merchant: merchant),
                              ),
                            );
                          },
                          onActionTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'إجراء: ${merchant.actionButtonText} لـ ${merchant.name}'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),

                // Floating Action Button: [ربط تاجر جديد]
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: ElevatedButton.icon(
                    onPressed: widget.onLinkNewMerchant ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('فتح نافذة ربط تاجر جديد'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                    icon: const Icon(Icons.store_mall_directory_outlined,
                        size: 18, color: Colors.white),
                    label: Text(
                      l10n.linkNewMerchant,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07192F),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
