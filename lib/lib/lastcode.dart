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
  int _selectedIndex = 0;

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
        return file;
      }

      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (e) {
      return null;
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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pdfFiles.isEmpty
              ? Center(
                  child:
                      Text("No PDFs available", style: TextStyle(fontSize: 18)))
              : ListView.builder(
                  physics:
                      BouncingScrollPhysics(), // Smooth scrolling for the entire list
                  padding: EdgeInsets.all(10),
                  itemCount: pdfFiles.length,
                  itemBuilder: (context, index) {
                    return PDFViewerWidget(pdfFile: pdfFiles[index]);
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
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
        },
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

  // Variable to track drag distance
  double dragDistance = 0.0;

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
                onTap: () {
                  // Toggle zoom on tap
                  setState(() {
                    scale = (scale == 1.0) ? 2.0 : 1.0;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  // Track drag distance
                  dragDistance += details.primaryDelta!;

                  // Threshold to change page
                  if (dragDistance.abs() > 50) {
                    // If drag exceeds 50 pixels
                    if (dragDistance > 0 && currentPage > 0) {
                      pdfController.setPage(
                          currentPage - 1); // Swipe right (go to previous page)
                    } else if (dragDistance < 0 &&
                        currentPage < totalPages - 1) {
                      pdfController.setPage(
                          currentPage + 1); // Swipe left (go to next page)
                    }

                    // Reset drag distance after page change
                    dragDistance = 0;
                  }
                },
                child: Transform.scale(
                  scale: scale,
                  child: PDFView(
                    filePath: widget.pdfFile.path,
                    enableSwipe: true,
                    swipeHorizontal:
                        true, // Horizontal swipe enabled for smooth navigation
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
                          scale =
                              (scale + 0.2).clamp(1.0, 3.0); // Increase zoom
                        });
                      }),
                      _buildControlButton(Icons.zoom_out, "Zoom Out", () {
                        setState(() {
                          scale =
                              (scale - 0.2).clamp(1.0, 3.0); // Decrease zoom
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
      IconData icon, String label, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: label,
    );
  }
}
