import 'package:latlong2/latlong.dart';

abstract class Filter {
  String toFilter();
}

class KeyFilter extends Filter {
  final String key;

  KeyFilter(this.key);

  @override
  String toFilter() {
    return '["$key"]';
  }

  NotKeyFilter operator -() {
    return NotKeyFilter(key);
  }
}

class NotKeyFilter extends Filter {
  final String key;

  NotKeyFilter(this.key);

  @override
  String toFilter() {
    return '[!"$key"]';
  }

  KeyFilter operator -() {
    return KeyFilter(key);
  }
}

class KeyValueFilter extends Filter {
  final String key;
  final String value;

  KeyValueFilter({required this.key, required this.value});

  factory KeyValueFilter.fromMapEntry(MapEntry<String, String> entry) {
    return KeyValueFilter(key: entry.key, value: entry.value);
  }

  @override
  String toFilter() {
    return '["$key"="$value"]';
  }

  NotKeyValueFilter operator -() {
    return NotKeyValueFilter(key: key, value: value);
  }
}

class NotKeyValueFilter extends Filter {
  final String key;
  final String value;

  NotKeyValueFilter({required this.key, required this.value});

  factory NotKeyValueFilter.fromMapEntry(MapEntry<String, String> entry) {
    return NotKeyValueFilter(key: entry.key, value: entry.value);
  }

  @override
  String toFilter() {
    return '["$key"!="$value"]';
  }

  KeyValueFilter operator -() {
    return KeyValueFilter(key: key, value: value);
  }
}

class KeyRegexValueFilter extends Filter {
  final String key;
  final String value;

  KeyRegexValueFilter({required this.key, required this.value});

  factory KeyRegexValueFilter.fromMapEntry(MapEntry<String, String> entry) {
    return KeyRegexValueFilter(key: entry.key, value: entry.value);
  }

  @override
  String toFilter() {
    return '["$key"~"$value"]';
  }

  KeyNotRegexValueFilter operator -() {
    return KeyNotRegexValueFilter(key: key, value: value);
  }
}

class KeyNotRegexValueFilter extends Filter {
  final String key;
  final String value;

  KeyNotRegexValueFilter({required this.key, required this.value});

  factory KeyNotRegexValueFilter.fromMapEntry(MapEntry<String, String> entry) {
    return KeyNotRegexValueFilter(key: entry.key, value: entry.value);
  }

  @override
  String toFilter() {
    return '["$key"!~"$value"]';
  }

  KeyRegexValueFilter operator -() {
    return KeyRegexValueFilter(key: key, value: value);
  }
}

class RegexKeyRegexValueFilter extends Filter {
  final String key;
  final String value;

  RegexKeyRegexValueFilter({required this.key, required this.value});

  factory RegexKeyRegexValueFilter.fromMapEntry(MapEntry<String, String> entry) {
    return RegexKeyRegexValueFilter(key: entry.key, value: entry.value);
  }

  @override
  String toFilter() {
    return '["~$key"~"$value"]';
  }
}

class BboxFilter extends Filter {
  final double south;
  final double west;
  final double north;
  final double east;

  BboxFilter({
    required this.south, 
    required this.west, 
    required this.north, 
    required this.east
  });

  @override
  String toFilter() {
    return '($south,$west,$north,$east)';
  }
}

enum RecurseFilterTypes {
  n,  // Forwards to nodes
  w,  // Forwards to ways
  r,  // Forwards to relations
  bn, // Backwards to nodes
  bw, // Backwards to ways
  br  // Backwards to relations
}

class RecurseFilter extends Filter {
  final RecurseFilterTypes type;
  final String set;
  final String? role;

  RecurseFilter({required this.type, this.set = '_', this.role});

  @override
  String toFilter() {
    if (role != null) {
      return '(${type.name}.$set:$role)';
    }

    return '(${type.name}.$set)';
  }
}

class SetFilter extends Filter {
  final List<String> sets;

  SetFilter(this.sets);

  @override
  String toFilter() {
    return '.${sets.join('.')}';
  }
}

class IdFilter extends Filter {
  final List<int> ids;

  IdFilter(this.ids);

  @override
  String toFilter() {
    if (ids.length == 1) {
      return '(${ids.first})';
    }

    return '(id:${ids.join(',')})';
  }
}

class AroundFilter extends Filter {
  final String set;
  final double radius;
  final List<LatLng>? points;

  AroundFilter({required this.set, required this.radius, this.points});

  @override
  String toFilter() {
    if (points != null) {
      return '(around.$set:$radius,${points!.map((point) => '${point.latitude},${point.longitude}').join(',')})';
    }

    return '(around.$set:$radius)';
  }
}