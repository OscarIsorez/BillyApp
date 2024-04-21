import 'package:billy/AppTheme/theme_provider.dart';
import 'package:billy/chat_provider.dart';
import 'package:billy/constant.dart';
import 'package:billy/pages/about_page.dart';
import 'package:billy/pages/home_page.dart';
import 'package:billy/pages/premium_page.dart';
import 'package:billy/pages/profile_page.dart';
import 'package:billy/pages/settings_page.dart';
import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/templates/ConversationType.dart';
import 'package:billy/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(
              conversation: Conversation(
                  name: 'Billy',
                  avatar: 'https://via.placeholder.com/150',
                  theme: ConvTheme(type: ConversationType.Bakery))),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Billy',
        home: MainScreen(),
        theme: Provider.of<ThemeProvider>(context).themeData,
        routes: {
          '/home': (context) => MainScreen(),
          '/about': (context) => AboutPage(),
          '/premium': (context) => PremiumPage(),
          '/profile': (context) => ProfilePage(),
          '/settings': (context) => SettingsPage(),
        });
  }
}
