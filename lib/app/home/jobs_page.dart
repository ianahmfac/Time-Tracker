import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/platform_alert_dialog.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final alertShowed = await PlatformAlertDialog(
        titleText: 'Confirmation Sign Out',
        contentText: 'Are you sure to sign out from this account?',
        buttonDialogText: 'Sign Out',
        cancelButtonDialogText: 'Cancel',
      ).show(context);
      if (alertShowed!) await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  void _addNewJob(BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);
    await db.createJob(Job(name: 'Mobile Developer', ratePerHour: 250000));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          TextButton(
            onPressed: () => _signOut(context),
            child: Text(
              'Sign Out',
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          )
        ],
      ),
      body: Center(
        child: Text(auth.currentUser?.email ?? 'Anonymous User'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_task),
        onPressed: () => _addNewJob(context),
      ),
    );
  }
}
