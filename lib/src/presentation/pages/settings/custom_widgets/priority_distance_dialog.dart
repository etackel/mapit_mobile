import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/settings_provider.dart';
import 'distance_dialog.dart';

class PriorityDistanceDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);
    final priorityDistances = appSettingsProvider.priorityDistances;
    return AlertDialog(
      title: Text('Priority Distances'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: priorityDistances.map((pd) {
          return ListTile(
            title: Text(pd.priority.toString().split('.').last),
            subtitle: Text('Distance: ${pd.distance} meters'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => DistanceDialog(priority: pd.priority, distance: pd.distance),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}