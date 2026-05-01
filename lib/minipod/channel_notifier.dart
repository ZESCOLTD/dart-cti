import 'channel_state.dart';
import 'channels_api.dart';
import 'core/mini_notifier.dart';

class ChannelNotifier extends MiniNotifier<ChannelState> {
  ChannelNotifier(String channelId)
    : super(ChannelState(channelId: channelId, state: 'New'));

  bool _isAnswering = false;

  @override
  set state(ChannelState newState) {
    final previous = super.state;

    super.state = newState;

    // ✅ React AFTER state change (safe place)
    _handleStateChange(previous, newState);
  }

  Future<void> _handleStateChange(
    ChannelState previous,
    ChannelState current,
  ) async {
    print('📊 [${current.channelId}] state → ${current.state}');

    // ✅ AUTO-ANSWER (safe, guarded)
    if (current.state == 'Ring' && !current.answered && !_isAnswering) {
      _isAnswering = true;

      print('📞 [${current.channelId}] Auto answering...');

      try {
        final resp = await ChannelsApi.answer(current.channelId);

        if (resp.statusCode == 200 || resp.statusCode == 204) {
          state = current.copyWith(answered: true);
          print('✅ [${current.channelId}] Answered');
        } else {
          print('❌ [${current.channelId}] Answer failed (${resp.statusCode})');
        }
      } catch (e) {
        print('❌ [${current.channelId}] Answer error: $e');
      } finally {
        _isAnswering = false;
      }
    }
  }

  void onStasisStart(Map<String, dynamic> event) {
    final ch = event['channel'];

    state = state.copyWith(
      state: ch['state'], // "Ring"
    );
  }

  // void onStateChange(String newState) {
  //   if (state.state != newState) {
  //     state = state.copyWith(state: newState);
  //   }
  // }

  void onStateChange(String newState) {
    if (newState == state.state) return;

    state = state.copyWith(state: newState);
  }

  void onEnd() {
    print('🗑️ [${state.channelId}] Channel ended');
  }

  // void onDtmf(Map<String, dynamic> event) {
  //   final digit = event['digit'];
  //   final duration = event['duration_ms'];

  //   print('🎧 [${state.channelId}] DTMF → $digit (${duration}ms)');
  // }

  void onDtmf(Map<String, dynamic> event) {
    final digit = event['digit'] as String;

    final newDigits = state.digits + digit;

    state = state.copyWith(digits: newDigits);

    print('🎧 [${state.channelId}] DTMF → $digit');
    print('🔢 [${state.channelId}] Collected → $newDigits');
  }
}
