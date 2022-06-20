import 'package:flutter/material.dart';
import 'package:going_live/resources/auth_method.dart';
import 'package:going_live/screens/home_screen.dart';
import 'package:going_live/widgets/customTextField.dart';
import 'package:going_live/widgets/custom_button.dart';
import 'package:going_live/widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthMethods authMethods = AuthMethods();
  bool isLoading = false;

  loginUser() async {
    setState(() {
      isLoading = true;
    });
    bool res = await authMethods.loginUser(
      context,
      emailController.text,
      passwordController.text,
    );
    setState(() {
      isLoading = false;
    });
    if (res) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "LogIn",
        ),
      ),
      body: isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.1),
                    const Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomTextField(
                        controller: emailController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomTextField(
                        controller: passwordController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(onTap: loginUser, text: "LogIn"),
                  ],
                ),
              ),
            ),
    );
  }
}
