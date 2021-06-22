class Entry {
  Entry({
    required this.id,
    required this.jobId,
    required this.start,
    required this.end,
    this.comment,
  });
  final String id;
  final String jobId;
  final DateTime start;
  final DateTime end;
  final String? comment;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map, String id) {
    return Entry(
      id: id,
      jobId: map['jobId'],
      start: DateTime.fromMillisecondsSinceEpoch(map['start']),
      end: DateTime.fromMillisecondsSinceEpoch(map['end']),
      comment: map['comment'],
    );
  }
}
