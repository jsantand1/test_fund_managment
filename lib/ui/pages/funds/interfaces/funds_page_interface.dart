import 'package:test_fund_managment/domain/entites/error/error_item.dart';
import 'package:test_fund_managment/domain/entites/fund/list_fund.dart';

abstract class FundsPageInterface {
  void showLoadingGetFunds();
  void hideLoadingGetFunds();
  void showErrorGetFunds(ErrorItem errorItem);
  void showSuccessGetFunds(ListFund listFund);
}