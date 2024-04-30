import 'package:toastification/toastification.dart';

class NotificationType {
  const NotificationType({required this.type, required this.style});

  final ToastificationType type;
  final ToastificationStyle style;

  static const NotificationType success = NotificationType(
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
  );

  static const NotificationType error = NotificationType(
    type: ToastificationType.error,
    style: ToastificationStyle.fillColored,
  );

  static const NotificationType info = NotificationType(
    type: ToastificationType.info,
    style: ToastificationStyle.fillColored,
  );
}
