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

  List<Conversation> convList = [];

  // Database({required this.uid});

  final _db = FirebaseFirestore.instance;
  Future<List<Conversation>> getConvList() async {
    CollectionReference users = _db.collection('Users');
    QuerySnapshot querySnapshot = await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .get();

    return querySnapshot.docs
        .map((doc) => Conversation.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<int> getConvListSize() async {
    CollectionReference users = _db.collection('Users');
    QuerySnapshot querySnapshot = await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .get();

    return querySnapshot.docs.length;
  }

  Future<void> addConv(Conversation conversation) async {
    CollectionReference users = _db.collection('Users');
    //  si l'élement est déjà présent dans la liste, on ne l'ajoute pas
    if (await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .doc(
            conversation.name) // Use the conversation's name as the document ID
        .get()
        .then((doc) => doc.exists)) {
      return;
    }
    await users
        .doc(uid) // Use the user's ID
        .collection('ConvList')
        .add(conversation.toJson());
  }

  Future<void> updateConversation(Conversation conversation) async {
    CollectionReference users = _db.collection('Users');
    await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .doc(
            conversation.name) // Use the conversation's name as the document ID
        .update(conversation.toJson());
  }

  Future<void> deleteConversation(Conversation conversation) async {
    CollectionReference users = _db.collection('Users');
    QuerySnapshot querySnapshot = await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      if (doc['name'] == conversation.name) {
        await doc.reference.delete();
      }
    }
  }

  Future<void> deleteAllConversations() async {
    CollectionReference users = _db.collection('Users');
    QuerySnapshot querySnapshot = await users
        .doc(uid) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  addUser(UserModel user) async {
    await _db
        .collection('Users')
        .doc(uid)
        .set(user.toJson())
        .whenComplete(() => print(user.name + ' added to database'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  Future<UserModel> getUser() async {
    CollectionReference users = _db.collection('Users');
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    return UserModel(
      name: documentSnapshot['name'],
      email: documentSnapshot['email'],
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
