import 'filter.dart';
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
  final List<Filter> filters;

  Element({
    required this.type, 
    required this.filters
  });

  @override
  String toQuery({String? set}) {
    String value = type.name;

    for (final filter in filters) {
      value += filter.toFilter();
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
