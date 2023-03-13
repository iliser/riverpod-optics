import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO rename it
class RiverpodAdapterAccessor<O, R> {
  RiverpodAdapterAccessor(this.value, this.update);

  final R value;
  final O Function(O Function(O v) updater) update;
}

abstract class RiverpodLensProviderAdapter<O> {
  RiverpodAdapterAccessor<O, T> watch<T>(WidgetRef ref, T Function(O) selector);
}
