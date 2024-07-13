import '../../../../utils/date_time_service.dart';
import 'create_meet_query.dart';

class CreateMeetMeetingQuery extends CreateMeetQuery {
  CreateMeetMeetingQuery({
    required this.title,
    required this.description,
    required this.size,
    required this.date,
    required this.poiId,
  });

  String title;
  String description;
  int size;
  DateTime date;
  int poiId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'size': size,
      'date': DateTimeService.formatTimeToString(date),
      'poiId': poiId,
      'ticketId': null,
    };
  }
}
