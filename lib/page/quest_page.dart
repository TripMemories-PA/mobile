import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../api/quest/quest_service.dart';
import '../bloc/quest_validation/quest_validation_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/quest.dart';
import '../utils/messenger.dart';

class QuestPage extends HookWidget {
  const QuestPage({super.key, required this.quest});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final image = useState<File?>(null);
    return BlocProvider(
      create: (context) => QuestValidationBloc(questService: QuestService()),
      child: BlocConsumer<QuestValidationBloc, QuestValidationState>(
        listener: (context, state) {
          if (state.error != null) {
            Messenger.showSnackBarError(
              state.error?.getDescription() ?? StringConstants().errorOccurred,
            );
          }
          if (state.status == QuestValidationStatus.success) {
            AudioPlayer().play(
              AssetSource(
                'sounds/wow.mp3',
              ),
            );
            Messenger.showSnackBarSuccess('Validé !');
          }
          if (state.status == QuestValidationStatus.failed) {
            AudioPlayer().play(
              AssetSource(
                'sounds/windowError.mp3',
              ),
            );
            Messenger.showSnackBarError('Echec de la validation');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.ph,
                  Row(
                    children: [
                      20.pw,
                      Text(
                        StringConstants().quest,
                        style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily:
                              GoogleFonts.urbanist(fontWeight: FontWeight.w800)
                                  .fontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              leadingWidth: 200,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.pop();
                  },
                ),
                10.pw,
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      30.ph,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.sports_esports_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      20.ph,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          quest.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w700,
                            ).fontFamily,
                          ),
                        ),
                      ),
                      20.ph,
                      const Divider(),
                      20.ph,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          StringConstants().takeAPicture,
                          style: TextStyle(
                            fontFamily: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w700,
                            ).fontFamily,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      20.ph,
                      GestureDetector(
                        onTap: () => _pickImage(image),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        ),
                      ),
                      20.ph,
                      if (image.value == null)
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: AutoSizeText(
                                    StringConstants().photoVisualisation,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    minFontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 400,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 400,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    image.value!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  onPressed: () {
                                    image.value = null;
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                20.ph,
                Container(
                  width: double.infinity,
                  height: 160,
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringConstants().onceQuestValidated,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w700,
                            ).fontFamily,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        10.ph,
                        Container(
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.redeem,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                10.pw,
                                Text(
                                  '50 points',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.normal,
                                    fontFamily:
                                        GoogleFonts.urbanist().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                20.ph,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final File? file = image.value;
                        if (file != null &&
                            state.status != QuestValidationStatus.loading) {
                          context.read<QuestValidationBloc>().add(
                                ValidateQuestEvent(
                                  id: quest.id,
                                  file: file,
                                ),
                              );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) {
                            if (image.value == null ||
                                state.status == QuestValidationStatus.loading) {
                              return Theme.of(context).colorScheme.tertiary;
                            }
                            return Theme.of(context).colorScheme.primary;
                          },
                        ),
                        shape: WidgetStateProperty.resolveWith(
                          (states) {
                            if (image.value == null ||
                                state.status == QuestValidationStatus.loading) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              );
                            }
                            return RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            );
                          },
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.status == QuestValidationStatus.loading)
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: CircularProgressIndicator(),
                            )
                          else
                            Text(
                              StringConstants().validate,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                20.ph,
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImage(ValueNotifier<File?> imageHook) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final File newImage = File(pickedFile.path);
      final int bytes = await newImage.length();
      final double megabytes = bytes / (1024 * 1024);
      if (megabytes > 5) {
        Messenger.showSnackBarError('Image trop lourde');
        return;
      }

      imageHook.value = File(pickedFile.path);
    }
  }
}
