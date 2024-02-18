import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          SizedBox(height: 20),
          Text(
            'Billy',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Billy@gmail.com',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "Total Coins: 100",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
