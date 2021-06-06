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
    try {
      final db = Provider.of<Database>(context, listen: false);
      await db.createJob(Job(name: 'Flutter Developer', ratePerHour: 250000));
    } catch (e) {
      PlatformAlertDialog(
        titleText: 'Something went wrong',
        contentText: e.toString(),
        buttonDialogText: 'Close',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_task),
        onPressed: () => _addNewJob(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: db.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.data!.isNotEmpty) {
          final jobs = snapshot.data!;
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return ListTile(
                title: Text(job.name),
                subtitle: Text(job.ratePerHour.toString()),
              );
            },
          );
        }
        return Center(
          child: Text('Jobs is empty'),
        );
      },
    );
  }
}
