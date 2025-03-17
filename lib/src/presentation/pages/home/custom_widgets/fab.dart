import 'package:flutter/material.dart';

import '../../create_note/create_note_view.dart';

class CustomFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateNoteScreen()),
        );
      },
      backgroundColor: Color(0xFF156FEE), // Background color
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.transparent, // You can adjust this color if needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Stack(
          children: [
            Container(
              width: 24,
              height: 24,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Color(0xFF156FEE), // Color of the inner circle
                shape: BoxShape.circle,
              ),
              child: Center(
                // Add any icon or widget you want in the center
                child: Icon(
                  Icons.add,
                  color: Colors.white, // Icon color
                ),
              ),
            ),
            // You can add more elements to the stack if needed
          ],
        ),
      ),
    );
  }
}

