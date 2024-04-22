import 'package:billy/AppTheme/theme_provider.dart';
import 'package:billy/AudioPlayerProvider.dart';
import 'package:billy/conversation_provider.dart';
import 'package:billy/constant.dart';
import 'package:billy/firebase_options.dart';
import 'package:billy/llm_api_manager.dart';
import 'package:billy/pages/about_page.dart';
import 'package:billy/pages/auth_page.dart';
import 'package:billy/pages/home_page.dart';
import 'package:billy/pages/premium_page.dart';
import 'package:billy/pages/profile_page.dart';
import 'package:billy/pages/settings_page.dart';
import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/templates/ConversationType.dart';
import 'package:billy/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ConversationProvider()),
        ChangeNotifierProvider(create: (context) => AudioPlayerProvider()),
        ChangeNotifierProvider(create: (context) => LlmApiManager()),
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
        home: AuthPage(),
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
