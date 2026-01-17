import 'dart:async';

import 'package:flutter_starter_pro/core/sync/sync_operation.dart';

/// Interface for managing offline sync operations.
///
/// The sync manager queues operations when offline and processes
/// them when connectivity is restored.
///
/// ## Usage
///
/// ```dart
/// final syncManager = ref.read(syncManagerProvider);
///
/// // Queue an operation when offline
/// await syncManager.enqueue(
///   SyncOperation(
///     id: uuid.v4(),
///     type: 'create_post',
///     endpoint: '/posts',
///     method: SyncMethod.post,
///     data: {'title': 'My Post'},
///     createdAt: DateTime.now(),
///   ),
/// );
///
/// // Process pending operations when online
/// await syncManager.processQueue();
/// ```
abstract class SyncManager {
  /// Initialize the sync manager.
  ///
  /// Loads pending operations from storage and sets up
  /// connectivity listeners.
  Future<void> initialize();

  /// Add an operation to the sync queue.
  Future<void> enqueue(SyncOperation operation);

  /// Remove an operation from the queue.
  Future<void> remove(String operationId);

  /// Process all pending operations.
  ///
  /// Returns a list of results for each processed operation.
  Future<List<SyncResult>> processQueue();

  /// Process a single operation.
  Future<SyncResult> processOperation(SyncOperation operation);

  /// Get all pending operations.
  Future<List<SyncOperation>> getPendingOperations();

  /// Get operations by type.
  Future<List<SyncOperation>> getOperationsByType(String type);

  /// Get the number of pending operations.
  Future<int> getPendingCount();

  /// Clear all pending operations.
  Future<void> clearQueue();

  /// Clear failed operations that exceeded max retries.
  Future<void> clearFailedOperations();

  /// Stream of sync status changes.
  Stream<SyncState> get stateStream;

  /// Current sync state.
  SyncState get currentState;

  /// Whether sync is currently in progress.
  bool get isSyncing;

  /// Dispose resources.
  void dispose();
}

/// Current state of the sync manager.
class SyncState {
  const SyncState({
    required this.status,
    this.pendingCount = 0,
    this.failedCount = 0,
    this.lastSyncTime,
    this.currentOperation,
    this.error,
  });

  /// Current sync status
  final SyncManagerStatus status;

  /// Number of pending operations
  final int pendingCount;

  /// Number of failed operations
  final int failedCount;

  /// When the last sync completed
  final DateTime? lastSyncTime;

  /// Currently processing operation (if any)
  final SyncOperation? currentOperation;

  /// Last error message
  final String? error;

  /// Initial idle state
  static const idle = SyncState(status: SyncManagerStatus.idle);

  SyncState copyWith({
    SyncManagerStatus? status,
    int? pendingCount,
    int? failedCount,
    DateTime? lastSyncTime,
    SyncOperation? currentOperation,
    String? error,
  }) {
    return SyncState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      failedCount: failedCount ?? this.failedCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      currentOperation: currentOperation,
      error: error,
    );
  }
}

/// Status of the sync manager.
enum SyncManagerStatus {
  /// No sync in progress
  idle,

  /// Sync is in progress
  syncing,

  /// Waiting for connectivity
  waitingForConnection,

  /// Sync completed successfully
  completed,

  /// Sync failed with errors
  error,
}
