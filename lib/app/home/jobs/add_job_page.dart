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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Job'),
      ),
      body: _buildContent(),
    );
  }
}

Widget _buildContent() {
  return SingleChildScrollView(
    child: Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Placeholder(
          fallbackHeight: 200,
        ),
      ),
    ),
  );
}
