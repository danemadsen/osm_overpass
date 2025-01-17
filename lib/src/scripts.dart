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
}