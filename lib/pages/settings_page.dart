import 'package:billy/AppTheme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
        title: const Text('S E T T I N G S'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "dark mode",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CupertinoSwitch(
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      })
                ]),
          ),
          Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Logout'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.currentUser!.delete();
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Delete Account'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
