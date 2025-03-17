import 'package:flutter/material.dart';

import 'custom_widgets/default_priority_dialog.dart';
import 'custom_widgets/priority_distance_dialog.dart';


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
                showDialog(
                  context: context,
                  builder: (BuildContext context) => DefaultPriorityDialog(),
                );
              },
            ),
            ListTile(
              title: Text('Priority Distances'),
              subtitle: Text('Change the distance settings for each priority'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => PriorityDistanceDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}