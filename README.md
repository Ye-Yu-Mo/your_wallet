# 加密货币记账应用

一款专注于加密货币投资记录的移动端记账应用，支持双人协作记账功能。

## 项目概述

本应用旨在解决现有记账软件缺乏加密货币支持的痛点，提供免费的云同步服务和独特的双人记账功能，适合个人投资者、情侣或投资伙伴使用。

## 核心功能

### 基础记账功能
- ✅ 手动添加交易记录（买入/卖出/转账）
- ✅ 主流交易所API自动同步（币安、欧易等）
- ✅ 多币种支持和实时汇率换算
- ✅ 交易成本计算（包含手续费）
- ✅ 投资组合概览和盈亏统计

### 双人记账功能
- ✅ 一对一用户配对系统
- ✅ 共享投资账本和实时同步
- ✅ 灵活权限管理（查看/编辑）
- ✅ 个人与共同投资分离统计

### 数据管理
- ✅ 数据可视化（收益曲线、资产分布图表）
- ✅ 价格预警和定投提醒
- ✅ 数据导出（Excel、PDF报表）
- ✅ 本地加密存储和生物识别解锁
- ✅ 离线模式支持

## 技术栈

### 前端
- **Framework**: Flutter 3.x
- **状态管理**: Provider / Riverpod
- **本地存储**: Hive / SQLite
- **网络请求**: Dio
- **图表**: FL Chart
- **安全**: Local Authentication

### 后端
- **语言**: Rust 1.75+
- **框架**: Axum / Actix-web
- **数据库**: PostgreSQL
- **ORM**: SeaORM / Diesel
- **缓存**: Redis
- **消息队列**: Redis Pub/Sub
- **认证**: JWT
- **API文档**: Utoipa (OpenAPI)

### 第三方集成
- **交易所API**: Binance API, OKX API
- **推送通知**: Firebase Cloud Messaging
- **云存储**: 对象存储服务

## 项目结构

```
your-wallet/
├── frontend/          # Flutter 前端应用
│   ├── lib/
│   │   └── main.dart  # 应用入口
│   ├── android/       # Android 平台支持
│   ├── ios/          # iOS 平台支持
│   ├── macos/        # macOS 桌面支持
│   ├── linux/        # Linux 桌面支持
│   ├── windows/      # Windows 桌面支持
│   ├── web/          # Web 平台支持
│   └── pubspec.yaml  # Flutter 依赖配置
├── backend/           # Rust 后端服务
│   ├── src/
│   │   ├── main.rs   # 入口文件
│   │   ├── api/      # API处理器
│   │   ├── models/   # 数据模型
│   │   ├── services/ # 业务逻辑
│   │   ├── db/       # 数据库操作
│   │   └── utils/    # 工具函数
│   ├── migrations/   # 数据库迁移
│   └── Cargo.toml    # Rust 依赖配置
├── docs/             # 项目文档
│   └── 开发流程文档.md
└── README.md         # 项目说明
```

## 开发计划

### Phase 1: MVP核心功能（4-6周）
- [ ] 用户注册登录系统
- [ ] 基础记账功能（手动添加）
- [ ] 简单的数据展示
- [ ] 基础的双人配对功能

### Phase 2: 数据集成（3-4周）
- [ ] 交易所API集成
- [ ] 自动数据同步
- [ ] 数据可视化图表
- [ ] 云端数据备份

### Phase 3: 高级功能（3-4周）
- [ ] 价格预警系统
- [ ] 数据导出功能
- [ ] 离线模式支持
- [ ] 性能优化

### Phase 4: 完善和发布（2-3周）
- [ ] UI/UX优化
- [ ] 测试和bug修复
- [ ] 应用商店发布
- [ ] 用户反馈收集

## 竞争优势

1. **专业性**: 专注加密货币投资记录
2. **免费性**: 云同步等核心功能完全免费
3. **协作性**: 独特的双人记账功能
4. **隐私性**: 本地加密存储，保护用户隐私
5. **易用性**: Flutter跨平台，一致的用户体验

## 快速启动指南

### 环境要求

#### 必需软件
- **Flutter SDK**: 3.35.3 或以上版本
- **Rust**: 1.75+ 
- **Android Studio**: 用于Android开发 (可选)
- **Git**: 版本控制

