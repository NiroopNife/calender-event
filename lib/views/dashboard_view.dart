import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text("Table Calender"),
        actions: [
          IconButton(onPressed: () async {
            await signOut();
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.power_settings_new))
        ],
      ),
    );
  }
}
