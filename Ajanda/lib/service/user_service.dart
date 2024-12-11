import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _currentUser;

  UserProvider() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;
}