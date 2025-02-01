import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'showing_image.dart'; // Ensure this import is correct
import 'contact_info.dart'; // Ensure this import is correct
import 'profile.dart'; // Ensure this import is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Viewer App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthCheck(),
        '/login_page': (context) => LoginPage(),
        '/showing_image': (context) => ShowingImagePage(), // Add this route
        '/contact_info': (context) => ContactInfoPage(),
        '/profile': (context) => ProfilePage(),
      },
      // Optional: Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.green, // Green background
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Peasant B', // Heading text
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome! Don\'t Miss Out on Today\'s Special Discount – Just for You!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          // If logged in, navigate to ShowingImagePage
          return ShowingImagePage();
        }
        // If not logged in, navigate to LoginPage
        return LoginPage();
      },
    );
  }
}
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'login_page.dart'; // Import your login page
// import 'old_showing_image.dart';
// import 'showing_image.dart'; // Import your showing image page
// import 'package:firebase_auth/firebase_auth.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // Define routes here
//       routes: {
//         '/': (context) => AuthCheck(),
//         '/login_page': (context) => LoginPage(),
//       },
//     );
//   }
// }

// class AuthCheck extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(body: Center(child: CircularProgressIndicator()));
//         }
//         if (snapshot.hasData) {
//           return ShowingImagePage(); // Navigate to ShowingImagePage if logged in
//         }
//         return LoginPage(); // Navigate to LoginPage if not logged in
//       },
//     );
//   }
// }
