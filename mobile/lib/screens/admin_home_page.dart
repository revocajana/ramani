import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchVenues();
  }

  Future<void> _fetchVenues() async {
    if (!mounted) return;
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
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteVenue(int id) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this venue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('${ApiConstants.venuesUrl}$id/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Venue deleted')));
          _fetchVenues();
        }
      } else {
        throw 'Failed to delete: ${response.body}';
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
          : IndexedStack(
              index: _selectedIndex,
              children: [
                _buildVenueList(),
                _buildMapView(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor.withOpacity(0.5),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Venues'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map View'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecordVenuePage()),
                );
                if (result == true) _fetchVenues();
              },
              backgroundColor: primaryColor,
              child: const Icon(Icons.add_location_alt, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildVenueList() {
    if (_venues.isEmpty) {
      return Center(
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
      );
    }
    return RefreshIndicator(
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
              subtitle: Text('Building: ${venue['building']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RecordVenuePage(venue: venue)),
                      );
                      if (result == true) _fetchVenues();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteVenue(venue['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapView() {
    if (_venues.isEmpty) return const Center(child: Text('No venues to display on map'));

    double avgLat = 0;
    double avgLng = 0;
    for (var v in _venues) {
      avgLat += double.parse(v['latitude'].toString());
      avgLng += double.parse(v['longitude'].toString());
    }
    avgLat /= _venues.length;
    avgLng /= _venues.length;

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(avgLat, avgLng),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://api.mapbox.com/styles/v1/${ApiConstants.mapboxStyleId}/tiles/{z}/{x}/{y}@2x?access_token=${ApiConstants.mapboxToken}',
          additionalOptions: {
            'accessToken': ApiConstants.mapboxToken,
            'id': ApiConstants.mapboxStyleId,
          },
          userAgentPackageName: 'com.nit.ramani',
        ),
        MarkerLayer(
          markers: _venues.map((v) {
            return Marker(
              point: LatLng(
                double.parse(v['latitude'].toString()),
                double.parse(v['longitude'].toString()),
              ),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showVenueDetails(v),
                child: Icon(
                  Icons.location_on,
                  color: primaryColor,
                  size: 40,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showVenueDetails(dynamic venue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getIconForType(venue['venue_type']), color: primaryColor, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      venue['name'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      Navigator.pop(context);
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RecordVenuePage(venue: venue)),
                      );
                      if (result == true) _fetchVenues();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteVenue(venue['id']);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Building: ${venue['building']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Coordinates: ${venue['latitude']}, ${venue['longitude']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              if (venue['description'] != null && venue['description'].isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Description: ${venue['description']}', style: const TextStyle(color: Colors.black87)),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
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
