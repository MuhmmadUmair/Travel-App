// lib/services/travel_advisor_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart'; // compute
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

class TravelAdvisorService {
  static const String _rapidApiKey =
      'd9dbfa1dacmsh8237cc3d4d2bd9ep1ac490jsne727d30a28d8';
  static const String _host = 'travel-advisor.p.rapidapi.com';

  /// Public method used by UI/provider. Uses compute() to parse in background.
  static Future<List<PlaceModel>> searchLocations(
    String query, {
    int limit = 15,
  }) async {
    final uri = Uri.https(_host, '/locations/search', {
      'query': query,
      'limit': limit.toString(),
      'currency': 'USD',
      'units': 'km',
      'lang': 'en_US',
    });

    final headers = {
      'x-rapidapi-key': _rapidApiKey,
      'x-rapidapi-host': _host,
      'accept': 'application/json',
      'content-type': 'application/json',
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception(
        'Travel Advisor API error: ${response.statusCode} - ${response.body}',
      );
    }

    // Offload JSON decode + map parsing to a background isolate.
    final List<PlaceModel> places = await compute(
      _parsePlacesBackground,
      response.body,
    );

    // If a limit was requested, enforce it here.
    if (places.length > limit) return places.take(limit).toList();
    return places;
  }

  /// Background isolate entrypoint: parse raw response string -> List<PlaceModel>
  static List<PlaceModel> _parsePlacesBackground(String responseBody) {
    final decoded = jsonDecode(responseBody);

    List<dynamic> items = [];
    if (decoded is Map && decoded['data'] is List) {
      items = decoded['data'] as List<dynamic>;
    } else if (decoded is Map && decoded['results'] is List) {
      items = decoded['results'] as List<dynamic>;
    } else if (decoded is List) {
      items = decoded;
    }

    final places = <PlaceModel>[];
    for (final it in items) {
      if (it is Map<String, dynamic>) {
        final candidate =
            (it['result_object'] as Map<String, dynamic>?) ??
            it as Map<String, dynamic>;
        try {
          final place = PlaceModel.fromTravelAdvisorResult(candidate);
          if (place.lat != 0 || place.lng != 0) places.add(place);
        } catch (_) {
          // ignore parse errors for single items
        }
      }
    }
    return places;
  }

  /// POST answers endpoint — left synchronous (small payload). Use if needed.
  static Future<Map<String, dynamic>> postAnswersList({
    required String contentType,
    required String contentId,
    required String questionId,
    int pagee = 0,
    String updateToken = '',
  }) async {
    final uri = Uri.https(_host, '/answers/v2/list', {
      'currency': 'USD',
      'units': 'km',
      'lang': 'en_US',
    });

    final headers = {
      'x-rapidapi-key': _rapidApiKey,
      'x-rapidapi-host': _host,
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    final body = jsonEncode({
      'contentType': contentType,
      'contentId': contentId,
      'questionId': questionId,
      'pagee': pagee,
      'updateToken': updateToken,
    });

    final resp = await http.post(uri, headers: headers, body: body);

    if (resp.statusCode != 200) {
      throw Exception(
        'Travel Advisor answers API error: ${resp.statusCode} - ${resp.body}',
      );
    }

    return jsonDecode(resp.body) as Map<String, dynamic>;
  }
}
