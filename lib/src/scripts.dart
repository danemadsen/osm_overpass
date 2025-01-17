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

  static const String military = '''
    [out:json];
    (
      node[military]({{bbox}});
      way[military]({{bbox}});
      relation[military]({{bbox}});
    );
    out body;
    >;
    out skel qt;
  ''';

  static const String parking = '''
    [out:json];
    (
      way[amenity=parking]({{bbox}});
      way[amenity=parking_space]({{bbox}});
    );
    out body;
    >;
    out skel qt;
  ''';

  static const String police = '''
    [out:json];
    (
      node[amenity=police]({{bbox}});
    );
    out;
  ''';

  static const Map<String, String> scripts = {
    'nightlife': nightlife,
    'food': food,
    'military': military,
    'parking': parking,
    'police': police,
  };
}