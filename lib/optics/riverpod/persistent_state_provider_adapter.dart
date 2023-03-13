import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_persistent_state/riverpod_persistent_state.dart';

import '../classic_lens.dart';
import 'riverpod_lens.dart';
import 'riverpod_lens_provider_adapter.dart';

class _Adapter<O> implements RiverpodLensProviderAdapter<O> {
  _Adapter(this.provider);

  final PersistentStateProvider<O> provider;

  @override
  RiverpodAdapterAccessor<O, T> watch<T>(
    WidgetRef ref,
    T Function(O) selector,
  ) {
    final value =
        ref.watch(provider.select((v) => v.whenData(selector).requireValue));
    O update(O Function(O) updater) =>
        ref.watch(provider.notifier).update(updater).requireValue;

    return RiverpodAdapterAccessor(value, update);
  }
}

extension PersistentStateProviderAdapterExtension<T>
    on PersistentStateProvider<T> {
  RiverpodLens<T, T> get lens => RiverpodLens(
        _Adapter(this),
        ValueLens(),
      );
}
