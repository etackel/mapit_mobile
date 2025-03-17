import 'package:awesome_notifications/awesome_notifications.dart';

import '../../domain/entities/note.dart';

class NotificationService {
  void showNoteFoundNotification(Note note) async {
    AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    int remainingTasks = note.taskList.where((task) => task.isCompleted == false).length;
    awesomeNotifications.createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'geofence_channel',
        title: 'Note with title ${note.title} found',
        body: 'You have $remainingTasks tasks remaining',
        notificationLayout: NotificationLayout.BigText,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OPEN_NOTE',
          label: 'Open Note',
        ),
      ],
    );
  }
}
