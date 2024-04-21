import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(
                16), // Ajoutez le BorderRadius souhaité ici
          ),
          child: const Text(
            '''Billy is a chatbot that helps you to lean english. I chossed to build this app because, as a student,I faced the lack of english practice. I hope that Billy will help you to improve your english skills. Enjoy !
          ''',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
