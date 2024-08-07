import '../../api/meet/meet_service.dart';
import '../../api/meet/model/response/meet_response.dart';
import '../../api/meet/model/response/meet_users.dart';
import '../../object/meet.dart';
import '../../repository/meet/i_meet_repository.dart';

class MeetRemoteDataSource implements IMeetRepository {
  final MeetService meetService = MeetService();

  @override
  Future<Meet> getMeet(int meetId) {
    return meetService.getMeet(meetId);
  }

  @override
  Future<MeetUsers> getMeetUsers(
    int meetId, {
    required int page,
    required int perPage,
  }) {
    return meetService.getMeetUsers(meetId, page: page, perPage: perPage);
  }

  @override
  Future<MeetResponse> getPoiMeet({
    required int poiId,
    required int page,
    required int perPage,
  }) {
    return meetService.getPoiMeet(poiId: poiId, page: page, perPage: perPage);
  }
}
