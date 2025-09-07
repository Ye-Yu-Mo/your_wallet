import '../models/models.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  // 创建用户
  Future<ApiResponse<User>> createUser(CreateUserRequest request) async {
    return await _apiClient.post(
      '/api/users',
      data: request.toJson(),
      fromJson: (json) => ApiResponse<User>.fromJson(
        json,
        (data) => User.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  // 获取用户信息
  Future<ApiResponse<User>> getUser(String userId) async {
    return await _apiClient.get(
      '/api/users/$userId',
      fromJson: (json) => ApiResponse<User>.fromJson(
        json,
        (data) => User.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  // 获取当前用户信息（模拟方法，实际应该从token中获取用户ID）
  Future<ApiResponse<User>> getCurrentUser() async {
    // 临时使用固定的用户ID，实际应用中应该从认证token中获取
    const mockUserId = 'user_123';
    return await getUser(mockUserId);
  }
}

// 单例实例
final userService = UserService();