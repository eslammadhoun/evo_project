import 'dart:io';
import 'package:equatable/equatable.dart';

enum UploadProfileImageState { initial, loading, success, failure }

class ProfileState extends Equatable {
  final UploadProfileImageState uploadProfileImageState;
  final String? errorMessage;
  final File? profileImage;

  const ProfileState({
    required this.uploadProfileImageState,
    this.errorMessage,
    this.profileImage,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      uploadProfileImageState: UploadProfileImageState.initial,
      profileImage: null,
    );
  }

  ProfileState copyWith({
    UploadProfileImageState? uploadProfileImageState,
    String? errorMessage,
    File? profileImage,
  }) {
    return ProfileState(
      uploadProfileImageState:
          uploadProfileImageState ?? this.uploadProfileImageState,
      errorMessage: errorMessage ?? this.errorMessage,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  List<Object?> get props => [uploadProfileImageState, errorMessage, profileImage];
}
