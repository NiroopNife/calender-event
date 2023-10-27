import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calender_event/services/auth_service.dart';

class CalenderEventService {
  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection("events");

  Future<void> createDayEvent(DateTime date, String eventName) async {
    try {
      await eventsCollection.add({
        "uId" : AuthService().getCurrentUser()?.uid,
        "date" : date,
        "event_name" : eventName
      });
    } catch (e) {}
  }

}