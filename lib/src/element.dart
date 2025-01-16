import 'package:latlong2/latlong.dart';

/// Represents an OSM (OpenStreetMap) element which can be a node, way, relation, or area.
///
/// The [Element] class is a base class that holds common properties and methods for all types of OSM elements.
///
/// Properties:
/// - `id`: The unique identifier of the element. It can be null.
/// - `tags`: A map of tags associated with the element. It can be null.
///
/// Constructors:
/// - `Element({this.id, this.tags})`: Creates an instance of [Element] with optional `id` and `tags`.
///
/// Factory Constructors:
/// - `factory Element.fromMap(Map<String, dynamic> map)`: Creates an instance of a specific element type (Node, Way, Relation, Area) based on the 'type' field in the provided map.
///
/// Methods:
/// - `Map<String, dynamic> toMap()`: Converts the [Element] instance to a map.
/// - `static List<Element> fromList(List<dynamic> list)`: Converts a list of maps to a list of [Element] instances.
class Element {
  /// The unique identifier for the element. This can be `null` if the element
  /// does not have an ID.
  final int? id;

  /// A map containing the tags associated with the element.
  ///
  /// The keys are the tag names and the values are the tag values.
  /// This can be `null` if the element has no tags.
  final Map<String, dynamic>? tags;

  /// Creates an instance of [Element].
  ///
  /// The [id] parameter is used to uniquely identify the element.
  /// The [tags] parameter is a map of key-value pairs associated with the element.
  ///
  /// Example:
  /// ```dart
  /// var element = Element(id: 123, tags: {'name': 'example'});
  /// ```
  Element({this.id, this.tags});

  /// Creates an `Element` instance from a map.
  ///
  /// The map must contain a 'type' key with one of the following values:
  /// - 'node': Creates a `Node` instance.
  /// - 'way': Creates a `Way` instance.
  /// - 'relation': Creates a `Relation` instance.
  /// - 'area': Creates an `Area` instance.
  ///
  /// Throws an [ArgumentError] if the 'type' value is invalid.
  factory Element.fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'node':
        return Node.fromMap(map);
      case 'way':
        return Way.fromMap(map);
      case 'relation':
        return Relation.fromMap(map);
      case 'area':
        return Area.fromMap(map);
      default:
        throw ArgumentError('Invalid element type');
    }
  }

  /// Converts the current object to a map.
  ///
  /// The resulting map will contain the `id` and `tags` fields if they are not null.
  ///
  /// Returns:
  ///   A map representation of the current object.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if (id != null) {
      data['id'] = id;
    }

    if (tags != null) {
      data['tags'] = tags;
    }

    return data;
  }
}

/// Extension on `List<Element>` providing utility methods for working with
/// collections of `Element` objects.
///
/// This extension includes methods for creating `Element` objects from a list
/// of dynamic objects, retrieving waypoints from a `Way` object, and filtering
/// elements with non-null tags.
extension Elements on List<Element> {
  /// Creates a list of `Element` objects from a list of dynamic objects.
  ///
  /// This method takes a list of dynamic objects, converts each object
  /// to an `Element` using the `Element.fromMap` constructor, and returns
  /// a list of the resulting `Element` objects.
  ///
  /// - Parameter list: A list of dynamic objects to be converted.
  /// - Returns: A list of `Element` objects.
  static List<Element> fromList(List<dynamic> list) {
    final List<Element> elements = [];
    for (final element in list) {
      elements.add(Element.fromMap(element));
    }

    return elements;
  }

  /// Retrieves the list of `LatLng` points for a given `Way`.
  ///
  /// This method iterates through the node IDs in the provided `Way` object,
  /// finds the corresponding `Node` objects, and extracts their `LatLng`
  /// coordinates to form a list of waypoints.
  ///
  /// - Parameter way: The `Way` object containing the node IDs.
  /// - Returns: A list of `LatLng` points representing the waypoints of the `Way`.
  /// - Throws: An exception if a node ID in the `Way` cannot be found in the list of elements.
  List<LatLng> getWayPoints(Way way) {
    final List<LatLng> wayPoints = [];
    for (final id in way.nodes!) {
      final node = firstWhere((element) => element.id == id) as Node;
      wayPoints.add(node.latLng!);
    }

    return wayPoints;
  }

