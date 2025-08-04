import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/presentation/movie/bloc/movie_list_event.dart';



part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieRepository movieRepository;
  final StorageService localStorage;
  bool hasReachedMax = false;

  MovieListBloc({
    required this.movieRepository,
    required this.localStorage,
  }) : super(const MovieListState()) {
    on<FetchMovies>(_onFetchMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onFetchMovies(
    FetchMovies event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.isLoading) return;
    
    emit(state.copyWith(isLoading: true));
    
    try {
      final movies = await movieRepository.getMovies(1);
      emit(state.copyWith(
        movies: movies,
        currentPage: 1,
        totalPages: 4, 
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.isLoadMore || 
        state.currentPage >= state.totalPages || 
        state.isLoading) return;
    
    emit(state.copyWith(isLoadMore: true));
    
    try {
      final nextPage = state.currentPage + 1;
      final newMovies = await movieRepository.getMovies(nextPage);
      
      final allMovies = [...state.movies, ...newMovies];
      
      emit(state.copyWith(
        movies: allMovies,
        currentPage: nextPage,
        isLoadMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoadMore: false,
      ));
    }
  }

  Future<void> _onRefreshMovies(
    RefreshMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));
    
    try {
      final movies = await movieRepository.getMovies(1);
      emit(state.copyWith(
        movies: movies,
        currentPage: 1,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isRefreshing: false,
      ));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<MovieListState> emit,
  ) async {
    try {
      final updatedMovies = state.movies.map((movie) {
        if (movie.id == event.movieId) {
          return movie.copyWith(isFavorite: !movie.isFavorite);
        }
        return movie;
      }).toList();

      // Favori durumunu güncelle
      if (updatedMovies.any((m) => m.id == event.movieId && m.isFavorite)) {
        await localStorage.addFavoriteMovie(event.movieId);
      } else {
        await localStorage.removeFavoriteMovie(event.movieId);
      }
      
      emit(state.copyWith(movies: updatedMovies));
    } catch (e) {
      // Hata durumunda eski state'i koru
      emit(state);
    }
  }
}