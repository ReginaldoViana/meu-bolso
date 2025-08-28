import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:meu_bolso/models/expense.dart';
import 'package:meu_bolso/viewmodels/expense_view_model.dart';
import 'package:meu_bolso/repositories/income_repository.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  Widget _buildLegendItem(
      BuildContext context, String category, double value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          category,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'R\$ ${value.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'alimentação':
      case 'alimentacao':
        return Colors.orange;
      case 'transporte':
        return Colors.blue;
      case 'moradia':
        return Colors.green;
      case 'saúde':
      case 'saude':
        return Colors.red;
      case 'educação':
      case 'educacao':
        return Colors.purple;
      case 'lazer':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    Color valueColor,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);
    final expenses = viewModel.getAllExpenses();
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final lastMonth = DateTime(now.year, now.month - 1, now.day);

    final weeklyExpenses = viewModel.getExpensesByDateRange(lastWeek, now);
    final monthlyExpenses = viewModel.getExpensesByDateRange(lastMonth, now);
    final totalDaily = viewModel.getTotalExpenses(
      expenses.where((e) => e.date.day == now.day).toList(),
    );
    final totalWeekly = viewModel.getTotalExpenses(weeklyExpenses);
    final totalMonthly = viewModel.getTotalExpenses(monthlyExpenses);
    final expensesByCategory = viewModel.getExpensesByCategory(monthlyExpenses);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total este mês',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'R\$ ${totalMonthly.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            totalMonthly > totalWeekly
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'R\$ ${totalWeekly.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricCard(
                      context,
                      'Entradas',
                      'R\$ ${Provider.of<IncomeRepository>(context).getIncome().toStringAsFixed(2)}',
                      Colors.green,
                    ),
                    _buildMetricCard(
                      context,
                      'Saídas',
                      'R\$ ${totalDaily.toStringAsFixed(2)}',
                      Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Distribuição por Categoria',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (expensesByCategory.isEmpty)
                    const Center(
                      child: Text(
                        'Nenhuma despesa registrada este mês',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: expensesByCategory.entries.map((e) {
                                final color = getCategoryColor(e.key);
                                final percentage =
                                    (e.value / totalMonthly * 100);
                                return PieChartSectionData(
                                  value: e.value,
                                  title: percentage >= 5
                                      ? '${percentage.toStringAsFixed(0)}%'
                                      : '',
                                  titlePositionPercentageOffset: 0.6,
                                  radius: 100,
                                  color: color,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList(),
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: expensesByCategory.entries.map((e) {
                            return _buildLegendItem(
                              context,
                              e.key,
                              e.value,
                              getCategoryColor(e.key),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
