extension HigherOrderFunctionality<T> on T? {
  /// Perform [action] on [this] if this is not null
  A? map<A>(A Function(T value) action) {
    if (this != null) {
      return action(this as T);
    } else {
      return null;
    }
  }
}
