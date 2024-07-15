import 'package:image_picker/image_picker.dart';

import 'model/query/post_quest_query_model.dart';
import 'model/query/update_quest_query_model.dart';

abstract class IQuestService {
  Future<void> storeImage(XFile file);

  Future<void> storeQuest({required PostQuestQueryModel questData});

  Future<void> updateQuest({
    required int id,
    required UpdateQuestQueryModel questData,
  });

  Future<void> deleteQuest(int id);

  Future<void> validateQuest({required int id, required XFile file});
}
