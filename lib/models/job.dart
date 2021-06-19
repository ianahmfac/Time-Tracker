class Job {
  final String id;
  final String name;
  final int ratePerHour;
  Job({
    required this.id,
    required this.name,
    required this.ratePerHour,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map, String id) {
    return Job(
      id: id,
      name: map['name'],
      ratePerHour: map['ratePerHour'],
    );
  }
}
