import 'element.dart';
import 'operation.dart';

class Difference extends Operation {
  final Element a;
  final Element b;

  Difference({required this.a, required this.b}) {
    if (a.set != b.set) throw ArgumentError('Elements must be in the same set');
  }

  @override
  String toOsmString() {
    return '(${a.toString()}; - ${b.toString()};)->.${a.set};';
  }
}