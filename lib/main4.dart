import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (e) => e).where((e) => e != null).cast();
}

class CountDown extends ValueNotifier<int> {
  late StreamSubscription sub;
  CountDown({required int from}) : super(from) {
    sub = Stream.periodic(
      const Duration(seconds: 1),
      (v) => from - v,
    ).takeWhile((value) => value >= 0).listen((value) {
      this.value = value;
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

class HomePage extends HookWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final countDown = useMemoized(() => CountDown(from: 20));
    final notifier = useListenable(countDown);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Text(notifier.value.toString()),
      ),
    );
  }
}
