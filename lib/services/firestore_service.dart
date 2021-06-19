import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final instance = FirestoreService._();

  Future<void> setData({
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

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshot = reference.snapshots();
    return snapshot.map(
      (event) => event.docs.map((job) {
        final data = job.data();
        return builder(data, job.id);
      }).toList(),
    );
  }
}
