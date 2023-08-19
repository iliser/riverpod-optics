import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_persistent_state/riverpod_persistent_state.dart';

import '../classic_lens.dart';
import '../focused_lens.dart';
import 'riverpod_lens.dart';

class _Lens<O, R> implements RiverpodLens<O, R> {
  _Lens(this.provider, this.lens);

  final PersistentStateProvider<O> provider;
  final ClassicLens<O, R> lens;

  @override
  RiverpodLens<O, I> riverpodLensProxy<I>(
    I Function(R object) valueFn,
    R Function(R object, I Function(I oldValue) updater) updateFn,
  ) {
    return _Lens(
      provider,
      lens.proxy(valueFn, updateFn),
    );
  }

  @override
  FocusedLens<R> riverpodLensWatchFocus(WidgetRef ref) {
    final value = ref.watch(provider.select((v) => lens.value(v.requireValue)));
    final update = ref.watch(provider.notifier).update;

    return FocusedLens.clojure(
      () => value,
      (updater) => lens.value(
        update((v) => lens.update(v, updater)).requireValue,
      ),
    );
  }
}

extension PersistentStateProviderAdapterExtension<T>
    on PersistentStateProvider<T> {
  RiverpodLens<T, T> get lens => _Lens(this, ValueLens());
}
