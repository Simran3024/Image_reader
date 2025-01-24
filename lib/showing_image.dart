import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowingImagePage extends StatefulWidget {
  @override
  _ShowingImagePageState createState() => _ShowingImagePageState();
}

class _ShowingImagePageState extends State<ShowingImagePage> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    const cloudName = "dlmq3cle6";
    const apiKey = "183218817666858";
    const apiSecret = "aJENQJTwJhLcqyIgRgi40ZxyqXs";
    const folder = "public"; // Fetch images only from 'public' folder

    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/resources/image?type=upload");

    final headers = {
      'Authorization':
          'Basic ' + base64Encode(utf8.encode("$apiKey:$apiSecret"))
    };

    try {
      final response = await http.get(url, headers: headers);
      print("Cloudinary Response: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey("resources")) {
          if (mounted) {
            setState(() {
              imageUrls = (data["resources"] as List)
                  .map((img) => img["secure_url"].toString())
                  .toList();
            });
          }
        }
      } else {
        print("Failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login_page');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up resources if necessary
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
          child: Image.asset('assets/image1.png', height: 80),
        ),
      ),
      body: imageUrls.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                      height: 300,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Center(child: Text("Failed to load image")),
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Profile'),
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

// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ShowingImagePage extends StatefulWidget {
//   @override
//   _ShowingImagePageState createState() => _ShowingImagePageState();
// }

// class _ShowingImagePageState extends State<ShowingImagePage> {
//   List<String> imageUrls = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchImages();
//   }

//   // Future<void> fetchImages() async {
//   //   const cloudName = "dlmq3cle6"; // Replace with your Cloudinary cloud name
//   //   const apiKey = "183218817666858"; // Replace with your Cloudinary API Key
//   //   const apiSecret =
//   //       "aJENQJTwJhLcqyIgRgi40ZxyqXs"; // Replace with your Cloudinary API Secret
//   //   const folder = "public"; // Folder where images are stored

//   //   final url = Uri.parse(
//   //       "https://api.cloudinary.com/v1_1/$cloudName/resources/image?prefix=$folder/");

//   //   final headers = {
//   //     'Authorization':
//   //         'Basic ' + base64Encode(utf8.encode("$apiKey:$apiSecret"))
//   //   };

//   //   try {
//   //     final response = await http.get(url, headers: headers);
//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);

//   //       // Debugging: Print the response to check structure
//   //       print("Cloudinary API Response: $data");

//   //       if (data.containsKey("resources") && data["resources"] is List) {
//   //         setState(() {
//   //           imageUrls = (data["resources"] as List)
//   //               .map((img) =>
//   //                   img["secure_url"].toString()) // Ensure it's a string
//   //               .toList();
//   //         });
//   //       } else {
//   //         print("No 'resources' key found in API response.");
//   //       }
//   //     } else {
//   //       print(
//   //           "Failed to fetch images: ${response.statusCode} - ${response.body}");
//   //     }
//   //   } catch (e) {
//   //     print("Error fetching images: $e");
//   //   }
//   // }
//   Future<void> fetchImages() async {
//     const cloudName = "dlmq3cle6";
//     const apiKey = "183218817666858";
//     const apiSecret =
//         "aJENQJTwJhLcqyIgRgi40ZxyqXs"; // Replace with your Cloudinary API Secret
//     const folder = "public";

//     final url = Uri.parse(
//         "https://api.cloudinary.com/v1_1/$cloudName/resources/image/upload?prefix=$folder&max_results=10");

//     final headers = {
//       'Authorization':
//           'Basic ' + base64Encode(utf8.encode("$apiKey:$apiSecret"))
//     };

//     try {
//       final response = await http.get(url, headers: headers);
//       print("Cloudinary Response: ${response.body}"); // Debugging

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.containsKey("resources")) {
//           setState(() {
//             imageUrls = (data["resources"] as List)
//                 .map((img) => img["secure_url"].toString())
//                 .toList();
//           });
//         }
//       } else {
//         print("Failed: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       print("Error: $e");
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
//       body: imageUrls.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: ListView.builder(
//                 itemCount: imageUrls.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CachedNetworkImage(
//                       imageUrl: imageUrls[index],
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                       height: 300,
//                       placeholder: (context, url) =>
//                           Center(child: CircularProgressIndicator()),
//                       errorWidget: (context, url, error) =>
//                           Center(child: Text("Failed to load image")),
//                     ),
//                   );
//                 },
//               ),
//             ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.transparent,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: IconButton(
//             icon:
//                 Icon(Icons.account_circle, size: 40, color: Colors.green[800]),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('Profile'),
//                     content: Text('Do you want to log out?'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           _logout(context);
//                           Navigator.of(context).pop();
//                         },
//                         child: Text('Logout'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
