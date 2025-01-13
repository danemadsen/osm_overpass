enum ElementType {
  node,
  way,
  relation,
  area;
}

class Element {
  final ElementType type;
  final Map<String, String> tags;

  Element({
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

extension Elements on List<Element> {
  String toSetString({String? set = '_'}) {
    String nodes = '';
    for (final element in this) {
      nodes += element.toString();
    }
    
    return '($nodes)->.$set;';
  }
}