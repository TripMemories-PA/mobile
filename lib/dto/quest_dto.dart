import '../bloc/quest/quest_bloc.dart';
import '../object/quest.dart';

class QuestBlocDTO {
  QuestBlocDTO({required this.questBloc, required this.poiId, this.quest});
  final QuestBloc questBloc;
  final Quest? quest;
  final int poiId;
}
