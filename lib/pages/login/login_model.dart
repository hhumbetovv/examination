import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../model/subject.dart';
import '../select_view.dart';
import 'login_view.dart';

abstract class LoginModel extends State<LoginView> {
  bool isLoading = false;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLogInPressed() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(userCredential.user?.email);
      final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      final subjectsSnapshot =
          await FirebaseFirestore.instance.collection('subjects').where('id', whereIn: userSnapshot['subjects']).get();

      final subjects = subjectsSnapshot.docs.map((doc) {
        return SubjectModel.fromJson(doc.data());
      }).toList();
      if (userSnapshot['isDynamic']) {
        debugPrint(userSnapshot['isDynamic'].toString());
        String newPassword = const Uuid().v1().substring(0, 8);
        final user = FirebaseAuth.instance.currentUser;
        await user!.updatePassword(newPassword);
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'password': newPassword,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password has ben changed')));
        }
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return SelectView(
              subjects: subjects,
            );
          },
        ));
      }
    } catch (e) {
      String err = '';
      if (e is FirebaseAuthException && e.message != null) {
        err = e.message!;
      } else {
        err = e.toString();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
    setState(() {
      isLoading = false;
    });
  }
}
