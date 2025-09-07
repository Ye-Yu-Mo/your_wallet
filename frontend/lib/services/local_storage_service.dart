import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class LocalStorageService {
  static const String _accountsKey = 'cached_accounts';
  static const String _transactionsKey = 'cached_transactions';
  static const String _summaryKey = 'cached_summary';
  static const String _categoriesKey = 'cached_categories';
  static const String _lastSyncTimeKey = 'last_sync_time';

  late SharedPreferences _prefs;
  
  // 初始化本地存储
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 缓存账户数据
  Future<void> cacheAccounts(List<Account> accounts) async {
    final accountsJson = accounts.map((account) => account.toJson()).toList();
    await _prefs.setString(_accountsKey, jsonEncode(accountsJson));
    await _updateLastSyncTime();
  }

  // 获取缓存的账户数据
  Future<List<Account>> getCachedAccounts() async {
    final accountsString = _prefs.getString(_accountsKey);
    if (accountsString == null) return [];
    
    try {
      final List<dynamic> accountsJson = jsonDecode(accountsString);
      return accountsJson
          .map((json) => Account.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error parsing cached accounts: $e');
      return [];
    }
  }

  // 缓存交易数据
  Future<void> cacheTransactions(List<Transaction> transactions) async {
    final transactionsJson = transactions.map((transaction) => transaction.toJson()).toList();
    await _prefs.setString(_transactionsKey, jsonEncode(transactionsJson));
    await _updateLastSyncTime();
  }

  // 获取缓存的交易数据
  Future<List<Transaction>> getCachedTransactions() async {
    final transactionsString = _prefs.getString(_transactionsKey);
    if (transactionsString == null) return [];
    
    try {
      final List<dynamic> transactionsJson = jsonDecode(transactionsString);
      return transactionsJson
          .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error parsing cached transactions: $e');
      return [];
    }
  }

  // 缓存财务概览数据
  Future<void> cacheFinancialSummary(FinancialSummary summary) async {
    await _prefs.setString(_summaryKey, jsonEncode(summary.toJson()));
    await _updateLastSyncTime();
  }

  // 获取缓存的财务概览数据
  Future<FinancialSummary?> getCachedFinancialSummary() async {
    final summaryString = _prefs.getString(_summaryKey);
    if (summaryString == null) return null;
    
    try {
      final Map<String, dynamic> summaryJson = jsonDecode(summaryString);
      return FinancialSummary.fromJson(summaryJson);
    } catch (e) {
      print('❌ Error parsing cached financial summary: $e');
      return null;
    }
  }

  // 缓存分类数据
  Future<void> cacheCategories(List<Map<String, dynamic>> categories) async {
    await _prefs.setString(_categoriesKey, jsonEncode(categories));
    await _updateLastSyncTime();
  }

  // 获取缓存的分类数据
  Future<List<Map<String, dynamic>>> getCachedCategories() async {
    final categoriesString = _prefs.getString(_categoriesKey);
    if (categoriesString == null) return [];
    
    try {
      final List<dynamic> categoriesJson = jsonDecode(categoriesString);
      return categoriesJson.cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ Error parsing cached categories: $e');
      return [];
    }
  }

  // 更新最后同步时间
  Future<void> _updateLastSyncTime() async {
    await _prefs.setInt(_lastSyncTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  // 获取最后同步时间
  DateTime? getLastSyncTime() {
    final timestamp = _prefs.getInt(_lastSyncTimeKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  // 检查缓存是否过期（默认1小时）
  bool isCacheExpired({Duration maxAge = const Duration(hours: 1)}) {
    final lastSync = getLastSyncTime();
    if (lastSync == null) return true;
    return DateTime.now().difference(lastSync) > maxAge;
  }

  // 清除所有缓存
  Future<void> clearAllCache() async {
    await _prefs.remove(_accountsKey);
    await _prefs.remove(_transactionsKey);
    await _prefs.remove(_summaryKey);
    await _prefs.remove(_categoriesKey);
    await _prefs.remove(_lastSyncTimeKey);
  }

  // 清除特定缓存
  Future<void> clearAccountsCache() async {
    await _prefs.remove(_accountsKey);
  }

  Future<void> clearTransactionsCache() async {
    await _prefs.remove(_transactionsKey);
  }

  Future<void> clearSummaryCache() async {
    await _prefs.remove(_summaryKey);
  }

  Future<void> clearCategoriesCache() async {
    await _prefs.remove(_categoriesKey);
  }

  // 获取缓存状态信息
  Map<String, dynamic> getCacheStatus() {
    final lastSync = getLastSyncTime();
    return {
      'hasAccountsCache': _prefs.containsKey(_accountsKey),
      'hasTransactionsCache': _prefs.containsKey(_transactionsKey),
      'hasSummaryCache': _prefs.containsKey(_summaryKey),
      'hasCategoriesCache': _prefs.containsKey(_categoriesKey),
      'lastSyncTime': lastSync?.toIso8601String(),
      'isCacheExpired': isCacheExpired(),
    };
  }
}

// 全局单例实例
final localStorageService = LocalStorageService();