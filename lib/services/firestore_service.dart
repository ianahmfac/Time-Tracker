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

  Future<void> deleteData({required String path}) async {
    try {
      final ref = FirebaseFirestore.instance.doc(path);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshot = query.snapshots();
    return snapshot.map((event) {
      final result = event.docs
          .map((job) => builder(job.data() as Map<String, dynamic>, job.id))
          .where((element) => element != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => builder(
        snapshot.data() as Map<String, dynamic>,
        snapshot.id,
      ),
    );
  }
}
