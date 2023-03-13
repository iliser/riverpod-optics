import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class PushConfig {
  PushConfig(this.personalPush, this.commercialPush);

  final bool personalPush;
  final bool commercialPush;
}

extension L<T> on RiverpodLens<T, PushConfig> {
  RiverpodLens<T, bool> get personalPush => this.proxy(
        (object) => object.personalPush,
        (object, updater) => PushConfig(
          updater(object.personalPush),
          object.commercialPush,
        ),
      );
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = _counter.lens.watch(ref);

    final push = _counter.lens.watch(ref);

    Type t<T>() => T;
    final type = t<int?>();

    if (type == t<int?>()) {
      debugPrint('type is nullable');
    } else {
      debugPrint('type is required');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
