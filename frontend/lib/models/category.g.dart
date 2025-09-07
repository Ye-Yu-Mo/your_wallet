// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  id: json['id'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String,
  color: json['color'] as String,
  transactionType: $enumDecode(
    _$TransactionTypeEnumMap,
    json['transaction_type'],
  ),
  isSystem: json['is_system'] as bool,
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'color': instance.color,
  'transaction_type': _$TransactionTypeEnumMap[instance.transactionType]!,
  'is_system': instance.isSystem,
};

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'Income',
  TransactionType.expense: 'Expense',
  TransactionType.transfer: 'Transfer',
  TransactionType.investment: 'Investment',
};
