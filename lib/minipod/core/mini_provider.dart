import 'mini_provider_base.dart';
import 'mini_ref.dart';

/// Plain dependency provider.
///
/// Good for objects like:
/// - ApiService
/// - Dio
/// - Repository
/// - Configuration
class MiniProvider<T> extends MiniProviderBase<T> {
  const MiniProvider(
    this._create, {
    this.onDispose,
  });

  final T Function(MiniRef ref) _create;
  final void Function(T value)? onDispose;

  @override
  T create(MiniRef ref) => _create(ref);

  @override
  void dispose(T value) {
    onDispose?.call(value);
  }
}
