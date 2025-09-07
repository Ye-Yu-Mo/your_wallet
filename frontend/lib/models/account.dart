import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

// Helper function to convert string to double
double _stringToDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

enum AccountType {
  @JsonValue('Cash')
  cash,
  @JsonValue('BankCard')
  bankCard,
  @JsonValue('CreditCard')
  creditCard,
  @JsonValue('Investment')
  investment,
  @JsonValue('Crypto')
  crypto,
}

@JsonSerializable()
class Account {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  @JsonKey(name: 'account_type')
  final AccountType accountType;
  final String currency;
  @JsonKey(fromJson: _stringToDouble)
  final double balance;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.accountType,
    required this.currency,
    required this.balance,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  // 辅助方法：获取账户类型的显示名称
  String get accountTypeDisplayName {
    switch (accountType) {
      case AccountType.cash:
        return '现金';
      case AccountType.bankCard:
        return '银行卡';
      case AccountType.creditCard:
        return '信用卡';
      case AccountType.investment:
        return '投资账户';
      case AccountType.crypto:
        return '加密货币';
    }
  }

  // 辅助方法：获取格式化的余额
  String get formattedBalance {
    return '$currency ${balance.toStringAsFixed(2)}';
  }
}

@JsonSerializable()
class CreateAccountRequest {
  final String name;
  @JsonKey(name: 'account_type')
  final AccountType accountType;
  final String currency;
  @JsonKey(name: 'initial_balance')
  final double? initialBalance;

  const CreateAccountRequest({
    required this.name,
    required this.accountType,
    required this.currency,
    this.initialBalance,
  });

  factory CreateAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateAccountRequestToJson(this);
}