  /// Returns a list of elements that have non-null tags.
  /// 
  /// This getter filters the elements and includes only those
  /// that have their `tags` property set to a non-null value.
  /// 
  /// Example:
  /// ```dart
  /// List<Element> elementsWithTags = elements.withTags;
  /// ```
  List<Element> get withTags => where((element) => element.tags != null).toList();
}

/// A class representing a Node element in the OpenStreetMap (OSM) data model.
///
/// A Node is a specific type of Element that has a geographical position defined
/// by latitude and longitude coordinates.
///
/// The [Node] class extends the [Element] class and adds a [LatLng] property to
/// store the geographical coordinates.
///
/// The [Node] class provides a factory constructor [Node.fromMap] to create an
/// instance from a map, and an overridden [toMap] method to convert an instance
/// back to a map.
///
/// Properties:
/// - [latLng]: The geographical coordinates of the node, represented as a [LatLng] object.
///
/// Constructors:
/// - [Node]: Creates a new instance of [Node] with the given id, tags, and optional latLng.
/// - [Node.fromMap]: Creates a new instance of [Node] from a map containing the node's data.
///
/// Methods:
/// - [toMap]: Converts the [Node] instance to a map, including the geographical coordinates if available.
class Node extends Element {
  /// The geographical coordinates (latitude and longitude) of the element.
  /// This can be `null` if the coordinates are not available.
  final LatLng? latLng;

  /// Creates a new instance of the Node class.
  ///
  /// The [id] and [tags] parameters are inherited from the superclass.
  /// The [latLng] parameter represents the latitude and longitude of the node.
  ///
  /// Example:
  /// ```dart
  /// var node = Node(id: 123, tags: {'name': 'example'}, latLng: LatLng(12.34, 56.78));
  /// ```
  Node({super.id, super.tags, this.latLng});

  /// Creates a [Node] instance from a map.
  ///
  /// The [map] parameter should contain the following keys:
  /// - 'id': The identifier of the node.
  /// - 'tags': A map of tags associated with the node.
  /// - 'lat': The latitude of the node.
  /// - 'lon': The longitude of the node.
  ///
  /// If both 'lat' and 'lon' are present in the map, a [LatLng] object is created
  /// and assigned to the [latLng] property of the [Node]. Otherwise, [latLng] is null.
  ///
  /// Returns a [Node] instance with the provided data.
  factory Node.fromMap(Map<String, dynamic> map) {
    final lat = map['lat'];
    final lon = map['lon'];
    final latLng = lat != null && lon != null ? LatLng(lat, lon) : null;

    return Node(id: map['id'], tags: map['tags'], latLng: latLng);
  }

  /// Converts the current object to a map representation.
  ///
  /// This method overrides the `toMap` method from the superclass and adds
  /// additional data specific to this class. It includes the type of the
  /// element as 'node' and, if available, the latitude and longitude from
  /// `latLng`.
  ///
  /// Returns a `Map<String, dynamic>` containing the data of the current object.
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = super.toMap();

    data['type'] = 'node';

    if (latLng != null) {
      data['lat'] = latLng!.latitude;
      data['lon'] = latLng!.longitude;
    }

    return data;
  }
}

/// A class representing a Way element in OpenStreetMap.
///
/// A Way is an ordered list of nodes which normally also has at least one tag
/// or is included within a Relation. It is used to represent linear features
/// and area boundaries.
///
/// Extends the [Element] class.
///
/// Properties:
/// - `nodes`: A list of node IDs that make up the way. Can be null.
///
/// Constructors:
/// - `Way({super.id, super.tags, this.nodes})`: Creates a Way instance with
///   the given id, tags, and nodes.
///
/// Factory Constructors:
/// - `Way.fromMap(Map<String, dynamic> map)`: Creates a Way instance from a
///   map. The map should contain the keys 'id', 'tags', and 'nodes'.
///
/// Methods:
/// - `@override Map<String, dynamic> toMap()`: Converts the Way instance to a
///   map. Adds the type 'way' and includes the nodes if they are not null.
class Way extends Element {
  /// A list of node IDs associated with this element.
  ///
  /// This list contains the IDs of the nodes that make up the element.
  /// It can be `null` if there are no nodes associated with the element.
  final List<int>? nodes;

