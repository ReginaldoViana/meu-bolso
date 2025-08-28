import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/models/expense.dart';
import 'package:meu_bolso/viewmodels/expense_view_model.dart';

void main() {
  late ExpenseViewModel viewModel;

  setUp(() {
    viewModel = ExpenseViewModel();
  });

  group('ExpenseViewModel Tests', () {
    test('should calculate total expenses correctly', () {
      final expenses = [
        Expense(
          id: '1',
          value: 100.0,
          category: 'Alimentação',
          date: DateTime.now(),
        ),
        Expense(
          id: '2',
          value: 50.0,
          category: 'Transporte',
          date: DateTime.now(),
        ),
      ];

      final total = viewModel.getTotalExpenses(expenses);
      expect(total, 150.0);
    });

    test('should group expenses by category correctly', () {
      final now = DateTime.now();
      final expenses = [
        Expense(id: '1', value: 100.0, category: 'Alimentação', date: now),
        Expense(id: '2', value: 50.0, category: 'Alimentação', date: now),
        Expense(id: '3', value: 75.0, category: 'Transporte', date: now),
      ];

      final groupedExpenses = viewModel.getExpensesByCategory(expenses);
      expect(groupedExpenses['Alimentação'], 150.0);
      expect(groupedExpenses['Transporte'], 75.0);
    });

    test('should filter expenses by date range correctly', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final lastWeek = now.subtract(const Duration(days: 7));
      final lastMonth = now.subtract(const Duration(days: 30));

      await viewModel.init();

      await viewModel.addExpense(
        value: 100.0,
        category: 'Alimentação',
        date: now,
      );

      await viewModel.addExpense(
        value: 50.0,
        category: 'Transporte',
        date: yesterday,
      );

      await viewModel.addExpense(
        value: 75.0,
        category: 'Lazer',
        date: lastWeek,
      );

      await viewModel.addExpense(
        value: 200.0,
        category: 'Moradia',
        date: lastMonth,
      );

      final recentExpenses = viewModel.getExpensesByDateRange(yesterday, now);

      expect(recentExpenses.length, 2);
      expect(
        recentExpenses.any(
          (e) => e.value == 100.0 && e.category == 'Alimentação',
        ),
        true,
      );
      expect(
        recentExpenses.any(
          (e) => e.value == 50.0 && e.category == 'Transporte',
        ),
        true,
      );
    });
  });
}
