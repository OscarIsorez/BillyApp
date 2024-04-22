import 'package:billy/pages/UserModel.dart';
import 'package:billy/providers/AudioPlayerProvider.dart';
import 'package:billy/providers/databaseProvider.dart';
import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/templates/ConversationType.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Page1 extends StatefulWidget {
  Page1({Key? key})
      : super(key: key); // Add a named 'key' parameter to the constructor

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final player = AudioPlayer();
  double _width = 200;
  double _height = 200;
  double _outerWidth = 220;
  double _outerHeight = 220;
  bool _isAnimating = false;
  StreamController<bool> _streamController = StreamController<bool>();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    _isAnimating = false;
    _streamController.add(_isAnimating);
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            _isAnimating = !_isAnimating;
            _streamController.add(_isAnimating);
            Database db = Provider.of<Database>(context, listen: false);
            db.addUser(
                UserModel(name: "Billy", email: "mail", password: "password"));

            db.addConvToUser(Conversation(
                name: "Billy",
                theme: ConvTheme(type: ConversationType.Normal)));

            db.getConvList();

            while (_isAnimating) {
              setState(() {
                _width = 220;
                _height = 220;
                _outerWidth = 240;
                _outerHeight = 240;
              });
              Provider.of<AudioPlayerProvider>(context, listen: false).play();
              await Future.delayed(const Duration(milliseconds: 600));
              if (!_isAnimating) {
                break;
              }
              setState(() {
                _width = 200;
                _height = 200;
                _outerWidth = 220;
                _outerHeight = 220;
              });
              await Future.delayed(const Duration(milliseconds: 600));
            }
          },
          child: StreamBuilder<bool>(
              stream: _streamController.stream,
              initialData: false,
              builder: (context, snapshot) {
                return AnimatedContainer(
                  width: _outerWidth,
                  height: _outerHeight,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                    child: AnimatedContainer(
                      width: _width,
                      height: _height,
                      decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle,
                      ),
                      duration: const Duration(seconds: 1),
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
                  ),
                );
              }),
        ),
      ),
    );
  }
}
