import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/auth/domain/entities/user_entity.dart';
import 'package:evo_project/features/auth/domain/usecases/login.dart';
import 'package:evo_project/features/auth/domain/usecases/logout.dart';
import 'package:evo_project/features/auth/domain/usecases/register.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUsecase logoutUsecase;
  final RegisterUseCase registerUseCase;
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUsecase,
    required this.registerUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RegisterEvent>(_onRegister);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final Either<Failure, UserEntity> loginResult = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    loginResult.fold(
      (failure) => emit(AuthError(failure.message)),
      (success) => emit(AuthSuccess(success)),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final Either<Failure, UserEntity> registerResult = await registerUseCase(
      name: event.name,
      email: event.email,
      password: event.password,
      telephone: event.telephone,
      telephoneExtension: event.telephoneExtension,
      dateOfBirth: event.dateOfBirth,
    );

    registerResult.fold(
      (failure) => emit(AuthError(failure.message)),
      (success) => emit(AuthSuccess(success)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final Either<Failure, void> logoutResult = await logoutUsecase();
    logoutResult.fold(
      (failure) => emit(AuthError(failure.message)),
      (success) => emit(LogoutSuccess()),
    );
  }
}
