import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/landing_page.dart';
import 'package:time_tracker/services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Provider<AuthBase>(
        create: (context) => Auth(),
        child: MaterialApp(
          title: 'Time Tracker',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: LandingPage(),
        ),
      ),
    );
  }
}
