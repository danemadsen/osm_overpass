import 'package:latlong2/latlong.dart';

import 'constants.dart';

abstract class Filter {
  String toQueryLanguage();
}

class KeyFilter extends Filter {
  final String key;

  KeyFilter(this.key);

  @override
  String toQueryLanguage() {
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
  String toQueryLanguage() {
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
  String toQueryLanguage() {
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
  String toQueryLanguage() {
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
  String toQueryLanguage() {
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
  String toQueryLanguage() {
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
  String toQueryLanguage() {
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
  String toQueryLanguage() {
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

  RecurseFilter({required this.type, this.set = kDefaultSet, this.role});

  @override
  String toQueryLanguage() {
    if (role != null) {
      return '(${type.name}.$set:$role)';
    }

    return '(${type.name}.$set)';
  }
}

class SetFilter extends Filter {
  final List<String> sets;

  SetFilter(this.sets);

  SetFilter.single(String set) : sets = [set];

  @override
  String toQueryLanguage() {
    return '.${sets.join('.')}';
  }
}

class IdFilter extends Filter {
  final List<int> ids;

  IdFilter(this.ids);

  IdFilter.single(int id) : ids = [id];

  @override
  String toQueryLanguage() {
    if (ids.length == 1) {
      return '(${ids.first})';
    }

    return '(id:${ids.join(',')})';
  }
}

class AroundFilter extends Filter {
  final double radius;
  final String set;
  final List<LatLng>? points;

  AroundFilter({required this.radius, this.set = kDefaultSet, this.points});

  @override
  String toQueryLanguage() {
    if (points != null) {
      return '(around.$set:$radius,${points!.map((point) => '${point.latitude},${point.longitude}').join(',')})';
    }

    return '(around.$set:$radius)';
  }
}

class PolygonFilter extends Filter {
  final List<LatLng> points;

  PolygonFilter(this.points);

  @override
  String toQueryLanguage() {
    return '(poly:"${points.map((point) => '${point.latitude},${point.longitude}').join(' ')}")';
  }
}

class NewerFilter extends Filter {
  final DateTime date;

  NewerFilter(this.date);

  @override
  String toQueryLanguage() {
    return '(newer:"${date.toIso8601String()}")';
  }
}

class ChangedFilter extends Filter {
  final List<DateTime> dates;

  ChangedFilter(this.dates);

  ChangedFilter.single(DateTime date) : dates = [date];

  @override
  String toQueryLanguage() {
    return '(changed:"${dates.map((date) => date.toIso8601String()).join('","')}")';
  }
}

class UserFilter extends Filter {
  final List<String> users;

  UserFilter(this.users);

  UserFilter.single(String user) : users = [user];

  @override
  String toQueryLanguage() {
    return '(user:"${users.join('","')}")';
  }
}

class UserIdFilter extends Filter {
  final List<int> ids;

  UserIdFilter(this.ids);

  UserIdFilter.single(int id) : ids = [id];

  @override
  String toQueryLanguage() {
    return '(uid:${ids.join(',')})';
  }
}

class AreaFilter extends Filter {
  final String set;
  final int? id;

  AreaFilter({this.id, this.set = kDefaultSet});

  @override
  String toQueryLanguage() {
    if (id != null) {
      return '(area.$set:$id)';
    }

    return '(area.$set)';
  }
}

class PivotFilter extends Filter {
  final String set;
  
  PivotFilter({this.set = kDefaultSet});

  @override
  String toQueryLanguage() {
    return '(pivot.$set)';
  }
}