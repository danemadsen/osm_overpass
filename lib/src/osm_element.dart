enum ElementType {
  node,
  way,
  relation,
  area;
}

class Element {
  final String set;
  final ElementType type;
  final Map<String, String> tags;

  Element({
    this.set = '_',
    required this.type, 
    required this.tags
  });

  @override
  String toString() {
    String value = type.name;
    for (final entry in tags.entries) {
      value += '[${entry.key}="${entry.value}"]';
    }
    return '$value;';
  }
}