import 'package:test_fund_managment/domain/usecases/app_usecases.dart';
import 'package:test_fund_managment/ui/pages/funds/interfaces/funds_page_interface.dart';

class FundsPagePresenter {
  final FundsPageInterface _interface;
  final AppUseCases _appUseCases;
  FundsPagePresenter(this._interface, this._appUseCases);

  Future<void> getFunds() async {
    _interface.showLoadingGetFunds();
    final result = await _appUseCases.getFunds();
    result.fold(
      (error) {
        _interface.hideLoadingGetFunds();
        _interface.showErrorGetFunds(error);
      },
      (success) {
        _interface.hideLoadingGetFunds();
        _interface.showSuccessGetFunds(success);
      },
    );
  }
}
