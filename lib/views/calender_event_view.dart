import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calender_event/model/event_model.dart';
import 'package:table_calender_event/services/auth_service.dart';
import 'package:table_calender_event/services/calender_event_service.dart';
import 'package:table_calender_event/views/widgets/event_item.dart';

class CalenderEventView extends StatefulWidget {
  const CalenderEventView({super.key});

  @override
  State<CalenderEventView> createState() => _CalenderEventViewState();
}

class _CalenderEventViewState extends State<CalenderEventView> {

  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Event>> _events;
  final DateTime _today = DateTime.now();

  final _eventController = TextEditingController();

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _loadFireStoreEvents();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  _loadFireStoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection("events")
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(fromFirestore: Event.fromFireStore, toFirestore: (event, options) => event.toFireStore())
        .get();

    for (var doc in snap.docs) {
      final event = doc.data();
      final day = DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: const Text("Event name"),
                content: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _eventController,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _events.addAll({
                        _selectedDay: [
                          Event(
                              id: AuthService().getCurrentUser()!.uid,
                              date: _selectedDay,
                              title: _eventController.text)
                        ]
                      });
                      CalenderEventService().createDayEvent(_selectedDay, _eventController.text);
                      _eventController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Submit"),
                  )
                ],
              );
            },
          );
        },
      ),
      body: Column(
        children: [
          SizedBox(
            child: TableCalendar(
              locale: "en_US",
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 01, 01),
              lastDay: _today,
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _getEventsForDay,
            ),
          ),
          ..._getEventsForDay(_selectedDay).map(
            (event) => EventItem(
              event: event,
              onDelete: () {},
            ),
          ),
        ],
      ),
    );
  }
}
