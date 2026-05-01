import 'mini_provider_base.dart';
import 'mini_ref.dart';

/// Runtime storage for provider instances.
///
/// The provider itself is only a definition.
/// The actual live value exists inside this container.
class MiniProviderContainer {
  final Map<MiniProviderBase<Object?>, Object?> _values =
      <MiniProviderBase<Object?>, Object?>{};

  final Map<MiniProviderBase<Object?>, void Function()> _disposers =
      <MiniProviderBase<Object?>, void Function()>{};

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  /// Read a provider value.
  ///
  /// - creates it lazily if needed
  /// - caches it for future reads
  T read<T>(MiniProviderBase<T> provider) {
    _ensureNotDisposed();

    final key = provider as MiniProviderBase<Object?>;

    if (_values.containsKey(key)) {
      return _values[key] as T;
    }

    final ref = MiniRef(this);
    final value = provider.create(ref);

    _values[key] = value as Object?;
    _disposers[key] = () => provider.dispose(value);

    return value;
  }

  /// Dispose and remove one provider instance.
  void invalidate<T>(MiniProviderBase<T> provider) {
    _ensureNotDisposed();

    final key = provider as MiniProviderBase<Object?>;
    final disposer = _disposers.remove(key);
    if (disposer != null) {
      disposer();
    }
    _values.remove(key);
  }

  /// Check whether a provider is already created in this container.
  bool contains<T>(MiniProviderBase<T> provider) {
    _ensureNotDisposed();
    final key = provider as MiniProviderBase<Object?>;
    return _values.containsKey(key);
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw StateError('MiniProviderContainer was used after being disposed.');
    }
  }

  /// Dispose every created provider in reverse creation order.
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    final disposers = _disposers.values.toList().reversed.toList();
    for (final dispose in disposers) {
      dispose();
    }

    _disposers.clear();
    _values.clear();
  }

  @override
  String toString() {
    return 'MiniProviderContainer(created: ${_values.length}, disposed: $_isDisposed)';
  }
}