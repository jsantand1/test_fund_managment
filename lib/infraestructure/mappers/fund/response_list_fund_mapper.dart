import 'package:test_fund_managment/domain/entites/fund/list_fund.dart';
import 'package:test_fund_managment/infraestructure/entities/fund/response_fund.dart';
import 'package:test_fund_managment/infraestructure/entities/fund/response_list_fund.dart';
import 'package:test_fund_managment/infraestructure/mappers/mapper.dart';
import 'package:test_fund_managment/infraestructure/mappers/fund/response_fund_mapper.dart';

class ResponseListFundMapper extends Mapper<ResponseListFund> {
  final ResponseFundMapper _fundMapper = ResponseFundMapper();

  @override
  ResponseListFund fromMap(Map<String, dynamic> map) {
    try {
      final funds = map['data'];
      
      return ResponseListFund(
        funds: funds != null && funds is List
            ? List<ResponseFund>.from(
                funds.map((x) => _fundMapper.fromMap(x as Map<String, dynamic>))
              )
            : null,
      );
    } catch (e) {
      throw FormatException('Invalid fund list format: $e');
    }
  }

  @override
  Map<String, dynamic> toMap(ResponseListFund data) {
    return {
      'funds': data.funds
          ?.map((fund) => _fundMapper.toMap(fund))
          .toList(),
    };
  }

  ListFund toDomain(ResponseListFund data) => ListFund(
    funds: data.funds
        ?.map((responseFund) => _fundMapper.toDomain(responseFund))
        .toList() ?? [],
  );
}
