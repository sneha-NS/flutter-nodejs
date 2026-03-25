import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/delivery_location.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const _endpoint = 'assets/delivery_locations.json';

  Future<List<DeliveryLocation>> fetchDeliveryLocations() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final String raw = await rootBundle.loadString(_endpoint);
      final List<dynamic> data = json.decode(raw) as List<dynamic>;
      return data
          .map((e) => DeliveryLocation.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw const ApiException('Received malformed data from server.');
    } catch (e) {
      throw ApiException('Could not load delivery data: $e');
    }
  }
}
