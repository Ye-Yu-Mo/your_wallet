// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  success: json['success'] as bool,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  message: json['message'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'message': instance.message,
  'timestamp': instance.timestamp.toIso8601String(),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

PaginationQuery _$PaginationQueryFromJson(Map<String, dynamic> json) =>
    PaginationQuery(
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationQueryToJson(PaginationQuery instance) =>
    <String, dynamic>{'page': instance.page, 'limit': instance.limit};

PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginatedResponse<T>(
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  hasNext: json['has_next'] as bool,
);

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'has_next': instance.hasNext,
};

FinancialSummary _$FinancialSummaryFromJson(Map<String, dynamic> json) =>
    FinancialSummary(
      totalIncome: _stringToDouble(json['total_income']),
      totalExpense: _stringToDouble(json['total_expense']),
      netIncome: _stringToDouble(json['net_income']),
      accountBalances: (json['account_balances'] as List<dynamic>)
          .map((e) => AccountBalance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FinancialSummaryToJson(FinancialSummary instance) =>
    <String, dynamic>{
      'total_income': instance.totalIncome,
      'total_expense': instance.totalExpense,
      'net_income': instance.netIncome,
      'account_balances': instance.accountBalances,
    };

AccountBalance _$AccountBalanceFromJson(Map<String, dynamic> json) =>
    AccountBalance(
      accountId: json['account_id'] as String,
      accountName: json['account_name'] as String,
      balance: _stringToDouble(json['balance']),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$AccountBalanceToJson(AccountBalance instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'account_name': instance.accountName,
      'balance': instance.balance,
      'currency': instance.currency,
    };
