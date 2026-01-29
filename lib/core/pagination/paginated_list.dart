import 'package:equatable/equatable.dart';
import 'package:flutter_starter_pro/core/pagination/pagination_params.dart';

/// A wrapper for paginated list data.
///
/// Contains the items for the current page along with pagination
/// metadata for navigation.
///
/// ## Usage
///
/// ```dart
/// final response = await api.getPosts(params);
/// final paginatedList = PaginatedList<Post>.fromJson(
///   response.data,
///   (json) => Post.fromJson(json),
/// );
///
/// print('Page ${paginatedList.currentPage} of ${paginatedList.totalPages}');
/// print('Showing ${paginatedList.items.length} of ${paginatedList.totalItems}');
/// ```
class PaginatedList<T> extends Equatable {
  const PaginatedList({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    this.nextCursor,
    this.previousCursor,
  });

  /// Create from API response JSON.
  ///
  /// Supports common pagination response formats:
  /// - { data: [...], meta: { current_page, last_page, total, per_page } }
  /// - { items: [...], page, total_pages, total, limit }
  /// - { results: [...], count, next, previous }
  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final itemsJson = json['data'] ??
        json['items'] ??
        json['results'] ??
        json['content'] ??
        <dynamic>[];

    final items = (itemsJson as List<dynamic>)
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    final meta = json['meta'] as Map<String, dynamic>? ?? json;

    return PaginatedList<T>(
      items: items,
      currentPage: meta['current_page'] as int? ?? meta['page'] as int? ?? 1,
      totalPages: meta['last_page'] as int? ?? meta['total_pages'] as int? ?? 1,
      totalItems:
          meta['total'] as int? ?? meta['count'] as int? ?? items.length,
      itemsPerPage: meta['per_page'] as int? ?? meta['limit'] as int? ?? 20,
      nextCursor: meta['next_cursor'] as String? ??
          _extractCursor(meta['next'] as String?),
      previousCursor: meta['previous_cursor'] as String? ??
          _extractCursor(meta['previous'] as String?),
    );
  }

  /// Items for the current page
  final List<T> items;

  /// Current page number (1-indexed)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Total number of items across all pages
  final int totalItems;

  /// Number of items per page
  final int itemsPerPage;

  /// Cursor for the next page (cursor-based pagination)
  final String? nextCursor;

  /// Cursor for the previous page (cursor-based pagination)
  final String? previousCursor;

  /// Whether there are more pages after this one
  bool get hasNextPage => currentPage < totalPages || nextCursor != null;

  /// Whether there are pages before this one
  bool get hasPreviousPage => currentPage > 1 || previousCursor != null;

  /// Whether this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Whether this is the last page
  bool get isLastPage => currentPage >= totalPages && nextCursor == null;

  /// Whether the list is empty
  bool get isEmpty => items.isEmpty;

  /// Whether the list is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Number of items on this page
  int get count => items.length;

  /// Create an empty paginated list
  static PaginatedList<T> empty<T>() {
    return PaginatedList<T>(
      items: const [],
      currentPage: 1,
      totalPages: 0,
      totalItems: 0,
      itemsPerPage: 20,
    );
  }

  /// Get pagination params for the next page
  PaginationParams getNextPageParams(PaginationParams current) {
    return current.nextPage(nextCursor: nextCursor);
  }

  /// Get pagination params for the previous page
  PaginationParams getPreviousPageParams(PaginationParams current) {
    return current.previousPage();
  }

  /// Map items to a different type
  PaginatedList<R> map<R>(R Function(T) mapper) {
    return PaginatedList<R>(
      items: items.map(mapper).toList(),
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      itemsPerPage: itemsPerPage,
      nextCursor: nextCursor,
      previousCursor: previousCursor,
    );
  }

  /// Merge with another page (for infinite scroll)
  PaginatedList<T> mergeWith(PaginatedList<T> other) {
    return PaginatedList<T>(
      items: [...items, ...other.items],
      currentPage: other.currentPage,
      totalPages: other.totalPages,
      totalItems: other.totalItems,
      itemsPerPage: other.itemsPerPage,
      nextCursor: other.nextCursor,
      previousCursor: previousCursor,
    );
  }

  @override
  List<Object?> get props => [
        items,
        currentPage,
        totalPages,
        totalItems,
        itemsPerPage,
        nextCursor,
        previousCursor,
      ];
}

/// Extract cursor from a URL string (for Django REST framework style)
String? _extractCursor(String? url) {
  if (url == null) return null;
  final uri = Uri.tryParse(url);
  return uri?.queryParameters['cursor'];
}
