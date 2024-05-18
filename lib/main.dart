import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterp2/Pages/home.dart';
import 'package:flutterp2/Pages/login_page.dart';
import 'package:flutterp2/Pages/splash_screen.dart';

void main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDAsIN1KwvztPx50MIaTGbLqkgL-JUL8Mk",
      authDomain: "com.example.flutterp2",
      projectId: "flutterp2-7b244",
      storageBucket: "flutterp2-7b244.appspot.com",
      messagingSenderId: "600638982316",
      appId: "1:600638982316:android:faa159b2fa2b57a9aef709",
    ),
  );
  // Check if the user is already signed in
  //User? user = FirebaseAuth.instance.currentUser;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //User? user;
  @override
  void initState() {
    // user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      //user != null ? const Home() : const Login()
    );
  }
}
