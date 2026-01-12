import 'package:flutter/material.dart';
import 'package:citytocoast_app/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:citytocoast_app/dev/seed_sitters.dart';
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
  final FirestoreService _firestoreService = FirestoreService();
  bool _isMigrating = false;
  bool _isSeeding = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  Future<void> _runSignUpMigration() async {
    setState(() => _isMigrating = true);
    try {
      await _firestoreService.migrateSignUpToUsers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Migration complete: signUp → users")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Migration failed: $e")));
    } finally {
      if (mounted) setState(() => _isMigrating = false);
    }
  }

  Future<void> _runSeedSitters() async {
    setState(() => _isSeeding = true);
    try {
      await seedSitters(overwrite: true);
      final aggregate = await FirebaseFirestore.instance
          .collection('sitters')
          .count()
          .get();
      final total =
          aggregate.count ??
          (await FirebaseFirestore.instance.collection('sitters').get())
              .docs
              .length;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seeded 24 sitters into /sitters")),
      );
      // ignore: avoid_print
      print('Sitters collection count after seeding: $total');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Seeding failed: $e")));
    } finally {
      if (mounted) setState(() => _isSeeding = false);
    }
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
          TextButton.icon(
            onPressed: _isMigrating ? null : _runSignUpMigration,
            icon: const Icon(Icons.sync, color: Colors.redAccent),
            label: Text(
              _isMigrating ? "Migrating..." : "Migrate signUp → users",
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton.icon(
            onPressed: _isSeeding ? null : _runSeedSitters,
            icon: const Icon(Icons.grass, color: Colors.green),
            label: Text(
              _isSeeding ? "Seeding..." : "Seed 24 Sitters",
              style: const TextStyle(color: Colors.green),
            ),
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
