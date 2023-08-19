import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optics_annotation/optics_annotation.dart';
import 'package:optics/optics.dart';

part 'config.freezed.dart';
part 'config.proxy_lens.dart';

@freezed
@generateOpticsExtension
class SomeData with _$SomeData {
  const SomeData._();

  const factory SomeData({
    required String id,
    required List<int> data,
  }) = _Data;
}
