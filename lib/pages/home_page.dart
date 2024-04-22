import 'package:billy/conversation_provider.dart';
import 'package:billy/components/text_bubble.dart';
import 'package:billy/pages/page1.dart';
import 'package:billy/pages/page2.dart';
import 'package:billy/pages/ConversationScreen.dart';
import 'package:billy/persistent_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late stt.SpeechToText _speech;
  late AnimationController _controller;
  bool _isListening = false;

  final user = FirebaseAuth.instance.currentUser!;

  void singOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 50));
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) {
        if (val == 'listening') {
          setState(() {
            _isListening = true;
          });
          _controller.forward();
        } else {
          setState(() {
            _isListening = false;
          });
          _controller.reverse();
        }
      },
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      _speech.listen(
        onResult: (val) =>
            Provider.of<ConversationProvider>(context, listen: false)
                .addMessage(val.recognizedWords),
      );
    }
  }

  int _currentIndex = 0;

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Meet Billy !'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.deepPurpleAccent,
                  Colors.purpleAccent,
                ],
              ),
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: GestureDetector(
                onTap: () {
                  print("50 coins");
                },
                child: const Row(children: [
                  Text("50"),
                  SizedBox(width: 5),
                  Icon(Icons.monetization_on_outlined),
                ]),
              ),
            )
          ],
        ),
        drawer: Container(
          width: 250,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text('Profile'),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(width: 10),
                      Text('Premium'),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/premium');
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 10),
                      Text('Settings'),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.info),
                      SizedBox(width: 10),
                      Text('About'),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/about');
                  },
                ),
              ],
            ),
          ),
        ),
        body: const PersistentTabScreen());
  }
}
