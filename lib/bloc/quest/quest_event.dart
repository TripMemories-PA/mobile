import 'package:image_picker/image_picker.dart';

import '../../api/quest/model/query/post_quest_query_model.dart';
import '../../api/quest/model/query/update_quest_query_model.dart';

abstract class QuestEvent {}

class StoreQuestImageEvent extends QuestEvent {
  StoreQuestImageEvent({required this.file});

  final XFile file;
}

class StoreQuestEvent extends QuestEvent {
  StoreQuestEvent(this.queryModel);

  final PostQuestQueryModel queryModel;
}

class GetQuestEvent extends QuestEvent {
  GetQuestEvent(this.id);

  final int id;
}

class GetPoiQuestEvent extends QuestEvent {
  GetPoiQuestEvent(this.id, {this.isRefresh = false});

  final int id;
  final bool isRefresh;
}

class UpdateQuestEvent extends QuestEvent {
  UpdateQuestEvent({required this.id, required this.queryModel});

  final int id;
  final UpdateQuestQueryModel queryModel;
}

class DeleteQuestEvent extends QuestEvent {
  DeleteQuestEvent(this.id);

  final int id;
}

class ValidateQuestEvent extends QuestEvent {
  ValidateQuestEvent({required this.id, required this.file});

  final int id;
  final XFile file;
}
