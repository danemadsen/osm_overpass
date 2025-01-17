/// A collection of Overpass API query scripts for different types of amenities.
///
/// This class provides static constants containing Overpass API queries for
/// various categories such as nightlife, food, military, parking, and police.
/// Each query is designed to fetch specific types of nodes, ways, or relations
/// within a given bounding box.
///
/// The available scripts are:
/// - `nightlife`: Queries for bars, pubs, nightclubs, and cinemas.
/// - `food`: Queries for restaurants, cafes, and fast food places.
/// - `military`: Queries for military-related nodes, ways, and relations.
/// - `parking`: Queries for parking amenities and parking spaces.
/// - `police`: Queries for police amenities.
///
/// The `scripts` map provides a convenient way to access these queries by name.
class OverpassScripts {
  /// A constant string containing an Overpass QL query to fetch nightlife-related amenities
  /// within a specified bounding box. The amenities included in the query are:
  /// - Bars
  /// - Pubs
  /// - Nightclubs
  /// - Cinemas
  ///
  /// The query is formatted to output results in JSON.
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

  /// A constant string containing an Overpass QL query to fetch food-related amenities
  /// within a specified bounding box. The query retrieves nodes for restaurants,
  /// cafes, and fast food establishments in JSON format.
  ///
  /// The query uses the following tags to identify amenities:
  /// - `amenity=restaurant`
  /// - `amenity=cafe`
  /// - `amenity=fast_food`
  ///
  /// The `{{bbox}}` placeholder should be replaced with the desired bounding box
  /// coordinates.
  static const String food = '''
    [out:json];
    (
      node[amenity=restaurant]({{bbox}});
      node[amenity=cafe]({{bbox}});
      node[amenity=fast_food]({{bbox}});
    );
    out;
  ''';

  /// A constant string containing an Overpass QL query to retrieve military-related
  /// nodes, ways, and relations within a specified bounding box.
  ///
  /// The query is formatted to output results in JSON format. It first retrieves
  /// the primary elements (nodes, ways, and relations) tagged with "military" within
  /// the bounding box defined by `{{bbox}}`. Then, it outputs the body of these elements,
  /// followed by a recursive query to retrieve the skeleton of the elements and their
  /// related elements in a quick and terse format.
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

  /// A constant string containing an Overpass QL query to fetch parking-related
  /// amenities within a specified bounding box.
  ///
  /// The query retrieves:
  /// - Ways with the tag `amenity=parking`
  /// - Ways with the tag `amenity=parking_space`
  ///
  /// The results are output in JSON format.
  ///
  /// The `{{bbox}}` placeholder should be replaced with the desired bounding box
  /// coordinates.
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

  /// A constant string containing an Overpass QL query to fetch police amenities
  /// within a specified bounding box.
  ///
  /// The query retrieves nodes with the `amenity=police` tag and outputs the
  /// results in JSON format.
  static const String police = '''
    [out:json];
    (
      node[amenity=police]({{bbox}});
    );
    out;
  ''';

  /// A map containing script names as keys and their corresponding script
  /// content as values. The available scripts are:
  ///
  /// - 'nightlife': Script related to nightlife activities.
  /// - 'food': Script related to food establishments.
  /// - 'military': Script related to military locations.
  /// - 'parking': Script related to parking areas.
  /// - 'police': Script related to police stations.
  static const Map<String, String> scripts = {
    'nightlife': nightlife,
    'food': food,
    'military': military,
    'parking': parking,
    'police': police,
  };
}
