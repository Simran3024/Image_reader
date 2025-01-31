import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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

    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/resources/image?type=upload");

    final headers = {
      'Authorization':
          'Basic ' + base64Encode(utf8.encode("$apiKey:$apiSecret"))
    };

    try {
      final response = await http.get(url, headers: headers);
      print("Cloudinary Response: ${response.body}");

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

  void _makeCall() async {
    final Uri phoneNumber = Uri.parse("tel:+919803691329");

    if (await canLaunchUrl(phoneNumber)) {
      await launchUrl(phoneNumber, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch call");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch call')),
      );
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.account_circle,
                    size: 40, color: Colors.green[800]),
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
              IconButton(
                icon: Icon(Icons.call, size: 40, color: Colors.green[800]),
                onPressed: _makeCall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
