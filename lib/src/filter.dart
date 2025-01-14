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

class SetFilter extends Filter {
  final String set;

  SetFilter(this.set);

  @override
  String toFilter() {
    return '.$set';
  }
}

class SetIntersectionFilter extends Filter {
  final List<String> sets;

  SetIntersectionFilter(this.sets);

  @override
  String toFilter() {
    return '.${sets.join('.')}';
  }
}