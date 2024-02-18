import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Premium Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Premium Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
