import 'package:flutter/material.dart';
import 'overview_tab.dart';
import 'trends_tab.dart';
import 'categories_tab.dart';
import 'sitters_tab.dart';
import 'alerts_tab.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedRange = "Last 90 days";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          DropdownButton<String>(
            value: selectedRange,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: "Last 30 days",
                child: Text("Last 30 days"),
              ),
              DropdownMenuItem(
                value: "Last 90 days",
                child: Text("Last 90 days"),
              ),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => selectedRange = val);
              }
            },
          ),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Export coming soon!")),
              );
            },
            icon: const Icon(Icons.download, color: Colors.blue),
            label: const Text("Export", style: TextStyle(color: Colors.blue)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: "Overview"),
            Tab(text: "Trends"),
            Tab(text: "Categories"),
            Tab(text: "Sitters"),
            Tab(text: "Alerts"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OverviewTab(),
          TrendsTab(),
          CategoriesTab(),
          SittersTab(),
          AlertsTab(),
        ],
      ),
    );
  }
}
