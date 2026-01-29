import 'dart:async';
import 'dart:convert';

import 'package:flutter_starter_pro/core/network/api_client.dart';
import 'package:flutter_starter_pro/core/network/network_info.dart';
import 'package:flutter_starter_pro/core/storage/local_storage.dart';
import 'package:flutter_starter_pro/core/sync/sync_manager.dart';
import 'package:flutter_starter_pro/core/sync/sync_operation.dart';
import 'package:flutter_starter_pro/core/utils/logger.dart';

/// Default implementation of [SyncManager].
///
/// Persists operations to local storage and processes them
/// when network connectivity is available.
class SyncManagerImpl implements SyncManager {
  SyncManagerImpl({
    required this.apiClient,
    required this.networkInfo,
    required this.localStorage,
  });

  final ApiClient apiClient;
  final NetworkInfo networkInfo;
  final LocalStorage localStorage;

  static const String _storageKey = 'pending_sync_operations';

  final _stateController = StreamController<SyncState>.broadcast();
  SyncState _currentState = SyncState.idle;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isSyncing = false;

  @override
  Stream<SyncState> get stateStream => _stateController.stream;

  @override
  SyncState get currentState => _currentState;

  @override
  bool get isSyncing => _isSyncing;

  @override
  Future<void> initialize() async {
    _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
      (isConnected) {
        if (isConnected && !_isSyncing) {
          processQueue();
        }
      },
    );

    final pending = await getPendingOperations();
    _updateState(_currentState.copyWith(pendingCount: pending.length));

    AppLogger.info(
      'SyncManager initialized with ${pending.length} pending operations',
    );
  }

  @override
  Future<void> enqueue(SyncOperation operation) async {
    final operations = await _loadOperations();
    operations.add(operation);
    await _saveOperations(operations);

    _updateState(
      _currentState.copyWith(
        pendingCount: operations.length,
      ),
    );

    AppLogger.debug('Enqueued sync operation: ${operation.type}');

    if (await networkInfo.isConnected && !_isSyncing) {
      unawaited(processQueue());
    }
  }

  @override
  Future<void> remove(String operationId) async {
    final operations = await _loadOperations();
    operations.removeWhere((op) => op.id == operationId);
    await _saveOperations(operations);

    _updateState(
      _currentState.copyWith(
        pendingCount: operations.length,
      ),
    );
  }

  @override
  Future<List<SyncResult>> processQueue() async {
    if (_isSyncing) {
      AppLogger.debug('Sync already in progress, skipping');
      return [];
    }

    if (!await networkInfo.isConnected) {
      _updateState(
        _currentState.copyWith(
          status: SyncManagerStatus.waitingForConnection,
        ),
      );
      return [];
    }

    _isSyncing = true;
    _updateState(_currentState.copyWith(status: SyncManagerStatus.syncing));

    final results = <SyncResult>[];
    final operations = await _loadOperations();
    final remainingOperations = <SyncOperation>[];
    var failedCount = 0;

    for (final operation in operations) {
      _updateState(_currentState.copyWith(currentOperation: operation));

      final result = await processOperation(operation);
      results.add(result);

      if (result.isSuccess) {
        AppLogger.info('Sync operation completed: ${operation.type}');
      } else if (operation.canRetry) {
        remainingOperations.add(operation.copyWithRetry(error: result.error));
        AppLogger.warning(
          'Sync operation failed, will retry: ${operation.type}',
        );
      } else {
        failedCount++;
        AppLogger.error('Sync operation abandoned: ${operation.type}');
      }
    }

    await _saveOperations(remainingOperations);

    _isSyncing = false;
    _updateState(
      SyncState(
        status: failedCount > 0
            ? SyncManagerStatus.error
            : SyncManagerStatus.completed,
        pendingCount: remainingOperations.length,
        failedCount: failedCount,
        lastSyncTime: DateTime.now(),
      ),
    );

    return results;
  }

  @override
  Future<SyncResult> processOperation(SyncOperation operation) async {
    try {
      final response = switch (operation.method) {
        SyncMethod.post => await apiClient.post<dynamic>(
            operation.endpoint,
            data: operation.data,
          ),
        SyncMethod.put => await apiClient.put<dynamic>(
            operation.endpoint,
            data: operation.data,
          ),
        SyncMethod.patch => await apiClient.patch<dynamic>(
            operation.endpoint,
            data: operation.data,
          ),
        SyncMethod.delete => await apiClient.delete<dynamic>(
            operation.endpoint,
            data: operation.data,
          ),
      };

      return SyncResult(
        operation: operation,
        status: SyncStatus.completed,
        response: response.data,
      );
    } catch (e) {
      return SyncResult(
        operation: operation,
        status: operation.canRetry ? SyncStatus.failed : SyncStatus.abandoned,
        error: e.toString(),
      );
    }
  }

  @override
  Future<List<SyncOperation>> getPendingOperations() => _loadOperations();

  @override
  Future<List<SyncOperation>> getOperationsByType(String type) async {
    final operations = await _loadOperations();
    return operations.where((op) => op.type == type).toList();
  }

  @override
  Future<int> getPendingCount() async {
    final operations = await _loadOperations();
    return operations.length;
  }

  @override
  Future<void> clearQueue() async {
    await localStorage.remove(_storageKey);
    _updateState(SyncState.idle);
  }

  @override
  Future<void> clearFailedOperations() async {
    final operations = await _loadOperations();
    final remaining = operations.where((op) => op.canRetry).toList();
    await _saveOperations(remaining);
    _updateState(
      _currentState.copyWith(
        pendingCount: remaining.length,
        failedCount: 0,
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _stateController.close();
  }

  void _updateState(SyncState state) {
    _currentState = state;
    _stateController.add(state);
  }

  Future<List<SyncOperation>> _loadOperations() async {
    final json = localStorage.getString(_storageKey);
    if (json == null || json.isEmpty) return [];

    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((item) => SyncOperation.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.error('Failed to load sync operations', error: e);
      return [];
    }
  }

  Future<void> _saveOperations(List<SyncOperation> operations) async {
    final json = jsonEncode(operations.map((op) => op.toJson()).toList());
    await localStorage.setString(_storageKey, json);
  }
}
