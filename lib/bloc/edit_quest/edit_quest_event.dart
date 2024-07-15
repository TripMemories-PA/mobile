import 'package:image_picker/image_picker.dart';

import '../../api/quest/model/query/post_quest_query_model.dart';
import '../../api/quest/model/query/update_quest_query_model.dart';

abstract class EditQuestEvent {}

class StoreQuestImageEvent extends EditQuestEvent {
  StoreQuestImageEvent({required this.file});

  final XFile file;
}

class StoreQuestEvent extends EditQuestEvent {
  StoreQuestEvent(this.queryModel);

  final PostQuestQueryModel queryModel;
}

class UpdateQuestEvent extends EditQuestEvent {
  UpdateQuestEvent({required this.id, required this.queryModel});

  final int id;
  final UpdateQuestQueryModel queryModel;
}

class ValidateQuestEvent extends EditQuestEvent {
  ValidateQuestEvent({required this.id, required this.file});

  final int id;
  final XFile file;
}

class SelectTitleEvent extends EditQuestEvent {
  SelectTitleEvent(this.title);

  final String title;
}
