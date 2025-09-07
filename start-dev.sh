#!/bin/bash

echo "🚀 启动YourWallet开发环境..."

# 检查必需的工具
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1 未安装，请先安装后再运行"
        exit 1
    fi
}

echo "🔍 检查开发环境..."
check_command flutter
check_command cargo

# 检查Flutter环境
echo "📱 检查Flutter环境..."
flutter doctor --machine > /dev/null
if [ $? -ne 0 ]; then
    echo "⚠️  Flutter环境有问题，请运行 'flutter doctor' 查看详情"
fi

# 安装依赖
echo "📦 安装Flutter依赖..."
cd frontend
flutter pub get
cd ..

echo "🏗️  编译Rust后端..."
cd backend
cargo build --release
if [ $? -ne 0 ]; then
    echo "❌ Rust编译失败，请检查代码"
    exit 1
fi
cd ..

# 启动后端
echo "🖥️  启动后端服务..."
cd backend && cargo run &
BACKEND_PID=$!

# 等待后端启动
echo "⏳ 等待后端服务启动..."
sleep 5

# 检查后端是否启动成功
curl -s http://localhost:3000/health > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ 后端服务启动成功: http://localhost:3000"
else
    echo "❌ 后端服务启动失败"
    kill $BACKEND_PID
    exit 1
fi

# 启动前端
echo "🌐 启动前端应用..."
cd frontend

# 检查可用设备
DEVICES=$(flutter devices --machine | jq -r '.[].id' 2>/dev/null)

if echo "$DEVICES" | grep -q "chrome"; then
    echo "🔥 使用Chrome浏览器启动..."
    flutter run -d chrome &
elif echo "$DEVICES" | grep -q "emulator"; then
    echo "📱 使用Android模拟器启动..."
    flutter run -d android &
elif echo "$DEVICES" | grep -q "macos"; then
    echo "🖥️  使用macOS桌面版启动..."
    flutter run -d macos &
else
    echo "🌐 默认使用Web版本启动..."
    flutter run -d web-server --web-port 8080 &
fi

FRONTEND_PID=$!

echo ""
echo "🎉 YourWallet开发环境已启动！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 后端API服务: http://localhost:3000"
echo "✅ 健康检查接口: http://localhost:3000/health"
echo "✅ 前端应用: 根据设备自动选择启动方式"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 开发提示:"
echo "   • 代码修改会自动热重载"
echo "   • 按 'r' 键重新加载应用"
echo "   • 按 'q' 键退出Flutter应用"
echo ""
echo "🛑 按 Ctrl+C 停止所有服务"

# 清理函数
cleanup() {
    echo ""
    echo "🔄 正在停止服务..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    echo "✅ 所有服务已停止"
    exit 0
}

# 捕获中断信号
trap cleanup SIGINT SIGTERM

# 等待用户停止
wait