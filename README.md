# YourWallet - 智能记账应用

一款现代化的个人财务管理应用，专为用户提供简洁、高效的记账体验。支持传统资产管理和加密货币投资追踪，同时提供独特的双人协作记账功能。

## 项目概述

本应用致力于打造最简洁优雅的记账体验，解决现有记账软件功能复杂、界面臃肿的痛点。提供免费的云同步服务和双人协作功能，适合个人用户、情侣或合作伙伴使用。

## 核心功能

### 💰 智能记账
- ✅ **快速添加收支记录（收入/支出/转账/投资）**
- ✅ **智能分类和标签管理系统**
- ✅ **多账户管理（现金/银行卡/信用卡等）**
- ✅ **完整的交易CRUD操作**
- ✅ **财务概览和统计**
- 🚧 预算设置和支出提醒
- 🚧 账单提醒和重复交易

### 📊 投资管理
- ✅ 股票基金追踪
- ✅ 加密货币投资记录
- ✅ 投资组合分析和收益统计
- ✅ 实时价格和汇率更新
- ✅ 投资目标设定

### 👥 协作记账
- ✅ 双人账本共享
- ✅ 实时同步和权限管理
- ✅ 共同支出分摊计算
- ✅ 个人和共同账目分离

### 📈 数据分析
- ✅ 美观的图表可视化
- ✅ 月度/年度财务报告
- ✅ 支出趋势分析
- ✅ 数据导出功能
- ✅ 隐私安全保护

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

## 产品特色

1. **简洁美观**: Material Design 3设计，界面干净优雅
2. **功能全面**: 涵盖日常记账到投资管理的完整需求
3. **协作友好**: 独特的双人记账功能，适合情侣和合作伙伴
4. **完全免费**: 所有核心功能免费使用，无广告无内购
5. **数据安全**: 本地加密存储，支持生物识别解锁
6. **跨平台**: 支持Android、iOS、Web、桌面等多平台

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
- [x] **Rust后端API服务 (15个RESTful接口)**
- [x] **前后端完整对接和数据交互**
- [x] **JSON序列化和类型转换**
- [x] **Provider状态管理集成**
- [x] **本地数据缓存系统 (SharedPreferences)**
- [x] **记账主导的界面设计**
- [x] **完整的添加/编辑交易界面**
- [x] **交易记录CRUD完整功能**
- [x] **财务统计和概览功能**
- [x] **Material Design 3 主题**
- [x] **响应式设计和暗黑模式**

#### 🚧 当前开发重点
- 🚧 数据可视化图表集成 (FL Chart)
- 🚧 交易列表UI和交互优化
- 🚧 用户认证和权限系统

#### 📋 下阶段功能
- [ ] 数据库持久化 (PostgreSQL)
- [ ] 加密货币API集成
- [ ] 双人记账协作功能
- [ ] 云端同步服务
- [ ] 数据导出和备份

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