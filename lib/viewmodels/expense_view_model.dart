import 'package:flutter/foundation.dart';
import 'package:meu_bolso/models/expense.dart';
import 'package:meu_bolso/repositories/expense_repository.dart';

class ExpenseViewModel extends ChangeNotifier {
  final _repository = ExpenseRepository();

  Future<void> init() async {
    await _repository.init();
  }

  List<String> get categories => [
        'Alimentação',
        'Transporte',
        'Lazer',
        'Moradia',
        'Saúde',
        'Educação',
        'Outros',
      ];

  Future<void> addExpense({
    required double value,
    required String category,
    required DateTime date,
    String? notes,
  }) async {
    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      value: value,
      category: category,
      date: date,
      notes: notes,
    );
    await _repository.addExpense(expense);
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await _repository.updateExpense(expense);
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await _repository.deleteExpense(id);
    notifyListeners();
  }

  List<Expense> getAllExpenses() {
    return _repository.getAllExpenses();
  }

  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _repository.getExpensesByDateRange(start, end);
  }

  double getTotalExpenses(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.value);
  }

  Map<String, double> getExpensesByCategory(List<Expense> expenses) {
    final map = <String, double>{};
    for (final expense in expenses) {
      map[expense.category] = (map[expense.category] ?? 0) + expense.value;
    }
    return map;
  }

  Future<String> exportToCsv() async {
    return await _repository.exportToCsv();
  }
}
