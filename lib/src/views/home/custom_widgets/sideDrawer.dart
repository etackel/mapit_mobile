import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          DrawerOption(
            title: 'Settings',
            onTap: () {
              // Handle Settings option
              Navigator.pop(context); // Close the drawer
            },
          ),
          DrawerOption(
            title: 'Support',
            onTap: () {
              // Handle Support option
              Navigator.pop(context); // Close the drawer
            },
          ),
          DrawerOption(
            title: 'Log Out',
            onTap: () {
              // Handle Log Out option
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}

class DrawerOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DrawerOption({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}
