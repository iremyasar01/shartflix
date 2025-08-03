import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/core/utils/auth_interceptor.dart';
import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/data/datasources/movie_remote_data_source.dart';
import 'package:shartflix/data/repositories/movie_repository_impl.dart';
import 'package:shartflix/data/repositories/profile_repository_impl.dart';
import 'package:shartflix/data/services/profile_service.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/domain/repositories/profile_repository.dart';

final GetIt sl = GetIt.instance;

void init() {
  // Dio instance (HTTP client)
  sl.registerLazySingleton<Dio>(() => Dio(
        BaseOptions(
          baseUrl: 'https://caseapi.servicelabs.tech',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      )..interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      AuthInterceptor(sl<StorageService>()), // Yeni eklediğimiz interceptor
    ]),
    );
  
        

  // Storage Service 
  sl.registerLazySingleton<StorageService>(() => StorageService());
  

  // Movie Data Source
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  // Movie Repository - localStorage PARAMETRESİ EKLENDİ
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      localStorage: sl(), 
    ),
  );

  // Profile Servisleri
  sl.registerLazySingleton<ProfileService>(() => ProfileService());
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profileService: sl()),
  );
  
}