import 'package:flutter/material.dart';
import 'package:going_live/screens/signUp_screen.dart';
import 'package:going_live/widgets/custom_button.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static const routeName = "/onboarding";
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome \n to Go Live",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
                text: 'Log In',
              ),
            ),
            CustomButton(
              onTap: () {
                Navigator.pushNamed(context, SignUpScreen.routeName);
              },
              text: 'Sign Up',
            ),
          ],
        ),
      ),
    );
  }
}
