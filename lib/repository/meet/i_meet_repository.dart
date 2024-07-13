import '../../api/meet/model/response/meet_response.dart';
import '../../api/meet/model/response/meet_users.dart';
import '../../object/meet.dart';

abstract class IMeetRepository {
  Future<MeetUsers> getMeetUsers(int meetId,
      {required int page, required int perPage,});

  Future<Meet> getMeet(int meetId);

  Future<MeetResponse> getPoiMeet(
      {required int poiId, required int page, required int perPage,});
}
