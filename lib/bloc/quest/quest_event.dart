abstract class QuestEvent {}

class GetQuestEvent extends QuestEvent {
  GetQuestEvent(this.id);

  final int id;
}

class GetPoiQuestEvent extends QuestEvent {
  GetPoiQuestEvent(this.id, {this.isRefresh = false});

  final int id;
  final bool isRefresh;
}

class DeleteQuestEvent extends QuestEvent {
  DeleteQuestEvent(this.id);

  final int id;
}
