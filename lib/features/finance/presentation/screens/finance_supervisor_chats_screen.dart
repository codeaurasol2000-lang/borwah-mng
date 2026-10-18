import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/merchants/presentation/screens/merchant_conversation_screen.dart';
import '../../../../l10n/app_localizations.dart';

class FinanceSupervisorChatsScreen extends StatelessWidget {
  const FinanceSupervisorChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final financeSupervisor = isArabic ? 'المشرف المالي' : 'Finance supervisor';
    final headSupervisor = l10n.productHeadSupervisorName;
    final support = l10n.productTechnicalSupportName;
    final threads = [
      (
        Icons.supervisor_account_outlined,
        headSupervisor,
        isArabic ? 'التواصل مع رئيس المشرفين بشأن القرارات والتصعيدات' : 'Discuss decisions and escalations with the head supervisor',
        l10n.productChatToday,
      ),
      (
        Icons.groups_outlined,
        isArabic ? 'مشرفو الأقسام' : 'Department supervisors',
        isArabic ? 'متابعة الطلبات والتسويات بين الأقسام' : 'Coordinate requests and settlements across departments',
        l10n.productChatToday,
      ),
      (
        Icons.support_agent_outlined,
        support,
        l10n.productTechnicalSupportPreview,
        l10n.productChatYesterday,
      ),
    ];

    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryDark,
        title: Text(
          isArabic ? 'الدردشات' : 'Chats',
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
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              leading: CircleAvatar(
                backgroundColor: AppColors.surfaceLight,
                child: Icon(thread.$1, color: AppColors.primaryDark),
              ),
              title: Text(
                thread.$2,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                thread.$3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                thread.$4,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => MerchantConversationScreen(
                    conversationTitle: thread.$2,
                    conversationParticipants: [thread.$2, financeSupervisor],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
