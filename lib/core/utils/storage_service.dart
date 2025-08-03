import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // TOKEN İŞLEMLERİ
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // FAVORİ FİLM İŞLEMLERİ
  Future<void> addFavoriteMovie(String movieId) async {
    final favorites = await getFavoriteMovieIds();
    if (!favorites.contains(movieId)) {
      favorites.add(movieId);
      await _storage.write(key: 'favorite_movies', value: json.encode(favorites));
    }
  }

  Future<void> removeFavoriteMovie(String movieId) async {
    final favorites = await getFavoriteMovieIds();
    favorites.remove(movieId);
    await _storage.write(key: 'favorite_movies', value: json.encode(favorites));
  }

  Future<List<String>> getFavoriteMovieIds() async {
    final favoritesJson = await _storage.read(key: 'favorite_movies');
    if (favoritesJson != null) {
      final List<dynamic> list = json.decode(favoritesJson);
      return list.cast<String>();
    }
    return [];
  }
}