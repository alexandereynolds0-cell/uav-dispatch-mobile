import 'package:flutter/material.dart';

/// 飞手技能认证模块
class PilotCertificationScreen extends StatefulWidget {
  const PilotCertificationScreen({Key? key}) : super(key: key);

  @override
  State<PilotCertificationScreen> createState() =>
      _PilotCertificationScreenState();
}

class _PilotCertificationScreenState extends State<PilotCertificationScreen> {
  // 认证数据
  late List<Map<String, dynamic>> _certifications;
  late List<Map<String, dynamic>> _pendingCertifications;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // 已通过的认证
    _certifications = [
      {
        'id': 1,
        'name': '无人机驾驶执照',
        'issuer': '中国民用航空局',
        'type': 'license',
        'status': 'approved',
        'issueDate': DateTime(2023, 6, 15),
        'expiryDate': DateTime(2026, 6, 15),
        'certificateNumber': 'CAAC-2023-001234',
        'imageUrl': null,
      },
      {
        'id': 2,
        'name': '农业植保无人机操作证',
        'issuer': '中国农业技术推广协会',
        'type': 'skill',
        'status': 'approved',
        'issueDate': DateTime(2023, 9, 20),
        'expiryDate': DateTime(2025, 9, 20),
        'certificateNumber': 'CATA-2023-005678',
        'imageUrl': null,
      },
      {
        'id': 3,
        'name': '无人机安全飞行培训证书',
        'issuer': '中国航空学会',
        'type': 'training',
        'status': 'approved',
        'issueDate': DateTime(2024, 1, 10),
        'expiryDate': DateTime(2027, 1, 10),
        'certificateNumber': 'CAA-2024-009012',
        'imageUrl': null,
      },
    ];

    // 待审核的认证
    _pendingCertifications = [
      {
        'id': 4,
        'name': '电力巡检无人机操作证',
        'issuer': '中国电力企业联合会',
        'type': 'skill',
        'status': 'pending',
        'uploadDate': DateTime.now().subtract(const Duration(days: 2)),
        'certificateNumber': 'CEUA-2024-003456',
        'imageUrl': null,
        'reviewNotes': null,
      },
      {
        'id': 5,
        'name': '测量无人机操作证',
        'issuer': '中国测绘地理信息学会',
        'type': 'skill',
        'status': 'rejected',
        'uploadDate': DateTime.now().subtract(const Duration(days: 5)),
        'certificateNumber': 'CSGIS-2024-001234',
        'imageUrl': null,
        'reviewNotes': '证书图片不清晰，请重新上传',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('技能认证'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 认证统计
            _buildCertificationStats(),

            // 已通过的认证
            _buildApprovedSection(),

            // 待审核的认证
            _buildPendingSection(),

            // 添加认证按钮
            _buildAddCertificationButton(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// 构建认证统计
  Widget _buildCertificationStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '认证进度',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '已通过',
                '${_certifications.length}',
                Colors.white,
              ),
              _buildStatItem(
                '待审核',
                '${_pendingCertifications.where((c) => c['status'] == 'pending').length}',
                Colors.white,
              ),
              _buildStatItem(
                '已驳回',
                '${_pendingCertifications.where((c) => c['status'] == 'rejected').length}',
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// 构建已通过认证部分
  Widget _buildApprovedSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '已通过认证',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                  '有效',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._certifications.map((cert) {
            return _buildCertificationCard(cert, isApproved: true);
          }).toList(),
        ],
      ),
    );
  }

  /// 构建待审核认证部分
  Widget _buildPendingSection() {
    if (_pendingCertifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 32),
          const Text(
            '审核中的认证',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._pendingCertifications.map((cert) {
            return _buildCertificationCard(cert, isApproved: false);
          }).toList(),
        ],
      ),
    );
  }

  /// 构建认证卡片
  Widget _buildCertificationCard(Map<String, dynamic> cert,
      {required bool isApproved}) {
    final status = cert['status'] as String;
    final statusColor = status == 'approved'
        ? Colors.green
        : status == 'pending'
            ? Colors.orange
            : Colors.red;
    final statusLabel = status == 'approved'
        ? '已通过'
        : status == 'pending'
            ? '待审核'
            : '已驳回';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cert['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert['issuer'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '证书号: ${cert['certificateNumber']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isApproved)
                        Text(
                          '有效期: ${_formatDate(cert['issueDate'])} - ${_formatDate(cert['expiryDate'])}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        )
                      else
                        Text(
                          '上传时间: ${_formatDate(cert['uploadDate'])}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (status == 'rejected' && cert['reviewNotes'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, size: 14, color: Colors.red),
                          const SizedBox(width: 6),
                          const Text(
                            '审核意见',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert['reviewNotes'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'rejected')
                  TextButton(
                    onPressed: () {
                      _showReuploadDialog(cert);
                    },
                    child: const Text('重新上传'),
                  ),
                if (status == 'approved')
                  TextButton(
                    onPressed: () {
                      _showCertificateDetail(cert);
                    },
                    child: const Text('查看详情'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建添加认证按钮
  Widget _buildAddCertificationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _showAddCertificationDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('添加新认证'),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示添加认证对话框
  void _showAddCertificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加新认证'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '选择要添加的认证类型：',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildCertTypeButton('无人机驾驶执照'),
              _buildCertTypeButton('农业植保操作证'),
              _buildCertTypeButton('电力巡检操作证'),
              _buildCertTypeButton('测量操作证'),
              _buildCertTypeButton('其他认证'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 构建认证类型按钮
  Widget _buildCertTypeButton(String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
            _showUploadCertificateDialog(type);
          },
          child: Text(type),
        ),
      ),
    );
  }

  /// 显示上传证书对话框
  void _showUploadCertificateDialog(String certType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('上传 $certType'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '请上传清晰的证书照片或扫描件',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 32, color: Colors.grey),
                      const SizedBox(height: 8),
                      const Text(
                        '点击选择文件',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '要求：',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 图片清晰可见，无遮挡\n• 支持JPG、PNG格式\n• 文件大小不超过5MB\n• 包含完整的证书信息',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$certType 已提交审核'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('提交审核'),
          ),
        ],
      ),
    );
  }

  /// 显示重新上传对话框
  void _showReuploadDialog(Map<String, dynamic> cert) {
    _showUploadCertificateDialog(cert['name'] as String);
  }

  /// 显示证书详情
  void _showCertificateDetail(Map<String, dynamic> cert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('证书详情'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('证书名称', cert['name'] as String),
              _buildDetailRow('颁发机构', cert['issuer'] as String),
              _buildDetailRow('证书号', cert['certificateNumber'] as String),
              _buildDetailRow('颁发日期', _formatDate(cert['issueDate'])),
              _buildDetailRow('有效期至', _formatDate(cert['expiryDate'])),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 构建详情行
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
