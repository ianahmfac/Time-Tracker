import 'package:flutter/material.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);
  static Future<void> show(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddJobPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (!form.validate()) return false;
    form.save();
    return true;
  }

  void _submit() {
    if (_validateAndSaveForm()) {
      print('Job Name: $_name');
      print('Rate per hour: $_ratePerHour');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Job'),
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
        onSaved: (newValue) => _ratePerHour = int.parse(newValue.toString()),
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
