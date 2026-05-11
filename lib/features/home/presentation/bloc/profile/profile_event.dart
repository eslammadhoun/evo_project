import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UploadProfileImageEvent extends ProfileEvent {
  final File imageFile;
  const UploadProfileImageEvent({required this.imageFile});

  @override
  List<Object> get props => [imageFile];
}
