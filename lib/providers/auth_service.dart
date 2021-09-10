import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;

  AuthService(this.firebaseAuth);
  Stream<User> get authStateChanges => firebaseAuth.idTokenChanges();
  Future<String> register({
    String email,
    String password,
    String name,
    String phone,
  }) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": email,
          "password": password,
          "name": name,
          "phone": phone,
        });
      });
      return "Register";
    } catch (e) {
      return "Fail";
    }
  }

  Future<String> login(String email, String password) async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => print(value.user.email));

      return "Login";
    } catch (e) {
      return "Fail";
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
