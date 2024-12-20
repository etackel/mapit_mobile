import 'package:flutter/material.dart';
import 'package:mapit/src/views/create_note/create_note_view.dart';
import 'package:quick_actions/quick_actions.dart';

class ShortcutService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void setup() {
    final QuickActions quickActions = QuickActions();
    
    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: 'action_create_note',
        localizedTitle: 'Create Note',
        icon: 'create_note',
      ),
    ]);

    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'action_create_note') {
        _handleCreateNoteShortcut();
      }
    });
  }

  static void _handleCreateNoteShortcut() {
    Navigator.push(
      navigatorKey.currentState!.context,
      MaterialPageRoute(builder: (context) => CreateNoteScreen()),
    );
  }
}
