import 'package:billy/chat_provider.dart';
import 'package:billy/components/text_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billy/pages/home_page.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
          color: Colors.deepPurpleAccent,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            "Billy",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ));
  }
}
