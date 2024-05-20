
import 'package:flutter/material.dart';

import '../models/priority.dart';

class AppSettingsProvider extends ChangeNotifier {
  Priority _defaultPriority = Priority.Medium;
  List<PriorityDistance> _priorityDistances = [
    PriorityDistance(priority: Priority.Low, distance: 100),
    PriorityDistance(priority: Priority.Medium, distance: 500),
    PriorityDistance(priority: Priority.High, distance: 1000),
  ];

  Priority get defaultPriority => _defaultPriority;

  List<PriorityDistance> get priorityDistances => _priorityDistances;

  void setDefaultPriority(Priority priority) {
    _defaultPriority = priority;
    notifyListeners();
  }

  void setPriorityDistance(Priority priority, double distance) {
    final index = _priorityDistances.indexWhere((pd) => pd.priority == priority);
    if (index != -1) {
      _priorityDistances[index] = PriorityDistance(priority: priority, distance: distance);
      notifyListeners();
    }
  }
}
