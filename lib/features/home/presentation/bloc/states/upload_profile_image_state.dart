import 'dart:io';

import 'package:equatable/equatable.dart';

enum UploadProfileImageState { initial, loading, success, failure }

class ProfileImageState extends Equatable {
  final UploadProfileImageState uploadProfileImageState;
  final String? errorMessage;
  final File? profileImage;

  const ProfileImageState({
    required this.uploadProfileImageState,
    this.errorMessage,
    this.profileImage
  });
  factory ProfileImageState.initial() {
    return ProfileImageState(
      uploadProfileImageState: UploadProfileImageState.initial,
      profileImage: null
    );
  }

  ProfileImageState copyWith({
    UploadProfileImageState? uploadProfileImageState,
    String? errorMessage,
    File? profileImage
  }) {
    return ProfileImageState(
      uploadProfileImageState:
      uploadProfileImageState ?? this.uploadProfileImageState,
      errorMessage: errorMessage ?? this.errorMessage,
        profileImage: profileImage ?? this.profileImage
    );
  }

  @override
  List<Object?> get props => [uploadProfileImageState, errorMessage, profileImage];
}
