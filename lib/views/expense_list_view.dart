import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meu_bolso/models/expense.dart';
import 'package:meu_bolso/viewmodels/expense_view_model.dart';
import 'package:meu_bolso/widgets/common_widgets.dart';
import 'package:intl/intl.dart';

class ExpenseListView extends StatelessWidget {
  final bool maskValues;

  const ExpenseListView({
    super.key,
    this.maskValues = false,
  });

  static IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'alimentação':
      case 'alimentacao':
        return Icons.restaurant;
      case 'transporte':
        return Icons.directions_car;
      case 'moradia':
        return Icons.home;
      case 'saúde':
      case 'saude':
        return Icons.medical_services;
      case 'educação':
      case 'educacao':
        return Icons.school;
      case 'lazer':
        return Icons.sports_esports;
      case 'outros':
        return Icons.category;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);
    return ExpenseListContent(
      viewModel: viewModel,
      maskValues: maskValues,
    );
  }
}

class ExpenseListContent extends StatefulWidget {
  final ExpenseViewModel viewModel;
  final bool maskValues;

  const ExpenseListContent({
    super.key,
    required this.viewModel,
    this.maskValues = false,
  });

  @override
  State<ExpenseListContent> createState() => _ExpenseListContentState();
}

class _ExpenseListContentState extends State<ExpenseListContent> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedCategory;
  List<Expense> filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredExpenses();
  }

  void _updateFilteredExpenses() {
    var expenses = widget.viewModel.getAllExpenses();

    if (startDate != null && endDate != null) {
      expenses = widget.viewModel.getExpensesByDateRange(startDate!, endDate!);
    }

    if (selectedCategory != null) {
      expenses = expenses.where((e) => e.category == selectedCategory).toList();
    }

    expenses.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      filteredExpenses = expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DateRangeSelector(
                  startDate: startDate,
                  endDate: endDate,
                  onDateRangeSelected: (start, end) {
                    setState(() {
                      startDate = start;
                      endDate = end;
                    });
                    _updateFilteredExpenses();
                  },
                ),
                const SizedBox(height: 8),
                CategoryFilter(
                  categories: widget.viewModel.categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                    _updateFilteredExpenses();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma despesa encontrada',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return AnimatedListItem(
                        index: index,
                        child: Dismissible(
                          key: ValueKey(expense.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16.0),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: Text(
                                  'Deseja realmente excluir a despesa de R\$ ${expense.value.toStringAsFixed(2)} em ${expense.category}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Excluir'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) async {
                            final deletedExpense = expense;
                            await widget.viewModel.deleteExpense(expense.id);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Despesa excluída'),
                                  action: SnackBarAction(
                                    label: 'Desfazer',
                                    onPressed: () {
                                      widget.viewModel.addExpense(
                                        value: deletedExpense.value,
                                        category: deletedExpense.category,
                                        date: deletedExpense.date,
                                        notes: deletedExpense.notes,
                                      );
                                      _updateFilteredExpenses();
                                    },
                                  ),
                                ),
                              );
                            }
                            _updateFilteredExpenses();
                          },
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Implementar edição de despesa
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      ExpenseListView._getCategoryIcon(
                                          expense.category),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense.category,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          expense.notes ?? '',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.maskValues
                                            ? 'R\$ ●●●●●'
                                            : 'R\$ ${expense.value.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(expense.date),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
