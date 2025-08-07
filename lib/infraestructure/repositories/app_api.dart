import 'package:dartz/dartz.dart';
import 'package:test_fund_managment/domain/entites/error/error_item.dart';
import 'package:test_fund_managment/domain/entites/fund/list_fund.dart';
import 'package:test_fund_managment/domain/repositories/app_gateway.dart';
import 'package:test_fund_managment/infraestructure/helpers/exception_helper.dart';
import 'package:test_fund_managment/infraestructure/infraestructure.dart';
import 'package:test_fund_managment/infraestructure/mappers/fund/response_list_fund_mapper.dart';
import 'package:test_fund_managment/infraestructure/entities/fund/response_list_fund.dart';
import 'package:test_fund_managment/infraestructure/utils/endpoints.dart';

class AppApi implements AppGateway {
  final HttpService _service = HttpService();
  AppApi();

  @override
  Future<Either<ErrorItem, ListFund>> getFunds() async {
    try {
      final response = await _service.get(Endpoints.funds);
      final mapper = ResponseListFundMapper();
      final ResponseListFund responseListFund = mapper.fromMap(response);
      final ListFund responseFund = mapper.toDomain(responseListFund);
      return Right<ErrorItem, ListFund>(responseFund);
    } catch (e) {
      // Capturar cualquier tipo de excepción
      final ErrorItem errorItem =
          ExceptionHelper.handlerBaseExceptionToErrorItem(e);
      return Left<ErrorItem, ListFund>(errorItem);
    }
  }
}
