// main.dart (updated without auth)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'admin_home_screen.dart';
import 'home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  timeago.setLocaleMessages('bn', timeago.BnMessages());

  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'দীনুত্তর',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'HindSiliguri',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'HindSiliguri',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          color: Colors.grey[900],
          titleTextStyle: TextStyle(
            fontFamily: 'HindSiliguri',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const AdminHomeScreen(),
      routes: {
        '/admin': (context) => const AdminHomeScreen(),
      },
    );
  }
}