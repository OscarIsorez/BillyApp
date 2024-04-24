// import 'package:flutter/material.dart';

// class MyDialog extends StatelessWidget {
//   const MyDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: const Text('Conversation Name'),
//                     content: TextField(
//                       controller: conversationNameController,
//                       decoration: const InputDecoration(
//                         hintText: "Conversation Name",
//                       ),
//                     ),
//                     actions: <Widget>[
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Provider.of<ConversationProvider>(context,
//                                   listen: false)
//                               .conversation
//                               .setName(conversationNameController.text);
//                           Provider.of<Database>(context, listen: false).addConv(
//                             Provider.of<ConversationProvider>(context,
//                                     listen: false)
//                                 .conversation,
//                           );
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Save'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//     )

//   }
// }