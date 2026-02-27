import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

/// 个人中心页面
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 模拟数据 - 实际应该从API获取
  late Map<String, dynamic> pilotStats;
  late List<Map<String, dynamic>> recentTasks;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // 模拟飞手统计数据
    pilotStats = {
      'totalTasks': 156,
      'completedTasks': 152,
      'completionRate': 97.4,
      'totalEarnings': 45680.50,
      'rating': 4.8,
      'level': 'VIP', // 初级、中级、高级、VIP
      'certificationStatus': 'verified', // pending, verified, rejected
      'totalFlightHours': 328.5,
    };

    // 模拟最近任务
    recentTasks = [
      {
        'id': 1,
        'title': '农田喷洒',
        'status': 'completed',
        'earnedAmount': 5000,
        'completedAt': '2026-02-25',
        'rating': 5,
      },
      {
        'id': 2,
        'title': '电力巡检',
        'status': 'completed',
        'earnedAmount': 3500,
        'completedAt': '2026-02-24',
        'rating': 4,
      },
      {
        'id': 3,
        'title': '建筑测量',
        'status': 'completed',
        'earnedAmount': 4200,
        'completedAt': '2026-02-23',
        'rating': 5,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          return _buildLoginPrompt(context);
        }

        final user = authProvider.currentUser;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('个人中心'),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 用户信息卡片
                _buildUserInfoCard(user),
                const SizedBox(height: 16),

                // 认证状态
                _buildCertificationStatus(),
                const SizedBox(height: 16),

                // 统计数据
                _buildStatsSection(),
                const SizedBox(height: 16),

                // 等级信息
                _buildLevelSection(),
                const SizedBox(height: 16),

                // 最近任务
                _buildRecentTasksSection(),
                const SizedBox(height: 24),

                // 操作按钮
                _buildActionButtons(context, authProvider),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserInfoCard(User user) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 头像
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              image: DecorationImage(
                image: NetworkImage(
                  user.avatar ?? 'https://via.placeholder.com/80',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 用户名和角色
          Text(
            user.name ?? '用户${user.id}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getRoleLabel(user.role),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 邮箱和手机
          if (user.email != null)
            Text(
              user.email!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          if (user.phone != null)
            Text(
              user.phone!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }

  /// 构建认证状态
  Widget _buildCertificationStatus() {
    final status = pilotStats['certificationStatus'] as String;
    final isVerified = status == 'verified';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isVerified ? Colors.green.shade50 : Colors.orange.shade50,
        border: Border.all(
          color: isVerified ? Colors.green.shade300 : Colors.orange.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isVerified ? Icons.verified : Icons.pending,
            color: isVerified ? Colors.green : Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVerified ? '已认证' : '待认证',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isVerified ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isVerified
                      ? '您的飞手资质已通过审核'
                      : '请上传资质文件进行认证',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (!isVerified)
            ElevatedButton(
              onPressed: () {
                // TODO: 导航到认证页面
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('认证', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  /// 构建统计数据部分
  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '统计数据',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildStatCard(
                '完成任务',
                '${pilotStats['completedTasks']}',
                Colors.blue,
                Icons.check_circle,
              ),
              _buildStatCard(
                '完成率',
                '${pilotStats['completionRate']}%',
                Colors.green,
                Icons.trending_up,
              ),
              _buildStatCard(
                '总收入',
                '¥${pilotStats['totalEarnings']}',
                Colors.orange,
                Icons.attach_money,
              ),
              _buildStatCard(
                '飞行时数',
                '${pilotStats['totalFlightHours']}h',
                Colors.purple,
                Icons.flight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建单个统计卡片
  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建等级信息
  Widget _buildLevelSection() {
    final level = pilotStats['level'] as String;
    final rating = pilotStats['rating'] as double;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border.all(color: Colors.amber.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '飞手等级',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  level,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < rating.toInt() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$rating/5.0',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getLevelDescription(level),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建最近任务部分
  Widget _buildRecentTasksSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '最近任务',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentTasks.length,
            itemBuilder: (context, index) {
              final task = recentTasks[index];
              return _buildTaskItem(task);
            },
          ),
        ],
      ),
    );
  }

  /// 构建任务项
  Widget _buildTaskItem(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.task, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task['completedAt'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '¥${task['earnedAmount']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < (task['rating'] as int) ? Icons.star : Icons.star_border,
                    size: 14,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context, AuthProvider authProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                // TODO: 导航到编辑资料页面
              },
              child: const Text('编辑资料'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                await authProvider.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              child: const Text('登出'),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建登录提示
  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            '请先登录',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
            child: const Text('去登录'),
          ),
        ],
      ),
    );
  }

  /// 获取角色标签
  String _getRoleLabel(String role) {
    switch (role) {
      case 'customer':
        return '客户';
      case 'pilot':
        return '飞手';
      case 'admin':
        return '管理员';
      default:
        return role;
    }
  }

  /// 获取等级描述
  String _getLevelDescription(String level) {
    switch (level) {
      case '初级':
        return '完成任务数 0-50，可接受基础任务';
      case '中级':
        return '完成任务数 51-150，可接受中等难度任务';
      case '高级':
        return '完成任务数 151-300，可接受高难度任务';
      case 'VIP':
        return '完成任务数 300+，享受VIP特权';
      default:
        return '';
    }
  }
}
