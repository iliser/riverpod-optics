import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_persistent_state/riverpod_persistent_state.dart';

import '../classic_lens.dart';
import '../focused_lens.dart';
import 'riverpod_lens.dart';

class _Lens<O, R> implements RiverpodLens<O, R> {
  _Lens(this.provider, this.lens);

  final PersistentSyncedStateProvider<O> provider;
  final ClassicLens<O, R> lens;

  @override
  RiverpodLens<O, I> proxy<I>(
    I Function(R object) valueFn,
    R Function(R object, I Function(I oldValue) updater) updateFn,
  ) {
    return _Lens(
      provider,
      lens.proxy(valueFn, updateFn),
    );
  }

  @override
  FocusedLens<R> watch(WidgetRef ref) {
    final value = ref.watch(provider.select(lens.value));
    final update = ref.watch(provider.notifier).update;

    return FocusedLens.clojure(
      () => value,
      (updater) => lens.value(update((v) => lens.update(v, updater))),
    );
  }
}

extension PersistentSyncedStateProviderAdapterExtension<T>
    on PersistentSyncedStateProvider<T> {
  RiverpodLens<T, T> get lens => _Lens(this, ValueLens());
}
