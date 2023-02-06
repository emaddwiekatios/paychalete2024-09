import 'package:firebase_auth/firebase_auth.dart';


Future<User> getUser() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  return await _auth.currentUser;

}


