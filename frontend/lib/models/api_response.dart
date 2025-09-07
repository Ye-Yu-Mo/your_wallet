import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

// Helper function to convert string to double
double _stringToDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final DateTime timestamp;

  const ApiResponse({
    required this.success,
    this.data,
    required this.message,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  // 工厂方法：成功响应
  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message ?? 'Success',
      timestamp: DateTime.now(),
    );
  }

  // 工厂方法：错误响应
  factory ApiResponse.error(String message) {
    return ApiResponse<T>(
      success: false,
      data: null,
      message: message,
      timestamp: DateTime.now(),
    );
  }
}

@JsonSerializable()
class PaginationQuery {
  final int? page;
  final int? limit;

  const PaginationQuery({
    this.page,
    this.limit,
  });

  factory PaginationQuery.fromJson(Map<String, dynamic> json) =>
      _$PaginationQueryFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationQueryToJson(this);

  // 默认分页参数
  static const PaginationQuery defaultQuery = PaginationQuery(
    page: 1,
    limit: 20,
  );
}

@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  final List<T> data;
  final int page;
  final int limit;
  final int total;
  @JsonKey(name: 'has_next')
  final bool hasNext;

  const PaginatedResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);

  // 辅助方法：计算总页数
  int get totalPages => (total / limit).ceil();

  // 辅助方法：是否有上一页
  bool get hasPrevious => page > 1;

  // 辅助方法：获取当前数据范围描述
  String get rangeDescription {
    final start = (page - 1) * limit + 1;
    final end = (start + data.length - 1).clamp(0, total);
    return '$start-$end / $total';
  }
}

@JsonSerializable()
class FinancialSummary {
  @JsonKey(name: 'total_income', fromJson: _stringToDouble)
  final double totalIncome;
  @JsonKey(name: 'total_expense', fromJson: _stringToDouble)
  final double totalExpense;
  @JsonKey(name: 'net_income', fromJson: _stringToDouble)
  final double netIncome;
  @JsonKey(name: 'account_balances')
  final List<AccountBalance> accountBalances;

  const FinancialSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netIncome,
    required this.accountBalances,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) =>
      _$FinancialSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$FinancialSummaryToJson(this);

  // 辅助方法：计算总资产
  double get totalAssets => accountBalances
      .fold(0.0, (sum, balance) => sum + balance.balance);

  // 辅助方法：获取格式化的净收入
  String get formattedNetIncome {
    final prefix = netIncome >= 0 ? '+' : '';
    return '$prefix¥${netIncome.toStringAsFixed(2)}';
  }
}

@JsonSerializable()
class AccountBalance {
  @JsonKey(name: 'account_id')
  final String accountId;
  @JsonKey(name: 'account_name')
  final String accountName;
  @JsonKey(fromJson: _stringToDouble)
  final double balance;
  final String currency;

  const AccountBalance({
    required this.accountId,
    required this.accountName,
    required this.balance,
    required this.currency,
  });

  factory AccountBalance.fromJson(Map<String, dynamic> json) =>
      _$AccountBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$AccountBalanceToJson(this);

  // 辅助方法：获取格式化的余额
  String get formattedBalance => '$currency ${balance.toStringAsFixed(2)}';
}