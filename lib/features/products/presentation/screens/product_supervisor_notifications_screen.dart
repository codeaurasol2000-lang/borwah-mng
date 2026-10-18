import 'package:flutter/material.dart';

import '../../../../core/widgets/local_event_inbox_screen.dart';
import '../../../finance/presentation/utils/open_financial_request_notice.dart';
import '../../../../l10n/app_localizations.dart';

class ProductSupervisorNotificationsScreen extends StatelessWidget {
  const ProductSupervisorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => LocalEventInboxScreen(
        recipient: 'products',
        title: AppLocalizations.of(context)!.productNotificationsTitle,
        onOpenEvent: (event) => openFinancialRequestNotice(context, event),
      );
}
