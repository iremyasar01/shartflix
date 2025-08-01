import 'package:get_it/get_it.dart';
import 'package:shartflix/data/repositories/profile_repository_impl.dart';
import 'package:shartflix/data/services/profile_service.dart';
import 'package:shartflix/domain/repositories/profile_repository.dart';

final GetIt sl = GetIt.instance;

void init() {
  // Profile Servisleri
  sl.registerLazySingleton<ProfileService>(() => ProfileService());
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profileService: sl()),
  );
  
  // Diğer bağımlılıklar...
}
