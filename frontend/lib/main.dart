import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';
import 'models/models.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/api_test_screen.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化本地存储服务
  await localStorageService.initialize();
  
  runApp(const YourWalletApp());
}

class YourWalletApp extends StatelessWidget {
  const YourWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'YourWallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  // 重新组织页面：以记账为主导的功能布局
  final List<Widget> _pages = [
    const AccountingHomePage(), // 记账主页（新的主页）
    const TransactionListScreen(), // 交易列表
    const StatisticsPage(), // 统计报表
    const SettingsPage(), // 设置页面
  ];

  @override
  void initState() {
    super.initState();
    // 初始化应用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: '记录',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: '统计',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
      // 浮动添加按钮：快速添加交易记录
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1 
        ? FloatingActionButton.extended(
            onPressed: () => _showAddTransactionDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('记一笔'),
            tooltip: '添加交易记录',
          )
        : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
  }
}

// 新的记账主页 - 以记账功能为中心
class AccountingHomePage extends StatelessWidget {
  const AccountingHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YourWallet'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return IconButton(
                onPressed: () => appProvider.checkConnection(),
                icon: Icon(
                  appProvider.isOnline ? Icons.cloud_done : Icons.cloud_off,
                  color: appProvider.isOnline ? Colors.green : Colors.red,
                ),
                tooltip: appProvider.isOnline ? '已连接' : '连接失败',
              );
            },
          ),
        ],
      ),
      body: Consumer3<AppProvider, AccountProvider, TransactionProvider>(
        builder: (context, appProvider, accountProvider, transactionProvider, child) {
          if (appProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在加载数据...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 财务概览卡片
                _buildFinancialOverviewCard(context, transactionProvider),
                
                // 快速记账操作
                _buildQuickActionsCard(context),
                
                // 最近交易记录
                _buildRecentTransactions(context, transactionProvider),
                
                // 账户余额概览
                _buildAccountSummary(context, accountProvider),
                
                // 底部间距
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFinancialOverviewCard(BuildContext context, TransactionProvider transactionProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '本月财务概览',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewItem(
                      context,
                      '收入',
                      '+¥${transactionProvider.totalIncome.toStringAsFixed(2)}',
                      Colors.green,
                      Icons.trending_up,
                    ),
                  ),
                  Expanded(
                    child: _buildOverviewItem(
                      context,
                      '支出', 
                      '-¥${transactionProvider.totalExpense.toStringAsFixed(2)}',
                      Colors.red,
                      Icons.trending_down,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      '净收入: ',
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    ),
                    Text(
                      '${transactionProvider.netIncome >= 0 ? '+' : ''}¥${transactionProvider.netIncome.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewItem(BuildContext context, String title, String amount, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '快速记账',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      '收入',
                      Icons.add_circle,
                      Colors.green,
                      () => _showAddTransactionDialog(context, TransactionType.income),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      '支出',
                      Icons.remove_circle,
                      Colors.red,
                      () => _showAddTransactionDialog(context, TransactionType.expense),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      '转账',
                      Icons.swap_horiz,
                      Colors.blue,
                      () => _showAddTransactionDialog(context, TransactionType.transfer),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, 
    String title, 
    IconData icon, 
    Color color, 
    VoidCallback onTap,
  ) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context, TransactionProvider transactionProvider) {
    final recentTransactions = transactionProvider.transactions.take(5).toList();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '最近记录',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 跳转到交易列表页面
                      DefaultTabController.of(context)?.animateTo(1);
                    },
                    child: const Text('查看全部'),
                  ),
                ],
              ),
              if (recentTransactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('还没有记录，开始记账吧！'),
                      ],
                    ),
                  ),
                )
              else
                ...recentTransactions.map((transaction) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: _getTransactionColor(transaction.transactionType).withOpacity(0.1),
                    child: Icon(
                      _getTransactionIcon(transaction.transactionType),
                      color: _getTransactionColor(transaction.transactionType),
                    ),
                  ),
                  title: Text(transaction.description),
                  subtitle: Text(_formatDate(transaction.transactionDate)),
                  trailing: Text(
                    '${transaction.transactionType == TransactionType.income ? '+' : '-'}¥${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: _getTransactionColor(transaction.transactionType),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSummary(BuildContext context, AccountProvider accountProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '账户概览',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (accountProvider.accounts.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('暂无账户信息'),
                  ),
                )
              else
                ...accountProvider.accounts.take(3).map((account) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          _getAccountIcon(account.accountType),
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.name,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              account.accountTypeDisplayName,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        account.formattedBalance,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.transfer:
        return Colors.blue;
      case TransactionType.investment:
        return Colors.purple;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Icons.trending_up;
      case TransactionType.expense:
        return Icons.trending_down;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.investment:
        return Icons.show_chart;
    }
  }

  IconData _getAccountIcon(dynamic accountType) {
    final typeStr = accountType.toString();
    if (typeStr.contains('cash')) return Icons.money;
    if (typeStr.contains('bank')) return Icons.account_balance;
    if (typeStr.contains('credit')) return Icons.credit_card;
    if (typeStr.contains('investment')) return Icons.trending_up;
    if (typeStr.contains('crypto')) return Icons.currency_bitcoin;
    return Icons.account_balance_wallet;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(date.year, date.month, date.day);
    
    if (transactionDate == today) {
      return '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      return '昨天';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  void _showAddTransactionDialog(BuildContext context, [TransactionType? type]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(initialType: type),
      ),
    );
  }
}

// 统计页面占位符
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计报表'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ApiTestScreen(),
                ),
              );
            },
            icon: const Icon(Icons.api),
            tooltip: 'API测试',
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '数据可视化图表',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('功能开发中，敬请期待！'),
          ],
        ),
      ),
    );
  }
}

// 设置页面占位符
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '应用设置',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('功能开发中，敬请期待！'),
          ],
        ),
      ),
    );
  }
}