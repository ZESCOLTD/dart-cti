import 'mini_notifier.dart';
import 'mini_provider_base.dart';
import 'mini_ref.dart';

/// Provider that creates a MiniNotifier.
///
/// This is useful when you want both:
/// - state
/// - methods that mutate that state
class MiniNotifierProvider<N extends MiniNotifier<T>, T>
    extends MiniProviderBase<N> {
  const MiniNotifierProvider(this._create);

  final N Function(MiniRef ref) _create;

  @override
  N create(MiniRef ref) {
    return _create(ref);
  }

  @override
  void dispose(N value) {
    value.dispose();
  }
}
