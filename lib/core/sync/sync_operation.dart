import 'package:equatable/equatable.dart';

/// Represents a pending sync operation to be executed when online.
///
/// Sync operations are persisted locally and processed when
/// network connectivity is restored.
class SyncOperation extends Equatable {
  const SyncOperation({
    required this.id,
    required this.type,
    required this.endpoint,
    required this.method,
    required this.createdAt,
    this.data,
    this.retryCount = 0,
    this.maxRetries = 3,
    this.lastAttempt,
    this.error,
  });

  /// Create from JSON
  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'] as String,
      type: json['type'] as String,
      endpoint: json['endpoint'] as String,
      method: SyncMethod.values.byName(json['method'] as String),
      data: json['data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
      maxRetries: json['maxRetries'] as int? ?? 3,
      lastAttempt: json['lastAttempt'] != null
          ? DateTime.parse(json['lastAttempt'] as String)
          : null,
      error: json['error'] as String?,
    );
  }

  /// Unique identifier for this operation
  final String id;

  /// Type of operation (e.g., 'create_user', 'update_post')
  final String type;

  /// API endpoint for this operation
  final String endpoint;

  /// HTTP method (POST, PUT, PATCH, DELETE)
  final SyncMethod method;

  /// Request payload data
  final Map<String, dynamic>? data;

  /// When the operation was created
  final DateTime createdAt;

  /// Number of retry attempts
  final int retryCount;

  /// Maximum retry attempts before giving up
  final int maxRetries;

  /// When the last attempt was made
  final DateTime? lastAttempt;

  /// Last error message if failed
  final String? error;

  /// Whether this operation can be retried
  bool get canRetry => retryCount < maxRetries;

  /// Whether this operation has failed permanently
  bool get hasFailed => retryCount >= maxRetries;

  /// Create a copy with updated retry information
  SyncOperation copyWithRetry({String? error}) {
    return SyncOperation(
      id: id,
      type: type,
      endpoint: endpoint,
      method: method,
      data: data,
      createdAt: createdAt,
      retryCount: retryCount + 1,
      maxRetries: maxRetries,
      lastAttempt: DateTime.now(),
      error: error,
    );
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'endpoint': endpoint,
      'method': method.name,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'maxRetries': maxRetries,
      'lastAttempt': lastAttempt?.toIso8601String(),
      'error': error,
    };
  }

  @override
  List<Object?> get props => [
        id,
        type,
        endpoint,
        method,
        data,
        createdAt,
        retryCount,
        maxRetries,
        lastAttempt,
        error,
      ];
}

/// HTTP methods for sync operations
enum SyncMethod {
  post,
  put,
  patch,
  delete,
}

/// Status of a sync operation
enum SyncStatus {
  /// Waiting to be processed
  pending,

  /// Currently being processed
  inProgress,

  /// Successfully completed
  completed,

  /// Failed but can be retried
  failed,

  /// Failed permanently (max retries exceeded)
  abandoned,
}

/// Result of a sync attempt
class SyncResult {
  const SyncResult({
    required this.operation,
    required this.status,
    this.response,
    this.error,
  });

  final SyncOperation operation;
  final SyncStatus status;
  final dynamic response;
  final String? error;

  bool get isSuccess => status == SyncStatus.completed;
  bool get isFailed =>
      status == SyncStatus.failed || status == SyncStatus.abandoned;
}
