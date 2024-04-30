import 'notification_type.dart';

class NotifierState {
  const NotifierState._({
    this.content,
    this.notificationType,
  });

  const NotifierState.initial()
      : this._(
          content: '',
          notificationType: null,
        );

  const NotifierState.notification({
    String? notification,
    NotificationType? type,
  }) : this._(
          content: notification,
          notificationType: type,
        );

  final String? content;
  final NotificationType? notificationType;
}
