enum OsmElementType {
  node,
  way,
  relation,
  area;
}

class OsmElement {
  final OsmElementType type;
  final Map<String, String> tags;

  OsmElement({
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