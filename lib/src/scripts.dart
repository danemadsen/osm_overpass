class OverpassScripts {
  static const String nightlife = '''
    [out:json];
    (
      node[amenity=bar]({{bbox}});
      node[amenity=pub]({{bbox}});
      node[amenity=nightclub]({{bbox}});
      node[amenity=cinema]({{bbox}});
    );
    out;
  ''';

  static const String food = '''
    [out:json];
    (
      node[amenity=restaurant]({{bbox}});
      node[amenity=cafe]({{bbox}});
      node[amenity=fast_food]({{bbox}});
    );
    out;
  ''';
}