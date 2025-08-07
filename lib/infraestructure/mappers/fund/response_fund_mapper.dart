import 'package:test_fund_managment/domain/entites/fund/fund.dart';
import 'package:test_fund_managment/infraestructure/entities/fund/response_fund.dart';
import 'package:test_fund_managment/infraestructure/mappers/mapper.dart';

class ResponseFundMapper extends Mapper<ResponseFund> {
  @override
  ResponseFund fromMap(Map<String, dynamic> map) {
    try {
      return ResponseFund(
        id: map['id'] as int?,
        name: map['name'] as String?,
        minimumAmount: (map['minimumAmount'] as num?)?.toDouble(),
        category: map['category'] as String?,
        currency: map['currency'] as String?,
      );
    } catch (e) {
      throw FormatException('Invalid fund data format: $e');
    }
  }

  @override
  Map<String, dynamic> toMap(ResponseFund data) {
    return {
      'id': data.id,
      'name': data.name,
      'minimumAmount': data.minimumAmount,
      'category': data.category,
      'currency': data.currency,
    };
  }

  Fund toDomain(ResponseFund data) => Fund(
    id: data.id ?? 0,
    name: data.name ?? '',
    minimumAmount: data.minimumAmount ?? 0.0,
    category: data.category ?? '',
    currency: data.currency ?? '',
  );
}
