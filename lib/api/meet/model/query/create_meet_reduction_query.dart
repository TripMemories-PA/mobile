import '../../../../utils/date_time_service.dart';
import 'create_meet_query.dart';

class CreateMeeReductionQuery extends CreateMeetQuery {
  CreateMeeReductionQuery({
    required this.title,
    required this.description,
    required this.date,
    required this.poiId,
    required this.ticketId,
  });

  String title;
  String description;
  DateTime date;
  int poiId;
  int ticketId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': DateTimeService.formatTimeToString(date),
      'poiId': poiId,
      'ticketId': ticketId,
      'size': 2,
    };
  }
}
