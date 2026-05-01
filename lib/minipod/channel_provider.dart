import 'channel_notifier.dart';
import 'channel_state.dart';
import 'core/mini_notifier_provider.dart';

// ✅ Single provider (not per-channel)
final channelProvider = MiniNotifierProvider<ChannelNotifier, ChannelState>((
  ref,
) {
  throw UnimplementedError(
    'Use ChannelManager.get(channelId) instead of channelProvider',
  );
});
