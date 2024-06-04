import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/profile/profile_bloc.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.isMyProfile = false,
  });

  final bool isMyProfile;

  Future<void> _selectImage(BuildContext context) async {
    if (!isMyProfile) {
      return;
    }
    final picker = ImagePicker();
    await picker
        .pickImage(
          source: ImageSource.gallery,
        )
        .then(
          (pickedImage) => {
            if (pickedImage != null)
              {
                context.read<ProfileBloc>().add(
                      UpdateProfilePictureEvent(
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
        final String? avatarUrl =
            context.read<ProfileBloc>().state.profile?.avatar?.url;
        return GestureDetector(
          onTap: () => _selectImage(context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                child: avatarUrl != null
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
