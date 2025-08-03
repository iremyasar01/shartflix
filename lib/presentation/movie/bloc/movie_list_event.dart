abstract class MovieListEvent {}

class FetchMovies extends MovieListEvent {}

class LoadMoreMovies extends MovieListEvent {}

class RefreshMovies extends MovieListEvent {}

class ToggleFavorite extends MovieListEvent {
  final String movieId;

  ToggleFavorite(this.movieId);
}