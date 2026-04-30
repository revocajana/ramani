import 'package:flutter/material.dart';
import 'features/location/models/location_record.dart';
import 'features/location/presentation/record_location_page.dart';

void main() {
  runApp(const RamaniApp());
}

class RamaniApp extends StatelessWidget {
  const RamaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramani Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<LocationRecord> _records = [];

  Future<void> _openRecordLocation() async {
    final result = await Navigator.push<LocationRecord>(
      context,
      MaterialPageRoute(builder: (_) => const RecordLocationPage()),
    );

    if (result != null) {
      setState(() {
        _records.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ramani Location Recorder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Visit a block and capture the actual location data here so we can feed real campus positions into the project.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _openRecordLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Record new block location'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _records.isEmpty
                  ? const Center(
                      child: Text(
                        'No locations recorded yet. Tap the button above to add a block.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: _records.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final record = _records[index];
                        return ListTile(
                          title: Text(record.blockName),
                          subtitle: Text(
                            'Label: ${record.blockLabel}\n${record.description}\nLat: ${record.latitude.toStringAsFixed(6)}, Lon: ${record.longitude.toStringAsFixed(6)}',
                          ),
                          isThreeLine: true,
                          trailing: Text(
                            '${record.recordedAt.hour.toString().padLeft(2, '0')}:${record.recordedAt.minute.toString().padLeft(2, '0')}',
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
