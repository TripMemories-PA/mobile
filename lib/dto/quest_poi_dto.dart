import '../object/poi/poi.dart';
import '../object/quest.dart';

class QuestPoiDto {
  QuestPoiDto({
    required this.quest,
    required this.poi,
  });

  final Quest quest;
  final Poi poi;
}
