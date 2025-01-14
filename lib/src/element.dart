import 'clause.dart';
import 'operation.dart';
import 'query_language.dart';

enum ElementType {
  node,
  way,
  relation,
  area;
}

class Element extends QueryLanguage {
  final ElementType type;
  final List<Clause> clauses;

  Element({
    required this.type, 
    required this.clauses
  });

  @override
  String toQuery({String? set}) {
    String value = type.name;

    for (final clause in clauses) {
      value += clause.toString();
    }

    if (set != null) {
      value += '->.$set';
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
