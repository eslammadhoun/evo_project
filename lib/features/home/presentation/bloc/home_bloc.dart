import 'package:evo_project/features/home/presentation/bloc/home_event.dart';
import 'package:evo_project/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial());
}
