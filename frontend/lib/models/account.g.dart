// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  accountType: $enumDecode(_$AccountTypeEnumMap, json['account_type']),
  currency: json['currency'] as String,
  balance: _stringToDouble(json['balance']),
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'account_type': _$AccountTypeEnumMap[instance.accountType]!,
  'currency': instance.currency,
  'balance': instance.balance,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$AccountTypeEnumMap = {
  AccountType.cash: 'Cash',
  AccountType.bankCard: 'BankCard',
  AccountType.creditCard: 'CreditCard',
  AccountType.investment: 'Investment',
  AccountType.crypto: 'Crypto',
};

CreateAccountRequest _$CreateAccountRequestFromJson(
  Map<String, dynamic> json,
) => CreateAccountRequest(
  name: json['name'] as String,
  accountType: $enumDecode(_$AccountTypeEnumMap, json['account_type']),
  currency: json['currency'] as String,
  initialBalance: (json['initial_balance'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CreateAccountRequestToJson(
  CreateAccountRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'account_type': _$AccountTypeEnumMap[instance.accountType]!,
  'currency': instance.currency,
  'initial_balance': instance.initialBalance,
};
