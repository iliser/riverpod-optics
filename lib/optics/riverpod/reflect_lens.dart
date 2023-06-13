import 'package:optics/optics/classic_lens.dart';

import 'riverpod_lens.dart';

abstract class LensReflect<T> {
  dynamic getField(Symbol name);
}

extension LensReflectProxy<T, O extends LensReflect<O>> on RiverpodLens<T, O> {
  RiverpodLens<T, R> proxyBySymbol<R>(Symbol symbol) =>
      RiverpodLens.proxyWithLens<T, O, R>(
        this,
        CopyWithLens<O, R>(symbol),
      );
}

// target for codegen

// Hack for simplify copy with lens defination
class CopyWithLens<O extends LensReflect<O>, R> extends ClassicLens<O, R> {
  final Symbol name;

  CopyWithLens(this.name);

  @override
  O update(O object, R Function(R oldValue) updater) {
    final copyWith = (object as dynamic).copyWith;
    return Function.apply(
      copyWith is Function ? copyWith : copyWith.call,
      [],
      {name: updater(object.getField(name))},
    );
  }

  @override
  R value(O object) => (object as dynamic).getField(name);
}
