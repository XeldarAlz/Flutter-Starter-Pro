import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_starter_pro/core/errors/failures.dart';

/// Base class for use cases that require parameters.
///
/// Use cases encapsulate a single piece of business logic and follow
/// the Single Responsibility Principle.
///
/// Example:
/// ```dart
/// class GetUserUseCase implements UseCase<User, GetUserParams> {
///   final UserRepository repository;
///
///   GetUserUseCase(this.repository);
///
///   @override
///   Future<Either<Failure, User>> call(GetUserParams params) {
///     return repository.getUser(params.id);
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Base class for use cases that don't require parameters.
///
/// Example:
/// ```dart
/// class GetCurrentUserUseCase implements UseCaseNoParams<User> {
///   final AuthRepository repository;
///
///   GetCurrentUserUseCase(this.repository);
///
///   @override
///   Future<Either<Failure, User>> call() {
///     return repository.getCurrentUser();
///   }
/// }
/// ```
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Base class for stream-based use cases that require parameters.
///
/// Example:
/// ```dart
/// class WatchUserUseCase implements StreamUseCase<User, WatchUserParams> {
///   final UserRepository repository;
///
///   WatchUserUseCase(this.repository);
///
///   @override
///   Stream<Either<Failure, User>> call(WatchUserParams params) {
///     return repository.watchUser(params.id);
///   }
/// }
/// ```
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// Base class for stream-based use cases that don't require parameters.
abstract class StreamUseCaseNoParams<Type> {
  Stream<Either<Failure, Type>> call();
}

/// Empty params class for use cases that technically have params
/// but don't need any actual parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
