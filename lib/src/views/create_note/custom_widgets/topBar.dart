import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(
              height: 25,
              color: Colors.white, // Adjust the color if needed
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Add functionality for notification button
                },
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.push_pin_outlined),
                onPressed: () {
                  // Add functionality for mail button
                },
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Add functionality for settings button
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
