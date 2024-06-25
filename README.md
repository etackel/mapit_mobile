# MapIt

MapIt is a Flutter-based application designed to provide users with note-taking functionality that includes location tagging. Users can create, pin, delete notes, and also mark their locations using Google Maps. The app features seamless Google Sign-In integration for user authentication.

## Features

- **Google Sign-In Authentication**: Secure and easy authentication using Google accounts.
- **Note Creation**: Create and manage notes with titles, descriptions, and tasks.
- **Location Tagging**: Tag notes with the current location using Google Maps.
- **Pin/Unpin Notes**: Swipe right to pin/unpin notes.
- **Delete Notes**: Swipe left to delete notes.
- **View Notes**: All pinned notes are displayed at the top, followed by unpinned notes.
- **Map Integration**: Search for locations using autocomplete and select locations on the map.

## Usage

### Authentication

MapIt uses Google Sign-In for authentication. When the app starts, it checks if the user is already signed in. If not, the user is presented with a Google Sign-In button.

### Notes Management

- **Create Note**: Click on the 'Add Note' button to create a new note. Fill in the title, description, and tasks.
- **Pin/Unpin Note**: Swipe right on a note to pin or unpin it. Pinned notes are displayed at the top.
- **Delete Note**: Swipe left on a note to delete it.
- **Tag Location**: Click on the location button to open the map, search for a location, and tag it to the note.
- **Set Reminder**: When creating or editing a note, you can set a reminder to receive a notification at a specified time.

### Location Tagging

The app uses the `google_maps_flutter` and `location` packages to get the current location and display the map. Users can search for a location using the autocomplete feature and select it.

### Reminder Feature

The reminder feature uses the `flutter_local_notifications` package to schedule notifications. When creating or editing a note, you can set a date and time for a reminder. The app will then notify you at the specified time to remind you about the note.


## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Google Maps for Flutter](https://pub.dev/packages/google_maps_flutter)
- [Location](https://pub.dev/packages/location)

## Contact

Created by [Abhinav Sharma](https://github.com/abhinavs1920) - feel free to contact me!
