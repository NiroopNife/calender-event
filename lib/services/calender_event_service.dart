import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calender_event/services/auth_service.dart';

class CalenderEventService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createDayEvent(DateTime date, String eventName) async {
    try {

      String userId = AuthService().getCurrentUser()!.uid;

      await usersCollection.doc(userId).collection('events').add({
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