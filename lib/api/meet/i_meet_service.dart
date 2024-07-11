import 'model/response/meet_response.dart';

abstract class IMeetService {
  Future<void> deleteUserFromMeet(int meetId, int userId);
  Future<MeetResponse> createMeet(Map<String, dynamic> data);
  Future<MeetResponse> updateMeet(int meetId, Map<String, dynamic> data);
  Future<void> deleteMeet(int meetId);
  Future<void> joinMeet(int meetId);
  Future<void> leaveMeet(int meetId);
  Future<void> payForMeet(int meetId);
}
