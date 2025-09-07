import 'package:flutter/material.dart';

void main() {
  runApp(const YourWalletApp());
}

class YourWalletApp extends StatelessWidget {
  const YourWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const TransactionsPage(),
    const PortfolioPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: '总览',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: '交易',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart),
            selectedIcon: Icon(Icons.pie_chart),
            label: '投资组合',
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

// 临时页面组件
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('YourWallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 总资产卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '总资产',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Icon(
                          Icons.visibility_outlined,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '¥ 0.00',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '今日收益',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+¥ 0.00 (0%)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 快速操作按钮
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('记录买入'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.remove),
                        SizedBox(width: 8),
                        Text('记录卖出'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 持仓概览
            Text(
              '持仓概览',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 持仓列表
            Card(
              child: Column(
                children: [
                  _buildHoldingItem(
                    context,
                    'BTC',
                    'Bitcoin',
                    '0.00',
                    '¥ 0.00',
                    '0%',
                    Colors.orange,
                    true,
                  ),
                  const Divider(height: 1),
                  _buildHoldingItem(
                    context,
                    'ETH',
                    'Ethereum',
                    '0.00',
                    '¥ 0.00',
                    '0%',
                    Colors.blue,
                    false,
                  ),
                  const Divider(height: 1),
                  _buildHoldingItem(
                    context,
                    'USDT',
                    'Tether',
                    '0.00',
                    '¥ 0.00',
                    '0%',
                    Colors.green,
                    false,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 最近交易
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '最近交易',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('查看全部'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 交易列表
            Card(
              child: Column(
                children: [
                  _buildTransactionItem(
                    context,
                    '买入 BTC',
                    '0.001 BTC',
                    '¥ 200.00',
                    '2024-01-15 14:30',
                    true,
                  ),
                  const Divider(height: 1),
                  _buildTransactionItem(
                    context,
                    '卖出 ETH',
                    '0.1 ETH',
                    '¥ 150.00',
                    '2024-01-14 10:20',
                    false,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Center(
                      child: Text(
                        '暂无更多交易记录',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingItem(
    BuildContext context,
    String symbol,
    String name,
    String amount,
    String value,
    String change,
    Color iconColor,
    bool isPositive,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Text(
          symbol.substring(0, 1),
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            symbol,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
      subtitle: Text('$amount $symbol'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            change,
            style: TextStyle(
              fontSize: 12,
              color: isPositive ? Colors.green[600] : Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String title,
    String amount,
    String value,
    String time,
    bool isBuy,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isBuy 
            ? Colors.green[50] 
            : Colors.red[50],
        child: Icon(
          isBuy ? Icons.add : Icons.remove,
          color: isBuy ? Colors.green[600] : Colors.red[600],
        ),
      ),
      title: Text(title),
      subtitle: Text(time),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedFilter = '全部';
  final List<String> _filterOptions = ['全部', '买入', '卖出'];
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('交易记录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TransactionSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 筛选选项
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '筛选:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filterOptions.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            selectedColor: colorScheme.primaryContainer,
                            checkmarkColor: colorScheme.primary,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 交易列表
          Expanded(
            child: _buildTransactionsList(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTransactionDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('记录交易'),
      ),
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    final transactions = _getFilteredTransactions();
    
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swap_horiz_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无交易记录',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击右下角按钮添加第一笔交易',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
          child: _buildTransactionTile(context, transaction),
        );
      },
    );
  }

  Widget _buildTransactionTile(BuildContext context, Map<String, dynamic> transaction) {
    final bool isBuy = transaction['type'] == '买入';
    final colorScheme = Theme.of(context).colorScheme;
    
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: CircleAvatar(
        backgroundColor: isBuy ? Colors.green[50] : Colors.red[50],
        child: Icon(
          isBuy ? Icons.add : Icons.remove,
          color: isBuy ? Colors.green[600] : Colors.red[600],
        ),
      ),
      title: Row(
        children: [
          Text(
            '${transaction['type']} ${transaction['symbol']}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            transaction['amount'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isBuy ? Colors.green[600] : Colors.red[600],
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Text('单价: ${transaction['price']}'),
              const Spacer(),
              Text('总额: ${transaction['total']}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 12,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                transaction['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              if (transaction['note'] != null && transaction['note'].isNotEmpty)
                Text(
                  '备注: ${transaction['note']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
      onTap: () {
        _showTransactionDetails(context, transaction);
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredTransactions() {
    final allTransactions = [
      {
        'type': '买入',
        'symbol': 'BTC',
        'amount': '0.001 BTC',
        'price': '¥ 200,000',
        'total': '¥ 200.00',
        'time': '2024-01-15 14:30',
        'note': '定投',
      },
      {
        'type': '卖出',
        'symbol': 'ETH',
        'amount': '0.1 ETH',
        'price': '¥ 1,500',
        'total': '¥ 150.00',
        'time': '2024-01-14 10:20',
        'note': '',
      },
      {
        'type': '买入',
        'symbol': 'USDT',
        'amount': '100 USDT',
        'price': '¥ 7.2',
        'total': '¥ 720.00',
        'time': '2024-01-13 09:15',
        'note': '资金准备',
      },
      {
        'type': '买入',
        'symbol': 'BTC',
        'amount': '0.0005 BTC',
        'price': '¥ 198,000',
        'total': '¥ 99.00',
        'time': '2024-01-10 16:45',
        'note': '小额试水',
      },
    ];
    
    if (_selectedFilter == '全部') {
      return allTransactions;
    }
    
    return allTransactions.where((transaction) => 
      transaction['type'] == _selectedFilter
    ).toList();
  }

  void _showAddTransactionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddTransactionSheet(),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '交易详情',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('交易类型', transaction['type']),
            _buildDetailRow('币种', transaction['symbol']),
            _buildDetailRow('数量', transaction['amount']),
            _buildDetailRow('单价', transaction['price']),
            _buildDetailRow('总额', transaction['total']),
            _buildDetailRow('时间', transaction['time']),
            if (transaction['note'] != null && transaction['note'].isNotEmpty)
              _buildDetailRow('备注', transaction['note']),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('编辑'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('删除'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class TransactionSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text('搜索结果'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: Icon(Icons.history),
          title: Text('BTC'),
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('ETH'),
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('USDT'),
        ),
      ],
    );
  }
}

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  String _transactionType = '买入';
  String _selectedSymbol = 'BTC';
  
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();
  
  final List<String> _symbols = ['BTC', 'ETH', 'USDT', 'BNB', 'ADA', 'SOL'];

  @override
  void dispose() {
    _amountController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '记录交易',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 交易类型
            Row(
              children: [
                Text(
                  '交易类型',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 16),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: '买入',
                      label: Text('买入'),
                      icon: Icon(Icons.add_circle_outline),
                    ),
                    ButtonSegment(
                      value: '卖出',
                      label: Text('卖出'),
                      icon: Icon(Icons.remove_circle_outline),
                    ),
                  ],
                  selected: {_transactionType},
                  onSelectionChanged: (Set<String> selected) {
                    setState(() {
                      _transactionType = selected.first;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 币种选择
            DropdownButtonFormField<String>(
              value: _selectedSymbol,
              decoration: const InputDecoration(
                labelText: '选择币种',
                border: OutlineInputBorder(),
              ),
              items: _symbols.map((symbol) {
                return DropdownMenuItem(
                  value: symbol,
                  child: Text(symbol),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSymbol = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // 数量
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: '数量',
                border: const OutlineInputBorder(),
                suffixText: _selectedSymbol,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入数量';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // 单价
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: '单价',
                border: OutlineInputBorder(),
                prefixText: '¥ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入单价';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // 备注
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: '备注 (可选)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            
            const SizedBox(height: 24),
            
            // 按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('交易记录已保存')),
                        );
                      }
                    },
                    child: const Text('保存'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('投资组合'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 总览卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '投资总览',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildOverviewItem(
                            context,
                            '总投入',
                            '¥ 1,169.00',
                            Icons.input_outlined,
                            colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildOverviewItem(
                            context,
                            '当前价值',
                            '¥ 1,234.56',
                            Icons.account_balance_wallet_outlined,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildOverviewItem(
                            context,
                            '总收益',
                            '¥ +65.56',
                            Icons.trending_up,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildOverviewItem(
                            context,
                            '收益率',
                            '+5.61%',
                            Icons.percent,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 资产分布
            Text(
              '资产分布',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 饼状图区域
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pie_chart,
                              size: 64,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '资产分布图',
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '图表功能开发中',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 资产比例说明
                    Column(
                      children: [
                        _buildAssetLegend(context, 'BTC', '40.5%', Colors.orange),
                        _buildAssetLegend(context, 'ETH', '25.8%', Colors.blue),
                        _buildAssetLegend(context, 'USDT', '33.7%', Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 持仓详情
            Text(
              '持仓详情',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 持仓列表
            Card(
              child: Column(
                children: [
                  _buildHoldingDetailItem(
                    context,
                    'BTC',
                    'Bitcoin',
                    '0.0015 BTC',
                    '¥ 500.00',
                    '¥ 299.00',
                    '¥ +201.00',
                    '+67.2%',
                    Colors.orange,
                    true,
                  ),
                  const Divider(height: 1),
                  _buildHoldingDetailItem(
                    context,
                    'ETH',
                    'Ethereum',
                    '0.1 ETH',
                    '¥ 318.97',
                    '¥ 150.00',
                    '¥ +168.97',
                    '+112.6%',
                    Colors.blue,
                    true,
                  ),
                  const Divider(height: 1),
                  _buildHoldingDetailItem(
                    context,
                    'USDT',
                    'Tether',
                    '100 USDT',
                    '¥ 415.59',
                    '¥ 720.00',
                    '¥ -304.41',
                    '-42.3%',
                    Colors.green,
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: value.contains('+') ? Colors.green[600] : 
                     value.contains('-') ? Colors.red[600] :
                     Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetLegend(BuildContext context, String symbol, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            symbol,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            percentage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingDetailItem(
    BuildContext context,
    String symbol,
    String name,
    String amount,
    String currentValue,
    String cost,
    String profit,
    String profitPercent,
    Color iconColor,
    bool isProfit,
  ) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Text(
          symbol.substring(0, 1),
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            symbol,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
      subtitle: Text(amount),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            currentValue,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            profitPercent,
            style: TextStyle(
              fontSize: 12,
              color: isProfit ? Colors.green[600] : Colors.red[600],
            ),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '持仓成本',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    cost,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '当前价值',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    currentValue,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '浮动盈亏',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    profit,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isProfit ? Colors.green[600] : Colors.red[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {},
                      child: const Text('买入'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {},
                      child: const Text('卖出'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _enableNotifications = true;
  bool _enableBiometric = false;
  bool _hideSensitiveInfo = false;
  String _currency = 'CNY';
  String _theme = 'system';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 个人设置
          Text(
            '个人设置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('个人资料'),
                  subtitle: const Text('管理您的个人信息'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showProfileDialog(context);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security_outlined),
                  title: const Text('账户安全'),
                  subtitle: const Text('密码和安全设置'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 应用设置
          Text(
            '应用设置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('推送通知'),
                  subtitle: const Text('接收价格提醒和交易通知'),
                  value: _enableNotifications,
                  onChanged: (value) {
                    setState(() {
                      _enableNotifications = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_outlined),
                  title: const Text('生物识别'),
                  subtitle: const Text('使用指纹或Face ID解锁'),
                  value: _enableBiometric,
                  onChanged: (value) {
                    setState(() {
                      _enableBiometric = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.visibility_off_outlined),
                  title: const Text('隐私模式'),
                  subtitle: const Text('在应用切换时隐藏敏感信息'),
                  value: _hideSensitiveInfo,
                  onChanged: (value) {
                    setState(() {
                      _hideSensitiveInfo = value;
                    });
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.currency_exchange_outlined),
                  title: const Text('默认货币'),
                  subtitle: Text('当前: ${_getCurrencyName(_currency)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showCurrencySelector(context);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('主题设置'),
                  subtitle: Text('当前: ${_getThemeName(_theme)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showThemeSelector(context);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 数据管理
          Text(
            '数据管理',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.backup_outlined),
                  title: const Text('数据备份'),
                  subtitle: const Text('备份您的交易记录'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showBackupDialog(context);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_outlined),
                  title: const Text('数据恢复'),
                  subtitle: const Text('从备份恢复数据'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.file_download_outlined),
                  title: const Text('导出数据'),
                  subtitle: const Text('导出为Excel或CSV格式'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 帮助与支持
          Text(
            '帮助与支持',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('使用帮助'),
                  subtitle: const Text('查看使用指南'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined),
                  title: const Text('意见反馈'),
                  subtitle: const Text('向我们提供建议'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showFeedbackDialog(context);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('关于应用'),
                  subtitle: const Text('版本信息和开发者'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _getCurrencyName(String code) {
    switch (code) {
      case 'CNY':
        return '人民币 (¥)';
      case 'USD':
        return '美元 (\$)';
      case 'EUR':
        return '欧元 (€)';
      default:
        return '人民币 (¥)';
    }
  }

  String _getThemeName(String theme) {
    switch (theme) {
      case 'light':
        return '浅色';
      case 'dark':
        return '深色';
      case 'system':
        return '跟随系统';
      default:
        return '跟随系统';
    }
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('个人资料'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '邮箱',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '选择默认货币',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text('¥'),
              title: const Text('人民币'),
              trailing: _currency == 'CNY' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  _currency = 'CNY';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('\$'),
              title: const Text('美元'),
              trailing: _currency == 'USD' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  _currency = 'USD';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('€'),
              title: const Text('欧元'),
              trailing: _currency == 'EUR' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  _currency = 'EUR';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '选择主题',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('浅色主题'),
              trailing: _theme == 'light' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  _theme = 'light';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('深色主题'),
              trailing: _theme == 'dark' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  _theme = 'dark';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_mode),
              title: const Text('跟随系统'),
              trailing: _theme == 'system' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  _theme = 'system';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('数据备份'),
        content: const Text('确定要备份您的数据吗？备份将包含所有交易记录和设置信息。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('数据备份完成')),
              );
            },
            child: const Text('备份'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('意见反馈'),
        content: const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: '请输入您的意见或建议...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('反馈已提交，谢谢您的建议')),
              );
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'YourWallet',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.account_balance_wallet,
          color: Colors.white,
          size: 32,
        ),
      ),
      children: const [
        Text('YourWallet 是一款专业的加密货币投资记账应用，帮助您轻松管理数字资产投资组合。'),
        SizedBox(height: 16),
        Text('开发者: jasxu'),
        Text('邮箱: xulei.ahu@qq.com'),
        SizedBox(height: 16),
        Text('© 2024 YourWallet. All rights reserved.'),
      ],
    );
  }
}
