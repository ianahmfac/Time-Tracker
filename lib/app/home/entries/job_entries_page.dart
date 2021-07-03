import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/entries/entry_list_item.dart';
import 'package:time_tracker/app/home/entries/entry_page.dart';
import 'package:time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/list_item_builder.dart';
import 'package:time_tracker/widgets/platform_alert_dialog.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({required this.database, required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      PlatformAlertDialog(
        titleText: 'Operation Failed',
        contentText: e.toString(),
        buttonDialogText: 'OK',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobDocStream(jobId: job.id),
        builder: (context, snapshot) {
          String jobName = '';
          if (snapshot.hasData) {
            jobName = snapshot.data?.name ?? '';
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  onPressed: () =>
                      EditJobPage.show(context, db: database, job: job),
                ),
              ],
            ),
            body: _buildContent(context, job),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => EntryPage.show(
                  context: context, database: database, job: job),
            ),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
