import 'filter.dart';

abstract class QueryLanguage {
  String toQuery({ String? set });
}

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

class Union extends QueryLanguage {
  final List<Element> elements;

  Union(this.elements);

  @override
  String toQuery({String? set}) {
    String osmString = '(';

    for (final element in elements) {
      osmString += element.toQuery();
    }

    osmString += ')->.${set ?? '_'};';
    
    return osmString;
  }

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

class Difference extends QueryLanguage {
  final Element a;
  final Element b;

  Difference(this.a, this.b);

  @override
  String toQuery({String? set}) {
    return '(${a.toQuery()} - ${b.toQuery()})->.${set ?? '_'};';
  }
}