import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Failure extends Equatable implements Exception {
  final String message;
  Failure(this.message) {
    if (kDebugMode) {
      log("Failure: $message");
    }
  }
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  ServerFailure(super.msg);
}

class AuthFailure extends Failure {
  AuthFailure(super.msg);
}

class CacheFailure extends Failure {
  CacheFailure(super.msg);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.msg);
}

class UserFailure extends Failure {
  UserFailure(super.msg);
}

class ListsFailure extends Failure {
  ListsFailure(super.msg);
}

class LocationPermissionFailure extends Failure {
  LocationPermissionFailure(super.msg);
}

class LocationServiceFailure extends Failure {
  LocationServiceFailure(super.msg);
}

class LocationTimeoutFailure extends Failure {
  LocationTimeoutFailure(super.msg);
}

class LocationFailure extends Failure {
  LocationFailure(super.msg);
}
