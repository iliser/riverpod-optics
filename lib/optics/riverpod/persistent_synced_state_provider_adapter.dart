import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_persistent_state/riverpod_persistent_state.dart';

import '../classic_lens.dart';
import 'riverpod_lens.dart';
import 'riverpod_lens_provider_adapter.dart';

class _Adapter<O> implements RiverpodLensProviderAdapter<O> {
  _Adapter(this.provider);

  final PersistentSyncedStateProvider<O> provider;

  @override
  RiverpodAdapterAccessor<O, T> watch<T>(
    WidgetRef ref,
    T Function(O) selector,
  ) {
    final value = ref.watch(provider.select(selector));
    final update = ref.watch(provider.notifier).update;

    return RiverpodAdapterAccessor(value, update);
  }
}

extension PersistentSyncedStateProviderAdapterExtension<T>
    on PersistentSyncedStateProvider<T> {
  RiverpodLens<T, T> get lens => RiverpodLens(
        _Adapter(this),
        ValueLens(),
      );
}
