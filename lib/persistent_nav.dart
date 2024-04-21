import 'package:billy/AppTheme/theme_provider.dart';
import 'package:billy/pages/page1.dart';
import 'package:billy/pages/page2.dart';
import 'package:billy/pages/page3.dart';
import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/templates/ConversationType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersistentTabScreen extends StatefulWidget {
  const PersistentTabScreen({Key? key}) : super(key: key);

  @override
  State<PersistentTabScreen> createState() => _PersistentTabScreenState();
}

class _PersistentTabScreenState extends State<PersistentTabScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      Page1(),
      Page2(),
      Page3(
        conversation: Conversation(
          name: "Start",
          avatar: '',
          theme: ConvTheme(type: ConversationType.Normal),
        ),
      ),
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _buildScreens(),
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: CupertinoColors.systemIndigo,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          });
          print(_currentIndex);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.t_bubble_fill),
            label: "Other",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.return_icon),
            label: "Tchat",
          ),
        ],
      ),
    );
  }
}
