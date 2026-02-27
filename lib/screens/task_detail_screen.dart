import 'package:flutter/material.dart';
import 'dart:async';

/// 任务详情页面 - 包含实时沟通功能
class TaskDetailScreen extends StatefulWidget {
  final int taskId;

  const TaskDetailScreen({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // 模拟任务数据
  late Map<String, dynamic> _task;
  
  // 消息数据
  late List<Map<String, dynamic>> _messages;
  final TextEditingController _messageController = TextEditingController();
  late ScrollController _scrollController;
  
  // 合规检测
  bool _complianceCheckPassed = true;
  String _complianceWarning = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeData();
    _simulateIncomingMessages();
  }

  void _initializeData() {
    // 模拟任务数据
    _task = {
      'id': widget.taskId,
      'title': '农田喷洒作业',
      'type': 'spray',
      'status': 'in_progress',
      'distance': 5.2,
      'price': 5000,
      'area': 100,
      'location': '北京市朝阳区',
      'description': '需要对100亩农田进行喷洒作业，要求使用专业农业无人机。',
      'customer': {
        'id': 1,
        'name': '张三',
        'avatar': null,
        'rating': 4.8,
        'ratingCount': 156,
      },
      'pilot': {
        'id': 2,
        'name': '王飞手',
        'avatar': null,
        'rating': 4.9,
        'ratingCount': 234,
        'level': 'VIP',
      },
      'startTime': DateTime.now().subtract(const Duration(hours: 2)),
      'estimatedEndTime': DateTime.now().add(const Duration(hours: 1)),
      'deadline': DateTime.now().add(const Duration(days: 1)),
      'requirements': [
        '需要有农业喷洒资质',
        '无人机续航时间≥30分钟',
        '具有5年以上飞行经验',
      ],
      'progress': 65,
    };

    // 模拟消息数据
    _messages = [
      {
        'id': 1,
        'sender': 'customer',
        'senderName': '张三',
        'senderAvatar': null,
        'message': '您好，今天天气不错，能按时完成吗？',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
        'isCompliant': true,
      },
      {
        'id': 2,
        'sender': 'pilot',
        'senderName': '王飞手',
        'senderAvatar': null,
        'message': '没问题，我现在已经到达作业地点，正在准备无人机。',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 28)),
        'isCompliant': true,
      },
      {
        'id': 3,
        'sender': 'customer',
        'senderName': '张三',
        'senderAvatar': null,
        'message': '好的，谢谢！请确保安全操作。',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
        'isCompliant': true,
      },
      {
        'id': 4,
        'sender': 'pilot',
        'senderName': '王飞手',
        'senderAvatar': null,
        'message': '已开始作业，预计1小时完成。我会定期发送进度更新。',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
        'isCompliant': true,
      },
    ];
  }

  void _simulateIncomingMessages() {
    // 模拟接收消息
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted && _messages.length < 10) {
        setState(() {
          _messages.add({
            'id': _messages.length + 1,
            'sender': _messages.last['sender'] == 'pilot' ? 'customer' : 'pilot',
            'senderName': _messages.last['sender'] == 'pilot' ? '张三' : '王飞手',
            'senderAvatar': null,
            'message': _generateRandomMessage(),
            'timestamp': DateTime.now(),
            'isCompliant': true,
          });
        });
        _scrollToBottom();
      }
    });
  }

  String _generateRandomMessage() {
    final messages = [
      '作业进度已达到50%',
      '天气条件很好，继续进行',
      '已完成北区喷洒，开始南区',
      '预计还需30分钟完成',
      '一切顺利，质量很好',
    ];
    return messages[_messages.length % messages.length];
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _checkCompliance(String message) async {
    // 模拟合规检测
    setState(() {
      _complianceCheckPassed = true;
      _complianceWarning = '';
    });

    // 检测不当内容
    final bannedWords = ['违法', '骗', '欺诈', '威胁'];
    for (var word in bannedWords) {
      if (message.contains(word)) {
        setState(() {
          _complianceCheckPassed = false;
          _complianceWarning = '消息包含不当内容，请修改后重试';
        });
        return;
      }
    }

    // 检测过长消息
    if (message.length > 500) {
      setState(() {
        _complianceCheckPassed = false;
        _complianceWarning = '消息过长（最多500个字符）';
      });
      return;
    }

    // 检测频繁发送
    if (_messages.isNotEmpty) {
      final lastMessage = _messages.last;
      final timeDiff = DateTime.now().difference(lastMessage['timestamp']);
      if (timeDiff.inSeconds < 2) {
        setState(() {
          _complianceCheckPassed = false;
          _complianceWarning = '发送过于频繁，请稍候再试';
        });
        return;
      }
    }
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // 检查合规性
    await _checkCompliance(message);

    if (!_complianceCheckPassed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_complianceWarning),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 添加消息
    setState(() {
      _messages.add({
        'id': _messages.length + 1,
        'sender': 'me',
        'senderName': '我',
        'senderAvatar': null,
        'message': message,
        'timestamp': DateTime.now(),
        'isCompliant': true,
      });
    });

    _messageController.clear();
    _scrollToBottom();

    // TODO: 发送到服务器
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('消息已发送')),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任务详情'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // 任务信息
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTaskHeader(),
                  _buildTaskInfo(),
                  _buildProgressSection(),
                  _buildParticipantsSection(),
                  _buildRequirementsSection(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 消息区域
          Expanded(
            child: _buildMessagesSection(),
          ),

          // 输入框
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// 构建任务头部
  Widget _buildTaskHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _task['title'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '进行中',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _task['location'] as String,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '¥${_task['price']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                '${_task['area']}亩',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建任务信息
  Widget _buildTaskInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '任务描述',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _task['description'] as String,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('开始时间', _formatDateTime(_task['startTime'])),
              _buildInfoItem('预计完成', _formatDateTime(_task['estimatedEndTime'])),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建进度部分
  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '作业进度',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_task['progress']}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_task['progress'] as int) / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(Colors.blue.shade400),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建参与者部分
  Widget _buildParticipantsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '参与者',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildParticipantCard(_task['customer']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildParticipantCard(_task['pilot']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建参与者卡片
  Widget _buildParticipantCard(Map<String, dynamic> participant) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              child: const Icon(Icons.person, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              participant['name'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, size: 12, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  '${participant['rating']}',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建需求部分
  Widget _buildRequirementsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '任务要求',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...((_task['requirements'] as List).map((req) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      req as String,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }).toList()),
        ],
      ),
    );
  }

  /// 构建消息部分
  Widget _buildMessagesSection() {
    return Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '实时沟通',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '合规检测已启用',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建消息气泡
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['sender'] == 'me';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              child: const Icon(Icons.person, size: 16),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: !isMe
                        ? Border.all(color: Colors.grey.shade200)
                        : null,
                  ),
                  child: Text(
                    message['message'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message['timestamp'] as DateTime),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade400,
              ),
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  /// 构建消息输入框
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_complianceWarning.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _complianceWarning,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: '输入消息（合规检测已启用）',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                  maxLength: 500,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                onPressed: _sendMessage,
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建信息项
  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// 格式化时间
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
