import 'package:billy/components/MyDropDownButton.dart';
import 'package:billy/pages/ConversationScreen.dart';
import 'package:billy/providers/databaseProvider.dart';
import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/providers/conversation_provider.dart';
import 'package:billy/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  //  une liste de themes
  ConvTheme selectedTheme = Constants.convThemes[0];

  //  des controllers pour les champs Names, Avatar et Theme
  final TextEditingController nameController = TextEditingController();
  List<Conversation> conversations = [];

  //  une liste de Conversartion

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      conversations =
          await Provider.of<Database>(context, listen: false).getConvList();
      if (mounted) {
        setState(
            () {}); // Call setState to trigger a rebuild after data is fetched
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        // la liste des converstions de l'utilisateur dans la base
        itemCount: conversations.length,

        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return Dismissible(
              key: Key(conversation.name),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                Provider.of<Database>(context, listen: false)
                    .deleteConversation(conversation);
                setState(() {
                  conversations.removeAt(index);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${conversation.name} dismissed")));
              },
              background: Container(
                color: Colors.red,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(conversation.name[0]),
                ),
                title: Text(conversation.name),
                subtitle: Text(conversation.theme.toString()),
                onTap: () {
                  //  on va sur la page 3 pour afficher les messages et pouvoir continuer la conversation
                  Provider.of<ConversationProvider>(context, listen: false)
                      .setConversation(conversation);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ConversationScreen(conversation: conversation),
                    ),
                  );
                },
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add a conversation'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    MyDropdownButton(
                        //  la liste des convtheme qqui est de type ConvTheme que l'on transforme en liste de string
                        themes: Constants.convThemes
                            .map((e) => e.toString())
                            .toList(),
                        onValueChanged: (value) {
                          selectedTheme = ConvTheme.fromString(value);
                        })
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        conversations.add(
                          Conversation(
                            name: nameController.text,
                            theme: selectedTheme,
                            messages: [],
                          ),
                        );
                      });
                      Provider.of<Database>(context, listen: false).addConv(
                          Conversation(
                              name: nameController.text,
                              theme: selectedTheme,
                              messages: []));
                      Navigator.of(context).pop();
                      nameController.clear();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
