abstract class Evaluator {
  String toQueryLanguage();

  bool _validEvaluator(dynamic value) {
    if (
      value is int || 
      value is double || 
      value is DateTime || 
      value is String || 
      value is Evaluator
    ) {
      return true;
    }
    else {
      return false;
    }
  }

  String _getEvaluatorString(dynamic evaluator) {
    if (evaluator is int || evaluator is double) {
      return evaluator.toString();
    }
    else if (evaluator is DateTime) {
      return '"${evaluator.toIso8601String()}"';
    }
    else if (evaluator is String) {
      return '"$evaluator"';
    }
    else if (evaluator is Evaluator) {
      return evaluator.toQueryLanguage();
    }
    else {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  NotEvaluator operator -() {
    return NotEvaluator(this);
  }

  OrEvaluator operator |(dynamic other) {
    return OrEvaluator(this, other);
  }

  AndEvaluator operator &(dynamic other) {
    return AndEvaluator(this, other);
  }

  LessThanEvaluator operator <(dynamic other) {
    return LessThanEvaluator(this, other);
  }

  LessThanOrEqualEvaluator operator <=(dynamic other) {
    return LessThanOrEqualEvaluator(this, other);
  }

  GreaterThanEvaluator operator >(dynamic other) {
    return GreaterThanEvaluator(this, other);
  }

  GreaterThanOrEqualEvaluator operator >=(dynamic other) {
    return GreaterThanOrEqualEvaluator(this, other);
  }

  PlusEvaluator operator +(dynamic other) {
    return PlusEvaluator(this, other);
  }

  MinusEvaluator operator -(dynamic other) {
    return MinusEvaluator(this, other);
  }

  MultiplyEvaluator operator *(dynamic other) {
    return MultiplyEvaluator(this, other);
  }

  DivideEvaluator operator /(dynamic other) {
    return DivideEvaluator(this, other);
  }
}

class DynamicEvaluator extends Evaluator {
  final dynamic value;

  DynamicEvaluator(this.value) {
    if (!_validEvaluator(value)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return _getEvaluatorString(value);
  }
}

class NotEvaluator extends Evaluator {
  final dynamic evaluator;

  NotEvaluator(this.evaluator) {
    if (evaluator is NotEvaluator) {
      throw ArgumentError('Cannot have nested NotEvaluator');
    }
    else if (!_validEvaluator(evaluator)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '! ${_getEvaluatorString(evaluator)}';
  }
}

class OrEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  OrEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} || ${_getEvaluatorString(right)}';
  }
}

class AndEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  AndEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} && ${_getEvaluatorString(right)}';
  }
}

class EqualityEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  EqualityEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} == ${_getEvaluatorString(right)}';
  }
}

class InequalityEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  InequalityEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} != ${_getEvaluatorString(right)}';
  }
}

class ParenthesesEvaluator extends Evaluator {
  final dynamic evaluator;

  ParenthesesEvaluator(this.evaluator) {
    if (!_validEvaluator(evaluator)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '(${_getEvaluatorString(evaluator)})';
  }
}

class LessThanEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  LessThanEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} < ${_getEvaluatorString(right)}';
  }
}

class LessThanOrEqualEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  LessThanOrEqualEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} <= ${_getEvaluatorString(right)}';
  }
}

class GreaterThanEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  GreaterThanEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} > ${_getEvaluatorString(right)}';
  }
}

class GreaterThanOrEqualEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  GreaterThanOrEqualEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} >= ${_getEvaluatorString(right)}';
  }
}

class PlusEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  PlusEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} + ${_getEvaluatorString(right)}';
  }
}

class MinusEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  MinusEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} - ${_getEvaluatorString(right)}';
  }
}

class MultiplyEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  MultiplyEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} * ${_getEvaluatorString(right)}';
  }
}

class DivideEvaluator extends Evaluator {
  final dynamic left;
  final dynamic right;

  DivideEvaluator(this.left, this.right) {
    if (!_validEvaluator(left) || !_validEvaluator(right)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(left)} / ${_getEvaluatorString(right)}';
  }
}

class TernaryEvaluator extends Evaluator {
  final dynamic condition;
  final dynamic trueValue;
  final dynamic falseValue;

  TernaryEvaluator(this.condition, this.trueValue, this.falseValue) {
    if (!_validEvaluator(condition) || !_validEvaluator(trueValue) || !_validEvaluator(falseValue)) {
      throw ArgumentError('Invalid type for evaluator');
    }
  }

  @override
  String toQueryLanguage() {
    return '${_getEvaluatorString(condition)} ? ${_getEvaluatorString(trueValue)} : ${_getEvaluatorString(falseValue)}';
  }
}