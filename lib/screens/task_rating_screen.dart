import 'package:flutter/material.dart';

/// 任务评价和反馈系统
class TaskRatingScreen extends StatefulWidget {
  final int taskId;
  final String pilotName;

  const TaskRatingScreen({
    Key? key,
    required this.taskId,
    required this.pilotName,
  }) : super(key: key);

  @override
  State<TaskRatingScreen> createState() => _TaskRatingScreenState();
}

class _TaskRatingScreenState extends State<TaskRatingScreen> {
  // 评分数据
  double _overallRating = 0;
  double _qualityRating = 0;
  double _timelinessRating = 0;
  double _communicationRating = 0;
  
  // 评论数据
  final TextEditingController _commentController = TextEditingController();
  bool _isAnonymous = false;
  
  // 合规检测
  bool _complianceCheckPassed = true;
  String _complianceWarning = '';

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _checkCompliance(String comment) async {
    // 模拟合规检测
    setState(() {
      _complianceCheckPassed = true;
      _complianceWarning = '';
    });

    // 检测不当内容
    final bannedWords = ['骂', '脏话', '威胁', '骚扰', '诈骗'];
    for (var word in bannedWords) {
      if (comment.contains(word)) {
        setState(() {
          _complianceCheckPassed = false;
          _complianceWarning = '评论包含不当内容，请修改后重试';
        });
        return;
      }
    }

    // 检测过长评论
    if (comment.length > 1000) {
      setState(() {
        _complianceCheckPassed = false;
        _complianceWarning = '评论过长（最多1000个字符）';
      });
      return;
    }

    // 检测个人隐私信息
    final privacyPatterns = [
      RegExp(r'\d{11}'), // 手机号
      RegExp(r'\d{6}'), // 邮编
      RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'), // 邮箱
    ];

    for (var pattern in privacyPatterns) {
      if (pattern.hasMatch(comment)) {
        setState(() {
          _complianceCheckPassed = false;
          _complianceWarning = '评论包含个人隐私信息，请删除后重试';
        });
        return;
      }
    }
  }

  void _submitRating() async {
    // 检查是否填写了评分
    if (_overallRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请给出总体评分')),
      );
      return;
    }

    // 检查评论的合规性
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      await _checkCompliance(comment);
      if (!_complianceCheckPassed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_complianceWarning),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // 提交评价
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认提交'),
        content: const Text('您的评价将被记录并用于改进我们的服务。提交后无法修改。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog();
            },
            child: const Text('确认提交'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提交成功'),
        content: const Text('感谢您的评价！您的反馈对我们很重要。'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('完成'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('评价任务'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 飞手信息
            _buildPilotInfo(),

            // 评分部分
            _buildRatingSection(),

            // 详细评分
            _buildDetailedRatingSection(),

            // 评论部分
            _buildCommentSection(),

            // 合规提示
            if (_complianceWarning.isNotEmpty) _buildComplianceWarning(),

            // 提交按钮
            _buildSubmitButton(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// 构建飞手信息
  Widget _buildPilotInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade100,
            ),
            child: const Icon(Icons.person, color: Colors.blue, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.pilotName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '任务已完成，请给出您的评价',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建总体评分部分
  Widget _buildRatingSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '总体评分',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _overallRating = (index + 1).toDouble();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.star,
                          size: 40,
                          color: index < _overallRating
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Text(
                  _overallRating == 0
                      ? '请选择评分'
                      : '${_overallRating.toStringAsFixed(1)}/5.0',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _overallRating == 0 ? Colors.grey : Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建详细评分部分
  Widget _buildDetailedRatingSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 32),
          const Text(
            '详细评分（可选）',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailedRatingItem(
            '作业质量',
            _qualityRating,
            (value) {
              setState(() => _qualityRating = value);
            },
          ),
          const SizedBox(height: 16),
          _buildDetailedRatingItem(
            '按时完成',
            _timelinessRating,
            (value) {
              setState(() => _timelinessRating = value);
            },
          ),
          const SizedBox(height: 16),
          _buildDetailedRatingItem(
            '沟通能力',
            _communicationRating,
            (value) {
              setState(() => _communicationRating = value);
            },
          ),
        ],
      ),
    );
  }

  /// 构建详细评分项
  Widget _buildDetailedRatingItem(
    String label,
    double rating,
    Function(double) onRatingChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                onRatingChanged((index + 1).toDouble());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.star,
                  size: 20,
                  color: index < rating ? Colors.amber : Colors.grey.shade300,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  /// 构建评论部分
  Widget _buildCommentSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 32),
          const Text(
            '评论（可选）',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '分享您对这次任务的看法，帮助我们改进服务',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 5,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: '请输入您的评论...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value ?? false;
                  });
                },
              ),
              const Text(
                '匿名评价',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建合规警告
  Widget _buildComplianceWarning() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, size: 20, color: Colors.red),
            const SizedBox(width: 12),
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
    );
  }

  /// 构建提交按钮
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _submitRating,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const Text('提交评价'),
        ),
      ),
    );
  }
}
