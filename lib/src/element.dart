import 'clause.dart';
import 'operation.dart';

enum ElementType {
  node,
  way,
  relation,
  area;
}

class Element {
  final String set;
  final ElementType type;
  final List<Clause> clauses;

  Element({
    this.set = '_',
    required this.type, 
    required this.clauses
  });

  @override
  String toString() {
    String value = type.name;
    for (final clause in clauses) {
      value += clause.toString();
    }
    return '$value;';
  }

  Union operator +(dynamic other) {
    if (other is Element) {
      return Union([this, other]);
    } 
    else if (other is Union) {
      return Union([this, ...other.elements]);
    } 
    else {
      throw ArgumentError('Invalid type for operator +');
    }
  }

  Difference operator -(Element other) {
    return Difference(this, other);
  }
}
