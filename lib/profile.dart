import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2; // Set the index for Profile page

    void _onItemTapped(int index) {
      if (index == _selectedIndex)
        return; // Do nothing if the same tab is tapped

      switch (index) {
        case 0:
          // Navigate to showing_image.dart
          Navigator.pushReplacementNamed(context, '/showing_image');
          break;
        case 1:
          // Navigate to contact_info.dart
          Navigator.pushReplacementNamed(context, '/contact_info');
          break;
        case 2:
          // Already on Profile page
          break;
      }
    }

    // Fetch the current user
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false, // Removes the back arrow
        titleSpacing: 10, // Adds space to the left of the logo
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image.asset('assets/image1.png', height: 50), // Your logo
            ),
          ],
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.account_circle, color: Colors.green[800], size: 30),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green[800],
                  ),
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                SizedBox(height: 20),
                if (user != null) ...[
                  Text(
                    "Email: ${user.email ?? 'N/A'}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ] else ...[
                  Text("No user logged in", style: TextStyle(fontSize: 18)),
                ],
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () =>
                      _showLogoutDialog(context), // Sign out button
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green[800], // Button background color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () => _showForgotPasswordDialog(
                      context), // Forgot password button
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.green[800], // Match the theme color
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'Flyer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Logout dialog function
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout', style: TextStyle(color: Colors.green[800])),
          content: Text('Do you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _logout(context);
                Navigator.of(context).pop();
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Forgot password dialog function
  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password',
              style: TextStyle(color: Colors.green[800])),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your email to reset your password:'),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[800]!),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _resetPassword(context, _emailController.text.trim());
                Navigator.of(context).pop();
              },
              child: Text('Reset Password',
                  style: TextStyle(color: Colors.green[800])),
            ),
          ],
        );
      },
    );
  }

  // Reset password function
  Future<void> _resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset email: $e')),
      );
    }
  }

  // Logout function
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      Navigator.pushReplacementNamed(
          context, '/login_page'); // Navigate to login page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    }
  }
}
