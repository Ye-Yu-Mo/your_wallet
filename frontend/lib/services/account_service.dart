import '../models/models.dart';
import 'api_client.dart';

class AccountService {
  final ApiClient _apiClient = ApiClient();

  // 获取账户列表
  Future<ApiResponse<PaginatedResponse<Account>>> getAccounts() async {
    return await _apiClient.get(
      '/api/accounts',
      fromJson: (json) => ApiResponse<PaginatedResponse<Account>>.fromJson(
        json,
        (data) => PaginatedResponse<Account>.fromJson(
          data as Map<String, dynamic>,
          (item) => Account.fromJson(item as Map<String, dynamic>),
        ),
      ),
    );
  }

  // 获取所有账户（简化版）
  Future<List<Account>> getAllAccounts() async {
    try {
      final response = await getAccounts();
      if (response.success && response.data != null) {
        return response.data!.data;
      }
      return [];
    } catch (e) {
      print('❌ Error parsing accounts: $e');
      return [];
    }
  }

  // 获取特定账户
  Future<ApiResponse<Account>> getAccount(String accountId) async {
    return await _apiClient.get(
      '/api/accounts/$accountId',
      fromJson: (json) => ApiResponse<Account>.fromJson(
        json,
        (data) => Account.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  // 创建账户
  Future<ApiResponse<Account>> createAccount(CreateAccountRequest request) async {
    return await _apiClient.post(
      '/api/accounts',
      data: request.toJson(),
      fromJson: (json) => ApiResponse<Account>.fromJson(
        json,
        (data) => Account.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  // 更新账户
  Future<ApiResponse<Account>> updateAccount(
    String accountId,
    CreateAccountRequest request,
  ) async {
    return await _apiClient.put(
      '/api/accounts/$accountId',
      data: request.toJson(),
      fromJson: (json) => ApiResponse<Account>.fromJson(
        json,
        (data) => Account.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  // 删除账户
  Future<ApiResponse<void>> deleteAccount(String accountId) async {
    return await _apiClient.delete(
      '/api/accounts/$accountId',
      fromJson: (json) {
        final response = json as Map<String, dynamic>;
        return ApiResponse<void>(
          success: response['success'] as bool,
          data: null,
          message: response['message'] as String,
          timestamp: DateTime.parse(response['timestamp'] as String),
        );
      },
    );
  }
}

// 单例实例
final accountService = AccountService();