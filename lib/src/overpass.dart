import 'dart:io';

import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

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
    else if (center != null) {
      query = query.replaceAll('{{center}}', '${center.latitude},${center.longitude}');
    }
    return query;
  }

  void query({required File script, Bbox? bbox, LatLng? center}) {
    final String query = _buildQuery(script, bbox, center);
    _dioClient.post(
      'https://overpass-api.de/api/interpreter',
      data: query,
    );
  }
}