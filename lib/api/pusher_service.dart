import 'package:dart_pusher_channels/dart_pusher_channels.dart';

class PusherService {
  PusherService._internal() {
    pusherInstance = PusherChannelsClient.websocket(
      options: testOptions,
      connectionErrorHandler: (exception, trace, refresh) {
        refresh();
      },
      activityDurationOverride: const Duration(
        seconds: 120,
      ),
    );
  }

  static const String apiKey = '{PUSHER_API_KEY}';
  static const String cluster = 'eu';

  // Pusher options
  static const PusherChannelsOptions testOptions =
      PusherChannelsOptions.fromCluster(
    scheme: 'wss',
    cluster: cluster,
    key: apiKey,
  );

  static PusherService? _instance;

  late final PusherChannelsClient pusherInstance;

  static PusherService getInstance() {
    _instance ??= PusherService._internal();
    return _instance!;
  }
}
