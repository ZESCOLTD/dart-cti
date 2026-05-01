import 'mini_provider_base.dart';
import 'mini_provider_container.dart';

/// Reference object passed into provider factories.
///
/// It gives providers access to the container,
/// so they can read dependencies.
class MiniRef {
  MiniRef(this._container);

  final MiniProviderContainer _container;

  T read<T>(MiniProviderBase<T> provider) {
    return _container.read(provider);
  }

  void invalidate<T>(MiniProviderBase<T> provider) {
    _container.invalidate(provider);
  }
}
