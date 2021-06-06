import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/models/job.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({
    required this.uid,
  });

  @override
  Future<void> createJob(Job job) async {
    final path = '/users/$uid/jobs';
    final collectionRef = FirebaseFirestore.instance.collection(path);

    await collectionRef.doc().set(job.toMap());
  }
}
