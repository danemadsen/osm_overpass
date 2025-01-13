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
}

class NotKeyClause extends Clause {
  NotKeyClause({required super.key});

  @override
  String toString() {
    return '[!"$key"]';
  }
}

class KeyValueClause extends Clause {
  KeyValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["$key"="$value"]';
  }
}

class NotKeyValueClause extends Clause {
  NotKeyValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["$key"!="$value"]';
  }
}

class KeyRegexValueClause extends Clause {
  KeyRegexValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["$key"~"$value"]';
  }
}

class KeyNotRegexValueClause extends Clause {
  KeyNotRegexValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["$key"!~"$value"]';
  }
}

class RegexKeyRegexValueClause extends Clause {
  RegexKeyRegexValueClause({required super.key, required String super.value});

  @override
  String toString() {
    return '["~$key"~"$value"]';
  }
}
