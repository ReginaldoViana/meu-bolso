import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class IncomeRepository extends ChangeNotifier {
  static const String boxName = 'income';
  late Box<double> _box;

  Future<void> init() async {
    _box = await Hive.openBox<double>(boxName);
    if (_box.isEmpty) {
      await _box.put('current', 2000.00);
    }
  }

  double getIncome() {
    return _box.get('current', defaultValue: 2000.00)!;
  }

  Future<void> updateIncome(double value) async {
    await _box.put('current', value);
    notifyListeners();
  }
}
