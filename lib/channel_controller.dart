import 'minipod/channel_notifier.dart';
import 'minipod/channel_provider.dart';
import 'minipod/core/mini_provider_container.dart';

class ChannelController {
  final String channelId;

  String state = 'New';
  String? name;

  ChannelController(this.channelId) {
    print('🆕 ChannelController created: $channelId');
  }

  void onStasisStart(Map<String, dynamic> event) {
    name = event['channel']['name'];
    state = event['channel']['state'];
    print('📞 [$channelId] StasisStart, state=$state');
  }

  void onStateChange(String newState) {
    state = newState;
    print('🔁 [$channelId] state → $state');
  }

  void onDial(Map<String, dynamic> event) {
    print('📲 [$channelId] Dial event');
  }

  bool _disposed = false;

  void dispose() {
    if (_disposed) return;
    _disposed = true;

    print('🗑️ ChannelController disposed: $channelId');
  }
}

// class ChannelRegistry {
//   final Map<String, ChannelController> _channels = {};

//   ChannelController get(String channelId) {
//     return _channels.putIfAbsent(channelId, () => ChannelController(channelId));
//   }

//   void remove(String channelId) {
//     final channel = _channels.remove(channelId);

//     if (channel != null) {
//       channel.dispose();
//     } else {
//       print('⚠️ Attempted to remove non-existent channel: $channelId');
//     }
//   }

//   void disposeAll() {
//     for (final ch in _channels.values) {
//       ch.dispose();
//     }
//     _channels.clear();
//   }
// }

class ChannelManager {
  final MiniProviderContainer container;

  final Map<String, ChannelNotifier> _channels = {};

  ChannelManager(this.container);

  ChannelNotifier get(String channelId) {
    return _channels.putIfAbsent(channelId, () => ChannelNotifier(channelId));
  }

  void remove(String channelId) {
    final notifier = _channels.remove(channelId);
    notifier?.onEnd();
  }
}
