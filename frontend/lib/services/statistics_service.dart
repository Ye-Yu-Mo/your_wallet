import '../models/models.dart';
import 'api_client.dart';

class StatisticsService {
  final ApiClient _apiClient = ApiClient();

  // 获取财务概览
  Future<ApiResponse<FinancialSummary>> getFinancialSummary() async {
    return await _apiClient.get(
      '/api/summary',
      fromJson: (json) => ApiResponse<FinancialSummary>.fromJson(
        json,
        (data) => FinancialSummary.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  // 获取分类列表
  Future<ApiResponse<List<Category>>> getCategories() async {
    return await _apiClient.get(
      '/api/categories',
      fromJson: (json) => ApiResponse<List<Category>>.fromJson(
        json,
        (data) {
          if (data is List) {
            return data.map((item) => Category.fromJson(item as Map<String, dynamic>)).toList();
          }
          return <Category>[];
        },
      ),
    );
  }

  // 测试连接
  Future<bool> testConnection() async {
    try {
      final response = await _apiClient.healthCheck();
      return response['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }

  // 获取服务器根路径信息
  Future<String> getRootInfo() async {
    try {
      return await _apiClient.rootTest();
    } catch (e) {
      return 'Connection failed';
    }
  }
}

// 单例实例
final statisticsService = StatisticsService();