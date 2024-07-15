import '../bloc/quest/quest_bloc.dart';
import '../object/quest.dart';

class QuestBlocDTO {
  QuestBlocDTO({required this.questBloc, this.quest});
  final QuestBloc questBloc;
  final Quest? quest;
}
