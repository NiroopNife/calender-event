import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final DateTime date;

  Event({
    required this.id,
    required this.title,
    required this.date,
  });

  factory Event.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot, [SnapshotOptions? options]) {
    final data = snapshot.data();
    return Event(
      id: snapshot.id,
      title: data?['event_name'],
      date: data?['date'].toDate(),
    );
  }

  Map<String, Object?> toFireStore() {
    return {
      "date" : Timestamp.fromDate(date),
      "event_name" : title
    };
  }
}
