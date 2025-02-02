import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Ensure this import points to your login page
import 'showing_image.dart'; // Replace with your home page widget

class AuthCheck extends StatelessWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // User is signed in
          return ShowingImagePage(); // Replace with your home page widget
        } else {
          // User is not signed in
          return LoginPage(); // Replace with your login page widget
        }
      },
    );
  }
}
