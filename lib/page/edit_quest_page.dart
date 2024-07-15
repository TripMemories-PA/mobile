import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../api/quest/quest_service.dart';
import '../bloc/edit_quest/edit_quest_bloc.dart';
import '../bloc/edit_quest/edit_quest_event.dart';
import '../constants/string_constants.dart';
import '../dto/quest_dto.dart';
import '../num_extensions.dart';
import '../utils/messenger.dart';

class EditQuestPage extends HookWidget {
  const EditQuestPage({super.key, required this.questBlocDTO});

  final QuestBlocDTO questBlocDTO;

  @override
  Widget build(BuildContext context) {
    final currentStep = useState(0);
    final titleController = useTextEditingController(
      text: questBlocDTO.quest?.title,
    );
    final selectedLabel = useState<String>('');
    return BlocProvider(
      create: (context) => EditQuestBloc(questService: QuestService()),
      child: BlocConsumer<EditQuestBloc, EditQuestState>(
        listener: (context, state) {
          if (state.publishQuestStep == PublishQuestStep.pickImage) {
            currentStep.value = 1;
          } else if (state.publishQuestStep == PublishQuestStep.selectLabels) {
            currentStep.value = 2;
          } else if (state.publishQuestStep == PublishQuestStep.storeQuest) {
            currentStep.value = 3;
          } else if (state.publishQuestStep == PublishQuestStep.posted) {
            currentStep.value = 3;
          } else if (state.publishQuestStep == PublishQuestStep.posted) {
            Messenger.showSnackBarSuccess(StringConstants().questUpdated);
            context.pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Stepper(
                currentStep: currentStep.value,
                steps: [
                  Step(
                    title: Text(StringConstants().title),
                    content: Column(
                      children: [
                        TextField(
                          controller: titleController,
                        ),
                        20.ph,
                        ElevatedButton(
                          onPressed: () {
                            if (titleController.text.isNotEmpty) {
                              context.read<EditQuestBloc>().add(
                                    SelectTitleEvent(
                                      titleController.text,
                                    ),
                                  );
                            } else {
                              Messenger.showSnackBarError(
                                StringConstants().titleCannotBeEmpty,
                              );
                            }
                          },
                          child: Text(StringConstants().validate),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text(StringConstants().imageSelection),
                    content: ElevatedButton(
                      onPressed: () {
                        _selectImage(context);
                      },
                      child: Text(StringConstants().pickImage),
                    ),
                  ),
                  Step(
                    title: Text(StringConstants().labels),
                    content: state.postQuestImageResponse.labels.isEmpty
                        ? Text(StringConstants().noLabels)
                        : Column(
                            children: state.postQuestImageResponse.labels
                                .map(
                                  (label) => ElevatedButton(
                                    onPressed: () =>
                                        selectedLabel.value = label,
                                    child: Text(label),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then(
          (pickedImage) => {
            if (pickedImage != null && context.mounted)
              {
                context.read<EditQuestBloc>().add(
                      StoreQuestImageEvent(
                        file: pickedImage,
                      ),
                    ),
              }
            else
              Messenger.showSnackBarError(StringConstants().pleaseSelectImage),
          },
        );
  }
}
