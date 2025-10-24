import 'package:shared_preferences/shared_preferences.dart';

import '../enums/units.dart';

class UnitsService {
  static const _keyUnits = 'units';

  Future<void> saveUnits(Units units) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUnits, units.name);
  }

  Future<Units> loadUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyUnits);
    if (value == null) return Units.metric;
    return Units.values.firstWhere((e) => e.name == value, orElse: () => Units.metric);
  }
}