  /// Creates a new instance of the `Way` class.
  ///
  /// The `id` and `tags` parameters are inherited from the superclass.
  /// The `nodes` parameter is a list of node IDs that make up the way.
  ///
  /// Example:
  /// ```dart
  /// var way = Way(id: 123, tags: {'highway': 'residential'}, nodes: [1, 2, 3]);
  /// ```
  Way({super.id, super.tags, this.nodes});

  /// Creates a new `Way` instance from a map.
  ///
  /// The [map] parameter must contain the following keys:
  /// - `id`: The identifier of the way.
  /// - `tags`: A map of tags associated with the way.
  /// - `nodes`: A list of node identifiers that make up the way.
  ///
  /// Returns a `Way` object initialized with the values from the map.
  factory Way.fromMap(Map<String, dynamic> map) {
    return Way(id: map['id'], tags: map['tags'], nodes: map['nodes']);
  }

  /// Converts the current object to a map representation.
  ///
  /// This method overrides the `toMap` method from the superclass and adds
  /// additional data specific to this class. It includes the type of the
  /// element as 'way' and, if available, the list of nodes.
  ///
  /// Returns a `Map<String, dynamic>` containing the data of the current object.
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = super.toMap();

    data['type'] = 'way';

    if (nodes != null) {
      data['nodes'] = nodes;
    }

    return data;
  }
}

/// A class representing a Relation element in OSM (OpenStreetMap).
///
/// A Relation is a collection of one or more members, which can be nodes,
/// ways, or other relations. Each member has a role within the relation.
///
/// This class extends the [Element] class and includes additional properties
/// specific to relations.
///
/// Properties:
/// - `members`: A list of [Member] objects that are part of this relation.
///
/// Constructors:
/// - `Relation({super.id, super.tags, this.members})`: Creates a new Relation
///   instance with the given id, tags, and members.
/// - `factory Relation.fromMap(Map<String, dynamic> map)`: Creates a new
///   Relation instance from a map. The map should contain the keys 'id',
///   'tags', and 'members'.
///
/// Methods:
/// - `@override Map<String, dynamic> toMap()`: Converts the Relation instance
///   to a map. The map will include the type 'relation' and the members if
///   they are not null.
class Relation extends Element {
  /// A list of members associated with this element.
  ///
  /// This list can be null if there are no members.
  ///
  /// Each member in the list is an instance of the `Member` class.
  final List<Member>? members;

  /// A class representing a relation element in OpenStreetMap.
  ///
  /// A relation is a multi-purpose data structure that documents a relationship
  /// between two or more data elements (nodes, ways, and/or other relations).
  ///
  /// The [Relation] class extends a base class that includes an identifier and
  /// tags, and adds a list of members that are part of the relation.
  ///
  /// - `id`: The unique identifier for the relation.
  /// - `tags`: A map of key-value pairs associated with the relation.
  /// - `members`: A list of members that are part of the relation.
  Relation({super.id, super.tags, this.members});

  /// Creates a [Relation] instance from a map.
  ///
  /// The [map] parameter must contain the keys 'id', 'tags', and optionally 'members'.
  /// If 'members' is present, it should be a list of maps that can be converted to [Member] instances.
  ///
  /// Returns a [Relation] object with the provided id, tags, and members.
  factory Relation.fromMap(Map<String, dynamic> map) {
    final List<Member> members = [];
    if (map['members'] != null) {
      for (final member in map['members']) {
        members.add(Member.fromMap(member));
      }
    }

    return Relation(id: map['id'], tags: map['tags'], members: members);
  }

  /// Converts the current object to a map representation.
  ///
  /// This method overrides the `toMap` method from the superclass and adds
  /// additional data specific to this class. It includes the type of the
  /// element as 'relation' and, if available, the list of members.
  ///
  /// Returns a `Map<String, dynamic>` containing the data of the current object.
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = super.toMap();

    data['type'] = 'relation';

    if (members != null) {
      data['members'] = members;
    }

    return data;
  }
}

