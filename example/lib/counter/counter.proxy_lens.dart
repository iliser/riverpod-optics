// ignore_for_file: annotate_overrides, unused_element

part of 'counter.dart';

// **************************************************************************
// ProxyLensGenerator
// **************************************************************************

extension CounterStateLensExtension<T> on RiverpodLens<T, CounterState> {
  RiverpodLens<T, int> get pushed => proxyBySymbol(
        #pushed,
        (v) => v.pushed,
      );
}
