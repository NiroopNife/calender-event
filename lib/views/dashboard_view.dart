import 'package:flutter/material.dart';
import 'package:table_calender_event/services/auth_service.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text("Table Calender"),
        actions: [
          IconButton(onPressed: () async {
            await AuthService().logout();
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.power_settings_new))
        ],
      ),
    );
  }
}
