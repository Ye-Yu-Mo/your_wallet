import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import 'transaction_list_screen.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final List<String> _testResults = [];
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    _runInitialTests();
  }

  void _addResult(String result, {bool isError = false}) {
    setState(() {
      final emoji = isError ? '❌' : '✅';
      _testResults.add('$emoji $result');
    });
  }

  Future<void> _runInitialTests() async {
    setState(() {
      _isTesting = true;
      _testResults.clear();
    });

    _addResult('开始测试后端API连接...');

    try {
      // 测试健康检查
      final healthCheck = await statisticsService.testConnection();
      if (healthCheck) {
        _addResult('健康检查通过');
      } else {
        _addResult('健康检查失败', isError: true);
      }

      // 测试根路径
      final rootInfo = await statisticsService.getRootInfo();
      _addResult('根路径响应: $rootInfo');

      // 测试账户API
      try {
        final accountsResponse = await accountService.getAccounts();
        if (accountsResponse.success) {
          _addResult('账户API测试成功，返回 ${accountsResponse.data?.data.length ?? 0} 个账户');
        } else {
          _addResult('账户API测试失败: ${accountsResponse.message}', isError: true);
        }
      } catch (e) {
        _addResult('账户API异常: $e', isError: true);
      }

      // 测试交易API
      try {
        final transactionsResponse = await transactionService.getTransactions();
        if (transactionsResponse.success) {
          _addResult('交易API测试成功，返回 ${transactionsResponse.data?.data.length ?? 0} 个交易');
        } else {
          _addResult('交易API测试失败: ${transactionsResponse.message}', isError: true);
        }
      } catch (e) {
        _addResult('交易API异常: $e', isError: true);
      }

      // 测试统计API
      try {
        final summaryResponse = await statisticsService.getFinancialSummary();
        if (summaryResponse.success) {
          _addResult('统计API测试成功');
        } else {
          _addResult('统计API测试失败: ${summaryResponse.message}', isError: true);
        }
      } catch (e) {
        _addResult('统计API异常: $e', isError: true);
      }

      // 测试分类API
      try {
        final categoriesResponse = await statisticsService.getCategories();
        if (categoriesResponse.success) {
          _addResult('分类API测试成功，返回 ${categoriesResponse.data?.length ?? 0} 个分类');
        } else {
          _addResult('分类API测试失败: ${categoriesResponse.message}', isError: true);
        }
      } catch (e) {
        _addResult('分类API异常: $e', isError: true);
      }

    } catch (e) {
      _addResult('测试过程中发生异常: $e', isError: true);
    }

    setState(() {
      _isTesting = false;
    });

    _addResult('API连接测试完成！');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API连接测试'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _isTesting ? null : _runInitialTests,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 连接状态卡片
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          appProvider.isOnline ? Icons.cloud_done : Icons.cloud_off,
                          color: appProvider.isOnline ? Colors.green : Colors.red,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appProvider.isOnline ? '后端服务已连接' : '后端服务连接失败',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: appProvider.isOnline ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'API地址: ${ApiClient.baseUrl}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 测试结果
                Row(
                  children: [
                    Text(
                      'API测试结果',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    if (_isTesting)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // 测试结果列表
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _testResults.length,
                      itemBuilder: (context, index) {
                        final result = _testResults[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            result,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 重新测试按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isTesting ? null : _runInitialTests,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(_isTesting ? '测试中...' : '重新运行测试'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 查看交易列表按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TransactionListScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.list),
                    label: const Text('查看交易列表'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}