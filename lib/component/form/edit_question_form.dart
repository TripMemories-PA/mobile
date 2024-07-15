import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../api/dio.dart';
import '../../api/quiz/model/query/post_question_query.dart';
import '../../bloc/edit_quiz/edit_quiz_bloc.dart';
import '../../constants/my_colors.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../object/quiz/question.dart';
import '../custom_card.dart';
import '../popup/confirmation_dialog.dart';

class EditQuestionForm extends HookWidget {
  const EditQuestionForm(
    this.question, {
    super.key,
    required this.editQuizBloc,
  });

  final Question? question;
  final EditQuizBloc editQuizBloc;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController questionController =
        useTextEditingController(text: question?.question);
    final answersControllers = useState(
      question?.answers
              .map((e) => TextEditingController(text: e.answer))
              .toList() ??
          [],
    );
    final selectedAnswerIndex = useState<int?>(
      question != null ? 0 : null,
    );
    final ValueNotifier<XFile?> image = useState(null);
    final loadingImage = useState(false);

    useEffect(
      () {
        if (question?.image?.url != null) {
          _downloadAndSetImage(question!.image!.url, loadingImage, image);
        }
        return null;
      },
      [],
    );

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          30.ph,
          TextFormField(
            maxLines: 3,
            controller: questionController,
            decoration: InputDecoration(
              labelText: StringConstants().questionCap,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return StringConstants().requiredField;
              }
              return null;
            },
          ),
          20.ph,
          if (image.value != null)
            loadingImage.value
                ? const CupertinoActivityIndicator()
                : Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: FileImage(
                              File(image.value!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                          ),
                          onPressed: () {
                            if (context.mounted) {
                              image.value = null;
                            }
                          },
                        ),
                      ),
                    ],
                  )
          else
            _buildImagePicker(image, context),
          20.ph,
          ...answersControllers.value.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLines: 2,
                          controller: entry.value,
                          decoration: InputDecoration(
                            labelText:
                                '${StringConstants().answer} ${entry.key + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return StringConstants().requiredField;
                            }
                            return null;
                          },
                        ),
                      ),
                      10.pw,
                      IconButton(
                        onPressed: () {
                          final List<TextEditingController> tmp =
                              List.from(answersControllers.value);
                          tmp.removeAt(entry.key);
                          answersControllers.value = tmp;
                          if (selectedAnswerIndex.value != null &&
                              selectedAnswerIndex.value! >= entry.key) {
                            selectedAnswerIndex.value =
                                selectedAnswerIndex.value! - 1;
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
          10.ph,
          if (answersControllers.value.length < 4)
            Center(
              child: IconButton(
                onPressed: () {
                  final List<TextEditingController> tmp =
                      List.from(answersControllers.value);
                  tmp.add(TextEditingController());
                  answersControllers.value = tmp;
                },
                icon: const Icon(Icons.add),
              ),
            ),
          20.ph,
          Center(child: Text(StringConstants().selectRightAnswer)),
          10.ph,
          Center(
            child: ToggleButtons(
              selectedColor: MyColors.success,
              isSelected: List.generate(
                answersControllers.value.length,
                (index) => index == selectedAnswerIndex.value,
              ),
              onPressed: (int index) {
                selectedAnswerIndex.value = index;
              },
              children: List.generate(
                answersControllers.value.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('${index + 1}'),
                ),
              ),
            ),
          ),
          20.ph,
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  String? message;
                  if(answersControllers.value.length < 2) {
                    message = StringConstants().addAtLeastTwoAnswers;
                  } else if(answersControllers.value.any((element) => element.text.isEmpty)) {
                    message = StringConstants().fillAllAnswers;
                  } else if(questionController.text.isEmpty) {
                    message = StringConstants().fillQuestion;
                  } else if(selectedAnswerIndex.value == null) {
                    message = StringConstants().selectRightAnswer;
                  }
                  if(message != null) {
                    confirmationPopUp(
                    context,
                    content: Text(
                      message,
                    ),
                    isOkPopUp: true,
                  );
                  } else {
                    if (formKey.currentState!.validate()) {
                      final List<PostQuestionQueryAnswer> answers = [];
                      for (int i = 0;
                          i < answersControllers.value.length;
                          i++) {
                        answers.add(
                          PostQuestionQueryAnswer(
                            answer: answersControllers.value[i].text,
                            isCorrect: i == selectedAnswerIndex.value,
                          ),
                        );
                      }
                      final PostQuestionQueryDto query = PostQuestionQueryDto(
                        question: questionController.text,
                        answers: answers,
                        image: image.value,
                      );
                      editQuizBloc.add(
                        question != null
                            ? UpdateQuestionEvent(
                                question!.id,
                                query,
                              )
                            : PostQuestionEvent(query),
                      );
                      context.pop();
                    }
                  }
                },
                child: Text(
                  question != null
                      ? StringConstants().update
                      : StringConstants().add,
                ),
              ),
            ],
          ),
          30.ph,
        ],
      ),
    );
  }

  Future<void> _selectImage(ValueNotifier<XFile?> image) async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then(
          (pickedImage) => {
            if (pickedImage != null)
              {
                image.value = pickedImage,
              },
          },
        );
  }

  Future<void> _downloadAndSetImage(
    String url,
    ValueNotifier<bool> loadingImage,
    ValueNotifier<XFile?> image,
  ) async {
    if (url.isNotEmpty) {
      loadingImage.value = true;

      try {
        final response = await DioClient.instance.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = Uint8List.fromList(response.data);
        final dir = await getApplicationDocumentsDirectory();
        final filePath = path.join(dir.path, path.basename(url));

        final file = File(filePath);
        await file.writeAsBytes(bytes);

        image.value = XFile(filePath);
        loadingImage.value = false;
      } catch (error) {
        loadingImage.value = false;
      }
    }
  }

  CustomCard _buildImagePicker(
    ValueNotifier<XFile?> image,
    BuildContext context,
  ) {
    return CustomCard(
      onTap: () => _selectImage(image),
      width: double.infinity,
      height: 200,
      borderColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: Text(
            StringConstants().addPhoto,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }
}
