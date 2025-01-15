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