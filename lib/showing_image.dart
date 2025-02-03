import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Add flutter_pdfview package
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'login_page.dart'; // Import the login page
import 'contact_info.dart';
import 'profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Viewer',
      home: ShowingImagePage(),
      routes: {
        '/contact_info': (context) =>
            ContactInfoPage(), // Assuming this page exists
        '/profile': (context) => ProfilePage(), // Assuming this page exists
      },
    );
  }
}

class ShowingImagePage extends StatefulWidget {
  @override
  _ShowingImagePageState createState() => _ShowingImagePageState();
}

class _ShowingImagePageState extends State<ShowingImagePage> {
  List<String> pdfUrls = []; // Store PDF URLs
  bool isLoading = true;
  String? selectedPdfUrl; // Store the local file path of the selected PDF
  int _selectedIndex = 0; // Track selected index for BottomNavigationBar

  @override
  void initState() {
    super.initState();
    fetchPdfUrls(); // Fetch URLs when the page loads
  }

  // Fetch all PDF URLs from Firebase Realtime Database
  void fetchPdfUrls() async {
    final ref = FirebaseDatabase.instance.ref().child('pdfs');
    final snapshot = await ref.get(); // Get all items from the 'pdfs' node

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      List<String> urls = [];

      // Extract the 'url' field for each item
      data.forEach((key, value) {
        if (value['url'] != null) {
          urls.add(value['url']);
        }
      });

      if (urls.isNotEmpty) {
        // Automatically download and display the first PDF
        String firstPdfPath = await downloadPdf(urls.first);
        setState(() {
          pdfUrls = urls;
          selectedPdfUrl = firstPdfPath;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to download the PDF from URL and return the local file path
  Future<String> downloadPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/contact_info');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 10,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image.asset('assets/image1.png', height: 50),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.black, size: 30),
            onPressed: _showLogoutDialog, // Show logout popup
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while fetching
          : selectedPdfUrl != null
              ? PDFView(
                  filePath: selectedPdfUrl) // Display the first available PDF
              : Center(
                  child: Text('No PDFs available')), // Show message if no PDFs
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.picture_as_pdf), label: 'Flyer'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail), label: 'Contact Info'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
