import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../component/custom_card.dart';
import '../num_extensions.dart';

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

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<XFile?> image = useState(null);
    final TextEditingController textEditingController =
        useTextEditingController();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            children: [
              _buildHeader(context),
              20.ph,
              if (image.value != null)
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
                    _buildRatingBar(context),
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
                    _buildMonumentPicker(context),
                  ],
                ),
              ),
            ],
          ),
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

  CustomCard _buildMonumentPicker(BuildContext context) {
    return CustomCard(
      width: double.infinity,
      height: 100,
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
            'Ajouter un lieu',
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
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

  RatingBar _buildRatingBar(BuildContext context) {
    return RatingBar(
      glow: false,
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
      onRatingUpdate: (double value) {},
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomCard(
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
