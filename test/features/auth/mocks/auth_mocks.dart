import 'package:flutter_starter_pro/core/network/network_info.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_starter_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock classes for auth feature tests
class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}
