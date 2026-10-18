import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/merchant_conversation_local_store.dart';
import '../../domain/entities/merchant_entity.dart';
import '../../domain/repositories/merchants_repository.dart';
import 'merchant_conversation_screen.dart';

class MerchantSupervisorChatsScreen extends StatefulWidget {
  const MerchantSupervisorChatsScreen({super.key});

  @override
  State<MerchantSupervisorChatsScreen> createState() =>
      _MerchantSupervisorChatsScreenState();
}

class _MerchantSupervisorChatsScreenState
    extends State<MerchantSupervisorChatsScreen> {
  final _store = MerchantConversationLocalStore();
  List<MerchantEntity> _merchants = const [];
  Map<String, MerchantConversationMessage> _latestMessages = const {};
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final merchants = await sl<MerchantsRepository>().getSupervisedMerchants();
      final messages = await _store.getAllMessages();
      final latest = <String, MerchantConversationMessage>{};
      for (final message in messages) {
        final previous = latest[message.merchantId];
        if (previous == null || message.sentAt.isAfter(previous.sentAt)) {
          latest[message.merchantId] = message;
        }
      }
      if (!mounted) return;
      setState(() {
        _merchants = merchants;
        _latestMessages = latest;
        _loading = false;
      });
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'merchant supervisor chats',
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
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final merchants = [..._merchants]
      ..sort((a, b) {
        final aTime = _latestMessages[a.id]?.sentAt;
        final bTime = _latestMessages[b.id]?.sentAt;
        if (aTime == null && bTime == null) return a.name.compareTo(b.name);
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(isArabic ? 'محادثات التجار' : 'Merchant chats'),
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primaryDark,
          actions: [
            IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.adsLoadFailed),
                        const SizedBox(height: 8),
                        FilledButton(onPressed: _load, child: Text(l10n.retryLoadMerchants)),
                      ],
                    ),
                  )
                : merchants.isEmpty
                    ? Center(child: Text(l10n.merchantConversationEmpty))
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: merchants.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final merchant = merchants[index];
                          final latest = _latestMessages[merchant.id];
                          return Card(
                            color: AppColors.white,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryDark,
                                child: Icon(
                                  merchant.logoIcon ?? merchant.categoryIcon,
                                  color: AppColors.white,
                                ),
                              ),
                              title: Text(
                                merchant.getName(isArabic),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                latest?.text ?? l10n.merchantInfoMessageMerchant,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () async {
                                await Navigator.of(context).push<void>(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        MerchantConversationScreen(merchant: merchant),
                                  ),
                                );
                                if (mounted) _load();
                              },
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
