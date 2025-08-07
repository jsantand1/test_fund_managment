import 'package:get_it/get_it.dart';
import 'package:test_fund_managment/domain/usecases/app_usecases.dart';
import 'package:test_fund_managment/infraestructure/infraestructure.dart';

final getIt = GetIt.instance;

void setUpLocator() {
  // Repositories
  getIt.registerLazySingleton<AppApi>(
    () => AppApi(),
  );
   // UseCases directamente
  getIt.registerLazySingleton<AppUseCases>(
    () => AppUseCases(getIt<AppApi>()),
  );
}