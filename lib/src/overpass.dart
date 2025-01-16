import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

import 'bbox.dart';
import 'query_builder.dart';
import 'element.dart';

/// A class that interacts with the Overpass API to perform queries.
///
/// The [Overpass] class uses a [Dio] client to send HTTP requests to the Overpass API.
/// It provides a method to perform queries using either a script text or a script file.
///
/// Example usage:
/// ```dart
/// final overpass = Overpass();
/// final elements = await overpass.query(scriptText: 'your_script_here');
/// ```
///
/// The [query] method supports optional parameters for bounding box and center coordinates.
///
/// Parameters:
/// - [dioClient]: An optional [Dio] client. If not provided, a default [Dio] client is created.
///
/// Methods:
/// - [query]: Performs a query to the Overpass API using the provided script text or script file.
///   - [script]: The Overpass query script as a string.
///   - [bbox]: An optional bounding box for the query.
///   - [center]: An optional center coordinate for the query.
///
/// Returns:
/// - A [Future] that resolves to a list of [Element] objects, or `null` if no elements are found.
class Overpass {
  final Dio _dioClient;

  /// Creates an instance of [Overpass].
  ///
  /// If a [dioClient] is provided, it will be used for making HTTP requests.
  /// Otherwise, a default instance of [Dio] will be created and used.
  ///
  /// [dioClient] - An optional [Dio] client for making HTTP requests.
  Overpass({Dio? dioClient}) : _dioClient = dioClient ?? Dio();

  /// Queries the Overpass API with the provided script or file and optional bounding box or center coordinates.
  ///
  /// The [script] parameter is a string containing the Overpass query script.
  /// The [bbox] parameter is an optional bounding box to limit the query.
  /// The [center] parameter is an optional center coordinate to limit the query.
  ///
  /// Returns a [Future] that resolves to a list of [Element] objects if the query is successful,
  /// or `null` if the query fails or no elements are found.
  Future<List<Element>?> query(
      {required String script, Bbox? bbox, LatLng? center}) async {
    script = script.buildQuery(bbox, center);

    final Map<String, String> queryMap = {
      'data': script,
    };

    final String data = queryMap.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final Response<Map<String, dynamic>> response = await _dioClient
        .post<Map<String, dynamic>>('https://overpass-api.de/api/interpreter',
            data: data,
            options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: {
                'charset': 'UTF-8',
              },
            ));

    final List<dynamic>? elements = response.data?['elements'];

    if (elements == null) {
      return null;
    }

    return Elements.fromList(elements);
  }
}
