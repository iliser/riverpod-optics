import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optics_annotation/optics_annotation.dart';
import 'package:optics/optics.dart';

part 'counter.freezed.dart';
part 'counter.proxy_lens.dart';

@freezed
@generateOpticsExtension
class CounterState with _$CounterState {
  const CounterState._();

  const factory CounterState({
    required int pushed,
  }) = _CounterState;
}
