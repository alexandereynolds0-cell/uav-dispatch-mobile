import 'package:flutter/material.dart';

/// 任务列表页面（带筛选和排序）
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // 筛选和排序参数
  String _sortBy = 'time'; // time, distance, price
  String _sortOrder = 'desc'; // asc, desc
  double _maxDistance = 50; // 公里
  double _minPrice = 0; // 元
  double _maxPrice = 100000; // 元
  String _taskType = 'all'; // all, spray, inspection, survey

  // 模拟任务数据
  late List<Map<String, dynamic>> _allTasks;
  late List<Map<String, dynamic>> _filteredTasks;

  @override
  void initState() {
    super.initState();
    _initializeTasks();
    _applyFiltersAndSort();
  }

  void _initializeTasks() {
    _allTasks = [
      {
        'id': 1,
        'title': '农田喷洒作业',
        'type': 'spray',
        'distance': 5.2,
        'price': 5000,
        'area': 100,
        'location': '北京市朝阳区',
        'publishedAt': DateTime.now().subtract(const Duration(hours: 2)),
        'deadline': DateTime.now().add(const Duration(days: 1)),
        'rating': 4.8,
        'ratingCount': 156,
        'status': 'available',
      },
      {
        'id': 2,
        'title': '电力线路巡检',
        'type': 'inspection',
        'distance': 12.5,
        'price': 3500,
        'length': 50,
        'location': '北京市丰台区',
        'publishedAt': DateTime.now().subtract(const Duration(hours: 4)),
        'deadline': DateTime.now().add(const Duration(days: 2)),
        'rating': 4.6,
        'ratingCount': 89,
        'status': 'available',
      },
      {
        'id': 3,
        'title': '建筑工地测量',
        'type': 'survey',
        'distance': 8.3,
        'price': 4200,
        'area': 50,
        'location': '北京市海淀区',
        'publishedAt': DateTime.now().subtract(const Duration(hours: 1)),
        'deadline': DateTime.now().add(const Duration(days: 3)),
        'rating': 4.9,
        'ratingCount': 234,
        'status': 'available',
      },
      {
        'id': 4,
        'title': '农业灾情评估',
        'type': 'spray',
        'distance': 25.8,
        'price': 6500,
        'area': 200,
        'location': '北京市顺义区',
        'publishedAt': DateTime.now().subtract(const Duration(hours: 6)),
        'deadline': DateTime.now().add(const Duration(days: 1)),
        'rating': 4.7,
        'ratingCount': 112,
        'status': 'available',
      },
      {
        'id': 5,
        'title': '管道巡线检测',
        'type': 'inspection',
        'distance': 3.1,
        'price': 2800,
        'length': 30,
        'location': '北京市东城区',
        'publishedAt': DateTime.now().subtract(const Duration(hours: 3)),
        'deadline': DateTime.now().add(const Duration(days: 2)),
        'rating': 4.5,
        'ratingCount': 67,
        'status': 'available',
      },
      {
        'id': 6,
        'title': '房产航拍',
        'type': 'survey',
        'distance': 15.7,
        'price': 3200,
        'area': 20,
        'location': '北京市朝阳区',
        'publishedAt': DateTime.now().subtract(const Duration(hours: 5)),
        'deadline': DateTime.now().add(const Duration(days: 3)),
        'rating': 4.8,
        'ratingCount': 145,
        'status': 'available',
      },
    ];
  }

  void _applyFiltersAndSort() {
    // 应用筛选
    _filteredTasks = _allTasks.where((task) {
      // 距离筛选
      final distance = (task['distance'] as num).toDouble();
      final price = (task['price'] as num).toDouble();

      if (distance > _maxDistance) return false;

      // 价格筛选
      if (price < _minPrice || price > _maxPrice) {
        return false;
      }

      // 任务类型筛选
      if (_taskType != 'all' && task['type'] != _taskType) return false;

      return true;
    }).toList();

    // 应用排序
    _filteredTasks.sort((a, b) {
      int comparison = 0;

      switch (_sortBy) {
        case 'distance':
          comparison = (a['distance'] as num)
              .toDouble()
              .compareTo((b['distance'] as num).toDouble());
          break;
        case 'price':
          comparison = (a['price'] as num)
              .toDouble()
              .compareTo((b['price'] as num).toDouble());
          break;
        case 'time':
        default:
          comparison = (b['publishedAt'] as DateTime)
              .compareTo(a['publishedAt'] as DateTime);
      }

      return _sortOrder == 'asc' ? comparison : -comparison;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('可用任务'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // 排序选项栏
          _buildSortBar(),

          // 任务列表
          Expanded(
            child: _filteredTasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredTasks.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return _buildTaskCard(_filteredTasks[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// 构建排序选项栏
  Widget _buildSortBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // 按时间排序
            _buildSortButton(
              label: '最新',
              value: 'time',
              isActive: _sortBy == 'time',
              onTap: () {
                setState(() {
                  _sortBy = 'time';
                  _sortOrder = 'desc';
                });
                _applyFiltersAndSort();
              },
            ),

            // 按距离排序
            _buildSortButton(
              label: '距离',
              value: 'distance',
              isActive: _sortBy == 'distance',
              onTap: () {
                setState(() {
                  _sortBy = 'distance';
                  _sortOrder = 'asc';
                });
                _applyFiltersAndSort();
              },
            ),

            // 按价格排序
            _buildSortButton(
              label: '价格',
              value: 'price',
              isActive: _sortBy == 'price',
              onTap: () {
                setState(() {
                  if (_sortBy == 'price') {
                    _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc';
                  } else {
                    _sortBy = 'price';
                    _sortOrder = 'desc';
                  }
                });
                _applyFiltersAndSort();
              },
            ),

            // 排序方向指示
            if (_sortBy == 'price')
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  _sortOrder == 'asc'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建排序按钮
  Widget _buildSortButton({
    required String label,
    required String value,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isActive,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: Colors.blue.shade100,
        side: BorderSide(
          color: isActive ? Colors.blue : Colors.grey.shade300,
        ),
        labelStyle: TextStyle(
          color: isActive ? Colors.blue : Colors.grey,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  /// 构建任务卡片
  Widget _buildTaskCard(Map<String, dynamic> task) {
    return GestureDetector(
      onTap: () {
        // TODO: 导航到任务详情页面
        Navigator.of(context).pushNamed(
          '/task-detail',
          arguments: task['id'],
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和类型
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task['location'] as String,
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
                      color: _getTaskTypeColor(task['type'] as String)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getTaskTypeLabel(task['type'] as String),
                      style: TextStyle(
                        fontSize: 11,
                        color: _getTaskTypeColor(task['type'] as String),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 关键信息
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 距离
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${task['distance']}km',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  // 价格
                  Text(
                    '¥${task['price']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  // 评分
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${task['rating']}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        '(${task['ratingCount']})',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 截止时间
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '截止: ${_formatDateTime(task['deadline'] as DateTime)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            '没有符合条件的任务',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _maxDistance = 50;
                _minPrice = 0;
                _maxPrice = 100000;
                _taskType = 'all';
                _sortBy = 'time';
                _sortOrder = 'desc';
              });
              _applyFiltersAndSort();
            },
            child: const Text('重置筛选'),
          ),
        ],
      ),
    );
  }

  /// 显示筛选对话框
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '筛选选项',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 任务类型
              const Text('任务类型'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip(
                    label: '全部',
                    value: 'all',
                    isSelected: _taskType == 'all',
                    onTap: () {
                      setModalState(() => _taskType = 'all');
                    },
                  ),
                  _buildFilterChip(
                    label: '喷洒',
                    value: 'spray',
                    isSelected: _taskType == 'spray',
                    onTap: () {
                      setModalState(() => _taskType = 'spray');
                    },
                  ),
                  _buildFilterChip(
                    label: '巡检',
                    value: 'inspection',
                    isSelected: _taskType == 'inspection',
                    onTap: () {
                      setModalState(() => _taskType = 'inspection');
                    },
                  ),
                  _buildFilterChip(
                    label: '测量',
                    value: 'survey',
                    isSelected: _taskType == 'survey',
                    onTap: () {
                      setModalState(() => _taskType = 'survey');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 距离范围
              const Text('最大距离: ${_maxDistance.toStringAsFixed(1)}km'),
              Slider(
                value: _maxDistance,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setModalState(() => _maxDistance = value);
                },
              ),
              const SizedBox(height: 16),

              // 价格范围
              const Text('价格范围'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '最低价格',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          _minPrice = double.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '最高价格',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          _maxPrice = double.tryParse(value) ?? 100000;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 按钮
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _applyFiltersAndSort();
                        Navigator.pop(context);
                      },
                      child: const Text('应用筛选'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建筛选芯片
  Widget _buildFilterChip({
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: Colors.blue.shade100,
      side: BorderSide(
        color: isSelected ? Colors.blue : Colors.grey.shade300,
      ),
    );
  }

  /// 获取任务类型颜色
  Color _getTaskTypeColor(String type) {
    switch (type) {
      case 'spray':
        return Colors.green;
      case 'inspection':
        return Colors.orange;
      case 'survey':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// 获取任务类型标签
  String _getTaskTypeLabel(String type) {
    switch (type) {
      case 'spray':
        return '喷洒';
      case 'inspection':
        return '巡检';
      case 'survey':
        return '测量';
      default:
        return type;
    }
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      return '今天 ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '明天 ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.month}月${dateTime.day}日';
    }
  }
}
