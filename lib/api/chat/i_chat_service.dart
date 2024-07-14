abstract class IChatService {
  Future<void> postPrivateMessage({
    required int userId,
    required String content,
  });

  Future<void> postMeetMessage({required int meetId, required String content});
}
