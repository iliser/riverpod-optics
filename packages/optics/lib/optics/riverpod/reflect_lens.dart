import 'package:optics/optics/classic_lens.dart';

import 'riverpod_lens.dart';

extension LensReflectProxy<T, O> on RiverpodLens<T, O> {
  RiverpodLens<T, R> proxyBySymbol<R>(Symbol symbol, R Function(O) getField) =>
      RiverpodLens.proxyWithLens<T, O, R>(
        this,
        CopyWithLens<O, R>(symbol, getField),
      );
}

// target for codegen

// Hack for simplify copy with lens defination
class CopyWithLens<O, R> extends ClassicLens<O, R> {
  final Symbol name;
  final R Function(O) getValue;

  CopyWithLens(this.name, this.getValue);

  @override
  O update(O object, R Function(R oldValue) updater) {
    final copyWith = (object as dynamic).copyWith;
    return Function.apply(
      copyWith is Function ? copyWith : copyWith.call,
      [],
      {name: updater(getValue(object))},
    );
  }

  @override
  R value(O object) => getValue(object);
}
