import 'package:kite_bird/models/wallet_model.dart';

class WalletOperations{

  Future deposit({String walletNo, double amount})async{
    final WalletModel _walletModel = WalletModel();
    final Map<String, dynamic> _dbres = await _walletModel.findAndModify(
      selector: where.eq("walletNo", walletNo),
      modifier: modify.inc('balance', amount)
      );
      return _dbres;
  }

  Future withdraw({String walletNo, double amount})async{
    final WalletModel _walletModel = WalletModel();
    final Map<String, dynamic> _dbres = await _walletModel.findAndModify(
      selector: where.eq("walletNo", walletNo).gt("balance", amount),
      modifier: modify.inc('balance', -amount)
      );
      return _dbres;
  }


}