import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class ShowingImagePage extends StatelessWidget {
  final List<String> imageUrls = [
    "https://res.cloudinary.com/dlmq3cle6/image/upload/v1737561216/241218_-_250108_Das_Angebot-2_vkxk8j.png",
    "https://res.cloudinary.com/dlmq3cle6/image/upload/v1737561209/241218_-_250108_Das_Angebot-3_lyknkx.png",
    "https://res.cloudinary.com/dlmq3cle6/image/upload/v1737561196/241218_-_250108_Das_Angebot-1_uzmjxz.png",
    "https://res.cloudinary.com/dlmq3cle6/image/upload/v1737561191/241218_-_250108_Das_Angebot-4_c6oifc.png",
  ];

  // Function to log out the user
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out user
      Navigator.pushReplacementNamed(context, '/login_page');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to log out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Image.asset('assets/image1.png', height: 80), // Logo Image
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ListView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300, // Set height for better visibility
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Center(child: Text("Failed to load image")),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon:
                Icon(Icons.account_circle, size: 40, color: Colors.green[800]),
            onPressed: () {
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Profile'),
                    content: Text('Do you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _logout(context); // Call logout function
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
