import '../../api/quest/model/response/get_quest_list.dart';
import '../../object/quest.dart';

abstract class IQuestRepository {
  Future<Quest> getQuest(int id);

  Future<GetQuestList> getQuestsFromPoi({
    required int poiId,
    required int page,
    required int perPage,
  });
}
