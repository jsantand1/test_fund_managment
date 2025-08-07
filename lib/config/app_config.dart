import 'package:test_fund_managment/domain/repositories/app_gateway.dart';
import 'package:test_fund_managment/domain/usecases/app_usecases.dart';

class AppConfig {
  late AppUseCases appUseCases;
  AppConfig(AppGateway api) {
    appUseCases = AppUseCases(api);
  }
}
