import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState();

  factory HomeState.initial() {
    return HomeState();
  }

  HomeState copyWith() {
    return HomeState();
  }

  @override
  List<Object?> get props => [];
}
