import 'mini_provider_base.dart';
import 'mini_ref.dart';
import 'mini_state.dart';

/// Provider that creates a MiniState<T>.
///
/// Great for simple values like:
/// - int counter
/// - bool isDarkMode
/// - String searchQuery
class MiniStateProvider<T> extends MiniProviderBase<MiniState<T>> {
  const MiniStateProvider(this._create);

  final T Function(MiniRef ref) _create;

  @override
  MiniState<T> create(MiniRef ref) {
    return MiniState<T>(_create(ref));
  }

  @override
  void dispose(MiniState<T> value) {
    value.dispose();
  }
}