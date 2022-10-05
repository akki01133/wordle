import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseException implements Exception{
  final String message;

  FirebaseException({required this.message});

  @override
  String toString()=> 'error while task -\n $message';
}

class FireStoreService{
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference notePageCollection;

  FireStoreService( {required this.uid}){
    notePageCollection = firestore.collection('UserData').doc(uid).collection('NotePageList');
  }
}
