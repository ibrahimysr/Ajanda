import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yonetici_paneli/pages/Login/login.dart';
import 'package:yonetici_paneli/pages/Home/control_page.dart';

class FlutterFireAuthService {
  final FirebaseAuth _firebaseauth;
  FlutterFireAuthService(this._firebaseauth);

  Stream<User?> get authStateChanges => _firebaseauth.idTokenChanges();

  Future passwordReset(String email,context) async {
    try {
      await _firebaseauth.sendPasswordResetEmail(email: email);
       showDialog(context: context, builder: (context){
        return const AlertDialog(
            content: Text("Sıfırlama Linki Gönderildi.E postanızı kontrol ediniz"),
         
        );
      });
         Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      debugPrint("$e");
      showDialog(context: context, builder: (context){
        return AlertDialog(
            content: Text(e.message.toString()),
        );
      });
    }
  }

  Future<String> signUp(String email, String password, String username,
      BuildContext context) async {
    try {
      UserCredential userCredential = await _firebaseauth
          .createUserWithEmailAndPassword(email: email, password: password);

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection("Kullanıcılar")
          .doc(userId)
          .set({
        "email": email,
        "Kullanıcı Adı": username,
        "Görev": [],
        "Toplantı": [],
        "Not": [],
      });

      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.size,
              alignment: Alignment.center,
              child: const LoginPage()));

      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Bir hata oluştu";
    }
  }

  Future<String> signIn(
      String email, String password, BuildContext context) async {
    try {
      await _firebaseauth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.size,
              alignment: Alignment.center,
              child: const ControlPage()));

      return "Success";
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context, "Kullanıcı adı veya şifre hatalı ");
      return e.message ?? "Bir hata oluştu";
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseauth.signOut().then((value) => {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()))
        });
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hata"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }
}
