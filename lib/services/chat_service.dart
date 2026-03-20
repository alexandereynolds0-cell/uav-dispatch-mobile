import '../models/chat_message.dart';
import 'api_service.dart';

/// 聊天服务 - 处理消息发送、接收和敏感词过滤
class ChatService {
  static final ApiService _apiService = ApiService();

  /// 获取对话列表
  static Future<List<Conversation>> getConversations() async {
    try {
      final data = await _apiService.getConversations();
      return data.map(Conversation.fromJson).toList();
    } catch (e) {
      print('Error fetching conversations: $e');
      return [];
    }
  }

  /// 获取历史消息
  static Future<List<ChatMessage>> getMessages(int conversationId) async {
    try {
      final data = await _apiService.getMessages(conversationId);
      return data.map(ChatMessage.fromJson).toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  /// 发送消息（自动检测敏感词）
  static Future<ChatMessage?> sendMessage({
    required int conversationId,
    int? receiverId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    try {
      final response = await _apiService.sendMessage(conversationId, content);
      return ChatMessage.fromJson({
        ...response,
        if (!response.containsKey('receiver_id') && receiverId != null) 'receiver_id': receiverId,
        if (!response.containsKey('receiver_name')) 'receiver_name': '',
        if (!response.containsKey('content')) 'content': content,
        if (!response.containsKey('type')) 'type': type.name,
        if (!response.containsKey('status')) 'status': MessageStatus.sent.name,
        if (!response.containsKey('created_at')) 'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

  /// 检查消息是否包含敏感信息（本地预检）
  static SensitiveContentResult checkSensitiveContent(String content) {
    final phoneRegex = RegExp(r'1[3-9]\d{9}', caseSensitive: false);
    final wechatRegex = RegExp(
      r'wx[:：]?\w{5,20}|wechat[:：]?\w{5,20}|微信[:：]?\w{5,20}',
      caseSensitive: false,
    );
    final qqRegex = RegExp(r'qq[:：]?\d{5,11}|\d{5,11}qq', caseSensitive: false);
    final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');

    final contactKeywords = [
      '加我', '加微信', '加QQ', '加我微信', '私聊',
      '电话', '手机号', '联系我', '联系方式',
      'v:x', 'vx', 'v信',
    ];

    final hasPhone = phoneRegex.hasMatch(content);
    final hasWechat = wechatRegex.hasMatch(content);
    final hasQQ = qqRegex.hasMatch(content);
    final hasEmail = emailRegex.hasMatch(content);
    final hasKeywords = contactKeywords.any((k) => content.toLowerCase().contains(k.toLowerCase()));

    if (hasPhone || hasWechat || hasQQ || hasEmail || hasKeywords) {
      var filtered = content
          .replaceAll(phoneRegex, '***')
          .replaceAll(wechatRegex, 'wx: ***')
          .replaceAll(qqRegex, 'qq: ***')
          .replaceAll(emailRegex, '***@***.***');

      for (final keyword in contactKeywords) {
        filtered = filtered.replaceAll(RegExp(keyword, caseSensitive: false), '***');
      }

      return SensitiveContentResult(
        hasSensitiveContent: true,
        filteredContent: filtered,
        reasons: [
          if (hasPhone) '包含手机号码',
          if (hasWechat) '包含微信号',
          if (hasQQ) '包含QQ号',
          if (hasEmail) '包含邮箱地址',
          if (hasKeywords) '包含联系方式关键词',
        ],
      );
    }

    return SensitiveContentResult(
      hasSensitiveContent: false,
      filteredContent: content,
      reasons: const [],
    );
  }

  /// 标记消息为已读
  static Future<bool> markAsRead(int conversationId) async {
    try {
      await _apiService.markNotificationAsRead(conversationId);
      return true;
    } catch (e) {
      print('Error marking as read: $e');
      return false;
    }
  }
}

class SensitiveContentResult {
  final bool hasSensitiveContent;
  final String filteredContent;
  final List<String> reasons;

  SensitiveContentResult({
    required this.hasSensitiveContent,
    required this.filteredContent,
    required this.reasons,
  });
}
