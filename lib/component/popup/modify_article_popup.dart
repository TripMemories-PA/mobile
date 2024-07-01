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
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../object/article.dart';
import '../../utils/messenger.dart';
import '../custom_card.dart';

class ArticleFormPopup extends HookWidget {
  const ArticleFormPopup({
    super.key,
    this.article,
  });

  final Article? article;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<XFile?> image = useState(null);
    final ValueNotifier<bool> loadingImage = useState(false);
    final articleTitleController =
        useTextEditingController(text: article?.title);
    final articleDescriptionController =
        useTextEditingController(text: article?.description);
    final articlePriceController =
        useTextEditingController(text: article?.price.toString());
    useEffect(
      () {
        final Article? article = this.article;
        if (article != null) {
          _downloadAndSetImage(article.imageUrl, loadingImage, image);
        }
        return null;
      },
      [],
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: CustomCard(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.83,
                content: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              article != null
                                  ? StringConstants().modifyArticle
                                  : StringConstants().addArticle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            CustomCard(
                              width: 100,
                              content: Text(
                                StringConstants().close,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.surface),
                              ),
                              backgroundColor:
                              Theme.of(context).colorScheme.primary,
                              onTap: () {
                                context.pop();
                              },
                            ),
                          ],
                        ),

                        20.ph,
                        SizedBox(
                            height: 200,
                            child: Builder(
                              builder: (context) {
                                if (loadingImage.value) {
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                } else {
                                  return image.value != null
                                      ? Stack(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
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
                                      : _buildImagePicker(image, context);
                                }
                              },
                            )),
                        10.ph,
                        Column(
                          children: [
                            Form(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: articleTitleController,
                                    decoration: InputDecoration(
                                      hintText: StringConstants().title,
                                    ),
                                  ),
                                  10.ph,
                                  TextFormField(
                                    controller: articleDescriptionController,
                                    decoration: InputDecoration(
                                      hintText: StringConstants().description,
                                    ),
                                    maxLines: 10,
                                  ),
                                  10.ph,
                                  TextFormField(
                                    controller: articlePriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: StringConstants().price,
                                    ),
                                  ),
                                  20.ph,
                                  CustomCard(
                                    height: 50,
                                    content: Text(
                                      article != null
                                          ? StringConstants().modifyArticle
                                          : StringConstants().addArticle,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    onTap: () {
                                      if (article != null) {
                                        Messenger.showSnackBarSuccess(
                                          'Modify article',
                                        );
                                      } else {
                                        Messenger.showSnackBarSuccess(
                                          'Add article',
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  CustomCard _buildImagePicker(
    ValueNotifier<XFile?> image,
    BuildContext context,
  ) {
    return CustomCard(
      onTap: () => _selectImage(image),
      width: double.infinity,
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
}

Future<bool> modifyArticlePopup({
  required BuildContext context,
  Article? article,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => ArticleFormPopup(
          article: article,
        ),
      ) ??
      false;
}
