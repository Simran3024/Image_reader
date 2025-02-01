import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 1; // Set the index for Contact Info page

    void _onItemTapped(int index) {
      if (index == _selectedIndex)
        return; // Do nothing if the same tab is tapped

      switch (index) {
        case 0:
          // Navigate to showing_image.dart
          Navigator.pushReplacementNamed(context, '/showing_image');
          break;
        case 1:
          // Already on Contact Info page
          break;
        case 2:
          // Navigate to profile.dart
          Navigator.pushReplacementNamed(context, '/profile');
          break;
      }
    }

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
              child: Image.asset('assets/image1.png',
                  height: 50), // Updated logo path
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Company logo & title
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/icon/icon1.png'),
            ),
            SizedBox(height: 20),
            Text(
              "Peasantb GmbH",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 10),

            // Address & Contact Info Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.green[800]),
                        SizedBox(width: 10),
                        Text(
                          "Franken 46, 84082 Laberweiting",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.green[800]),
                        SizedBox(width: 10),
                        Text(
                          "hsingh@peasantb.de",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.language, color: Colors.green[800]),
                        SizedBox(width: 10),
                        Text(
                          "peasantb.de",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
          title: Text('Logout'),
          content: Text('Do you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
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

  // Logout function
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login_page');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out')),
      );
    }
  }
}
