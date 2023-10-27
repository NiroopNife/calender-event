import 'package:flutter/material.dart';
import 'package:table_calender_event/services/auth_service.dart';
import 'package:table_calender_event/views/views.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            FilledButton(
              onPressed: () async {
                await AuthService().signInWithGoogle();
                if (mounted) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardView()));
                }
              },
              child: const Text("Sign In with Google"),
            ),
          ],
        ),
      ),
    );
  }
}
