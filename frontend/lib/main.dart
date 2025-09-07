import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';
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
  
  // 临时页面，后续会替换为真正的页面
  final List<Widget> _pages = [
    const DashboardPage(),
    const ApiTestScreen(),
    const PlaceholderPage(title: '投资组合'),
    const PlaceholderPage(title: '设置'),
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
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: '总览',
          ),
          NavigationDestination(
            icon: Icon(Icons.api_outlined),
            selectedIcon: Icon(Icons.api),
            label: 'API测试',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: '投资',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

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
      body: Consumer2<AppProvider, AccountProvider>(
        builder: (context, appProvider, accountProvider, child) {
          if (appProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在初始化应用...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 连接状态卡片
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              appProvider.isOnline ? Icons.check_circle : Icons.error,
                              color: appProvider.isOnline ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '后端服务状态',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appProvider.isOnline ? '✅ 已连接到后端API服务' : '❌ 无法连接到后端服务',
                          style: TextStyle(
                            color: appProvider.isOnline ? Colors.green : Colors.red,
                          ),
                        ),
                        if (appProvider.errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            '错误信息: ${appProvider.errorMessage}',
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 快速操作区域
                Text(
                  '快速操作',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: InkWell(
                          onTap: () async {
                            await accountProvider.fetchAccounts();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    accountProvider.errorMessage.isNotEmpty 
                                      ? '加载失败: ${accountProvider.errorMessage}'
                                      : '成功加载 ${accountProvider.accounts.length} 个账户',
                                  ),
                                  backgroundColor: accountProvider.errorMessage.isNotEmpty 
                                    ? Colors.red 
                                    : Colors.green,
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                if (accountProvider.isLoading)
                                  const CircularProgressIndicator()
                                else
                                  const Icon(Icons.account_balance_wallet, size: 32),
                                const SizedBox(height: 8),
                                const Text('加载账户'),
                                Text(
                                  '${accountProvider.accounts.length} 个账户',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ApiTestScreen(),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(Icons.api, size: 32),
                                SizedBox(height: 8),
                                Text('API测试'),
                                Text(
                                  '测试所有端点',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 账户信息展示
                if (accountProvider.accounts.isNotEmpty) ...[
                  Text(
                    '我的账户',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...accountProvider.accounts.map((account) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          _getAccountIcon(account.accountType),
                          color: Colors.white,
                        ),
                      ),
                      title: Text(account.name),
                      subtitle: Text(account.accountTypeDisplayName),
                      trailing: Text(
                        account.formattedBalance,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )).toList(),
                ],

                const SizedBox(height: 32),
                
                // 版本信息
                Center(
                  child: Text(
                    'YourWallet v0.1.0 - API集成测试版',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getAccountIcon(dynamic accountType) {
    // 临时处理，因为枚举可能解析问题
    final typeStr = accountType.toString();
    if (typeStr.contains('cash')) return Icons.money;
    if (typeStr.contains('bank')) return Icons.account_balance;
    if (typeStr.contains('credit')) return Icons.credit_card;
    if (typeStr.contains('investment')) return Icons.trending_up;
    if (typeStr.contains('crypto')) return Icons.currency_bitcoin;
    return Icons.account_balance_wallet;
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title 功能开发中',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('敬请期待更多功能！'),
          ],
        ),
      ),
    );
  }
}