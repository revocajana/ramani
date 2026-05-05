import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class RecordVenuePage extends StatefulWidget {
  const RecordVenuePage({Key? key}) : super(key: key);

  @override
  State<RecordVenuePage> createState() => _RecordVenuePageState();
}

class _RecordVenuePageState extends State<RecordVenuePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _buildingController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _venueType = 'lecture_hall';
  double? _latitude;
  double? _longitude;
  bool _gettingLocation = false;
  bool _isSubmitting = false;

  final Color primaryColor = const Color(0xFF1F3B4D);

  final List<Map<String, String>> _venueTypes = [
    {'value': 'lecture_hall', 'label': 'Lecture Hall'},
    {'value': 'office', 'label': 'Office'},
    {'value': 'laboratory', 'label': 'Laboratory'},
    {'value': 'library', 'label': 'Library'},
    {'value': 'cafeteria', 'label': 'Cafeteria'},
    {'value': 'computer_lab', 'label': 'Computer Lab'},
    {'value': 'other', 'label': 'Other'},
  ];

  Future<void> _getCurrentLocation() async {
    setState(() => _gettingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _gettingLocation = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _latitude == null) {
      if (_latitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please capture coordinates first')),
        );
      }
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(ApiConstants.venuesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'building': _buildingController.text,
          'venue_type': _venueType,
          'latitude': _latitude,
          'longitude': _longitude,
          'description': _descriptionController.text,
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venue recorded successfully!')),
          );
          Navigator.pop(context, true);
        }
      } else {
        throw 'Failed to record venue: ${response.body}';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text('Record Venue', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Venue Name (e.g. Room 101)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _buildingController,
                decoration: InputDecoration(
                  labelText: 'Building Name (e.g. Block A)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _venueType,
                decoration: InputDecoration(
                  labelText: 'Venue Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _venueTypes.map((t) {
                  return DropdownMenuItem(value: t['value'], child: Text(t['label']!));
                }).toList(),
                onChanged: (v) => setState(() => _venueType = v!),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    if (_latitude != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Latitude', style: TextStyle(color: Colors.grey)),
                              Text(_latitude!.toStringAsFixed(6), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Longitude', style: TextStyle(color: Colors.grey)),
                              Text(_longitude!.toStringAsFixed(6), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    ElevatedButton.icon(
                      onPressed: _gettingLocation ? null : _getCurrentLocation,
                      icon: _gettingLocation 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.my_location),
                      label: Text(_latitude == null ? 'Capture Coordinates' : 'Update Coordinates'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Venue', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
