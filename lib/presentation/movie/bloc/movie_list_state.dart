part of 'movie_list_bloc.dart';

class MovieListState extends Equatable {
  final List<Movie> movies;
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadMore;
  final String? error;

  const MovieListState({
    this.movies = const [],
    this.currentPage = 0,
    this.totalPages = 0,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadMore = false,
    this.error,
  });

  MovieListState copyWith({
    List<Movie>? movies,
    int? currentPage,
    int? totalPages,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadMore,
    String? error,
  }) {
    return MovieListState(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        movies,
        currentPage,
        totalPages,
        isLoading,
        isRefreshing,
        isLoadMore,
        error,
      ];
}