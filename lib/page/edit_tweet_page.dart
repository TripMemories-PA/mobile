import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../api/monument/model/response/poi/poi.dart';
import '../api/post/post_service.dart';
import '../bloc/edit_tweet_bloc/publish_post_bloc.dart';
import '../component/custom_card.dart';
import '../component/popup/search_monument_popup.dart';
import '../num_extensions.dart';
import '../utils/messenger.dart';

class EditTweetPage extends HookWidget {
  const EditTweetPage({super.key});

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

  void publishTweet({
    required BuildContext context,
    required ValueNotifier<XFile?> image,
    required TextEditingController textEditingController,
    Poi? selectedMonument,
    required double rating,
  }) {
    context.read<PublishPostBloc>().add(
          PostTweetRequested(
            content: textEditingController.text,
            rating: rating,
            monumentId: selectedMonument!.id,
            image: image.value,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<XFile?> image = useState(null);
    final TextEditingController textEditingController =
        useTextEditingController();
    final selectedMonument = useState<Poi?>(null);
    final rating = useState<double>(0.0);
    return BlocProvider(
      create: (context) => PublishPostBloc(postService: PostService()),
      child: SafeArea(
        child: BlocBuilder<PublishPostBloc, PublishPostState>(
          builder: (context, state) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ListView(
                  children: [
                    BlocListener<PublishPostBloc, PublishPostState>(
                      listener: (context, state) {
                        if (state.error != null) {
                          Messenger.showSnackBarError(
                            state.error!.getDescription(),
                          );
                        } else if (state.status == EditTweetStatus.posted) {
                          Messenger.showSnackBarSuccess('Tweet publié');
                          context.pop();
                        }
                      },
                      child: const SizedBox.shrink(),
                    ),
                    20.ph,
                    _buildHeader(context, () {
                      publishTweet(
                        context: context,
                        image: image,
                        textEditingController: textEditingController,
                        selectedMonument: selectedMonument.value,
                        rating: rating.value,
                      );
                    }),
                    20.ph,
                    if (image.value != null)
                      Stack(
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
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Evaluez votre expérience',
                            textAlign: TextAlign.left,
                          ),
                          _buildRatingBar(context, rating),
                          10.ph,
                          Text(
                            'Mon expérience',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          10.ph,
                          _buildPostText(context, textEditingController),
                          10.ph,
                          Text(
                            'Localisation',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          10.ph,
                          _buildMonumentPicker(context, selectedMonument),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
      height: 200,
      borderColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      content: CustomCard(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.35,
        borderRadius: 20,
        borderColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Ajouter une photo',
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }

  CustomCard _buildMonumentPicker(
    BuildContext context,
    ValueNotifier<Poi?> selectedMonument,
  ) {
    return CustomCard(
      width: double.infinity,
      height: 100,
      borderColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      content: selectedMonument.value == null
          ? CustomCard(
              onTap: () async {
                final Poi? result = await searchMonumentPopup(context);
                if (result == null) {
                  return;
                } else {
                  if (context.mounted) {
                    selectedMonument.value = result;
                  }
                }
              },
              height: 40,
              width: MediaQuery.of(context).size.width * 0.35,
              borderRadius: 20,
              borderColor: Colors.transparent,
              backgroundColor: Theme.of(context).colorScheme.primary,
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Ajouter un lieu',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      imageUrl: selectedMonument.value?.cover.url ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  selectedMonument.value?.city ?? 'Une ville',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
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
                        selectedMonument.value = null;
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Container _buildPostText(
    BuildContext context,
    TextEditingController textEditingController,
  ) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        controller: textEditingController,
        maxLength: 500,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: 'Partagez votre expérience',
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.all(
            12.0,
          ),
        ),
      ),
    );
  }

  RatingBar _buildRatingBar(
      BuildContext context, ValueNotifier<double> rating) {
    return RatingBar(
      glow: false,
      initialRating: rating.value,
      minRating: 1,
      maxRating: 5,
      updateOnDrag: true,
      allowHalfRating: true,
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
          color: Theme.of(context).colorScheme.primary,
        ),
        half: Icon(
          Icons.star_half,
          color: Theme.of(context).colorScheme.primary,
        ),
        empty: Icon(
          Icons.star,
          color: Theme.of(context).colorScheme.surfaceTint,
        ),
      ),
      onRatingUpdate: (double value) {
        rating.value = value;
      },
    );
  }

  Row _buildHeader(BuildContext context, Function() validate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomCard(
          onTap: () => context.pop(),
          borderColor: Theme.of(context).colorScheme.primary,
          height: 30,
          borderRadius: 20,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              2.pw,
              SizedBox(
                width: 25,
                height: 25,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(const Size(25, 25)),
                    maximumSize: WidgetStateProperty.all(const Size(25, 25)),
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.surface,
                    ),
                    side: WidgetStateProperty.all(
                      BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.zero,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.primary,
                    size: 15,
                  ),
                  onPressed: null,
                ),
              ),
              10.pw,
              Text(
                'Retour',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 11,
                ),
              ),
              10.pw,
            ],
          ),
        ),
        CustomCard(
          onTap: validate,
          height: 30,
          width: 100,
          borderRadius: 20,
          borderColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Valider',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ),
      ],
    );
  }
}
