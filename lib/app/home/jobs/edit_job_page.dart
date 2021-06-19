import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/platform_alert_dialog.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job? job;
  const EditJobPage({
    Key? key,
    required this.database,
    this.job,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {Job? job}) async {
    final db = Provider.of<Database>(context, listen: false);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: db,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (!form.validate()) return false;
    form.save();
    return true;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNameJob = jobs.map((e) => e.name).toList();
        if (widget.job != null) {
          allNameJob.remove(widget.job?.name);
        }
        if (allNameJob.contains(_name)) {
          PlatformAlertDialog(
            titleText: 'Name already used',
            contentText: 'Please choose a different job name',
            buttonDialogText: 'OK',
          ).show(context);
          return;
        }
        final id = widget.job?.id ?? documentIdFromCurrentDate();
        final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);
        await widget.database.setJob(job);
        Navigator.pop(context);
      } catch (e) {
        PlatformAlertDialog(
          titleText: 'Operation Failed',
          contentText: e.toString(),
          buttonDialogText: 'OK',
        ).show(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job?.name;
      _ratePerHour = widget.job?.ratePerHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job != null ? 'Edit Job' : 'New Job'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18),
            ),
            style: TextButton.styleFrom(primary: Colors.white),
          )
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        onSaved: (newValue) => _name = newValue,
        validator: (value) {
          if (value!.isEmpty) return 'Job name cannot be empty';
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Job Name',
        ),
      ),
      SizedBox(height: 8),
      TextFormField(
        initialValue: _ratePerHour != null ? _ratePerHour.toString() : null,
        onSaved: (newValue) =>
            _ratePerHour = int.tryParse(newValue.toString()) ?? 0,
        validator: (value) {
          if (value!.isEmpty) return 'Rate hour cannot be empty';
          return null;
        },
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        decoration: InputDecoration(
          labelText: 'Rate per Hour',
        ),
      ),
    ];
  }
}
