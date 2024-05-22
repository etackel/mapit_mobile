import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/priority.dart';
import '../../provider/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text('Default Priority'),
              subtitle: Text('Change the default priority setting'),
              onTap: () {
                _showDefaultPriorityDialog(context);
              },
            ),
            ListTile(
              title: Text('Priority Distances'),
              subtitle: Text('Change the distance settings for each priority'),
              onTap: () {
                _showPriorityDistanceDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDefaultPriorityDialog(BuildContext context) {
    print('trying to open the priority dialog');
    final appSettingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Default Priority'),
          content: DropdownButtonFormField<Priority>(
            value: appSettingsProvider.defaultPriority,
            items: Priority.values.map((Priority priority) {
              return DropdownMenuItem<Priority>(
                value: priority,
                child: Text(priority.toString().split('.').last),
              );
            }).toList(),
            onChanged: (Priority? value) {
              if (value != null) {
                appSettingsProvider.setDefaultPriority(value);
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }

  void _showPriorityDistanceDialog(BuildContext context) {
    print('trying to open the priority distance dialog');
    final appSettingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);
    final priorityDistances = appSettingsProvider.priorityDistances;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Priority Distances'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: priorityDistances.map((pd) {
              return ListTile(
                title: Text(pd.priority.toString().split('.').last),
                subtitle: Text('Distance: ${pd.distance} meters'),
                onTap: () {
                  _showDistanceDialog(context, pd.priority, pd.distance);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showDistanceDialog(BuildContext context, Priority priority, double distance) {
    final appSettingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);
    TextEditingController controller = TextEditingController(text: distance.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Distance for ${priority.toString().split('.').last} Priority'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Distance (in meters)'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double newDistance = double.tryParse(controller.text) ?? 0;
                appSettingsProvider.setPriorityDistance(priority, newDistance);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}