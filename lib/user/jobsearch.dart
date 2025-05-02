import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List _jobs = [];
  bool _isLoading = false;

  final String _appId = 'c48699d4';
  final String _appKey = 'b9d83b116ef4ed1c3878f47b605b8ba9';

  @override
  void initState() {
    super.initState();
    _searchController.text = 'Flutter Developer';
    searchJobs('Flutter Developer');
  }

  Future<void> searchJobs(String query) async {
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://api.adzuna.com/v1/api/jobs/in/search/1?app_id=$_appId&app_key=$_appKey&results_per_page=20&what=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _jobs = data['results'] ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _jobs = [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       
        
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search field
            TextField(
              controller: _searchController,
              onSubmitted: searchJobs,
              decoration: InputDecoration(
                hintText: 'Search for jobs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _jobs.clear());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : _jobs.isEmpty
                    ? const Text("No jobs found.")
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _jobs.length,
                          itemBuilder: (context, index) {
                            final job = _jobs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(job['title'] ?? 'No Title'),
                                subtitle: Text(job['company']['display_name'] ?? ''),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  final url = job['redirect_url'];
                                  if (url != null) {
                                    launchUrl(Uri.parse(url));
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
