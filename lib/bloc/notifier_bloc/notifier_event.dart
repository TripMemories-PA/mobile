import 'package:flutter/cupertino.dart';

import 'notification_type.dart';

@immutable
abstract class NotifierEvent {
  const NotifierEvent();
}

class AppendNotification extends NotifierEvent {
  const AppendNotification({
    this.notification,
    this.type,
  });
  final String? notification;
  final NotificationType? type;
}
