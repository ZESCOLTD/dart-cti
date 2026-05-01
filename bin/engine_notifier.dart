import 'package:dart_cti/minipod/minipod.dart';

class CounterNotifier extends MiniNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state = state + 1;
  void decrement() => state = state - 1;
}

void main() {
  final container = MiniProviderContainer();

  final counterProvider = MiniNotifierProvider<CounterNotifier, int>((ref) {
    return CounterNotifier();
  });

  final counter = container.read(counterProvider);

  final unsubscribe = counter.addListener(() {
    print('Notifier state -> ${counter.state}');
  });

  counter.increment();
  counter.increment();
  counter.decrement();

  unsubscribe();
  container.dispose();
}
