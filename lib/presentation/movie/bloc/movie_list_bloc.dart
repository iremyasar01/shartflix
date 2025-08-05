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
    
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final movies = await movieRepository.getMovies(1);
      emit(state.copyWith(
        movies: movies,
        currentPage: 1,
        totalPages: 4, 
        isLoading: false,
        error: null,
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
    
    emit(state.copyWith(isLoadMore: true, error: null));
    
    try {
      final nextPage = state.currentPage + 1;
      final newMovies = await movieRepository.getMovies(nextPage);
      
      final allMovies = [...state.movies, ...newMovies];
      
      emit(state.copyWith(
        movies: allMovies,
        currentPage: nextPage,
        isLoadMore: false,
        error: null,
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
    emit(state.copyWith(isRefreshing: true, error: null));
    
    try {
      final movies = await movieRepository.getMovies(1);
      emit(state.copyWith(
        movies: movies,
        currentPage: 1,
        isRefreshing: false,
        error: null,
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
    // Önce mevcut movie'yi bul
    final currentMovie = state.movies.firstWhere(
      (movie) => movie.id == event.movieId,
      orElse: () => throw Exception('Film bulunamadı'),
    );

    try {
      print('Toggle favorite için movie bulundu: ${currentMovie.title}');
      
      // Optimistic UI Update - kullanıcıya anında geri bildirim
      final newFavoriteStatus = !currentMovie.isFavorite;
      final optimisticMovies = state.movies.map((movie) {
        if (movie.id == event.movieId) {
          return movie.copyWith(isFavorite: newFavoriteStatus);
        }
        return movie;
      }).toList();

      emit(state.copyWith(movies: optimisticMovies));

      // API çağrısını yap
      await movieRepository.toggleFavorite(event.movieId);
      
      // API başarılı oldu, optimistic update'i koru
      print('Favori toggle işlemi başarılı - Movie: ${currentMovie.title}, Yeni durum: $newFavoriteStatus');
      
      // İsteğe bağlı: Başarılı işlem sonrası güncel movie bilgisini al
      // Bu durumda optimistic update'i koruyoruz çünkü API'den tam bilgi gelmeyebilir
      final finalMovies = state.movies.map((movie) {
        if (movie.id == event.movieId) {
          return currentMovie.copyWith(isFavorite: newFavoriteStatus);
        }
        return movie;
      }).toList();

      emit(state.copyWith(movies: finalMovies, error: null));
      
    } catch (e) {
      print('Toggle favorite hatası: $e');
      
      // Hata durumunda eski durumu geri yükle
      final revertedMovies = state.movies.map((movie) {
        if (movie.id == event.movieId) {
          return currentMovie; // Orijinal movie nesnesini geri yükle
        }
        return movie;
      }).toList();

      emit(state.copyWith(
        movies: revertedMovies,
        error: 'Favori durumu güncellenemedi: ${e.toString()}',
      ));
    }
  }
}