import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../services/local_storage_service.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  Transaction? _selectedTransaction;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Transaction> get transactions => _transactions;
  Transaction? get selectedTransaction => _selectedTransaction;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // 按类型筛选交易
  List<Transaction> getTransactionsByType(TransactionType type) {
    return _transactions.where((t) => t.transactionType == type).toList();
  }

  // 按日期范围筛选交易
  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) {
      return t.transactionDate.isAfter(start.subtract(const Duration(days: 1))) &&
             t.transactionDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // 计算总收入
  double get totalIncome {
    return _transactions
        .where((t) => t.transactionType == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // 计算总支出
  double get totalExpense {
    return _transactions
        .where((t) => t.transactionType == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // 计算净收入
  double get netIncome => totalIncome - totalExpense;

  // 设置加载状态
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  // 设置错误信息
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // 清除错误信息
  void clearError() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }

  // 获取交易列表（支持缓存）
  Future<void> fetchTransactions({bool useCache = true}) async {
    _setLoading(true);
    clearError();

    try {
      // 如果启用缓存且缓存未过期，先加载缓存数据
      if (useCache && !localStorageService.isCacheExpired()) {
        final cachedTransactions = await localStorageService.getCachedTransactions();
        if (cachedTransactions.isNotEmpty) {
          _transactions = cachedTransactions;
          notifyListeners();
          debugPrint('📱 Loaded ${_transactions.length} transactions from cache');
        }
      }

      // 尝试从API获取最新数据
      try {
        final transactions = await transactionService.getAllTransactions();
        _transactions = transactions;
        
        // 缓存最新数据
        await localStorageService.cacheTransactions(_transactions);
        
        notifyListeners();
        debugPrint('✅ Loaded ${_transactions.length} transactions from API');
      } on ApiException catch (apiError) {
        // API调用失败，如果有缓存数据则使用缓存
        if (_transactions.isEmpty) {
          final cachedTransactions = await localStorageService.getCachedTransactions();
          if (cachedTransactions.isNotEmpty) {
            _transactions = cachedTransactions;
            notifyListeners();
            debugPrint('📱 Using cached transactions due to API error');
          } else {
            throw apiError; // 没有缓存数据，抛出API错误
          }
        }
        debugPrint('⚠️ API error, using cached data: ${apiError.message}');
      }
    } catch (e) {
      _setError('加载交易记录失败');
      debugPrint('❌ Error fetching transactions: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 创建新交易
  Future<bool> createTransaction(CreateTransactionRequest request) async {
    _setLoading(true);
    clearError();

    try {
      final response = await transactionService.createTransaction(request);
      
      if (response.success && response.data != null) {
        _transactions.insert(0, response.data!); // 添加到列表顶部
        
        // 更新缓存
        await localStorageService.cacheTransactions(_transactions);
        
        notifyListeners();
        debugPrint('✅ Transaction created: ${response.data!.description}');
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } on ApiException catch (e) {
      _setError(e.message);
      debugPrint('❌ Failed to create transaction: ${e.message}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 更新交易
  Future<bool> updateTransaction(String transactionId, UpdateTransactionRequest request) async {
    _setLoading(true);
    clearError();

    try {
      final response = await transactionService.updateTransaction(transactionId, request);
      
      if (response.success && response.data != null) {
        final index = _transactions.indexWhere((t) => t.id == transactionId);
        if (index != -1) {
          _transactions[index] = response.data!;
          
          // 更新缓存
          await localStorageService.cacheTransactions(_transactions);
          
          notifyListeners();
          debugPrint('✅ Transaction updated: ${response.data!.description}');
          return true;
        }
      } else {
        _setError(response.message);
      }
    } on ApiException catch (e) {
      _setError(e.message);
      debugPrint('❌ Failed to update transaction: ${e.message}');
    } finally {
      _setLoading(false);
    }
    return false;
  }

  // 删除交易
  Future<bool> deleteTransaction(String transactionId) async {
    _setLoading(true);
    clearError();

    try {
      final response = await transactionService.deleteTransaction(transactionId);
      
      if (response.success) {
        _transactions.removeWhere((t) => t.id == transactionId);
        if (_selectedTransaction?.id == transactionId) {
          _selectedTransaction = null;
        }
        
        // 更新缓存
        await localStorageService.cacheTransactions(_transactions);
        
        notifyListeners();
        debugPrint('✅ Transaction deleted');
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } on ApiException catch (e) {
      _setError(e.message);
      debugPrint('❌ Failed to delete transaction: ${e.message}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 选择交易
  void selectTransaction(Transaction? transaction) {
    if (_selectedTransaction != transaction) {
      _selectedTransaction = transaction;
      notifyListeners();
    }
  }

  // 根据ID查找交易
  Transaction? findTransactionById(String transactionId) {
    try {
      return _transactions.firstWhere((t) => t.id == transactionId);
    } catch (e) {
      return null;
    }
  }

  // 强制刷新（跳过缓存）
  Future<void> forceRefresh() async {
    await fetchTransactions(useCache: false);
  }

  // 清除缓存并刷新
  Future<void> clearCacheAndRefresh() async {
    await localStorageService.clearTransactionsCache();
    await fetchTransactions(useCache: false);
  }

  // 获取缓存状态信息
  bool get hasCachedData {
    return localStorageService.getCacheStatus()['hasTransactionsCache'] ?? false;
  }

  bool get isCacheExpired {
    return localStorageService.isCacheExpired();
  }

  DateTime? get lastSyncTime {
    return localStorageService.getLastSyncTime();
  }
}