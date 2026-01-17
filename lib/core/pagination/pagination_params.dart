import 'package:equatable/equatable.dart';

/// Parameters for paginated API requests.
///
/// Supports both offset-based and cursor-based pagination.
class PaginationParams extends Equatable {
  const PaginationParams({
    this.page = 1,
    this.limit = 20,
    this.offset,
    this.cursor,
    this.sortBy,
    this.sortOrder = SortOrder.desc,
  });

  /// Current page number (1-indexed)
  final int page;

  /// Number of items per page
  final int limit;

  /// Offset for offset-based pagination (alternative to page)
  final int? offset;

  /// Cursor for cursor-based pagination
  final String? cursor;

  /// Field to sort by
  final String? sortBy;

  /// Sort order (ascending or descending)
  final SortOrder sortOrder;

  /// Calculate offset from page and limit
  int get calculatedOffset => offset ?? (page - 1) * limit;

  /// Whether this is the first page
  bool get isFirstPage => page == 1 && cursor == null;

  /// Create params for the next page
  PaginationParams nextPage({String? nextCursor}) {
    if (nextCursor != null) {
      return copyWith(cursor: nextCursor);
    }
    return copyWith(page: page + 1);
  }

  /// Create params for the previous page
  PaginationParams previousPage() {
    if (page <= 1) return this;
    return copyWith(page: page - 1);
  }

  /// Convert to query parameters map
  Map<String, dynamic> toQueryParams() {
    return {
      if (cursor != null) 'cursor': cursor else 'page': page,
      'limit': limit,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortBy != null) 'sort_order': sortOrder.value,
    };
  }

  PaginationParams copyWith({
    int? page,
    int? limit,
    int? offset,
    String? cursor,
    String? sortBy,
    SortOrder? sortOrder,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      cursor: cursor ?? this.cursor,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [page, limit, offset, cursor, sortBy, sortOrder];
}

/// Sort order for paginated results.
enum SortOrder {
  asc('asc'),
  desc('desc');

  const SortOrder(this.value);
  final String value;
}
