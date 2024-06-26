import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progressive_image/progressive_image.dart';

import '../bloc/profile/profile_bloc.dart';
import '../object/avatar/uploaded_file.dart';

class ProfilePictureInteractive extends StatelessWidget {
  const ProfilePictureInteractive({
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
                    ? LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return ProgressiveImage(
                            placeholder: null,
                            // size: 1.87KB
                            thumbnail: const AssetImage(
                              'assets/images/user_placeholder.jpg',
                            ),
                            // size: 1.29MB
                            image: NetworkImage(avatarUrl),
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                            fit: BoxFit.cover,
                          );
                        },
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

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.uploadedFile,
  });

  final UploadFile? uploadedFile;

  @override
  Widget build(BuildContext context) {
    final UploadFile? uploadedFile = this.uploadedFile;
    return DecoratedBox(
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
        width: 60,
        height: 60,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(50.0),
          ),
          child: uploadedFile != null
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return ProgressiveImage(
                      placeholder: null,
                      // size: 1.87KB
                      thumbnail: const AssetImage(
                        'assets/images/user_placeholder.jpg',
                      ),
                      // size: 1.29MB
                      image: NetworkImage(uploadedFile.url),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      fit: BoxFit.cover,
                    );
                  },
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
    );
  }
}
