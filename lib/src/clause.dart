abstract class Clause {
  final String key;
  final String? value;

  Clause({required this.key, this.value});
}

class KeyClause extends Clause {
  KeyClause({required super.key});

  @override
  String toString() {
    return '["$key"]';
  }

  NotKeyClause operator -() {
    return NotKeyClause(key: key);
  }
}

class NotKeyClause extends Clause {
  NotKeyClause({required super.key});

  @override
  String toString() {
    return '[!"$key"]';
  }

  KeyClause operator -() {
    return KeyClause(key: key);
  }
}

class KeyValueClause extends Clause {
  KeyValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["$key"="$value"]';
  }

  NotKeyValueClause operator -() {
    return NotKeyValueClause(key: key, value: value!);
  }
}

class NotKeyValueClause extends Clause {
  NotKeyValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["$key"!="$value"]';
  }

  KeyValueClause operator -() {
    return KeyValueClause(key: key, value: value!);
  }
}

class KeyRegexValueClause extends Clause {
  KeyRegexValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["$key"~"$value"]';
  }

  KeyNotRegexValueClause operator -() {
    return KeyNotRegexValueClause(key: key, value: value!);
  }
}

class KeyNotRegexValueClause extends Clause {
  KeyNotRegexValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["$key"!~"$value"]';
  }

  KeyRegexValueClause operator -() {
    return KeyRegexValueClause(key: key, value: value!);
  }
}

class RegexKeyRegexValueClause extends Clause {
  RegexKeyRegexValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["~$key"~"$value"]';
  }
}
