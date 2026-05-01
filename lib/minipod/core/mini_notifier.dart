import 'mini_state.dart';

/// A mutable controller that owns a state value.
///
/// You extend this class to create business-logic controllers.
/// Example:
/// - CounterNotifier extends MiniNotifier<int>
/// - AuthNotifier extends MiniNotifier<AuthState>
abstract class MiniNotifier<T> extends MiniState<T> {
  MiniNotifier(super.initialState);
}