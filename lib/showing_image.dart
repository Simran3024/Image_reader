import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ShowingImagePage extends StatefulWidget {
  @override
  _ShowingImagePageState createState() => _ShowingImagePageState();
}

class _ShowingImagePageState extends State<ShowingImagePage> {
  List<File> pdfFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPdfsOnly();
  }

  Future<void> fetchPdfsOnly() async {
    try {
      final pdfRefs = await FirebaseStorage.instance.ref('pdf/').listAll();
      final pdfUrls =
          await Future.wait(pdfRefs.items.map((ref) => ref.getDownloadURL()));

      final downloadedPdfs =
          await Future.wait(pdfUrls.map((url) => _downloadOrGetCachedPdf(url)));

      if (mounted) {
        setState(() {
          pdfFiles = downloadedPdfs.whereType<File>().toList();
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch PDFs')),
      );
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<File?> _downloadOrGetCachedPdf(String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = Uri.parse(url).pathSegments.last;
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        return file; // Return cached file if exists
      }

      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (e) {
      return null;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 10, // Adds space to the left of the logo
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
            icon:
                Icon(Icons.account_circle, color: Colors.green[800], size: 30),
            onPressed: () => _showLogoutDialog(context),
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pdfFiles.isEmpty
              ? Center(
                  child:
                      Text("No PDFs available", style: TextStyle(fontSize: 18)))
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: pdfFiles.length,
                  itemBuilder: (context, index) {
                    return PDFViewerWidget(pdfFile: pdfFiles[index]);
                  },
                ),
    );
  }

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
}

class PDFViewerWidget extends StatefulWidget {
  final File pdfFile;

  const PDFViewerWidget({required this.pdfFile});

  @override
  _PDFViewerWidgetState createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget> {
  int totalPages = 0;
  int currentPage = 0;
  bool isReady = false;
  double scale = 1.0;
  late PDFViewController pdfController;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onScaleUpdate: (details) {
                  setState(() {
                    scale =
                        details.scale.clamp(1.0, 3.0); // Pinch-to-zoom support
                  });
                },
                child: Transform.scale(
                  scale: scale,
                  child: PDFView(
                    filePath: widget.pdfFile.path,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageFling: true,
                    fitPolicy: FitPolicy.BOTH,
                    onRender: (pages) {
                      setState(() {
                        totalPages = pages ?? 0;
                        isReady = true;
                      });
                    },
                    onPageChanged: (page, _) {
                      setState(() {
                        currentPage = page ?? 0;
                      });
                    },
                    onViewCreated: (controller) {
                      pdfController = controller;
                    },
                  ),
                ),
              ),
            ),
          ),
          if (isReady)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(
                    "Page ${currentPage + 1} of $totalPages",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(Icons.chevron_left, "Prev", () {
                        if (currentPage > 0) {
                          pdfController.setPage(currentPage - 1);
                        }
                      }),
                      _buildControlButton(Icons.zoom_in, "Zoom In", () {
                        setState(() {
                          scale = (scale + 0.2).clamp(1.0, 3.0);
                        });
                      }),
                      _buildControlButton(Icons.zoom_out, "Zoom Out", () {
                        setState(() {
                          scale = (scale - 0.2).clamp(1.0, 3.0);
                        });
                      }),
                      _buildControlButton(Icons.chevron_right, "Next", () {
                        if (currentPage < totalPages - 1) {
                          pdfController.setPage(currentPage + 1);
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Icon(icon, size: 24),
      ),
    );
  }
}
