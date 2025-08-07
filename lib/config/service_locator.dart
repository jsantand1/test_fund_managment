import 'package:get_it/get_it.dart';
import 'package:test_fund_managment/config/app_config.dart';
import 'package:test_fund_managment/infraestructure/infraestructure.dart';

final getIt = GetIt.instance;

void setUpLocator() {
  // Repositories
  getIt.registerLazySingleton<AppApi>(
    () => AppApi(),
  );
  // configs
  getIt.registerLazySingleton<AppConfig>(() => AppConfig(getIt<AppApi>()));
}