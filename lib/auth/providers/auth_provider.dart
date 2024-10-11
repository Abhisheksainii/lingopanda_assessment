import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingopanda_assessment/auth/models/user_model.dart';
import 'package:lingopanda_assessment/utils/log_utils.dart';
import 'package:lingopanda_assessment/utils/result.dart';

class AuthenticationProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? errorMessage;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isNewUser = false;
  bool get isNewUser => _isNewUser;

  set isNewUser(bool val) {
    _isNewUser = val;
    notifyListeners();
  }

  Future<Result<bool>> signUpWithEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Store user data in Firestore
        final authUser = FirebaseAuth.instance.currentUser;
        if (authUser != null) {
          final user = UserModel(
              uid: authUser.uid,
              email: emailController.text,
              name: nameController.text);
          await firestore
              .collection("users")
              .doc(authUser.uid)
              .set(user.toJson());
        }
        return const Result.success(data: true);
      } on FirebaseAuthException catch (e) {
        logger.e(e);
        return Result.failure(reason: e.message ?? "Something went wrong");
      }
    }
    return const Result.success(data: false);
  }

  Future<Result<bool>> signInWithEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        return const Result.success(data: true);
      } on FirebaseAuthException catch (e) {
        return Result.failure(reason: e.message ?? "Something went wrong");
      }
    }
    return const Result.success(data: false);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
