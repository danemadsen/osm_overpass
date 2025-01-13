import 'clause.dart';

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
}
