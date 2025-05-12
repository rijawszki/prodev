import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<HomeScreen> {
  final String _apiKey = 'pub_843008d8562226acc932674c97fd45f79a3f5';
  List _articles = [];
  List _filteredArticles = [];
  bool _isLoading = true;

  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchNews();

    // Auto-scroll timer
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients && _filteredArticles.isNotEmpty) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= _filteredArticles.length) nextPage = 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse(
        'https://newsdata.io/api/1/news?apikey=$_apiKey&country=in&category=education,science,technology');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'] ?? [];

      setState(() {
        _articles = results;
        _filteredArticles = results;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterArticles(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredArticles = _articles;
      });
      return;
    }

    setState(() {
      _filteredArticles = _articles.where((article) {
        final title = (article['title'] ?? '').toString().toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredArticles.isEmpty
              ? const Center(child: Text("No matching news found"))
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  children: [
                    // Welcome Message
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "👋 Welcome to ProDev",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[700],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        onChanged: _filterArticles,
                        decoration: InputDecoration(
                          hintText: "Search news...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Section Title
                    const Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 8),
                      child: Text(
                        "📢 Daily Career News",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Auto-Scrolling Carousel
                    // SizedBox(
                    //   height: 240,
                    //   child: PageView.builder(
                    //     controller: _pageController,
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: _filteredArticles.length,
                    //     itemBuilder: (context, index) {
                    //       final article = _filteredArticles[index];
                    //       final imageUrl = article['image_url'];

                    //       return GestureDetector(
                    //         onTap: () {
                    //           if (article['link'] != null) {
                    //             _launchUrl(article['link']);
                    //           }
                    //         },
                    //         child: Container(
                    //           width: 300,
                    //           margin: const EdgeInsets.only(
                    //               left: 20, right: 10, bottom: 12),
                    //           decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.circular(16),
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 color: Colors.black12,
                    //                 blurRadius: 8,
                    //                 offset: const Offset(0, 4),
                    //               ),
                    //             ],
                    //           ),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               ClipRRect(
                    //                 borderRadius: const BorderRadius.vertical(
                    //                     top: Radius.circular(16)),
                    //                 child: imageUrl != null
                    //                     ? Image.network(
                    //                         imageUrl,
                    //                         height: 130,
                    //                         width: double.infinity,
                    //                         fit: BoxFit.cover,
                    //                       )
                    //                     : Container(
                    //                         height: 130,
                    //                         color: Colors.deepPurple[100],
                    //                         child: const Center(
                    //                           child: Icon(
                    //                               Icons.image_not_supported),
                    //                         ),
                    //                       ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.all(10),
                    //                 child: Text(
                    //                   article['title'] ?? 'No title',
                    //                   maxLines: 3,
                    //                   overflow: TextOverflow.ellipsis,
                    //                   style: const TextStyle(
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w600,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    SizedBox(
  height: 240,
  child: PageView.builder(
    controller: _pageController,
    scrollDirection: Axis.horizontal,
    itemCount: _filteredArticles.length,
    itemBuilder: (context, index) {
      final article = _filteredArticles[index];
      final imageUrl = article['image_url'];

      return GestureDetector(
        onTap: () {
          if (article['link'] != null) {
            _launchUrl(article['link']);
          }
        },
        child: Container(
          width: 300,
          margin: const EdgeInsets.only(left: 20, right: 10, bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            // Image loaded, show the actual image
                            return child;
                          } else {
                            // While loading, show the placeholder from assets
                            return Image.asset(
                              'assets/nothumb.jpg', // Placeholder image from assets
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }
                        },   
                      )
                    : Container(
                        height: 130,
                        color: Colors.deepPurple[100],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  article['title'] ?? 'No title',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
)

                  ],
                ),
    );
  }
}
