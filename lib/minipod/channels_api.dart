import 'dart:convert';
import 'dart:io';

class ChannelsApi {
  static late String scheme;
  static late String host;
  static late int port;
  static late String apiKey;

  static final HttpClient _client = HttpClient();

  /// ✅ ANSWER CHANNEL
  static Future<dynamic> answer(String channelId) async {
    final uri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: "ari/channels/$channelId/answer",
      queryParameters: {'api_key': apiKey},
    );

    try {
      final request = await _client.postUrl(uri);
      final response = await request.close();

      final body = await response.transform(utf8.decoder).join();

      return (statusCode: response.statusCode, resp: body);
    } catch (e) {
      print("❌ Answer API error: $e");
      return (statusCode: null, resp: null, err: e);
    }
  }

  /// ✅ HANGUP CHANNEL
  static Future<dynamic> hangup(String channelId) async {
    final uri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: "ari/channels/$channelId",
      queryParameters: {'api_key': apiKey},
    );

    try {
      final request = await _client.deleteUrl(uri);
      final response = await request.close();

      final body = await response.transform(utf8.decoder).join();

      return (statusCode: response.statusCode, resp: body);
    } catch (e) {
      print("❌ Hangup API error: $e");
      return (statusCode: null, resp: null, err: e);
    }
  }

  /// ✅ PLAY AUDIO
  static Future<dynamic> play({
    required String channelId,
    required List<String> media,
  }) async {
    final uri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: "ari/channels/$channelId/play",
      queryParameters: {'api_key': apiKey, 'media': media.join(",")},
    );

    try {
      final request = await _client.postUrl(uri);
      final response = await request.close();

      final body = await response.transform(utf8.decoder).join();

      return (statusCode: response.statusCode, resp: body);
    } catch (e) {
      print("❌ Play API error: $e");
      return (statusCode: null, resp: null, err: e);
    }
  }
}
