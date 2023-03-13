import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../focused_lens.dart';

abstract class RiverpodLens<O, R> {
  const RiverpodLens();

  FocusedLens<R> watch(WidgetRef ref);

  RiverpodLens<O, I> proxy<I>(
    I Function(R object) valueFn,
    R Function(R object, I Function(I oldValue) updater) updateFn,
  );
}

class OptionalLens<O, R> extends RiverpodLens<O, R?> {
  OptionalLens.from(this.lens);

  final RiverpodLens<O, R?> lens;

  @override
  RiverpodLens<O, I> proxy<I>(
    I Function(R? object) valueFn,
    R? Function(R? object, I Function(I oldValue) updater) updateFn,
  ) =>
      lens.proxy(valueFn, updateFn);

  @override
  FocusedLens<R?> watch(WidgetRef ref) => lens.watch(ref);
}
