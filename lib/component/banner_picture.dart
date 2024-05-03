import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/profile/profile_bloc.dart';

class BannerPicture extends StatelessWidget {
  const BannerPicture({
    super.key,
  });

  Future<void> _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then(
          (pickedImage) => {
            if (pickedImage != null)
              {
                context.read<ProfileBloc>().add(
                      UpdateProfileBannerEvent(
                        pickedImage,
                      ),
                    ),
              },
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    final String? bannerUrl =
        context.read<ProfileBloc>().state.profile?.banner?.url;
    return GestureDetector(
      onTap: () => _selectImage(context),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 210,
        child: bannerUrl != null
            ? CachedNetworkImage(
                imageUrl: bannerUrl,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : Image.asset('assets/images/louvre.png'),
      ),
    );
  },
);
  }
}
