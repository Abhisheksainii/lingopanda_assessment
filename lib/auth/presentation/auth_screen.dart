import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lingopanda_assessment/auth/providers/auth_provider.dart';
import 'package:lingopanda_assessment/common/snackbar.dart';
import 'package:lingopanda_assessment/common/widgets/custom_button.dart';
import 'package:lingopanda_assessment/news/presentation/my_news.dart';
import 'package:lingopanda_assessment/utils/colors.dart';
import 'package:lingopanda_assessment/utils/styles.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.scaffoldBackgroundColor,
        title: Text(
          'MyNews',
          style: Styles.bodyTextStyle1.copyWith(color: AppColor.blue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Email/Password Sign Up
              AuthenticationForm(
                height: height,
                formKey: authProvider.formKey,
                width: width,
                authProvider: authProvider,
              ),
              Column(
                children: [
                  CustomButton(
                    ontap: () async {
                      if (authProvider.isNewUser) {
                        if (authProvider.nameController.text.isEmpty) {
                          showCustomSnackbar(context, "Please type your name!");
                          return;
                        }
                      } else {
                        if (authProvider.emailController.text.isEmpty) {
                          showCustomSnackbar(
                              context, "Please type your email!");
                          return;
                        } else if (authProvider
                            .passwordController.text.isEmpty) {
                          showCustomSnackbar(
                              context, "Please type your password!");
                          return;
                        }
                      }
                      final result = authProvider.isNewUser
                          ? await authProvider.signUpWithEmailAndPassword()
                          : await authProvider.signInWithEmailAndPassword();
                      result.when(success: (data) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const MyNews();
                        }));
                      }, failure: (e) {
                        showCustomSnackbar(context, e);
                        return;
                      });
                    },
                    width: width,
                    height: height,
                    text: authProvider.isNewUser ? "Signup" : "Login",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      text: authProvider.isNewUser
                          ? "Already have an account? "
                          : "New here? ",
                      style: Styles.inputTextStyle,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => authProvider.isNewUser =
                                !authProvider.isNewUser,
                          text: authProvider.isNewUser ? "Login" : "Signup",
                          style: Styles.bodyTextStyle2.copyWith(
                            color: AppColor.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Email/Password Sign In
            ],
          ),
        ),
      ),
    );
  }
}

class AuthenticationForm extends StatelessWidget {
  const AuthenticationForm({
    super.key,
    required this.height,
    required this.width,
    required this.authProvider,
    required this.formKey,
  });

  final double height;
  final double width;
  final AuthenticationProvider authProvider;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.2),
        child: Column(
          children: [
            if (authProvider.isNewUser) ...[
              AuthTextField(
                width: width,
                authProvider: authProvider,
                hintText: "Name",
                controller: authProvider.nameController,
              ),
              const SizedBox(
                height: 18,
              ),
            ],
            AuthTextField(
              width: width,
              authProvider: authProvider,
              hintText: "Email",
              controller: authProvider.emailController,
            ),
            const SizedBox(
              height: 18,
            ),
            AuthTextField(
              width: width,
              obscureText: true,
              authProvider: authProvider,
              hintText: "Password",
              controller: authProvider.passwordController,
            ),
          ],
        ),
      ),
    );
  }
}

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.width,
    required this.authProvider,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });

  final double width;
  final AuthenticationProvider authProvider;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.9,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 12),
      child: TextField(
        obscureText: !_passwordVisible && widget.obscureText,
        cursorHeight: 18,
        controller: widget.controller,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: Styles.inputTextStyle,
          labelStyle: Styles.inputTextStyle,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColor.darkBlue,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
