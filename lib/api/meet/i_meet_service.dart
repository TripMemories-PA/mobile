import '../../object/meet.dart';
import 'model/query/create_meet_query.dart';
import 'model/query/update_meet_query.dart';

abstract class IMeetService {
  Future<void> deleteUserFromMeet(int meetId, int userId);
  Future<void> createMeet(CreateMeetQuery query);
  Future<Meet> updateMeet(UpdateMeetQuery query);
  Future<void> deleteMeet(int meetId);
  Future<void> joinMeet(int meetId);
  Future<void> leaveMeet(int meetId);
  Future<void> payForMeet(int meetId);
}
