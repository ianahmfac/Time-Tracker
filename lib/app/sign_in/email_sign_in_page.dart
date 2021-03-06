import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In with Email'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: EmailSignInFormChangeNotifier.create(context),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
