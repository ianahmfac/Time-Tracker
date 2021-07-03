import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/services/firestore_service.dart';
import 'package:time_tracker/utils/api_path.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);
  Stream<Job> jobDocStream({required String jobId});

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job? job});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({
    required this.uid,
  });

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> deleteJob(Job job) async {
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    await _service.deleteData(path: APIPath.job(uid, job.id));
  }

  @override
  Future<void> deleteEntry(Entry entry) {
    return _service.deleteData(path: APIPath.entry(uid, entry.id));
  }

  @override
  Stream<List<Entry>> entriesStream({Job? job}) {
    return _service.collectionStream<Entry>(
      path: APIPath.entries(uid),
      builder: (data, documentId) => Entry.fromMap(data, documentId),
      queryBuilder: job != null
          ? (query) => query.where('jobId', isEqualTo: job.id)
          : null,
      sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
    );
  }

  @override
  Future<void> setEntry(Entry entry) {
    return _service.setData(
      path: APIPath.entry(uid, entry.id),
      data: entry.toMap(),
    );
  }

  @override
  Stream<Job> jobDocStream({required String jobId}) {
    return _service.documentStream(
      path: APIPath.job(uid, jobId),
      builder: (data, documentID) => Job.fromMap(data, documentID),
    );
  }
}
