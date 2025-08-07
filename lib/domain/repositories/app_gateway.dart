import 'package:test_fund_managment/domain/entites/error/error_item.dart';
import 'package:test_fund_managment/domain/entites/fund/list_fund.dart';
import 'package:dartz/dartz.dart';

abstract class AppGateway {
  Future<Either<ErrorItem, ListFund>> getFunds();
}
