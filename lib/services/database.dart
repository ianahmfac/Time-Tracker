import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({
    required this.uid,
  });

  @override
  Future<void> createJob(Job job) async => _setData(
        path: APIPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );

  Future<void> _setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final ref = FirebaseFirestore.instance.doc(path);
      await ref.set(data);
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }
}
