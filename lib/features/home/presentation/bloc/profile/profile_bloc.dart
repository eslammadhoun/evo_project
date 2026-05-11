import 'package:evo_project/features/home/domain/usecases/upload_profile_image.dart';
import 'package:evo_project/features/home/presentation/bloc/profile/profile_event.dart';
import 'package:evo_project/features/home/presentation/bloc/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UploadProfileImageUsecase uploadProfileImageUsecase;

  ProfileBloc({required this.uploadProfileImageUsecase})
    : super(ProfileState.initial()) {
    on<UploadProfileImageEvent>(_uploadProfileImage);
  }

  Future<void> _uploadProfileImage(
    UploadProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(uploadProfileImageState: UploadProfileImageState.loading),
    );

    final result = await uploadProfileImageUsecase(imageFile: event.imageFile);

    result.fold(
      (failure) => emit(
        state.copyWith(
          uploadProfileImageState: UploadProfileImageState.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          uploadProfileImageState: UploadProfileImageState.success,
          profileImage: event.imageFile,
        ),
      ),
    );
  }
}