/// Represents an area element in the OSM Overpass API.
///
/// The [Area] class extends the [Element] class and provides additional
/// functionality specific to areas.
///
/// The [Area] class has a constructor that accepts an optional [id] and [tags].
///
/// The [Area.fromMap] factory constructor creates an [Area] instance from a
/// given map. The map should contain the keys 'id' and 'tags'.
///
/// The [toMap] method overrides the [Element.toMap] method to include the
/// 'type' key with the value 'area'.
///
/// Example usage:
/// ```dart
/// final area = Area(id: 123, tags: {'name': 'Central Park'});
/// final areaMap = area.toMap();
/// print(areaMap); // Output: {id: 123, tags: {name: Central Park}, type: area}
/// ```
class Area extends Element {
  /// Creates an instance of the `Area` class with the given [id] and [tags].
  ///
  /// The [id] parameter is used to uniquely identify the area, and the [tags]
  /// parameter is a map of key-value pairs that provide additional information
  /// about the area.
  Area({super.id, super.tags});

  /// Creates an instance of `Area` from a map.
  ///
  /// The map should contain the following keys:
  /// - `id`: The identifier of the area.
  /// - `tags`: A map of tags associated with the area.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> areaMap = {
  ///   'id': 123,
  ///   'tags': {'name': 'Central Park', 'type': 'park'}
  /// };
  /// Area area = Area.fromMap(areaMap);
  /// ```
  ///
  /// Throws a `TypeError` if the map does not contain the required keys or if the values are of incorrect types.
  ///
  /// - Parameter map: A map containing the data to create an `Area` instance.
  /// - Returns: An `Area` instance created from the provided map.
  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(id: map['id'], tags: map['tags']);
  }

  /// Converts the current object to a map representation.
  ///
  /// This method overrides the `toMap` method from the superclass and adds
  /// additional data specific to this class. It includes the type of the
  /// element as 'area'.
  ///
  /// Returns a `Map<String, dynamic>` containing the data of the current object.
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = super.toMap();

    data['type'] = 'area';

    return data;
  }
}

/// A class representing a member element with optional type, reference, and role.
///
/// The [Member] class provides a way to create member elements with optional
/// properties such as [type], [ref], and [role]. It also includes methods to
/// convert from and to a map representation.
///
/// Example usage:
/// ```dart
/// final member = Member(type: 'node', ref: 123, role: 'outer');
/// final map = member.toMap();
/// final newMember = Member.fromMap(map);
/// ```
///
/// Properties:
/// - [type]: The type of the member element (e.g., 'node', 'way', 'relation').
/// - [ref]: The reference ID of the member element.
/// - [role]: The role of the member element in a relation.
///
/// Constructors:
/// - [Member]: Creates a new instance of [Member] with optional [type], [ref], and [role].
/// - [Member.fromMap]: Creates a new instance of [Member] from a map representation.
///
/// Methods:
/// - [toMap]: Converts the [Member] instance to a map representation.
class Member {
  /// The type of the element, which can be null.
  final String? type;

  /// A nullable integer representing a reference.
  final int? ref;

  /// The role of the element, which can be null.
  /// This is typically used to describe the function or purpose of the element
  /// within a relation in OpenStreetMap data.
  final String? role;

  /// A class representing a member of an OSM (OpenStreetMap) element.
  ///
  /// The [Member] class contains information about the type, reference, and role
  /// of a member within an OSM element.
  ///
  /// - [type]: The type of the member (e.g., node, way, relation).
  /// - [ref]: The reference ID of the member.
  /// - [role]: The role of the member within the element.
  Member({this.type, this.ref, this.role});

  /// Creates a new `Member` instance from a map.
  ///
  /// The [map] parameter must contain the following keys:
  /// - `type`: The type of the member.
  /// - `ref`: The reference ID of the member.
  /// - `role`: The role of the member.
  ///
  /// Returns a `Member` instance with the values from the map.
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(type: map['type'], ref: map['ref'], role: map['role']);
  }

  /// Converts the current object to a map representation.
  ///
  /// Returns a `Map<String, dynamic>` containing the data of the current object.
  /// The map will include the `type`, `ref`, and `role` fields if they are not null.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if (type != null) {
      data['type'] = type;
    }

    if (ref != null) {
      data['ref'] = ref;
    }

    if (role != null) {
      data['role'] = role;
    }

    return data;
  }
}
