import '../../../../object/meta_object.dart';
import '../../../../object/quest.dart';

class GetQuestList {
  GetQuestList({
    required this.quest,
    required this.meta,
  });

  factory GetQuestList.fromJson(Map<String, dynamic> json) {
    return GetQuestList(
      quest: Quest.fromJson(json['data']),
      meta: MetaObject.fromJson(json['meta']),
    );
  }

  final Quest quest;
  final MetaObject meta;
}
