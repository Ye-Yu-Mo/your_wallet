import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType? initialType;
  final Transaction? editTransaction;

  const AddTransactionScreen({
    Key? key,
    this.initialType,
    this.editTransaction,
  }) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // 表单字段
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.expense;
  String? _selectedAccountId;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  List<String> _tags = [];
  final _tagController = TextEditingController();

  // UI状态
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // 初始化类型
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }

    // 如果是编辑模式，填充表单
    if (widget.editTransaction != null) {
      _fillFormForEdit();
    }

    // 初始化TabController
    _tabController = TabController(
      length: TransactionType.values.length,
      vsync: this,
      initialIndex: TransactionType.values.indexOf(_selectedType),
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedType = TransactionType.values[_tabController.index];
        });
      }
    });
  }

  void _fillFormForEdit() {
    final transaction = widget.editTransaction!;
    _amountController.text = transaction.amount.toString();
    _descriptionController.text = transaction.description;
    _notesController.text = transaction.notes ?? '';
    _selectedType = transaction.transactionType;
    _selectedDate = transaction.transactionDate;
    _tags = List.from(transaction.tags);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editTransaction != null ? '编辑记录' : '添加记录'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton.icon(
              onPressed: _saveTransaction,
              icon: const Icon(Icons.save),
              label: const Text('保存'),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.trending_down, color: Colors.red),
                text: '支出',
              ),
              Tab(
                icon: Icon(Icons.trending_up, color: Colors.green),
                text: '收入',
              ),
              Tab(
                icon: Icon(Icons.swap_horiz, color: Colors.blue),
                text: '转账',
              ),
              Tab(
                icon: Icon(Icons.show_chart, color: Colors.purple),
                text: '投资',
              ),
            ],
            labelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 金额输入
              _buildAmountCard(),
              
              const SizedBox(height: 16),
              
              // 基本信息
              _buildBasicInfoCard(),
              
              const SizedBox(height: 16),
              
              // 账户选择
              _buildAccountCard(),
              
              const SizedBox(height: 16),
              
              // 分类选择
              _buildCategoryCard(),
              
              const SizedBox(height: 16),
              
              // 日期选择
              _buildDateCard(),
              
              const SizedBox(height: 16),
              
              // 标签
              _buildTagsCard(),
              
              const SizedBox(height: 32),
              
              // 保存按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getTypeColor(_selectedType),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.editTransaction != null ? '更新记录' : '保存记录',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getTypeIcon(_selectedType),
                  color: _getTypeColor(_selectedType),
                ),
                const SizedBox(width: 8),
                Text(
                  '金额',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '¥',
                  style: TextStyle(
                    fontSize: 32,
                    color: _getTypeColor(_selectedType),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    style: TextStyle(
                      fontSize: 32,
                      color: _getTypeColor(_selectedType),
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        color: _getTypeColor(_selectedType).withOpacity(0.5),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入金额';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return '请输入有效的金额';
                      }
                      return null;
                    },
                    autofocus: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '描述',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: '例如：午餐、工资、转账等',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入交易描述';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: '备注（可选）',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '账户',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Consumer<AccountProvider>(
              builder: (context, accountProvider, child) {
                if (accountProvider.accounts.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('暂无账户，请先添加账户'),
                  );
                }
                
                return DropdownButtonFormField<String>(
                  value: _selectedAccountId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance_wallet),
                  ),
                  hint: const Text('选择账户'),
                  items: accountProvider.accounts.map((account) {
                    return DropdownMenuItem<String>(
                      value: account.id,
                      child: Row(
                        children: [
                          Icon(_getAccountIcon(account.accountType), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(account.name),
                                Text(
                                  account.formattedBalance,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择账户';
                    }
                    return null;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '分类',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // TODO: 实现分类选择，目前使用简单输入框
            TextFormField(
              decoration: const InputDecoration(
                hintText: '选择或输入分类',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              onChanged: (value) {
                _selectedCategoryId = value.isEmpty ? null : value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '日期',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatDate(_selectedDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            _formatTime(_selectedDate),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '标签',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      hintText: '添加标签',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.tag),
                    ),
                    onSubmitted: _addTag,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _addTag(_tagController.text),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _tags.map((tag) => Chip(
                  label: Text(tag),
                  onDeleted: () => _removeTag(tag),
                  backgroundColor: _getTypeColor(_selectedType).withOpacity(0.1),
                  labelStyle: TextStyle(color: _getTypeColor(_selectedType)),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _addTag(String tagText) {
    final tag = tagText.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
      });
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      
      if (widget.editTransaction != null) {
        // 更新交易
        final request = UpdateTransactionRequest(
          accountId: _selectedAccountId!,
          categoryId: _selectedCategoryId,
          amount: amount,
          description: _descriptionController.text.trim(),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          tags: _tags,
          transactionDate: _selectedDate,
        );
        
        final success = await context.read<TransactionProvider>()
            .updateTransaction(widget.editTransaction!.id, request);
        
        if (success && mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('交易记录已更新'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // 创建新交易
        final request = CreateTransactionRequest(
          accountId: _selectedAccountId!,
          categoryId: _selectedCategoryId,
          transactionType: _selectedType,
          amount: amount,
          description: _descriptionController.text.trim(),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          tags: _tags,
          transactionDate: _selectedDate,
        );
        
        final success = await context.read<TransactionProvider>()
            .createTransaction(request);
        
        if (success && mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getTypeName(_selectedType)}记录已保存'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _getTypeColor(TransactionType type) {
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

  IconData _getTypeIcon(TransactionType type) {
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

  String _getTypeName(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return '收入';
      case TransactionType.expense:
        return '支出';
      case TransactionType.transfer:
        return '转账';
      case TransactionType.investment:
        return '投资';
    }
  }

  IconData _getAccountIcon(dynamic accountType) {
    final typeStr = accountType.toString().toLowerCase();
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
    final selectedDay = DateTime(date.year, date.month, date.day);
    
    if (selectedDay == today) {
      return '今天';
    } else if (selectedDay == today.subtract(const Duration(days: 1))) {
      return '昨天';
    } else if (selectedDay == today.add(const Duration(days: 1))) {
      return '明天';
    } else {
      return '${date.year}年${date.month}月${date.day}日';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}