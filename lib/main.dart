import 'package:billy/chat_provider.dart';
import 'package:billy/pages/about_page.dart';
import 'package:billy/pages/home_page.dart';
import 'package:billy/pages/premium_page.dart';
import 'package:billy/pages/profile_page.dart';
import 'package:billy/pages/settings_page.dart';
import 'package:billy/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Billy',
        theme: generatePurpleTheme(),
        home: MainScreen(),
        routes: {
          '/home': (context) => MainScreen(),
          '/about': (context) => AboutPage(),
          '/premium': (context) => PremiumPage(),
          '/profile': (context) => ProfilePage(),
          '/settings': (context) => SettingsPage(),
        });
  }
}
