import '../../api/error/api_error.dart';

class SubscribeState {
  const SubscribeState._({
    this.loading = false,
    this.error,
    this.subscribed = false,
  });

  const SubscribeState.loading()
      : this._(
          loading: true,
          error: null,
        );

  const SubscribeState.notLoading()
      : this._(
          loading: false,
          error: null,
        );

  const SubscribeState.subscribed()
      : this._(
          loading: false,
          error: null,
          subscribed: true,
        );

  SubscribeState.error({ApiError? error})
      : this._(loading: false, error: error ?? ApiError.unknown());
  final bool loading;
  final ApiError? error;
  final bool subscribed;
}
