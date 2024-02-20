import 'package:flutter/material.dart';
import 'package:mapit/src/provider/note_provider.dart';
import 'package:mapit/src/provider/user_provider.dart';
import 'package:mapit/src/views/home/home_view.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(

        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteProvider(),
      child: MaterialApp(
        home: Scaffold(
          body: HomeScreen(),
        ),
        ),

    );
  }
}
