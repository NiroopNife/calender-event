import 'package:cloud_firestore/cloud_firestore.dart';

extension DateExtension on Timestamp {
  DateTime get dateTimeFromTimeStamp {
    return toDate();
  }
}
