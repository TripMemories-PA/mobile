
import '../../api/meet/model/response/meet_response.dart';
import '../../api/meet/model/response/meet_users.dart';

abstract class IMeetRepository {
  Future<MeetUsers> getMeetUsers(int meetId, {required int page, required int perPage});
  Future<MeetResponse> getMeet(int meetId);
}
