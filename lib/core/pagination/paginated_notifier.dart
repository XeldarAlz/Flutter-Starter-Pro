import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/errors/failures.dart';
import 'package:flutter_starter_pro/core/pagination/paginated_list.dart';
import 'package:flutter_starter_pro/core/pagination/pagination_params.dart';

/// State for paginated data with loading, error, and data states.
class PaginatedState<T> {
  const PaginatedState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.hasNextPage = false,
    this.nextCursor,
  });

  /// All loaded items (accumulated for infinite scroll)
  final List<T> items;

  /// Whether initial load is in progress
  final bool isLoading;

  /// Whether loading more items
  final bool isLoadingMore;

  /// Error message if any
  final String? error;

  /// Current page number
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Total number of items
  final int totalItems;

  /// Whether there are more items to load
  final bool hasNextPage;

  /// Cursor for next page (if using cursor pagination)
  final String? nextCursor;

  /// Whether the list is empty
  bool get isEmpty => items.isEmpty && !isLoading;

  /// Whether we have data
  bool get hasData => items.isNotEmpty;

  /// Whether there's an error
  bool get hasError => error != null;

  /// Initial loading state
  static PaginatedState<T> loading<T>() {
    return const PaginatedState(isLoading: true);
  }

  PaginatedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? hasNextPage,
    String? nextCursor,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      nextCursor: nextCursor,
    );
  }
}

/// Base class for paginated data notifiers.
///
/// Extend this class to create a paginated data provider.
///
/// ## Usage
///
/// ```dart
/// class PostsNotifier extends PaginatedNotifier<Post> {
///   PostsNotifier(this.repository) : super();
///
///   final PostRepository repository;
///
///   @override
///   Future<Either<Failure, PaginatedList<Post>>> fetchPage(
///     PaginationParams params,
///   ) {
///     return repository.getPosts(params);
///   }
/// }
/// ```
abstract class PaginatedNotifier<T> extends StateNotifier<PaginatedState<T>> {
  PaginatedNotifier() : super(const PaginatedState());

  PaginationParams _currentParams = const PaginationParams();

  /// Fetch a page of data. Override in subclass.
  Future<Either<Failure, PaginatedList<T>>> fetchPage(PaginationParams params);

  /// Load the first page (or refresh)
  Future<void> loadInitial({PaginationParams? params}) async {
    _currentParams = params ?? const PaginationParams();

    state = state.copyWith(isLoading: true, error: null);

    final result = await fetchPage(_currentParams);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (paginatedList) {
        state = PaginatedState<T>(
          items: paginatedList.items,
          currentPage: paginatedList.currentPage,
          totalPages: paginatedList.totalPages,
          totalItems: paginatedList.totalItems,
          hasNextPage: paginatedList.hasNextPage,
          nextCursor: paginatedList.nextCursor,
        );
      },
    );
  }

  /// Load the next page (for infinite scroll)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    _currentParams = _currentParams.nextPage(nextCursor: state.nextCursor);

    final result = await fetchPage(_currentParams);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingMore: false,
          error: failure.message,
        );
      },
      (paginatedList) {
        state = state.copyWith(
          items: [...state.items, ...paginatedList.items],
          isLoadingMore: false,
          currentPage: paginatedList.currentPage,
          totalPages: paginatedList.totalPages,
          totalItems: paginatedList.totalItems,
          hasNextPage: paginatedList.hasNextPage,
          nextCursor: paginatedList.nextCursor,
        );
      },
    );
  }

  /// Refresh the list (reload from first page)
  Future<void> refresh() async {
    await loadInitial(params: _currentParams.copyWith(page: 1));
  }

  /// Update sort order and reload
  Future<void> updateSort(String? sortBy, {SortOrder? order}) async {
    await loadInitial(
      params: _currentParams.copyWith(
        sortBy: sortBy,
        sortOrder: order ?? _currentParams.sortOrder,
        page: 1,
      ),
    );
  }
}
