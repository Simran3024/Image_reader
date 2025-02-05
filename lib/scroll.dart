// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// class ShowingImagePage extends StatefulWidget {
//   @override
//   _ShowingImagePageState createState() => _ShowingImagePageState();
// }

// class _ShowingImagePageState extends State<ShowingImagePage> {
//   List<File> pdfFiles = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchPdfsOnly(); // Fetch only PDFs
//   }

//   Future<void> fetchPdfsOnly() async {
//     try {
//       // Fetch only PDFs from the '/pdf/' folder
//       final pdfRefs = await FirebaseStorage.instance.ref('pdf/').listAll();
//       final pdfUrls =
//           await Future.wait(pdfRefs.items.map((ref) => ref.getDownloadURL()));

//       // Download all PDFs
//       final downloadedPdfs =
//           await Future.wait(pdfUrls.map((url) => _downloadPdf(url)));

//       if (mounted) {
//         setState(() {
//           pdfFiles =
//               downloadedPdfs.whereType<File>().toList(); // Remove null values
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching PDFs: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch PDFs')),
//       );
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   Future<File?> _downloadPdf(String url) async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       final dir = await getApplicationDocumentsDirectory();
//       final file = File('${dir.path}/${Uri.parse(url).pathSegments.last}');
//       await file.writeAsBytes(response.bodyBytes);
//       return file;
//     } catch (e) {
//       print("Error downloading PDF: $e");
//       return null;
//     }
//   }

//   Future<void> _logout(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.pushReplacementNamed(context, '/login_page');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to log out: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Padding(
//           padding: const EdgeInsets.only(top: 20.0),
//           child: Image.asset('assets/image1.png', height: 80),
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : pdfFiles.isEmpty
//               ? Center(
//                   child:
//                       Text("No PDFs available", style: TextStyle(fontSize: 18)))
//               : SingleChildScrollView(
//                   child: Column(
//                     children: pdfFiles.map((file) {
//                       return Container(
//                         height: MediaQuery.of(context).size.height *
//                             0.75, // Adjusted height
//                         margin: EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey, width: 1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: PDFView(
//                             filePath: file.path,
//                             enableSwipe: true,
//                             swipeHorizontal: false,
//                             autoSpacing: true,
//                             pageFling: true,
//                             fitPolicy: FitPolicy.BOTH,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.transparent,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.account_circle,
//                     size: 40, color: Colors.green[800]),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Profile'),
//                         content: Text('Do you want to log out?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               _logout(context);
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('Logout'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
