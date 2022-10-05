import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wordle/utils/values/enums.dart';

class AuthProvider extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _currentUser;
  User get user => _currentUser!;
  AuthStatus get authStatus => _currentUser == null ? AuthStatus.notLoggedIn : AuthStatus.loggedIn;

  final _googleSignIn = GoogleSignIn();

  AuthProvider(){
    _currentUser = _firebaseAuth.currentUser;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future signInWithGoogle() async{

    //for web config
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await _firebaseAuth.signInWithPopup(authProvider);
        _currentUser = userCredential.user;
      } catch (e) {
        rethrow;
      }
      return;
    }
    //for android and ios config

    final googleUser = await _googleSignIn.signIn();
    if(googleUser == null){ return; }
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );
    try {
      final UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);
      _currentUser = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
          throw 'account exists with different credential';
      }
      else if (e.code == 'invalid-credential') {
        throw 'invalid credentials';
      }
    } catch (e) {
      //todo - update with the navigation key
      print(e);
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
     return;
    }
  }
}
