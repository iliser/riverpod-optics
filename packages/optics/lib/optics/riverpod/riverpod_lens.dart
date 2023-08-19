import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optics/optics/optics.dart';

abstract class RiverpodLens<O, R> {
  const RiverpodLens();

  // focus classic lens into object in ref context
  FocusedLens<R> riverpodLensWatchFocus(WidgetRef ref);

  // proxy lens with functions
  RiverpodLens<O, I> riverpodLensProxy<I>(
    I Function(R object) valueFn,
    R Function(R object, I Function(I oldValue) updater) updateFn,
  );

  static FocusedLens<R> focus<O, R>(
    RiverpodLens<O, R> lens,
    WidgetRef ref,
  ) {
    return lens.riverpodLensWatchFocus(ref);
  }

  static RiverpodLens<O, I> proxy<O, R, I>(
    RiverpodLens<O, R> lens,
    I Function(R object) valueFn,
    R Function(R object, I Function(I oldValue) updater) updateFn,
  ) {
    return lens.riverpodLensProxy(valueFn, updateFn);
  }

  static RiverpodLens<O, I> proxyWithLens<O, R, I>(
    RiverpodLens<O, R> lens,
    ClassicLens<R, I> lensToFocus,
  ) {
    return lens.riverpodLensProxy(lensToFocus.value, lensToFocus.update);
  }
}
