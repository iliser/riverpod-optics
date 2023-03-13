// hold classic lens and provider and allow to build `FocusedLens` from it
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../classic_lens.dart';
import '../focused_lens.dart';
import 'riverpod_lens_provider_adapter.dart';

class RiverpodLens<O, R> {
  RiverpodLens(this.adapter, this.lens);

  final RiverpodLensProviderAdapter<O> adapter;
  final ClassicLens<O, R> lens;

  FocusedLens<R> watch(WidgetRef ref) {
    final state = adapter.watch(ref, lens.value);
    final value = state.value;
    final update = state.update;

    return FocusedLens.clojure(
      () => value,
      (updater) => lens.value(update((v) => lens.update(v, updater))),
    );
  }

  RiverpodLens<O, I> proxy<I>(
    I Function(R object) valueFn,
    R Function(R object, I Function(I oldValue) updater) updateFn,
  ) {
    return RiverpodLens(
      adapter,
      lens.proxy(valueFn, updateFn),
    );
  }
}

class OptionalLens<O, R> extends RiverpodLens<O, R?> {
  OptionalLens(super.adapter, super.lens);

  OptionalLens.from(RiverpodLens<O, R?> lens) : super(lens.adapter, lens.lens);
}
