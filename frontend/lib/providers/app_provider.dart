import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class AppProvider with ChangeNotifier {
  // 应用状态
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isOnline = false;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isOnline => _isOnline;

  // 设置加载状态
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  // 设置错误信息
  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // 清除错误信息
  void clearError() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }

  // 检查网络连接状态
  Future<void> checkConnection() async {
    try {
      final isConnected = await statisticsService.testConnection();
      _isOnline = isConnected;
      notifyListeners();
    } catch (e) {
      _isOnline = false;
      notifyListeners();
    }
  }

  // 初始化应用
  Future<void> initializeApp() async {
    setLoading(true);
    clearError();

    try {
      // 检查网络连接
      await checkConnection();
      
      if (_isOnline) {
        debugPrint('✅ Backend API connection successful');
      } else {
        setError('无法连接到后端服务');
      }
    } catch (e) {
      setError('应用初始化失败: $e');
      debugPrint('❌ App initialization failed: $e');
    } finally {
      setLoading(false);
    }
  }

  // 处理API异常
  void handleApiException(ApiException exception) {
    setError(exception.message);
    debugPrint('API Error: ${exception.message} (${exception.statusCode})');
  }

  // 显示成功消息
  void showSuccess(String message) {
    debugPrint('✅ $message');
    // 可以在这里添加Toast或Snackbar显示逻辑
  }
}