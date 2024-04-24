import 'package:billy/templates/UserModel.dart';
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
              return FutureBuilder<String>(
                future: Provider.of<Database>(context, listen: false)
                    .getThemefromDB(),
                builder: (BuildContext context,
                    AsyncSnapshot<String> themeSnapshot) {
                  if (themeSnapshot.connectionState == ConnectionState.done) {
                    Provider.of<Database>(context, listen: false)
                        .addUser(UserModel(
                      name: snapshot.data!.displayName!,
                      email: snapshot.data!.email!,
                      themeChoosed: themeSnapshot.data!,
                    ));
                    return MainScreen();
                  } else {
                    return CircularProgressIndicator(); // Show a loading spinner while waiting for the future to complete
                  }
                },
              );
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
