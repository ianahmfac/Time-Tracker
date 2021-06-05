import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:time_tracker/services/auth.dart';

class SignInBloc {
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
  SignInBloc({
    required this.auth,
    required this.isLoading,
  });

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);
  Future<User?> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);
  Future<User?> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
}
