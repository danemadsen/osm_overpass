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

  Union(this.elements);

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

  Union operator +(dynamic other) {
    if (other is Element) {
      return Union([...elements, other]);
    } 
    else if (other is Union) {
      return Union([...elements, ...other.elements]);
    } 
    else {
      throw ArgumentError('Invalid type for operator +');
    }
  }

  Union operator -(dynamic other) {
    if (other is Element) {
      return Union(elements.where((element) => element != other).toList());
    } 
    else if (other is Union) {
      return Union(elements.where((element) => !other.elements.contains(element)).toList());
    } 
    else {
      throw ArgumentError('Invalid type for operator -');
    }
  }
}

class Difference extends Operation {
  final Element a;
  final Element b;

  Difference(this.a, this.b) {
    if (a.set != b.set) throw ArgumentError('Elements must be in the same set');
  }

  @override
  String toString() {
    return '(${a.toString()}; - ${b.toString()};)->.${a.set};';
  }

  @override
  OperationType get type => OperationType.difference;
}