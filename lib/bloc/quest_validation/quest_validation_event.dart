part of 'quest_validation_bloc.dart';

abstract class QuestValidationEvent {}

class ValidateQuestEvent extends QuestValidationEvent {
  ValidateQuestEvent({required this.id, required this.file});

  final int id;
  final File file;
}
