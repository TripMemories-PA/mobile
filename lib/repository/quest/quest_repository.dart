import '../../api/quest/model/response/get_quest_list.dart';
import '../../api/quest/quest_service.dart';
import '../../object/quest.dart';
import 'i_repository.dart';

class QuestRepository implements IQuestRepository {
  QuestRepository(this._questDataSource);

  final QuestService _questDataSource;

  @override
  Future<Quest> getQuest(int id) {
    return _questDataSource.getQuest(id);
  }

  @override
  Future<GetQuestList> getQuestsFromPoi({
    required int poiId,
    required int page,
    required int perPage,
  }) {
    return _questDataSource.getQuestsFromPoi(
      poiId: poiId,
      page: page,
      perPage: perPage,
    );
  }
}
