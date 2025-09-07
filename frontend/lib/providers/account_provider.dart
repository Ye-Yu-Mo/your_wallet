import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../services/local_storage_service.dart';

class AccountProvider with ChangeNotifier {
  List<Account> _accounts = [];
  Account? _selectedAccount;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Account> get accounts => _accounts;
  Account? get selectedAccount => _selectedAccount;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // 获取总资产
  double get totalAssets {
    return _accounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  // 获取活跃账户数量
  int get activeAccountsCount {
    return _accounts.where((account) => account.isActive).length;
  }

  // 按类型分组的账户
  Map<AccountType, List<Account>> get accountsByType {
    final Map<AccountType, List<Account>> grouped = {};
    for (var account in _accounts) {
      if (!grouped.containsKey(account.accountType)) {
        grouped[account.accountType] = [];
      }
      grouped[account.accountType]!.add(account);
    }
    return grouped;
  }

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

  // 获取账户列表（支持缓存）
  Future<void> fetchAccounts({bool useCache = true}) async {
    _setLoading(true);
    clearError();

    try {
      // 如果启用缓存且缓存未过期，先加载缓存数据
      if (useCache && !localStorageService.isCacheExpired()) {
        final cachedAccounts = await localStorageService.getCachedAccounts();
        if (cachedAccounts.isNotEmpty) {
          _accounts = cachedAccounts;
          notifyListeners();
          debugPrint('📱 Loaded ${_accounts.length} accounts from cache');
        }
      }

      // 尝试从API获取最新数据
      try {
        final accounts = await accountService.getAllAccounts();
        _accounts = accounts;
        
        // 缓存最新数据
        await localStorageService.cacheAccounts(accounts);
        
        notifyListeners();
        debugPrint('✅ Loaded ${_accounts.length} accounts from API');
      } on ApiException catch (apiError) {
        // API调用失败，如果有缓存数据则使用缓存
        if (_accounts.isEmpty) {
          final cachedAccounts = await localStorageService.getCachedAccounts();
          if (cachedAccounts.isNotEmpty) {
            _accounts = cachedAccounts;
            notifyListeners();
            debugPrint('📱 Using cached accounts due to API error');
          } else {
            throw apiError; // 没有缓存数据，抛出API错误
          }
        }
        debugPrint('⚠️ API error, using cached data: ${apiError.message}');
      }
    } catch (e) {
      _setError('加载账户列表失败');
      debugPrint('❌ Error fetching accounts: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 获取特定账户
  Future<Account?> getAccount(String accountId) async {
    try {
      final response = await accountService.getAccount(accountId);
      
      if (response.success && response.data != null) {
        return response.data!;
      }
    } on ApiException catch (e) {
      _setError(e.message);
    }
    return null;
  }

  // 创建账户
  Future<bool> createAccount(CreateAccountRequest request) async {
    _setLoading(true);
    clearError();

    try {
      final response = await accountService.createAccount(request);
      
      if (response.success && response.data != null) {
        _accounts.add(response.data!);
        notifyListeners();
        debugPrint('✅ Account created: ${response.data!.name}');
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } on ApiException catch (e) {
      _setError(e.message);
      debugPrint('❌ Failed to create account: ${e.message}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 更新账户
  Future<bool> updateAccount(String accountId, CreateAccountRequest request) async {
    _setLoading(true);
    clearError();

    try {
      final response = await accountService.updateAccount(accountId, request);
      
      if (response.success && response.data != null) {
        final index = _accounts.indexWhere((account) => account.id == accountId);
        if (index != -1) {
          _accounts[index] = response.data!;
          notifyListeners();
          debugPrint('✅ Account updated: ${response.data!.name}');
          return true;
        }
      } else {
        _setError(response.message);
      }
    } on ApiException catch (e) {
      _setError(e.message);
      debugPrint('❌ Failed to update account: ${e.message}');
    } finally {
      _setLoading(false);
    }
    return false;
  }

  // 删除账户
  Future<bool> deleteAccount(String accountId) async {
    _setLoading(true);
    clearError();

    try {
      final response = await accountService.deleteAccount(accountId);
      
      if (response.success) {
        _accounts.removeWhere((account) => account.id == accountId);
        if (_selectedAccount?.id == accountId) {
          _selectedAccount = null;
        }
        notifyListeners();
        debugPrint('✅ Account deleted');
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } on ApiException catch (e) {
      _setError(e.message);
      debugPrint('❌ Failed to delete account: ${e.message}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 选择账户
  void selectAccount(Account? account) {
    if (_selectedAccount != account) {
      _selectedAccount = account;
      notifyListeners();
    }
  }

  // 根据ID查找账户
  Account? findAccountById(String accountId) {
    try {
      return _accounts.firstWhere((account) => account.id == accountId);
    } catch (e) {
      return null;
    }
  }

  // 按类型获取账户
  List<Account> getAccountsByType(AccountType type) {
    return _accounts.where((account) => account.accountType == type).toList();
  }

  // 获取活跃账户
  List<Account> get activeAccounts {
    return _accounts.where((account) => account.isActive).toList();
  }

  // 强制刷新（跳过缓存）
  Future<void> forceRefresh() async {
    await fetchAccounts(useCache: false);
  }

  // 清除缓存并刷新
  Future<void> clearCacheAndRefresh() async {
    await localStorageService.clearAccountsCache();
    await fetchAccounts(useCache: false);
  }

  // 获取缓存状态信息
  bool get hasCachedData {
    return localStorageService.getCacheStatus()['hasAccountsCache'] ?? false;
  }

  bool get isCacheExpired {
    return localStorageService.isCacheExpired();
  }

  DateTime? get lastSyncTime {
    return localStorageService.getLastSyncTime();
  }
}