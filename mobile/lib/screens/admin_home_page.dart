import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import 'login_page.dart';
import 'record_venue_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final Color primaryColor = const Color(0xFF1F3B4D);
  List<dynamic> _venues = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchVenues();
  }

  Future<void> _fetchVenues() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(ApiConstants.venuesUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data is Map && data.containsKey('results')) {
            _venues = data['results'];
          } else {
            _venues = data;
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching venues: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('lib/assets/images/nit.png'),
        ),
        title: Text('Admin Dashboard', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: primaryColor),
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _venues.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('No venues recorded yet', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RecordVenuePage()),
                          );
                          if (result == true) _fetchVenues();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                        child: const Text('Record First Venue', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchVenues,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _venues.length,
                    itemBuilder: (context, index) {
                      final venue = _venues[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: Icon(_getIconForType(venue['venue_type']), color: primaryColor),
                          ),
                          title: Text(venue['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Building: ${venue['building']}\nLat: ${venue['latitude']}, Lon: ${venue['longitude']}'),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecordVenuePage()),
          );
          if (result == true) _fetchVenues();
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add_location_alt, color: Colors.white),
      ),
    );
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'lecture_hall': return Icons.school;
      case 'office': return Icons.work;
      case 'laboratory': return Icons.science;
      case 'library': return Icons.menu_book;
      case 'cafeteria': return Icons.restaurant;
      case 'computer_lab': return Icons.computer;
      default: return Icons.location_on;
    }
  }
}
