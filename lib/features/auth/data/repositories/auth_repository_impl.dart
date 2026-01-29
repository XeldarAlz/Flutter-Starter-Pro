import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_starter_pro/core/errors/exceptions.dart';
import 'package:flutter_starter_pro/core/errors/failures.dart';
import 'package:flutter_starter_pro/core/network/network_info.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_starter_pro/features/auth/data/models/user_model.dart';
import 'package:flutter_starter_pro/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_pro/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository].
///
/// This class coordinates between remote and local data sources,
/// handles caching, and manages network connectivity.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.signIn(
        email: email,
        password: password,
      );

      await localDataSource.saveTokens(response.tokens);

      final user = UserModel.fromJson(response.user);
      await localDataSource.cacheUser(user);

      _authStateController.add(user);

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
      );

      await localDataSource.saveTokens(response.tokens);

      final user = UserModel.fromJson(response.user);
      await localDataSource.cacheUser(user);

      _authStateController.add(user);

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.signOut();
        } catch (_) {}
      }

      await localDataSource.clearTokens();
      await localDataSource.clearCachedUser();

      _authStateController.add(null);

      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        if (await networkInfo.isConnected) {
          unawaited(_refreshUserInBackground());
        }
        return Right(cachedUser);
      }
    } catch (_) {}

    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(user);
      return Right(user);
    } on UnauthorizedException {
      await localDataSource.clearTokens();
      await localDataSource.clearCachedUser();
      _authStateController.add(null);
      return const Left(AuthFailure(message: 'Session expired'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  Future<void> _refreshUserInBackground() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(user);
      _authStateController.add(user);
    } catch (_) {}
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await remoteDataSource.updateUser(
        name: name,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );

      await localDataSource.cacheUser(user);
      _authStateController.add(user);

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return localDataSource.hasValidToken();
  }

  /// Disposes the stream controller and releases resources.
  void dispose() {
    _authStateController.close();
  }
}
