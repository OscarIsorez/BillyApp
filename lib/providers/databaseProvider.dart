import 'package:billy/pages/UserModel.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/**
 * A database manager class that provides methods to interact with the database.
 * 
 * We use Firestore as our database.
  */
class Database with ChangeNotifier {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Database({required this.uid});

  final _db = FirebaseFirestore.instance;
  Future<List<Conversation>> getConvList() async {
    CollectionReference users = _db.collection('Users');
    QuerySnapshot querySnapshot = await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .get();

    List<Conversation> conversations = [];
    print(' the conversations are: ');
    print(querySnapshot.docs);

    return conversations;
  }

  Future<void> addConvToUser(Conversation conversation) async {
    CollectionReference users = _db.collection('Users');
    await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .add(conversation.toJson());
  }

  Future<void> updateConvInUser(Conversation conversation) async {
    CollectionReference users = _db.collection('Users');
    await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .doc(
            conversation.name) // Use the conversation's name as the document ID
        .update(conversation.toJson());
  }

  Future<void> deleteConvFromUser(Conversation conversation) async {
    CollectionReference users = _db.collection('Users');
    await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .doc(
            conversation.name) // Use the conversation's name as the document ID
        .delete();
  }

  addUser(UserModel user) async {
    await _db
        .collection('Users')
        .doc(uid)
        .set(user.toJson())
        .whenComplete(() => print('User added'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  Future<UserModel> getUser() async {
    CollectionReference users = _db.collection('Users');
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    return UserModel(
      name: documentSnapshot['name'],
      email: documentSnapshot['email'],
      password: documentSnapshot['password'],
    );
  }

  Future<void> updateUser(UserModel user) async {
    CollectionReference users = _db.collection('Users');
    await users.doc(uid).update(user.toJson());
  }

  Future<void> deleteUser() async {
    CollectionReference users = _db.collection('Users');
    await users.doc(uid).delete();
  }
}
