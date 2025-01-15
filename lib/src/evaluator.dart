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
      return evaluator.toIso8601String();
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