import 'package:billy/templates/Conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * A database manager class that provides methods to interact with the database.
 * 
 * We use Firestore as our database.
  */
class Database {
  final _db = FirebaseFirestore.instance;
  getConvListeFromUID(String userId) async {
    CollectionReference users = _db.collection('Users');
    QuerySnapshot querySnapshot = await users
        .doc(userId) // Use the user's ID
        .collection('ConvList') // Access the 'Conversations' sub-collection
        .get();

    List<Conversation> conversations = [];
   

    return conversations;
  }
}
