import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progressive_image/progressive_image.dart';

import '../bloc/profile/profile_bloc.dart';

class BannerPicture extends StatelessWidget {
  const BannerPicture({
    super.key,
    this.isMyProfile = false,
  });

  final bool isMyProfile;

  Future<void> _selectImage(BuildContext context) async {
    if (!isMyProfile) {
      return;
    }
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
            height: 150,
            child: bannerUrl != null
                ? LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return ProgressiveImage(
                        placeholder: null,
                        // size: 1.87KB
                        thumbnail:
                            const AssetImage('assets/images/placeholder.jpg'),
                        // size: 1.29MB
                        image: NetworkImage(bannerUrl),
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/louvre.png',
                    fit: BoxFit.cover,
                  ),
          ),
        );
      },
    );
  }
}
