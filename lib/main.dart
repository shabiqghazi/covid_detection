import 'package:covid_detection/firebase_options.dart';
import 'package:covid_detection/pages/home.dart';
import 'package:covid_detection/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Color.fromARGB(0, 3, 3, 3)),
  );

  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        primarySwatch: Colors.teal,
      ),
      routes: {
        '/': (context) => Login(),
        '/home': (context) => Home(),
      },
      initialRoute: '/',
    );
  }
}
