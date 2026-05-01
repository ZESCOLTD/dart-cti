import 'package:dart_cti/minipod/minipod.dart';

void main() {
  final container = MiniProviderContainer();

  final counterProvider = MiniStateProvider<int>((ref) => 0);

  final counter = container.read(counterProvider);

  final unsubscribe = counter.addListener(() {
    print('Counter changed -> ${counter.state}');
  });

  print(counter.state); // 0
  counter.state = 1; // listener fires
  counter.state = 2; // listener fires

  unsubscribe();
  counter.state = 3; // no listener now

  container.dispose();
}
