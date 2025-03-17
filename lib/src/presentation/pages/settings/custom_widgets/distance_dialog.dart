import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/priority.dart';
import '../../../providers/settings_provider.dart';

class DistanceDialog extends StatelessWidget {
  final Priority priority;
  final double distance;

  DistanceDialog({required this.priority, required this.distance});

  @override
  Widget build(BuildContext context) {
    final appSettingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);
    TextEditingController controller = TextEditingController(text: distance.toString());
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
  }
}