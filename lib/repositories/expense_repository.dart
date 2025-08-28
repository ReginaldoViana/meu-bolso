import 'package:hive_flutter/hive_flutter.dart';
import 'package:meu_bolso/models/expense.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';

class ExpenseRepository {
  static const String boxName = 'expenses';
  late Box<Expense> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ExpenseAdapter());
    }
    _box = await Hive.openBox<Expense>(boxName);
  }

  Future<void> addExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  Future<void> updateExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  List<Expense> getAllExpenses() {
    return _box.values.toList();
  }

  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _box.values
        .where(
          (expense) =>
              expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
              expense.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList();
  }

  List<Expense> getExpensesByCategory(String category) {
    return _box.values
        .where((expense) => expense.category == category)
        .toList();
  }

  Future<String> exportToCsv() async {
    final expenses = getAllExpenses();
    final csvData = [
      ['ID', 'Value', 'Category', 'Date', 'Notes'],
      ...expenses.map(
        (e) => [
          e.id,
          e.value.toString(),
          e.category,
          e.date.toIso8601String(),
          e.notes ?? '',
        ],
      ),
    ];

    final csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/expenses.csv');
    await file.writeAsString(csv);
    return file.path;
  }
}