#### Android开发环境 (可选)
```bash
# 检查Flutter环境
flutter doctor

# 如果需要Android开发，确保Android SDK已安装
flutter doctor --android-licenses  # 接受Android许可证
```

### 启动步骤

#### 1. 克隆项目并安装依赖
```bash
git clone https://github.com/Ye-Yu-Mo/your_wallet.git
cd your_wallet

# 安装Flutter依赖
cd frontend
flutter pub get
cd ..
```

#### 2. 启动后端服务
```bash
cd backend
cargo run
# ✅ 后端服务启动在 http://localhost:3000
# ✅ 健康检查接口: http://localhost:3000/health
```

#### 3. 启动前端应用

**🔥 推荐：Web版本 (最稳定)**
```bash
cd frontend
flutter run -d chrome
# 自动打开浏览器，支持热重载
```

**📱 Android手机/模拟器**
```bash
# 启动Android模拟器 (如果使用模拟器)
cd frontend
flutter run -d android
# 或指定具体设备: flutter run -d emulator-5554
```

**🖥️ 桌面应用**
```bash
cd frontend
flutter run -d macos    # macOS (需要Xcode)
flutter run -d linux    # Linux
flutter run -d windows  # Windows
```

#### 4. 开发模式快捷启动脚本

创建启动脚本 `start-dev.sh`:
```bash
#!/bin/bash
echo "🚀 启动YourWallet开发环境..."

# 启动后端
cd backend && cargo run &
BACKEND_PID=$!

# 等待后端启动
sleep 3

# 启动前端 (Web版本)
cd ../frontend && flutter run -d chrome &
FRONTEND_PID=$!

echo "✅ 后端服务: http://localhost:3000"
echo "✅ 前端应用: 自动打开浏览器"
echo "🛑 按Ctrl+C停止所有服务"

# 等待用户停止
wait
```

### 当前开发状态

#### ✅ 已完成功能
- [x] 项目基础架构搭建
- [x] Flutter + Rust 开发环境
- [x] 完整的UI界面 (4个主要页面)
- [x] Material Design 3 主题
- [x] 响应式设计和暗黑模式
- [x] 基础的交易记录界面
- [x] 投资组合展示页面
- [x] 用户设置页面

#### 🚧 开发中功能
- [ ] 后端API接口实现
- [ ] 前后端数据对接
- [ ] 数据持久化存储
- [ ] 用户认证系统

#### 📋 待实现功能
- [ ] 加密货币API集成
- [ ] 双人记账功能
- [ ] 数据可视化图表
- [ ] 云端同步服务

### 常见问题排查

#### Flutter问题
```bash
# 检查Flutter环境
flutter doctor

# 清理缓存
flutter clean && flutter pub get

# 重新生成代码
flutter packages pub run build_runner build
```

#### Android问题
```bash
# 检查Android设备
flutter devices

# 启动Android模拟器
emulator -avd Pixel_7_API_35

# 安装到指定设备
flutter install -d android
```

#### Rust后端问题
```bash
# 重新编译
cd backend
cargo clean
cargo build

# 检查依赖
cargo check
```

### 开发工具推荐

- **IDE**: VS Code + Flutter插件 + Rust插件
- **Git**: 使用常规提交格式 (conventional commits)
- **调试**: Flutter Inspector + Chrome DevTools
- **API测试**: Postman 或 curl

### 项目架构简图

```
┌─────────────────┐    HTTP/JSON    ┌──────────────────┐
│   Flutter App   │ ◄──────────────► │   Rust Backend   │
│   (Frontend)    │     API调用      │   (API Server)   │
│                 │                  │                  │
│ • UI界面        │                  │ • RESTful API    │
│ • 状态管理      │                  │ • 业务逻辑       │
│ • 本地存储      │                  │ • 数据库操作     │
└─────────────────┘                  └──────────────────┘
        │                                      │
        ▼                                      ▼
┌─────────────────┐                  ┌──────────────────┐
│   本地数据库    │                  │   PostgreSQL     │
│   (SQLite)      │                  │   (生产数据库)   │
└─────────────────┘                  └──────────────────┘
```

## 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系方式

- 项目维护者: jasxu
- 邮箱: xulei.ahu@qq.com
- 项目链接: [https://github.com/Ye-Yu-Mo/your_wallet](https://github.com/Ye-Yu-Mo/your_wallet)