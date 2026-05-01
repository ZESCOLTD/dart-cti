import 'mini_ref.dart';

/// Base class for all providers.
///
/// A provider is only a definition/recipe.
/// It is NOT the actual value instance.
abstract class MiniProviderBase<T> {
  const MiniProviderBase();

  /// Called by the container when the provider is first read.
  T create(MiniRef ref);

  /// Called by the container when the provider is invalidated/disposed.
  void dispose(T value) {}
}