import 'package:billy/chat_provider.dart';
import 'package:billy/components/text_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billy/pages/home_page.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Page 2'),
          ],
        ),
      ),
    );
  }
}
