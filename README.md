# 🚁 无人机飞手调度平台 - 移动端

> Flutter移动应用，支持Android和鸿蒙系统

## ✨ 功能特点

| 角色 | 功能 |
|------|------|
| 👤 客户 | 发布任务、支付费用、联系飞手、评价 |
| 🚁 飞手 | 实名认证、接单、作业上报、收益查看 |
| 💬 聊天 | 实时聊天、敏感词过滤（禁止泄露联系方式） |

## 📱 系统要求

- Android 7.0+ / 鸿蒙系统
- iOS 12.0+

## 🚀 快速开始

### 方法一：直接安装（推荐）

1. 下载 `release/app-release.apk`
2. 安装到手机
3. 打开应用，配置后端地址

### 方法二：自己编译

#### 1. 安装 Flutter

```bash
# Windows/Mac: https://flutter.dev/docs/get-started/install
# Linux:
sudo snap install flutter
```

#### 2. 克隆项目

```bash
git clone https://github.com/greasebig/uav-dispatch-mobile.git
cd uav-dispatch-mobile
```

#### 3. 安装依赖

```bash
flutter pub get
```

#### 4. 配置

编辑 `lib/config/app_config.dart`：

```dart
// 后端API地址
static const String apiBaseUrl = 'http://你的服务器IP:3000';

// 地图（可选: google, amap, tencent, baidu）
static const String mapProvider = 'google';
static const String googleMapsApiKey = '你的Google地图Key';

// 支付（可选: stripe）
static const String paymentProvider = 'stripe';
```

#### 5. 运行

```bash
# 开发模式
flutter run

# 编译APK
flutter build apk --release
```

## 📲 使用流程

### 客户使用
```
1. 注册/登录 
2. 点击"发布任务"
3. 填写任务信息（类型、地点、时间、预算）
4. 提交并支付
5. 查看飞手列表
6. 付费解锁飞手联系方式
7. 私下沟通确认
8. 作业完成后确认验收
9. 评价飞手
```

### 飞手使用
```
1. 注册并选择"飞手"角色
2. 实名认证（上传身份证）
3. 上传资质证书
4. 等待审核通过
5. 查看附近任务
6. 抢单/接单
7. 到达现场确认
8. 执行作业
9. 上传作业结果
10. 等待客户验收
11. 收益到账
```

### 聊天功能

- 实时消息收发
- **敏感词过滤**：自动检测并拦截手机号、微信号、QQ号等联系方式
- 发送前会有警告提示

## 🔧 常见问题

### Q: 无法登录
A: 检查后端服务是否启动，API地址是否正确

### Q: 地图不显示
A: 需要申请对应地图的API Key并配置

### Q: 支付失败
A: 检查Stripe配置是否正确

### Q: 鸿蒙系统能用吗
A: 可以！编译的APK在鸿蒙系统上兼容运行

## 📂 项目结构

```
lib/
├── config/          # 配置文件
├── models/          # 数据模型
├── services/        # API服务
├── screens/         # 页面
│   ├── chat_screen.dart    # 聊天页面
│   ├── task_list_screen.dart
│   ├── task_detail_screen.dart
│   └── ...
└── main.dart        # 入口文件
```

## 🔗 相关项目

- [后端仓库](https://github.com/greasebig/uav-dispatch-platform)

## 🐛 问题反馈

- [GitHub Issues](https://github.com/greasebig/uav-dispatch-mobile/issues)

## 📄 许可证

MIT License

---

**版本**: 1.1.0
**日期**: 2026年3月
