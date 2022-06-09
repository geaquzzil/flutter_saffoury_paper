library flutter_view_controller;

extension IterableModifier<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) =>
      cast<E?>().firstWhere((v) => v != null && test(v), orElse: () => null);
}

/// A Calculator.
class Calculator {
  int dsa = 0;
  int i = 0;

  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
