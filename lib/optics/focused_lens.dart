// lens that locked on state object and allow to manipulate it
abstract class FocusedLens<T> {
  // provide access to object through clojure
  factory FocusedLens.clojure(
    T Function() valueFn,
    T Function(T Function(T oldValue) updater) updateFn,
  ) =>
      _FocusedLensClojure(valueFn, updateFn);

  T get value;
  T update(T Function(T oldValue) updater);
}

class _FocusedLensClojure<T> implements FocusedLens<T> {
  _FocusedLensClojure(this.valueFn, this.updateFn);

  final T Function() valueFn;
  final T Function(T Function(T oldValue) updater) updateFn;

  @override
  T update(T Function(T oldValue) updater) => updateFn(updater);

  @override
  T get value => valueFn();
}
