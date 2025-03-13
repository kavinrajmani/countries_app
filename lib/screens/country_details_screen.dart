import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/country.dart';

class CountryDetailsScreen extends StatelessWidget {
  final Country country;

  const CountryDetailsScreen({super.key, required this.country});

  Future<void> _openGoogleMaps() async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${country.name}');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: country.flagUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // General Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('General Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildInfoRow('Official Name', country.officialName),
                    _buildInfoRow(
                        'Population', _formatNumber(country.population)),
                    _buildInfoRow('Languages', _formatList(country.languages)),
                    _buildInfoRow(
                        'Currencies', _formatList(country.currencies)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Geography Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Geography',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildInfoRow('Region', country.region),
                    _buildInfoRow('Subregion', country.subregion),
                    _buildInfoRow('Capital', country.capital),
                    _buildInfoRow('Area', '${_formatNumber(country.area)} km²'),
                    if (country.borders.isNotEmpty)
                      _buildInfoRow('Borders', _formatList(country.borders)),
                    _buildInfoRow('Timezones', _formatList(country.timezones)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openGoogleMaps,
                        icon: const Icon(Icons.map),
                        label: const Text('View on Google Maps'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(num number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _formatList(List<String> items) {
    if (items.isEmpty) return 'N/A';
    return items.join(', ');
  }
}
