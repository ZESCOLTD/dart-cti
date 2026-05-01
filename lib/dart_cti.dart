import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';

import 'channel_controller.dart';
import 'minipod/channels_api.dart';
import 'minipod/core/mini_provider_container.dart';

// final ChannelRegistry registry = ChannelRegistry();

class WsClient {
  final container = MiniProviderContainer();
  late final ChannelManager manager = ChannelManager(container);

  Future<void> handleMessage(String message) async {
    final jsonData = jsonDecode(message);

    final type = jsonData['type'];
    final channel = jsonData['channel'];

    if (channel == null) return;

    final channelId = channel['id'];

    final notifier = manager.get(channelId);

    switch (type) {
      case 'StasisStart':
        notifier.onStasisStart(jsonData);
        break;

      case 'ChannelStateChange':
        notifier.onStateChange(channel['state']);
        break;

      case 'StasisEnd':
        manager.remove(channelId);
        break;

      case 'ChannelDtmfReceived':
        notifier.onDtmf(jsonData); // ✅ ADD THIS
        break;

      default:
        print('⚠️ Unhandled event type: $type');
    }
  }

  // static Future<void> handleMessage(String message) async {
  //   var jsonData = jsonDecode(message);

  //   if (jsonData['type'] == 'Dial') {
  //     print("Json: $jsonData");
  //   }

  //   if (jsonData['type'] == 'StasisEnd') {
  //     print("Json: $jsonData");
  //   }

  //   if (jsonData['type'] == 'StasisStart') {
  //     print("Json: $jsonData");
  //   }
  // }

  // static Future<void> handleMessage(String message) async {
  //   final jsonData = jsonDecode(message);

  //   final type = jsonData['type'];
  //   final channel = jsonData['channel'];

  //   if (channel == null) return;

  //   final channelId = channel['id'];

  //   final notifier = manager.get(channelId);

  //   switch (type) {
  //     case 'StasisStart':
  //       notifier.onStasisStart(jsonData);
  //       break;

  //     case 'ChannelStateChange':
  //       notifier.onStateChange(channel['state']);
  //       break;

  //     case 'StasisEnd':
  //       manager.remove(channelId);
  //       break;
  //   }
  // }

  // static Future<void> handleMessage(String message) async {
  //   final jsonData = jsonDecode(message);

  //   final type = jsonData['type'];
  //   final channel = jsonData['channel'];

  //   if (channel == null) return;

  //   final channelId = channel['id'];

  //   final controller = registry.get(channelId);

  //   switch (type) {
  //     case 'StasisStart':
  //       controller.onStasisStart(jsonData);
  //       break;

  //     case 'ChannelStateChange':
  //       controller.onStateChange(channel['state']);
  //       break;

  //     case 'Dial':
  //       controller.onDial(jsonData);
  //       break;

  //     case 'StasisEnd':
  //       controller.dispose();
  //       registry.remove(channelId);
  //       break;

  //     case 'ChannelDestroyed':
  //       controller.dispose();
  //       registry.remove(channelId);
  //       break;
  //   }
  // }

  Future<void> connect() async {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final serverIp = env['SERVER_IP']!;
    final serverPort = int.parse(env['SERVER_PORT']!);
    final serverPath = env['SERVER_PATH']!;

    final apiKey = "asterisk:asterisk";
    final queryParams = {
      'api_key': apiKey,
      'app': 'hello',
      'subscribe_all': 'true',
    };

    final url =
        'ws://$serverIp:$serverPort/$serverPath?${Uri(queryParameters: queryParams).query}';

    while (true) {
      WebSocket? socket;
      Timer? pingTimer;

      try {
        print('🔄 Attempting connection...');
        socket = await WebSocket.connect(url);
        print('✅ Connected to $url');

        // Start ping timer
        // pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        //   try {
        //     socket!.add(jsonEncode({'type': 'ping'}));
        //   } catch (_) {
        //     pingTimer?.cancel();
        //   }
        // });

        await for (var message in socket) {
          await handleMessage(message);
        }

        print('❌ Connection closed by server.');
      } catch (e) {
        print('❌ Connection failed: $e');
      } finally {
        pingTimer?.cancel();
        socket?.close();
      }

      // Wait before retry
      print('⏳ Reconnecting in 5 seconds...');
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  ChannelsApi.scheme = "http";
  ChannelsApi.host = env['SERVER_IP']!;
  ChannelsApi.port = int.parse(env['SERVER_PORT']!);
  ChannelsApi.apiKey = "asterisk:asterisk";

  final client = WsClient();
  await client.connect();
}
