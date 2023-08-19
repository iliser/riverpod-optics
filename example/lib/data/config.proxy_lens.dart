// ignore_for_file: annotate_overrides, unused_element

part of 'config.dart';

// **************************************************************************
// ProxyLensGenerator
// **************************************************************************

extension SomeDataLensExtension<T> on RiverpodLens<T, SomeData> {
  RiverpodLens<T, String> get id => proxyBySymbol(
        #id,
        (v) => v.id,
      );
  RiverpodLens<T, List<int>> get data => proxyBySymbol(
        #data,
        (v) => v.data,
      );
}
