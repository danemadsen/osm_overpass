extension NodeExtension on Map<String, String> {
  String _createNode(String key, String value) => 'node($key="$value");\n';

  String _addSet(String str, String? set) {
    if (set == null) return '$str;';
    return '$str->.$set;';
  }
  
  String? toNodes({String? set}) {
    if (entries.isEmpty) return null;

    String nodes = '';
    for (var entry in entries) {
      nodes += _createNode(entry.key, entry.value);
    }

    if (entries.length == 1) {
      return _addSet(nodes, set);
    }
    return _addSet('(\n$nodes)', set);
  }
}