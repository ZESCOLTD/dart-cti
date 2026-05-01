import 'package:dart_cti/minipod/minipod.dart';

void main() {
  final container = MiniProviderContainer();

  var createdCount = 0;

  final numberProvider = MiniProvider<int>((ref) {
    createdCount++;
    print('Creating provider...');
    return 42;
  });

  final a = container.read(numberProvider);
  final b = container.read(numberProvider);

  print('a = $a');
  print('b = $b');
  print('createdCount = $createdCount');

  container.invalidate(numberProvider);

  final c = container.read(numberProvider);
  print('c = $c');
  print('createdCount = $createdCount');

  container.dispose();
}
