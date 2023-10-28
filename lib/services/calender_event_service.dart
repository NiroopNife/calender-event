import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calender_event/services/auth_service.dart';

class CalenderEventService {
  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection("events");

  Future<void> createDayEvent(DateTime date, String eventName) async {
    try {
      await eventsCollection.add({
        "uId": AuthService()
            .getCurrentUser()
            ?.uid,
        "date": date,
        "event_name": eventName
      });
    } catch (e) {}
  }

  Future<List<DocumentSnapshot>> getEvents(DateTime chosenDay) async {
    Map<String, dynamic> _events = {};

    final firstDay = DateTime(chosenDay.year, chosenDay.month, 1);
    final lastDay = DateTime(chosenDay.year, chosenDay.month + 1, 0);


    return [];
  }
}