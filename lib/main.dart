import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optics/meterial/switch_list_tile.dart';
import 'package:optics/meterial/text_field.dart';
import 'package:optics/optics/optics.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final _counter = StateProvider((ref) => 0);

class PushConfig implements LensReflect<PushConfig> {
  PushConfig(this.personalPush, this.commercialPush, this.readonly);

  final bool personalPush;
  final bool commercialPush;
  final bool readonly;

  @override
  PushConfig copyWith({
    bool? personalPush,
    bool? commercialPush,
    bool? readonly,
  }) {
    return PushConfig(
      personalPush ?? this.personalPush,
      commercialPush ?? this.commercialPush,
      readonly ?? this.readonly,
    );
  }

  @override
  dynamic getField(Symbol field) => switch (field) {
        #personalPush => personalPush,
        #commercialPush => commercialPush,
        #readonly => readonly,
        _ => throw 'field not found'
      };
}

extension<T> on RiverpodLens<T, PushConfig> {
  RiverpodLens<T, bool> get personalPush => proxyBySymbol(#personalPush);
  RiverpodLens<T, bool> get commercialPush => proxyBySymbol(#commercialPush);
  RiverpodLens<T, bool> get readonly => proxyBySymbol(#readonly);
}

final config = StateProvider((ref) => PushConfig(false, false, false));
final stringProvider = StateProvider((ref) => '');

class MyHomePage extends ConsumerWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = RiverpodLens.focus(_counter.lens, ref);

    final push = RiverpodLens.focus(
      _counter.lens.riverpodLensProxy(
        (object) => object.toDouble(),
        (object, updater) => updater(object.toDouble()).toInt(),
      ),
      ref,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Slider(
              divisions: 64,
              value: counter.value.toDouble(),
              onChanged: (v) => counter.change(v.toInt()),
              min: 0,
              max: 64,
            ),
            RadioListTile(
              value: 1,
              groupValue: 1,
              title: Text('first'),
              onChanged: (_) {},
            ),
            RadioListTile(
              value: 2,
              groupValue: 1,
              title: Text('second'),
              onChanged: (_) {},
            ),
            TextFieldL(lens: stringProvider.lens),
            SwitchListTileL(
              lens: config.lens.personalPush,
              title: Text('Personal push'),
            ),
            SwitchListTileL(
              lens: config.lens.commercialPush,
              title: Text('Commercial push'),
            ),
            SwitchListTileL(
              lens: config.lens.readonly,
              title: Text('Readonly'),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.update((v) => ++v),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
