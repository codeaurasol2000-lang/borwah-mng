import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/merchants/presentation/screens/merchant_conversation_screen.dart';
import '../../../../l10n/app_localizations.dart';

class ProductSupervisorChatsScreen extends StatelessWidget {
  const ProductSupervisorChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final threads = [
      (
        Icons.supervisor_account_outlined,
        l10n.productHeadSupervisorName,
        l10n.productHeadSupervisorPreview,
        l10n.productChatToday,
      ),
      (
        Icons.support_agent_outlined,
        l10n.productTechnicalSupportName,
        l10n.productTechnicalSupportPreview,
        l10n.productChatYesterday,
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDark,
        title: Text(
          l10n.productChatsTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: threads.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final thread = threads[index];
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              leading: CircleAvatar(
                backgroundColor: AppColors.surfaceLight,
                child: Icon(thread.$1, color: AppColors.primaryDark),
              ),
              title: Text(thread.$2,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text(thread.$3, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Text(thread.$4,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 10)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      MerchantConversationScreen(conversationTitle: thread.$2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
