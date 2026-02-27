import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

/// 地图页面 - 显示实时飞手位置
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 模拟数据
  late List<Map<String, dynamic>> _nearbyPilots;
  late Map<String, dynamic> _userLocation;
  Timer? _locationUpdateTimer;
  String _selectedMapProvider = 'google'; // google, amap, tencent, baidu

  // 地图中心点（北京）
  static const double _defaultLat = 39.9042;
  static const double _defaultLng = 116.4074;
  static const double _defaultZoom = 15;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startLocationUpdates();
  }

  void _initializeData() {
    // 用户位置
    _userLocation = {
      'lat': _defaultLat,
      'lng': _defaultLng,
      'name': '我的位置',
    };

    // 模拟附近飞手数据
    _nearbyPilots = [
      {
        'id': 1,
        'name': '王飞手',
        'lat': _defaultLat + 0.01,
        'lng': _defaultLng + 0.01,
        'distance': 1.2,
        'rating': 4.8,
        'level': 'VIP',
        'status': 'available',
        'taskCount': 156,
      },
      {
        'id': 2,
        'name': '李飞手',
        'lat': _defaultLat - 0.008,
        'lng': _defaultLng + 0.015,
        'distance': 2.1,
        'rating': 4.6,
        'level': '高级',
        'status': 'available',
        'taskCount': 98,
      },
      {
        'id': 3,
        'name': '张飞手',
        'lat': _defaultLat + 0.015,
        'lng': _defaultLng - 0.012,
        'distance': 2.8,
        'rating': 4.5,
        'level': '中级',
        'status': 'busy',
        'taskCount': 45,
      },
      {
        'id': 4,
        'name': '刘飞手',
        'lat': _defaultLat - 0.012,
        'lng': _defaultLng - 0.01,
        'distance': 1.9,
        'rating': 4.9,
        'level': 'VIP',
        'status': 'available',
        'taskCount': 234,
      },
      {
        'id': 5,
        'name': '陈飞手',
        'lat': _defaultLat + 0.005,
        'lng': _defaultLng - 0.02,
        'distance': 2.3,
        'rating': 4.7,
        'level': '高级',
        'status': 'available',
        'taskCount': 112,
      },
    ];
  }

  void _startLocationUpdates() {
    // 模拟定期更新飞手位置
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        // 模拟飞手位置变化
        for (var pilot in _nearbyPilots) {
          pilot['lat'] += (Random().nextDouble() - 0.5) * 0.001;
          pilot['lng'] += (Random().nextDouble() - 0.5) * 0.001;
        }
      });
    });
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('附近飞手'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedMapProvider = value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'google',
                child: Text('Google Maps'),
              ),
              const PopupMenuItem(
                value: 'amap',
                child: Text('高德地图'),
              ),
              const PopupMenuItem(
                value: 'tencent',
                child: Text('腾讯地图'),
              ),
              const PopupMenuItem(
                value: 'baidu',
                child: Text('百度地图'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // 地图区域
          _buildMapArea(),

          // 飞手列表面板
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildPilotListPanel(),
          ),
        ],
      ),
    );
  }

  /// 构建地图区域
  Widget _buildMapArea() {
    return Container(
      color: Colors.grey.shade200,
      child: Stack(
        children: [
          // 地图占位符
          Container(
            color: Colors.blue.shade100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 64,
                    color: Colors.blue.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_selectedMapProvider.toUpperCase()} 地图',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '中心: ${_userLocation['lat']}, ${_userLocation['lng']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: 集成真实地图SDK
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '集成${_selectedMapProvider.toUpperCase()}地图',
                          ),
                        ),
                      );
                    },
                    child: const Text('集成地图'),
                  ),
                ],
              ),
            ),
          ),

          // 用户位置标记
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '我',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 飞手位置标记
          ..._nearbyPilots.map((pilot) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.2 +
                  (pilot['lat'] - _defaultLat) * 5000,
              left: MediaQuery.of(context).size.width * 0.5 +
                  (pilot['lng'] - _defaultLng) * 5000,
              child: GestureDetector(
                onTap: () => _showPilotDetail(pilot),
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pilot['status'] == 'available'
                            ? Colors.green
                            : Colors.orange,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: (pilot['status'] == 'available'
                                    ? Colors.green
                                    : Colors.orange)
                                .withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.airplanemode_active,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        pilot['name'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          // 控制按钮
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    // 定位到我
                    setState(() {});
                  },
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    // 放大
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    // 缩小
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建飞手列表面板
  Widget _buildPilotListPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖动指示器
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // 标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '附近${_nearbyPilots.length}位飞手',
                  style: const TextStyle(
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
                    '实时更新',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 飞手列表
          SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _nearbyPilots.length,
              itemBuilder: (context, index) {
                return _buildPilotItem(_nearbyPilots[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建飞手项
  Widget _buildPilotItem(Map<String, dynamic> pilot) {
    return GestureDetector(
      onTap: () => _showPilotDetail(pilot),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 头像和状态
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade100,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pilot['status'] == 'available'
                            ? Colors.green
                            : Colors.orange,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pilot['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            pilot['level'] as String,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${pilot['rating']} (${pilot['taskCount']})',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${pilot['distance']}km',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 操作按钮
              ElevatedButton(
                onPressed: () {
                  // TODO: 发送任务给飞手
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('向${pilot['name']}发送任务'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: const Text('派单', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示飞手详情
  void _showPilotDetail(Map<String, dynamic> pilot) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pilot['name'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 信息行
            _buildDetailRow('等级', pilot['level'] as String),
            _buildDetailRow('评分', '${pilot['rating']}/5.0'),
            _buildDetailRow('任务数', '${pilot['taskCount']}'),
            _buildDetailRow('距离', '${pilot['distance']}km'),
            _buildDetailRow('状态',
                pilot['status'] == 'available' ? '可接单' : '忙碌中'),
            const SizedBox(height: 24),

            // 按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: 导航到派单页面
                },
                child: const Text('向此飞手派单'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建详情行
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
