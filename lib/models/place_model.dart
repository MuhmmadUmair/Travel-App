class PlaceModel {
  final String name;
  final String imageUrl;
  final double lat;
  final double lng;
  final String description;
  bool isFavourite;

  PlaceModel({
    required this.name,
    required this.imageUrl,
    required this.lat,
    required this.lng,
    required this.description,
    this.isFavourite = false,
  });

  // Backwards-compatible getters for code that uses latitude/longitude
  double get latitude => lat;
  double get longitude => lng;

  static const String _kPlaceholderImage =
      'https://via.placeholder.com/800x600.png?text=No+Image';

  // Generic JSON parser: safe fallbacks
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final rawImage =
        (json['image'] ??
                json['imageUrl'] ??
                json['photo']?['images']?['medium']?['url'] ??
                json['photo']?['images']?['large']?['url'] ??
                '')
            .toString();
    final image = rawImage.isNotEmpty ? rawImage : _kPlaceholderImage;

    return PlaceModel(
      name: (json['name'] ?? json['title'] ?? 'Unknown Place').toString(),
      imageUrl: image,
      lat: parseDouble(
        json['lat'] ?? json['latitude'] ?? json['location']?['lat'],
      ),
      lng: parseDouble(
        json['lng'] ?? json['longitude'] ?? json['location']?['lng'],
      ),
      description:
          (json['description'] ??
                  json['snippet'] ??
                  json['location_string'] ??
                  '')
              .toString(),
    );
  }

  // Travel Advisor specific parser (many endpoints return result shapes)
  factory PlaceModel.fromTravelAdvisorResult(Map<String, dynamic> result) {
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final photoUrl =
        (result['photo']?['images']?['large']?['url']) ??
        (result['photo']?['images']?['medium']?['url']) ??
        (result['image_url']) ??
        '';

    final image = (photoUrl?.toString() ?? '').isNotEmpty
        ? photoUrl.toString()
        : _kPlaceholderImage;

    final name =
        (result['name'] ?? result['title'] ?? result['location_string'] ?? '')
            .toString();
    final desc =
        (result['description'] ?? result['snippet'] ?? result['address'] ?? '')
            .toString();

    final latVal =
        result['latitude'] ?? result['lat'] ?? result['location']?['lat'];
    final lngVal =
        result['longitude'] ?? result['lng'] ?? result['location']?['lng'];

    return PlaceModel(
      name: name.isNotEmpty ? name : 'Unknown place',
      imageUrl: image,
      lat: parseDouble(latVal),
      lng: parseDouble(lngVal),
      description: desc.isNotEmpty ? desc : 'No description available.',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
    'lat': lat,
    'lng': lng,
    'description': description,
    'isFavourite': isFavourite,
  };
}
