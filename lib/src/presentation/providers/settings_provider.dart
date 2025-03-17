import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/priority.dart';

class AppSettingsProvider extends ChangeNotifier {
  Priority _defaultPriority = Priority.moderate;
  List<PriorityDistance> _priorityDistances = [
    PriorityDistance(priority: Priority.low, distance: 100),
    PriorityDistance(priority: Priority.moderate, distance: 500),
    PriorityDistance(priority: Priority.high, distance: 1000),
  ];

  Priority get defaultPriority => _defaultPriority;

  List<PriorityDistance> get priorityDistances => _priorityDistances;

  void setDefaultPriority(Priority priority) {
    _defaultPriority = priority;
    notifyListeners();
    saveSettings();
  }

  void setPriorityDistance(Priority priority, double distance) {
    final index = _priorityDistances.indexWhere((pd) => pd.priority == priority);
    if (index != -1) {
      _priorityDistances[index] = PriorityDistance(priority: priority, distance: distance);
      notifyListeners();
      saveSettings();
    }
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('defaultPriority', _defaultPriority.toString());
    for (var pd in _priorityDistances) {
      prefs.setDouble(pd.priority.toString(), pd.distance);
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? defaultPriority = prefs.getString('defaultPriority');
    if (defaultPriority != null) {
      _defaultPriority = Priority.values.firstWhere((p) => p.toString() == defaultPriority);
    }
    for (var pd in _priorityDistances) {
      double? distance = prefs.getDouble(pd.priority.toString());
      if (distance != null) {
        pd.distance = distance;
      }
    }
    notifyListeners();
  }
}
