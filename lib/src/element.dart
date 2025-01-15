import 'package:latlong2/latlong.dart';

class Element {
  int? id;
  Map<String, String>? tags;

  Element({this.id, this.tags});

  Element.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tags = map['tags'];
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
}

class Node extends Element {
  LatLng? latLng;

  Node({super.id, super.tags, this.latLng});

  Node.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    latLng = LatLng(map['lat'], map['lon']);
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = super.toMap();
    
    if (latLng != null) {
      data['lat'] = latLng!.latitude;
      data['lon'] = latLng!.longitude;
    }

    return data;
  }
}

class Way extends Element {
  List<int>? nodes;

  Way({super.id, super.tags, this.nodes});

  Way.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    nodes = map['nodes'];
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = super.toMap();
    
    if (nodes != null) {
      data['nodes'] = nodes;
    }

    return data;
  }
}

class Relation extends Element {
  List<Member>? members;

  Relation({super.id, super.tags, this.members});

  Relation.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    members = map['members'];
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = super.toMap();
    
    if (members != null) {
      data['members'] = members;
    }

    return data;
  }
}

class Member {
  String? type;
  int? ref;
  String? role;

  Member({this.type, this.ref, this.role});

  Member.fromMap(Map<String, dynamic> map) {
    type = map['type'];
    ref = map['ref'];
    role = map['role'];
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