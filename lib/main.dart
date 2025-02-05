import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Ensure this points to your LoginPage implementation
import 'showing_image.dart';
import 'contact_info.dart';
import 'profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Temporarily comment out App Check activation for testing
  /*
  if (kIsWeb) {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('your-recaptcha-site-key'), // Replace with your actual reCAPTCHA site key
    );
  }
  */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Viewer App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/login_page', // Set the initial route to login_page
      routes: {
        '/login_page': (context) => LoginPage(), // Ensure LoginPage is defined
        '/showing_image': (context) => ShowingImagePage(),
        '/contact_info': (context) => ContactInfoPage(),
        '/profile': (context) => ProfilePage(),
      },
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
