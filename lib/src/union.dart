import 'element.dart';
import 'operation.dart';

class Union extends Operation {
  final List<Element> elements;

  Union({required this.elements});

  @override
  String toOsmString() {
    // Group elements by set
    Map<String, List<Element>> sets = {};
    for (final element in elements) {
      if (!sets.containsKey(element.set)) {
        sets[element.set] = [];
      }
      sets[element.set]!.add(element);
    }

    // Generate OSM string
    String osmString = '';
    for (final set in sets.entries) {
      osmString += '(';
      for (final element in set.value) {
        osmString += element.toString();
      }
      osmString += ')->.${set.key};';
    }
    
    return osmString;
  }
}