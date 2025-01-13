import 'element.dart';

enum OperationType {
  union,
  difference;
}

abstract class Operation {
  OperationType get type;
}

class Union extends Operation {
  final List<Element> elements;

  Union({required this.elements});

  @override
  String toString() {
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

  @override
  OperationType get type => OperationType.union;
}

class Difference extends Operation {
  final Element a;
  final Element b;

  Difference({required this.a, required this.b}) {
    if (a.set != b.set) throw ArgumentError('Elements must be in the same set');
  }

  @override
  String toString() {
    return '(${a.toString()}; - ${b.toString()};)->.${a.set};';
  }

  @override
  OperationType get type => OperationType.difference;
}