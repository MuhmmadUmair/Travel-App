import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/place_model.dart';
import '../provider/place_provider.dart';

class PlaceCard extends StatelessWidget {
  final PlaceModel place;
  const PlaceCard({super.key, required this.place});

  Future<void> _openMap(BuildContext context) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${place.lat},${place.lng}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open map app.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlaceProvider>(context, listen: false);

    final imageSource = place.imageUrl;

    return GestureDetector(
      onTap: () => _openMap(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cached and resilient image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: imageSource,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (ctx, url) => SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (ctx, url, err) => Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // place name + favourite icon
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      place.isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () => provider.toggleFavourite(place),
                  ),
                ],
              ),
            ),

            // description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    'Tap to open location',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
