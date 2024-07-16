import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../api/quest/model/query/post_quest_query_model.dart';
import '../api/quest/model/query/update_quest_query_model.dart';
import '../api/quest/quest_service.dart';
import '../bloc/edit_quest/edit_quest_bloc.dart';
import '../bloc/edit_quest/edit_quest_event.dart';
import '../bloc/quest/quest_event.dart';
import '../constants/string_constants.dart';
import '../dto/quest_dto.dart';
import '../num_extensions.dart';
import '../object/quest.dart';
import '../object/uploaded_file.dart';
import '../utils/messenger.dart';

class EditQuestPage extends HookWidget {
  const EditQuestPage({super.key, required this.questBlocDTO});

  final QuestBlocDTO questBlocDTO;

  @override
  Widget build(BuildContext context) {
    final Quest? questToModify = questBlocDTO.quest;
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
          }
          if (state.publishQuestStep == PublishQuestStep.selectLabels) {
            currentStep.value = 2;
          }
          if (state.publishQuestStep == PublishQuestStep.posted) {
            Messenger.showSnackBarSuccess(StringConstants().questPosted);
            questBlocDTO.questBloc.add(GetPoiQuestEvent(questBlocDTO.poiId));
            context.pop();
          }
          if (state.publishQuestStep == PublishQuestStep.updated) {
            Messenger.showSnackBarSuccess(StringConstants().questionUpdated);
            questBlocDTO.questBloc.add(GetPoiQuestEvent(questBlocDTO.poiId));
            context.pop();
          }
          if (state.status == QuestStatus.updated) {
            Messenger.showSnackBarSuccess(StringConstants().questUpdated);
            questBlocDTO.questBloc.add(GetPoiQuestEvent(questBlocDTO.poiId));
            context.pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: questToModify != null
                ? _buildUpdateQuestBody(
                    titleController,
                    context,
                    questToModify.id,
                  )
                : _buildCreateQuestBody(
                    currentStep,
                    titleController,
                    context,
                    state,
                    selectedLabel,
                  ),
          );
        },
      ),
    );
  }

  Center _buildCreateQuestBody(
    ValueNotifier<int> currentStep,
    TextEditingController titleController,
    BuildContext context,
    EditQuestState state,
    ValueNotifier<String> selectedLabel,
  ) {
    return Center(
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
                    children: [
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: state.postQuestImageResponse.labels
                            .map(
                              (label) => SizedBox(
                                width: 100,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () => selectedLabel.value = label,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith(
                                      (states) => selectedLabel.value == label
                                          ? Colors.green
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                  ),
                                  child: Text(label),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      20.ph,
                      ElevatedButton(
                        onPressed: () {
                          final UploadFile? file =
                              state.postQuestImageResponse.file;
                          if (selectedLabel.value.isNotEmpty && file != null) {
                            context.read<EditQuestBloc>().add(
                                  StoreQuestEvent(
                                    PostQuestQueryModel(
                                      title: titleController.text,
                                      label: selectedLabel.value,
                                      poiId: questBlocDTO.poiId,
                                      imageId: file.id,
                                    ),
                                  ),
                                );
                          } else {
                            Messenger.showSnackBarError(
                              StringConstants().pleaseSelectLabel,
                            );
                          }
                        },
                        child: Text(StringConstants().validate),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  BlocBuilder<EditQuestBloc, EditQuestState> _buildUpdateQuestBody(
    TextEditingController titleController,
    BuildContext context,
    int questId,
  ) {
    return BlocBuilder<EditQuestBloc, EditQuestState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: titleController,
                  maxLines: 3,
                ),
                20.ph,
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      state.status == QuestStatus.loading
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        state.status != QuestStatus.loading) {
                      context.read<EditQuestBloc>().add(
                            UpdateQuestEvent(
                              queryModel: UpdateQuestQueryModel(
                                title: titleController.text,
                              ),
                              id: questId,
                            ),
                          );
                    } else {
                      Messenger.showSnackBarError(
                        StringConstants().titleCannotBeEmpty,
                      );
                    }
                  },
                  child: context.read<EditQuestBloc>().state.status ==
                          QuestStatus.loading
                      ? const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: CircularProgressIndicator(),
                        )
                      : Text(StringConstants().validate),
                ),
              ],
            ),
          ),
        );
      },
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
