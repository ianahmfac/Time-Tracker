import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({
    required this.uid,
  });

  final _service = FirestoreService.instance;

  String get _documentId => DateTime.now().toIso8601String();

  @override
  Future<void> createJob(Job job) async => _service.setData(
        path: APIPath.job(uid, _documentId),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
