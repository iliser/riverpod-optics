import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optics/optics.dart';

class Config {
  final bool enablePush;
  final bool saveHistory;

  Config(this.enablePush, this.saveHistory);

  Config copyWith({bool? enablePush, bool? saveHistory}) {
    return Config(
      enablePush ?? this.enablePush,
      saveHistory ?? this.saveHistory,
    );
  }
}

extension<T> on RiverpodLens<T, Config> {
  RiverpodLens<T, bool> get enablePush => proxyBySymbol(
        #enablePush,
        (v) => v.enablePush,
      );
  RiverpodLens<T, bool> get saveHistory => proxyBySymbol(
        #saveHistory,
        (v) => v.saveHistory,
      );
}

final configProvider = StateProvider((ref) => Config(false, false));

void main() {
  test('adds one to input values', () {});
}
