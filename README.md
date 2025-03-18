# MapIt

**MapIt** is a Flutter-based application designed to provide users with note-taking functionality that includes **location tagging**. Users can create, pin, delete notes, and mark their locations using **Google Maps**. The app features **seamless Google Sign-In integration** for user authentication.

---

## ✨ Features

- **Google Sign-In Authentication**: Secure and easy authentication using Google accounts.
- **Note Creation**: Create and manage notes with titles, descriptions, and tasks.
- **Location Tagging**: Tag notes with the current location using **Google Maps**.
- **Pin/Unpin Notes**: Swipe right to pin/unpin notes.
- **Delete Notes**: Swipe left to delete notes.
- **View Notes**: All pinned notes are displayed at the top, followed by unpinned notes.
- **Map Integration**: Search for locations using autocomplete and select locations on the map.
- **Set Reminders**: Schedule reminders for notes to receive notifications at a specified time.

---

## 🛠 Tech Stack

MapIt is built using **Flutter** with the following technologies:

- **Flutter & Dart**: The core framework for UI and functionality.
- **Firebase Authentication**: Secure authentication using Google Sign-In.
- **Google Maps for Flutter**: For location tagging and map integration.
- **Location Package**: To fetch the user's current location.
- **flutter_local_notifications**: For scheduling reminders and notifications.
- **Isolates**: For handling background tasks efficiently.
- **Geofencing**: To trigger location-based reminders.
- **Background Notification Service**: Ensures notifications even when the app is closed.
- **Battery Optimization**: Keeps background services efficient without excessive battery drain.

---

## 🚀 Usage

### 🔐 Authentication
MapIt uses **Google Sign-In** for authentication. When the app starts, it checks if the user is already signed in. If not, the user is presented with a Google Sign-In button.

### 📝 Notes Management
- **Create Note**: Tap the **'Add Note'** button to create a new note. Fill in the title, description, and tasks.
- **Pin/Unpin Note**: Swipe right on a note to pin/unpin it. Pinned notes appear at the top.
- **Delete Note**: Swipe left on a note to delete it.
- **Tag Location**: Click on the **location button** to open the map, search for a location, and tag it to the note.
- **Set Reminder**: When creating or editing a note, set a date and time to receive a notification.

### 📍 Location Tagging
The app uses **google_maps_flutter** and **location** packages to:
- Get the current location.
- Display a map for tagging locations.
- Enable **autocomplete search** for selecting locations.

### ⏰ Reminder Feature
The **flutter_local_notifications** package schedules notifications. When a reminder is set, the app will notify the user at the specified time.

---

## 🛤 Roadmap

### 🔜 Planned Features
Here are some features that will be added in future updates:

1. **Offline Mode** - Allow users to access and modify notes without an internet connection.
2. **Geofencing Alerts** - Get reminders based on location (e.g., "Remind me when I reach home").
3. **Voice-to-Text Notes** - Convert speech into text for faster note-taking.
4. **Dark Mode** - Support for light and dark themes.
5. **Collaborative Notes** - Share and edit notes with others in real-time.
6. **Cloud Backup & Sync** - Automatic backup and sync across multiple devices.
7. **Custom Categories & Tags** - Organize notes better using categories and labels.
8. **Widgets & Quick Actions** - Home screen widgets for quick access to pinned notes.

---

## 🎗 Acknowledgements

- **Flutter** - Open-source UI framework.
- **Firebase Authentication** - Secure sign-in integration.
- **Google Maps for Flutter** - Used for map functionalities.
- **Location Package** - Fetches the current user location.
- **flutter_local_notifications** - Enables scheduling notifications.

---

## 📩 Contact

Created by **Abhinav Sharma** – Feel free to reach out for any queries or collaboration!
