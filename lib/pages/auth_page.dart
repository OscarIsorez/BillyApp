import 'package:billy/pages/UserModel.dart';
import 'package:billy/pages/home_page.dart';
import 'package:billy/pages/login_or_register_page.dart';
import 'package:billy/providers/databaseProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // si la connexion s'est faite par google, on ajoute l'utilisateur à la base de données

            if (snapshot.data!.providerData[0].providerId == 'google.com') {
              Provider.of<Database>(context, listen: false).addUser(UserModel(
                  name: snapshot.data!.displayName!,
                  email: snapshot.data!.email!));
            }
            return MainScreen();
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
