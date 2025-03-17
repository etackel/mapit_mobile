import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/priority.dart';
import '../../../providers/settings_provider.dart';

class DefaultPriorityDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);
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
  }
}