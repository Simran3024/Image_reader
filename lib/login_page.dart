import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Navigate to signup page
import 'showing_image.dart'; // Import ShowingImagePage correctly
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false; // To toggle the visibility of password

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      // Validate that all inputs are filled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email and password')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Check if the email is verified
        if (userCredential.user!.emailVerified) {
          // On successful login, show success message and navigate
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ShowingImagePage()),
          );
        } else {
          // If email is not verified, show a message and ask the user to verify
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please verify your email before logging in.',
                style: TextStyle(color: Colors.white), // White text color
              ),
              backgroundColor: Colors.red, // Red background color
            ),
          );

          await _auth.signOut(); // Sign out the user
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      // Detailed error handling with user-friendly messages
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email address.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format. Please check your email.';
      } else {
        errorMessage =
            'Failed to log in. Please check your email and password.';
      }

      // Display the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Handle any unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 150.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo appears after the AppBar
              Image.asset(
                'assets/image1.png', // Ensure the correct path
                height: 100, // Adjust size as needed
              ),
              SizedBox(height: 20), // Space between logo and form

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0), // Add bottom padding
                    child: Text(
                      'LOGIN NOW',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                        fontFamily: 'Times New Roman',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0), // Add bottom padding
                    child: Text(
                      'TO GET ACCESS TO TODAY’S SPECIAL MENU AND DEALS!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                        fontFamily: 'Times New Roman',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30), // Space between heading and form
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Colors.green[800]), // Green label color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green[800]!), // Green focused border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green[800]!,
                        width: 1.5), // Green border color
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.green[800]),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Colors.green[800]), // Green label color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green[800]!), // Green focused border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green[800]!,
                        width: 1.5), // Green border color
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.green[800]),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.green[800],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800], // Green button color
                  foregroundColor: Colors.white, // White text color on button
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style:
                      TextStyle(color: Colors.green[800]), // Green text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
