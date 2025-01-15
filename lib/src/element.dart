import 'package:latlong2/latlong.dart';

class Element {
  final int? id;
  final Map<String, dynamic>? tags;

  Element({this.id, this.tags});

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

  static List<Element> fromList(List<dynamic> list) {
    final List<Element> elements = [];
    for (final element in list) {
      elements.add(Element.fromMap(element));
    }

    return elements;
  }
}

class Node extends Element {
  final LatLng? latLng;

  Node({super.id, super.tags, this.latLng});

  factory Node.fromMap(Map<String, dynamic> map) {
    final lat = map['lat'];
    final lon = map['lon'];
    final latLng = lat != null && lon != null ? LatLng(lat, lon) : null;

    return Node(
      id: map['id'],
      tags: map['tags'],
      latLng: latLng
    );
  }

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

class Way extends Element {
  final List<int>? nodes;

  Way({super.id, super.tags, this.nodes});

  factory Way.fromMap(Map<String, dynamic> map) {
    return Way(
      id: map['id'],
      tags: map['tags'],
      nodes: map['nodes']
    );
  }

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

class Relation extends Element {
  final List<Member>? members;

  Relation({super.id, super.tags, this.members});

  factory Relation.fromMap(Map<String, dynamic> map) {
    final List<Member> members = [];
    if (map['members'] != null) {
      for (final member in map['members']) {
        members.add(Member.fromMap(member));
      }
    }

    return Relation(
      id: map['id'],
      tags: map['tags'],
      members: members
    );
  }

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

class Area extends Element {
  Area({super.id, super.tags});

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: map['id'],
      tags: map['tags']
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = super.toMap();

    data['type'] = 'area';

    return data;
  }
}

class Member {
  final String? type;
  final int? ref;
  final String? role;

  Member({this.type, this.ref, this.role});

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      type: map['type'],
      ref: map['ref'],
      role: map['role']
    );
  }

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