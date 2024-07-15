import '../../../../object/meta_object.dart';
import '../../../../object/quest.dart';

class GetQuestList {
  GetQuestList({
    required this.quests,
    required this.meta,
  });

  factory GetQuestList.fromJson(Map<String, dynamic> json) {
    return GetQuestList(
      quests: List<Quest>.from(json['data'].map((x) => Quest.fromJson(x))),
      meta: MetaObject.fromJson(json['meta']),
    );
  }

  final List<Quest> quests;
  final MetaObject meta;
}
