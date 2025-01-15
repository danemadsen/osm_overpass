import 'dart:io';

import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

import 'element.dart';

typedef Bbox = (double, double, double, double);

class Overpass {
  final Dio _dioClient;
  
  Overpass({
    Dio? dioClient
  }) : _dioClient = dioClient ?? Dio();

  String _buildQuery(File script, Bbox? bbox, LatLng? center) {
    String query = script.readAsStringSync();

    if (bbox != null) {
      query = query.replaceAll('{{bbox}}', '${bbox.$1},${bbox.$2},${bbox.$3},${bbox.$4}');
    } 
    
    if (center != null) {
      query = query.replaceAll('{{center}}', '${center.latitude},${center.longitude}');
    }

    final dateRegex = RegExp(r'\{\{date:\s*(-?\d+)\s*(seconds?|minutes?|hours?|days?|weeks?|months?|years?)\}\}');
    if (dateRegex.hasMatch(query)) {
      query = query.replaceAllMapped(dateRegex, _replaceDateMatch);
    }

    final outRegex = RegExp(r'\[out:(xml|json|csv|custom|popup)\]');
    if (outRegex.hasMatch(query)) {
      query = query.replaceAll(outRegex, '[out:json]');
    }
    else {
      query = '[out:json]/n$query';
    }

    return query;
  }

  String _replaceDateMatch(Match match) {
    final int amount = int.parse(match.group(1)!);
    final String unit = match.group(2)!;
    final DateTime now = DateTime.now();
    DateTime date;
    switch (unit) {
      case 'second':
      case 'seconds':
        date = now.subtract(Duration(seconds: amount));
        break;
      case 'minute':
      case 'minutes':
        date = now.subtract(Duration(minutes: amount));
        break;
      case 'hour':
      case 'hours':
        date = now.subtract(Duration(hours: amount));
        break;
      case 'day':
      case 'days':
        date = now.subtract(Duration(days: amount));
        break;
      case 'week':
      case 'weeks':
        date = now.subtract(Duration(days: amount * 7));
        break;
      case 'month':
      case 'months':
        date = DateTime(now.year, now.month - amount, now.day, now.hour, now.minute, now.second);
        break;
      case 'year':
      case 'years':
        date = DateTime(now.year - amount, now.month, now.day, now.hour, now.minute, now.second);
        break;
      default:
        throw Exception('Invalid unit: $unit');
    }
    return date.toIso8601String();
  }

  Future<List<Element>?> query({required File script, Bbox? bbox, LatLng? center}) async {
    final String query = _buildQuery(script, bbox, center);

    final Response<Map<String, dynamic>> response = await _dioClient.post<Map<String, dynamic>>(
      'https://overpass-api.de/api/interpreter',
      data: query,
    );

    final List<dynamic>? elements = response.data?['elements'];

    if (elements == null) {
      return null;
    }

    return Element.fromList(elements);
  }
}