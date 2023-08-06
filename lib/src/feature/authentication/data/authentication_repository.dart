import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:open_weather_app/src/feature/authentication/model/user.dart';

abstract class IAuthenticationRepository {
  Stream<User> get user;
  Future<void> signUp({
    required String email,
    required String password,
  });
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> logOut();
}

class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  var currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
    );
  }
}
