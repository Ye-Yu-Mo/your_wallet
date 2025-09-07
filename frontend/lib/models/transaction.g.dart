// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  accountId: json['account_id'] as String,
  categoryId: json['category_id'] as String?,
  transactionType: $enumDecode(
    _$TransactionTypeEnumMap,
    json['transaction_type'],
  ),
  amount: _stringToDouble(json['amount']),
  currency: json['currency'] as String,
  description: json['description'] as String,
  notes: json['notes'] as String?,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  transactionDate: DateTime.parse(json['transaction_date'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'account_id': instance.accountId,
      'category_id': instance.categoryId,
      'transaction_type': _$TransactionTypeEnumMap[instance.transactionType]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'description': instance.description,
      'notes': instance.notes,
      'tags': instance.tags,
      'transaction_date': instance.transactionDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'Income',
  TransactionType.expense: 'Expense',
  TransactionType.transfer: 'Transfer',
  TransactionType.investment: 'Investment',
};

CreateTransactionRequest _$CreateTransactionRequestFromJson(
  Map<String, dynamic> json,
) => CreateTransactionRequest(
  accountId: json['account_id'] as String,
  categoryId: json['category_id'] as String?,
  transactionType: $enumDecode(
    _$TransactionTypeEnumMap,
    json['transaction_type'],
  ),
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String,
  notes: json['notes'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  transactionDate: json['transaction_date'] == null
      ? null
      : DateTime.parse(json['transaction_date'] as String),
);

Map<String, dynamic> _$CreateTransactionRequestToJson(
  CreateTransactionRequest instance,
) => <String, dynamic>{
  'account_id': instance.accountId,
  'category_id': instance.categoryId,
  'transaction_type': _$TransactionTypeEnumMap[instance.transactionType]!,
  'amount': instance.amount,
  'description': instance.description,
  'notes': instance.notes,
  'tags': instance.tags,
  'transaction_date': instance.transactionDate?.toIso8601String(),
};

UpdateTransactionRequest _$UpdateTransactionRequestFromJson(
  Map<String, dynamic> json,
) => UpdateTransactionRequest(
  accountId: json['account_id'] as String?,
  categoryId: json['category_id'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  transactionDate: json['transaction_date'] == null
      ? null
      : DateTime.parse(json['transaction_date'] as String),
);

Map<String, dynamic> _$UpdateTransactionRequestToJson(
  UpdateTransactionRequest instance,
) => <String, dynamic>{
  'account_id': instance.accountId,
  'category_id': instance.categoryId,
  'amount': instance.amount,
  'description': instance.description,
  'notes': instance.notes,
  'tags': instance.tags,
  'transaction_date': instance.transactionDate?.toIso8601String(),
};
