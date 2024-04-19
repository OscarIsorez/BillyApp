import 'package:billy/Conversation.dart';
import 'package:billy/chat_provider.dart';
import 'package:billy/components/text_bubble.dart';
import 'package:billy/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billy/pages/home_page.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  //  une liste de themes
  String selectedTheme = Constants.themes[0];

  //  des controllers pour les champs Names, Avatar et Theme
  final TextEditingController nameController = TextEditingController();

  //  une liste de Conversartion
  List<Conversation> conversations = [
    Conversation(
      name: 'John Doe',
      avatar: 'https://via.placeholder.com/150',
      theme: Constants.themes[0],
    ),
    Conversation(
      name: 'Jane Doe',
      avatar: 'https://via.placeholder.com/150',
      theme: Constants.themes[0],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return Dismissible(
              key: Key(conversation.name),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
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
                  backgroundImage: NetworkImage(conversation.avatar),
                ),
                title: Text(conversation.name),
                subtitle: Text(conversation.theme),
                onTap: () {},
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
                        themes: Constants.themes,
                        onValueChanged: (value) {
                          selectedTheme = value;
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
                            avatar: 'https://via.placeholder.com/150',
                            theme: selectedTheme,
                          ),
                        );
                      });
                      print(conversations);
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

class MyDropdownButton extends StatefulWidget {
  final List<String> themes;
  final ValueChanged<String> onValueChanged;

  MyDropdownButton({required this.themes, required this.onValueChanged});

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  String dropdownValue = Constants.themes[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });

        widget.onValueChanged(newValue!);
      },
      items: widget.themes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
