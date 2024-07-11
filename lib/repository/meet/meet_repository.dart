import '../../api/meet/model/response/meet_response.dart';
import '../../api/meet/model/response/meet_users.dart';
import '../../service/meet/meet_remote_data_source.dart';
import 'i_meet_repository.dart';

class MeetRepository implements IMeetRepository {
  MeetRepository({required this.remoteDataSource});

  final MeetRemoteDataSource remoteDataSource;

  @override
  Future<MeetResponse> getMeet(int meetId) {
    return remoteDataSource.getMeet(meetId);
  }

  @override
  Future<MeetUsers> getMeetUsers(
    int meetId, {
    required int page,
    required int perPage,
  }) {
    return remoteDataSource.getMeetUsers(meetId, page: page, perPage: perPage);
  }
}
