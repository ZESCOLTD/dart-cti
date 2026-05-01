typedef VoidCallback = void Function();
typedef RemoveListener = void Function();

/// Anything that supports subscriptions.
abstract class MiniSubscribable {
  RemoveListener addListener(VoidCallback listener);
}

/// Small reactive state holder.
///
/// This is the core of the whole engine:
/// - it stores a value
/// - it notifies listeners when the value changes
class MiniState<T> implements MiniSubscribable {
  MiniState(this._state);

  T _state;
  final Set<VoidCallback> _listeners = <VoidCallback>{};
  bool _isDisposed = false;

  T get state => _state;

  set state(T value) {
    _ensureNotDisposed();

    if (_state == value) return;
    _state = value;
    _notifyListeners();
  }

  bool get isDisposed => _isDisposed;

  @override
  RemoveListener addListener(VoidCallback listener) {
    _ensureNotDisposed();
    _listeners.add(listener);

    return () {
      _listeners.remove(listener);
    };
  }

  void _notifyListeners() {
    // Copy first so listeners can safely unsubscribe during notification.
    final snapshot = List<VoidCallback>.from(_listeners);
    for (final listener in snapshot) {
      listener();
    }
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw StateError('MiniState<$T> was used after being disposed.');
    }
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _listeners.clear();
  }

  @override
  String toString() => 'MiniState<$T>(state: $_state)';
}
