import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/home_wrapper.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user == null
              ? SignInPage.create(context)
              : Provider<Database>(
                  create: (_) => FirestoreDatabase(uid: user.uid),
                  child: HomeWrapper(),
                );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
