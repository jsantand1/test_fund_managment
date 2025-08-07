import 'package:test_fund_managment/domain/entites/error/error_item.dart';
import 'package:test_fund_managment/domain/entites/fund/list_fund.dart';
import 'package:dartz/dartz.dart';
import 'package:test_fund_managment/domain/repositories/app_gateway.dart';

class AppUseCases {
  final AppGateway _appGateway;

  AppUseCases(this._appGateway);

  Future<Either<ErrorItem, ListFund>> getFunds() async =>
      await _appGateway.getFunds();
}
