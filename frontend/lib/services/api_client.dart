import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class ApiClient {
  late final Dio _dio;
  static const String baseUrl = 'http://127.0.0.1:3000';
  
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 添加拦截器用于日志记录
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }

    // 添加错误拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        debugPrint('API Error: ${error.message}');
        if (error.response?.statusCode == 404) {
          // 处理404错误
          error = DioException(
            requestOptions: error.requestOptions,
            message: '请求的资源不存在',
            type: DioExceptionType.badResponse,
          );
        } else if (error.response?.statusCode == 500) {
          // 处理服务器错误
          error = DioException(
            requestOptions: error.requestOptions,
            message: '服务器内部错误',
            type: DioExceptionType.badResponse,
          );
        }
        handler.next(error);
      },
    ));
  }

  // 通用GET请求
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // 通用POST请求
  Future<T> post<T>(
    String path, {
    dynamic data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // 通用PUT请求
  Future<T> put<T>(
    String path, {
    dynamic data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      return fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // 通用DELETE请求
  Future<T> delete<T>(
    String path, {
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.delete(path);
      return fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // 健康检查
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // 根路径测试
  Future<String> rootTest() async {
    try {
      final response = await _dio.get('/');
      return response.data.toString();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

// API异常类
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  factory ApiException.fromDioException(DioException dioException) {
    String message = '网络请求失败';
    int? statusCode;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        message = '连接超时';
        break;
      case DioExceptionType.sendTimeout:
        message = '发送超时';
        break;
      case DioExceptionType.receiveTimeout:
        message = '接收超时';
        break;
      case DioExceptionType.badResponse:
        statusCode = dioException.response?.statusCode;
        message = _getErrorMessageFromResponse(dioException.response);
        break;
      case DioExceptionType.cancel:
        message = '请求已取消';
        break;
      case DioExceptionType.connectionError:
        message = '网络连接错误，请检查网络设置';
        break;
      default:
        message = dioException.message ?? '未知错误';
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      errorCode: dioException.response?.statusCode.toString(),
    );
  }

  static String _getErrorMessageFromResponse(Response? response) {
    if (response == null) return '服务器响应异常';

    try {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        // 尝试解析后端返回的错误信息
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
        if (data.containsKey('error')) {
          return data['error'].toString();
        }
      }
    } catch (e) {
      debugPrint('Error parsing response: $e');
    }

    // 根据状态码返回默认错误信息
    switch (response.statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权访问';
      case 403:
        return '禁止访问';
      case 404:
        return '请求的资源不存在';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务不可用';
      default:
        return '请求失败 (${response.statusCode})';
    }
  }

  @override
  String toString() => 'ApiException: $message';
}