import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

// Helper function to convert string to double
double _stringToDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

enum TransactionType {
  @JsonValue('Income')
  income,
  @JsonValue('Expense')
  expense,
  @JsonValue('Transfer')
  transfer,
  @JsonValue('Investment')
  investment,
}

@JsonSerializable()
class Transaction {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'account_id')
  final String accountId;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @JsonKey(name: 'transaction_type')
  final TransactionType transactionType;
  @JsonKey(fromJson: _stringToDouble)
  final double amount;
  final String currency;
  final String description;
  final String? notes;
  final List<String> tags;
  @JsonKey(name: 'transaction_date')
  final DateTime transactionDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.userId,
    required this.accountId,
    this.categoryId,
    required this.transactionType,
    required this.amount,
    required this.currency,
    required this.description,
    this.notes,
    required this.tags,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  // 辅助方法：获取交易类型的显示名称
  String get transactionTypeDisplayName {
    switch (transactionType) {
      case TransactionType.income:
        return '收入';
      case TransactionType.expense:
        return '支出';
      case TransactionType.transfer:
        return '转账';
      case TransactionType.investment:
        return '投资';
    }
  }

  // 辅助方法：获取格式化的金额
  String get formattedAmount {
    String prefix = transactionType == TransactionType.income ? '+' : 
                   transactionType == TransactionType.expense ? '-' : '';
    return '$prefix$currency ${amount.toStringAsFixed(2)}';
  }

  // 辅助方法：获取交易类型的颜色
  String get transactionTypeColor {
    switch (transactionType) {
      case TransactionType.income:
        return '#4CAF50'; // 绿色
      case TransactionType.expense:
        return '#F44336'; // 红色
      case TransactionType.transfer:
        return '#2196F3'; // 蓝色
      case TransactionType.investment:
        return '#FF9800'; // 橙色
    }
  }
}

@JsonSerializable()
class CreateTransactionRequest {
  @JsonKey(name: 'account_id')
  final String accountId;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @JsonKey(name: 'transaction_type')
  final TransactionType transactionType;
  final double amount;
  final String description;
  final String? notes;
  final List<String>? tags;
  @JsonKey(name: 'transaction_date')
  final DateTime? transactionDate;

  const CreateTransactionRequest({
    required this.accountId,
    this.categoryId,
    required this.transactionType,
    required this.amount,
    required this.description,
    this.notes,
    this.tags,
    this.transactionDate,
  });

  factory CreateTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionRequestToJson(this);
}

@JsonSerializable()
class UpdateTransactionRequest {
  @JsonKey(name: 'account_id')
  final String? accountId;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  final double? amount;
  final String? description;
  final String? notes;
  final List<String>? tags;
  @JsonKey(name: 'transaction_date')
  final DateTime? transactionDate;

  const UpdateTransactionRequest({
    this.accountId,
    this.categoryId,
    this.amount,
    this.description,
    this.notes,
    this.tags,
    this.transactionDate,
  });

  factory UpdateTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTransactionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateTransactionRequestToJson(this);
}