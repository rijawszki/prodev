import 'package:flutter/material.dart';
import 'package:prodev/admin/admin_company.dart';
import 'package:prodev/admin/admin_content.dart';
import 'package:prodev/admin/admin_jobmanagement.dart';
import 'package:prodev/admin/admin_user.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration initialDelayTime = const Duration(milliseconds: 300);

  final List<_DashboardItem> items = [
    _DashboardItem("Users", Icons.people, Colors.blue, AdminUserManagementScreen()),
    _DashboardItem("Companies", Icons.business, Colors.green, AdminCompanyManagementScreen()),
    _DashboardItem("Jobs", Icons.work, Colors.orange, AdminJobManagementScreen()),
    _DashboardItem("Content", Icons.article, Colors.purple, AdminContentPage()),
  ];

  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    for (int i = 0; i < items.length; i++) {
      final start = i * 0.1;
      final end = start + 0.6;

      _slideAnimations.add(
        Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          ),
        ),
      );

      _fadeAnimations.add(
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeIn),
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: 
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                return SlideTransition(
                  position: _slideAnimations[index],
                  child: FadeTransition(
                    opacity: _fadeAnimations[index],
                    child: Material(
                      elevation: 6,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      shadowColor: item.color.withOpacity(0.3),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => item.page),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: item.color.withOpacity(0.1),
                                child: Icon(item.icon, color: item.color),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_rounded, color: item.color, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget page;

  _DashboardItem(this.title, this.icon, this.color, this.page);
}
