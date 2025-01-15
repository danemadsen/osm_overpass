import 'dart:io';

import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

import 'query_builder.dart';
import 'element.dart';

class Overpass {
  final Dio _dioClient;
  
  Overpass({
    Dio? dioClient
  }) : _dioClient = dioClient ?? Dio();

  Future<List<Element>?> query({String? scriptText, File? scriptFile, Bbox? bbox, LatLng? center}) async {
    assert(scriptText != null || scriptFile != null);

    String query = scriptText ?? await scriptFile!.readAsString();
    query = query.buildQuery(bbox, center);

    final Map<String, String> queryMap = {
      'data': query,
    };

    final String data = queryMap.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');

    final Response<Map<String, dynamic>> response = await _dioClient.post<Map<String, dynamic>>(
      'https://overpass-api.de/api/interpreter',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'charset': 'UTF-8',
        },
      )
    );

    final List<dynamic>? elements = response.data?['elements'];

    if (elements == null) {
      return null;
    }

    return Element.fromList(elements);
  }
}