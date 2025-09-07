import '../models/models.dart';
import 'api_client.dart';

class TransactionService {
  final ApiClient _apiClient = ApiClient();

  // 获取交易列表（支持分页）
  Future<ApiResponse<PaginatedResponse<Transaction>>> getTransactions({
    PaginationQuery? pagination,
  }) async {
    final queryParams = pagination?.toJson() ?? PaginationQuery.defaultQuery.toJson();
    
    return await _apiClient.get(
      '/api/transactions',
      queryParameters: queryParams,
      fromJson: (json) => ApiResponse<PaginatedResponse<Transaction>>.fromJson(
        json,
        (data) => PaginatedResponse<Transaction>.fromJson(
          data as Map<String, dynamic>,
          (item) => Transaction.fromJson(item as Map<String, dynamic>),
        ),
      ),
    );
  }

  // 获取特定交易
  Future<ApiResponse<Transaction>> getTransaction(String transactionId) async {
    return await _apiClient.get(
      '/api/transactions/$transactionId',
      fromJson: (json) => ApiResponse<Transaction>.fromJson(
        json,
        (data) => Transaction.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  // 创建交易
  Future<ApiResponse<Transaction>> createTransaction(CreateTransactionRequest request) async {
    return await _apiClient.post(
      '/api/transactions',
      data: request.toJson(),
      fromJson: (json) => ApiResponse<Transaction>.fromJson(
        json,
        (data) => Transaction.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  // 更新交易
  Future<ApiResponse<Transaction>> updateTransaction(
    String transactionId,
    UpdateTransactionRequest request,
  ) async {
    return await _apiClient.put(
      '/api/transactions/$transactionId',
      data: request.toJson(),
      fromJson: (json) => ApiResponse<Transaction>.fromJson(
        json,
        (data) => Transaction.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  // 删除交易
  Future<ApiResponse<void>> deleteTransaction(String transactionId) async {
    return await _apiClient.delete(
      '/api/transactions/$transactionId',
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

  // 获取用户的所有交易（不分页）
  Future<List<Transaction>> getAllTransactions() async {
    try {
      final response = await getTransactions(
        pagination: const PaginationQuery(page: 1, limit: 1000),
      );
      
      if (response.success && response.data != null) {
        return response.data!.data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 根据类型筛选交易
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    final allTransactions = await getAllTransactions();
    return allTransactions.where((t) => t.transactionType == type).toList();
  }

  // 根据日期范围获取交易
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allTransactions = await getAllTransactions();
    return allTransactions.where((t) {
      return t.transactionDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
             t.transactionDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
}

// 单例实例
final transactionService = TransactionService();