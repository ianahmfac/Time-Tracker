import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/entries/job_entries_page.dart';
import 'package:time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/list_item_builder.dart';
import 'package:time_tracker/widgets/platform_alert_dialog.dart';

class JobsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final db = Provider.of<Database>(context, listen: false);
      final isConfirmed = await PlatformAlertDialog(
        titleText: 'Delete Item',
        contentText: 'Do you want to delete this item?',
        buttonDialogText: 'Delete',
        cancelButtonDialogText: 'Cancel',
      ).show(context);
      if (isConfirmed!) await db.deleteJob(job);
    } catch (e) {
      PlatformAlertDialog(
        titleText: 'Something Went Wrong',
        contentText: e.toString(),
        buttonDialogText: 'OK',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          IconButton(
            onPressed: () => EditJobPage.show(context, db: db),
            icon: Icon(
              Icons.add_task,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: db.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Slidable(
            key: Key('job-${job.id}'),
            actionPane: SlidableDrawerActionPane(),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
            secondaryActions: [
              IconSlideAction(
                color: Colors.red,
                icon: Icons.delete,
                caption: 'Delete',
                onTap: () => _delete(context, job),
                closeOnTap: false,
              ),
            ],
          ),
        );
      },
    );
  }
}
