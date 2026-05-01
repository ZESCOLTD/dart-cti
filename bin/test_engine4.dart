import 'package:dart_cti/minipod/minipod.dart';

void main() {
  final container = MiniProviderContainer();

  var createdCount = 0;

  final messageProvider = MiniProvider<String>((ref) {
    createdCount++;
    return 'instance #$createdCount';
  });

  final first = container.read(messageProvider);
  print(first); // instance #1

  container.invalidate(messageProvider);

  final second = container.read(messageProvider);
  print(second); // instance #2

  container.dispose();
}
