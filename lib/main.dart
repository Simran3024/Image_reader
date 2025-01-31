import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart'; // Import your login page
import 'showing_image.dart'; // Import your showing image page

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
      routes: {
        '/': (context) => AuthCheck(),
        '/login_page': (context) => LoginPage(),
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
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return ShowingImagePage(); // If logged in, navigate to ShowingImagePage
        }
        return LoginPage(); // If not logged in, navigate to LoginPage
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


// FCM Token: crVW7K8GRLGoifMC-C8z5A:APA91bEzv0d3sCxsM6hURvzNoMcaoxw2A0fFxB7kBUigfvhxZzM7sgOMfZw1al3w7pI_GWC74r3iAh4Gl7nGXnGLp8aKRgMkdUSbVuGGcvWKpjKP4S-X8EU

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//   FirebaseMessaging.onBackgroundMessage(
//       _firebaseMessagingBackgroundHandler); // Handle background messages
//   runApp(MyApp());
// }

// // Background message handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? _fcmToken;

//   @override
//   void initState() {
//     super.initState();
//     _initFirebaseMessaging();
//   }

//   void _initFirebaseMessaging() async {
//     // Request notification permissions (necessary for iOS)
//     NotificationSettings settings =
//         await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("User granted permission for notifications");
//     } else {
//       print("User denied notification permissions");
//       return;
//     }

//     // Get FCM token
//     String? token = await FirebaseMessaging.instance.getToken();
//     if (token != null) {
//       setState(() {
//         _fcmToken = token;
//       });
//       print("FCM Token: $token");
//       // You can send this token to your server for further usage
//     }

//     // Listen for foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Received a foreground message: ${message.notification?.title}");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("FCM Token Generator"),
//       ),
//       body: Center(
//         child: _fcmToken == null
//             ? CircularProgressIndicator()
//             : Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   "FCM Token:\n\n$_fcmToken",
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//       ),
//     );
//   }
// }