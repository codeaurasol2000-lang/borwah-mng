import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/merchant_conversation_local_store.dart';
import '../../domain/entities/merchant_entity.dart';

class MerchantConversationScreen extends StatefulWidget {
  final MerchantEntity? merchant;
  final String? conversationId;
  final String? conversationTitle;
  final List<String> conversationParticipants;

  const MerchantConversationScreen({
    super.key,
    this.merchant,
    this.conversationId,
    this.conversationTitle,
    this.conversationParticipants = const [],
  }) : assert(merchant != null || conversationTitle != null),
       assert(merchant != null || conversationId != null || conversationTitle != null);

  @override
  State<MerchantConversationScreen> createState() =>
      _MerchantConversationScreenState();
}

class _MerchantConversationScreenState
    extends State<MerchantConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final MerchantConversationLocalStore _store =
      MerchantConversationLocalStore();
  List<MerchantConversationMessage> _messages = const [];
  bool _loading = true;
  bool _sending = false;

  String? get _merchantId => widget.merchant?.id ?? widget.conversationId;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final merchantId = _merchantId;
    if (merchantId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      await _store.markMerchantMessagesRead(merchantId);
      final messages = await _store.getMessages(merchantId);
      if (!mounted) return;
      setState(() {
        _messages = messages;
        _loading = false;
      });
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'merchant conversation',
      ));
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primaryDark,
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryDark,
                child: Icon(
                  widget.merchant?.logoIcon ??
                      widget.merchant?.categoryIcon ??
                      Icons.support_agent_outlined,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.conversationTitle ??
                          widget.merchant!.getName(isArabic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                    ),
                    if (widget.conversationParticipants.isNotEmpty)
                      Text(
                        widget.conversationParticipants.join(' • '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
        ),
        body: Column(
          children: [
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _messages.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.forum_outlined,
                              size: 52,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.merchantConversationEmpty,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) => Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.sizeOf(context).width * .78,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                          _messages[index].text,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        ),
                      ),
                    ),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                color: AppColors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: l10n.merchantConversationInputHint,
                          filled: true,
                          fillColor: AppColors.surfaceLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: l10n.merchantConversationSend,
                      onPressed: _sendMessage,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: AppColors.white,
                      ),
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    final merchantId = _merchantId;
    if (message.isEmpty || merchantId == null || _sending) return;
    setState(() => _sending = true);
    final item = MerchantConversationMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}',
      merchantId: merchantId,
      text: message,
      sentAt: DateTime.now(),
      fromSupervisor: true,
    );
    try {
      await _store.addMessage(item);
      if (!mounted) return;
      setState(() {
        _messages = [..._messages, item];
        _messageController.clear();
        _sending = false;
      });
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'merchant conversation',
      ));
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.productAuditSaveError)),
      );
    }
  }
}
