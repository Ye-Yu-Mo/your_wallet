import 'package:json_annotation/json_annotation.dart';
import 'transaction.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final String id;
  final String name;
  final String icon;
  final String color;
  @JsonKey(name: 'transaction_type')
  final TransactionType transactionType;
  @JsonKey(name: 'is_system')
  final bool isSystem;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.transactionType,
    required this.isSystem,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

// 预定义的分类数据
class CategoryData {
  static const List<Category> defaultIncomeCategories = [
    Category(
      id: 'income_salary',
      name: '工资收入',
      icon: 'work',
      color: '#4CAF50',
      transactionType: TransactionType.income,
      isSystem: true,
    ),
    Category(
      id: 'income_bonus',
      name: '奖金',
      icon: 'card_giftcard',
      color: '#4CAF50',
      transactionType: TransactionType.income,
      isSystem: true,
    ),
    Category(
      id: 'income_investment',
      name: '投资收益',
      icon: 'trending_up',
      color: '#4CAF50',
      transactionType: TransactionType.income,
      isSystem: true,
    ),
    Category(
      id: 'income_other',
      name: '其他收入',
      icon: 'attach_money',
      color: '#4CAF50',
      transactionType: TransactionType.income,
      isSystem: true,
    ),
  ];

  static const List<Category> defaultExpenseCategories = [
    Category(
      id: 'expense_food',
      name: '餐饮',
      icon: 'restaurant',
      color: '#FF5722',
      transactionType: TransactionType.expense,
      isSystem: true,
    ),
    Category(
      id: 'expense_transport',
      name: '交通',
      icon: 'directions_bus',
      color: '#FF5722',
      transactionType: TransactionType.expense,
      isSystem: true,
    ),
    Category(
      id: 'expense_shopping',
      name: '购物',
      icon: 'shopping_cart',
      color: '#FF5722',
      transactionType: TransactionType.expense,
      isSystem: true,
    ),
    Category(
      id: 'expense_entertainment',
      name: '娱乐',
      icon: 'movie',
      color: '#FF5722',
      transactionType: TransactionType.expense,
      isSystem: true,
    ),
    Category(
      id: 'expense_health',
      name: '医疗',
      icon: 'local_hospital',
      color: '#FF5722',
      transactionType: TransactionType.expense,
      isSystem: true,
    ),
    Category(
      id: 'expense_education',
      name: '教育',
      icon: 'school',
      color: '#FF5722',
      transactionType: TransactionType.expense,
      isSystem: true,
    ),
    Category(
      id: 'expense_utilities',
      name: '生活缴费',
      icon: 'receipt',
      color: '#FF5722',
      transactionType: TransactionType.expense,
      isSystem: true,
    ),
    Category(
      id: 'expense_other',
      name: '其他支出',
      icon: 'more_horiz',
      color: '#FF5722',
      transactionType: TransactionType.expense,
      isSystem: true,
    ),
  ];

  static List<Category> get allDefaultCategories => [
    ...defaultIncomeCategories,
    ...defaultExpenseCategories,
  ];

  static Category? getCategoryById(String id) {
    try {
      return allDefaultCategories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Category> getCategoriesByType(TransactionType type) {
    return allDefaultCategories
        .where((category) => category.transactionType == type)
        .toList();
  }
}