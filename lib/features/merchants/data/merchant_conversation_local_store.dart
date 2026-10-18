import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MerchantConversationMessage {
  final String id;
  final String merchantId;
  final String text;
  final DateTime sentAt;
  final bool fromSupervisor;
  final bool isRead;

  const MerchantConversationMessage({
    required this.id,
    required this.merchantId,
    required this.text,
    required this.sentAt,
    required this.fromSupervisor,
    this.isRead = true,
  });

  MerchantConversationMessage copyWith({bool? isRead}) =>
      MerchantConversationMessage(
        id: id,
        merchantId: merchantId,
        text: text,
        sentAt: sentAt,
        fromSupervisor: fromSupervisor,
        isRead: isRead ?? this.isRead,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'merchantId': merchantId,
        'text': text,
        'sentAt': sentAt.toIso8601String(),
        'fromSupervisor': fromSupervisor,
        'isRead': isRead,
      };

  factory MerchantConversationMessage.fromJson(Map<String, dynamic> json) =>
      MerchantConversationMessage(
        id: json['id'] as String,
        merchantId: json['merchantId'] as String,
        text: json['text'] as String,
        sentAt: DateTime.parse(json['sentAt'] as String),
        fromSupervisor: json['fromSupervisor'] as bool,
        isRead: json['isRead'] as bool? ?? true,
      );
}

class MerchantConversationLocalStore {
  static const _storageKey = 'merchant_supervisor_conversations_v1';

  Future<List<MerchantConversationMessage>> getMessages(
    String merchantId,
  ) async {
    final all = await _getAll();
    return all.where((message) => message.merchantId == merchantId).toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }

  Future<List<MerchantConversationMessage>> getAllMessages() => _getAll();

  Future<void> addMessage(MerchantConversationMessage message) async {
    final all = await _getAll();
    all.add(message);
    await _save(all);
  }

  Future<void> markMerchantMessagesRead(String merchantId) async {
    final all = await _getAll();
    var changed = false;
    final updated = all.map((message) {
      if (message.merchantId == merchantId &&
          !message.fromSupervisor &&
          !message.isRead) {
        changed = true;
        return message.copyWith(isRead: true);
      }
      return message;
    }).toList();
    if (changed) await _save(updated);
  }

  Future<List<MerchantConversationMessage>> _getAll() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_storageKey);
    if (encoded == null) return [];
    final decoded = jsonDecode(encoded);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Invalid merchant conversations.');
    }
    return decoded.map((value) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Invalid merchant conversation message.');
      }
      return MerchantConversationMessage.fromJson(value);
    }).toList();
  }

  Future<void> _save(List<MerchantConversationMessage> messages) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _storageKey,
      jsonEncode(messages.map((message) => message.toJson()).toList()),
    );
    if (!saved) throw StateError('Could not save merchant conversations.');
  }
}
