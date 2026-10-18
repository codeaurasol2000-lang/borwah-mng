import 'package:flutter/material.dart';

import '../../../../core/widgets/local_event_inbox_screen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../finance/presentation/utils/open_financial_request_notice.dart';

class MerchantSupervisorNotificationsScreen extends StatelessWidget {
  const MerchantSupervisorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context)!.localeName.startsWith('ar');
    return LocalEventInboxScreen(
      recipient: 'merchant',
      title: isArabic
          ? 'إشعارات مشرف التجار'
          : 'Merchant supervisor notifications',
      onOpenEvent: (event) => openFinancialRequestNotice(context, event),
    );
  }
}
