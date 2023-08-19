abstract class ClassicLens<O, R> {
  R value(O object);
  O update(O object, R Function(R oldValue) updater);

  ClassicLens<O, I> proxy<I>(
    I Function(R object) valueFn,
    R Function(R object, I Function(I oldValue) updater) updateFn,
  ) {
    return ClassicLensProxy(this, valueFn, updateFn);
  }

  ClassicLens<O, I> proxyWithLens<I>(ClassicLens<R, I> lens) {
    return ClassicLensProxy(this, lens.value, lens.update);
  }
}

class ValueLens<O> extends ClassicLens<O, O> {
  ValueLens();

  @override
  O update(O object, O Function(O oldValue) updater) => updater(value(object));

  @override
  O value(O object) => object;
}

class ClassicLensProxy<O, R, I> extends ClassicLens<O, I> {
  ClassicLensProxy(
    this.lens,
    this.valueFn,
    this.updateFn,
  );

  final ClassicLens<O, R> lens;
  final I Function(R object) valueFn;
  final R Function(R object, I Function(I oldValue) updater) updateFn;

  @override
  O update(O object, I Function(I oldValue) updater) {
    return lens.update(
      object,
      (oldValue) => updateFn(oldValue, updater),
    );
  }

  @override
  I value(O object) => valueFn(lens.value(object));
}
