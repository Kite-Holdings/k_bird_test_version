import 'package:kite_bird/accounts/models/accounts_models.dart';
import 'package:kite_bird/jarvis/modules/jarvis_modules.dart' show jarvisSendSms;
import 'package:kite_bird/transactions/models/transactions_models.dart' show TransactionType;
import 'package:kite_bird/wallets/models/wallet_model.dart';
import 'package:kite_bird/wallets/models/wallet_activities_model.dart';

class WalletOperations{
  WalletOperations({
    this.amount,
    this.recipient,
    this.sender,
    this.transactionType = TransactionType.walletTowallet
  });

  final String recipient;
  final String sender;
  final double amount;
  final TransactionType transactionType;

  Future<bool> deposit()async{
    bool _successful = false;
    final WalletModel _walletModel = WalletModel();
    final Map<String, dynamic> _dbres = await _walletModel.findAndModify(
      selector: where.eq("walletNo", recipient),
      modifier: modify.inc('balance', amount)
      );
    if(_dbres['status'] == 0){
      if(_dbres['body'] != null){
        final double _balance = double.parse(_dbres['body']['balance'].toString());
        final WalletActivitiesModel _walletActivities = WalletActivitiesModel(
          amount: amount,
          balance: _balance,
          operation: WalletOperationType.recieve,
          secondPartNo: sender,
          transactionType: transactionType,
          walletNo: recipient
        );
        await _walletActivities.save();
        _successful = true;

        // Send sms
        final Map<String, dynamic> _walletRes = await _walletModel.findOneBy(
          where.eq('walletNo', recipient),
          fields: ['ownerId']
        );
        final AccountModel _accountModel = AccountModel();
        Map<String, dynamic> _accountRes;
        String _phoneNo;
        try {
          _accountRes = await _accountModel.findById(_walletRes['body']['ownerId'].toString(), fields: ['phoneNo']);
        } catch (e) {
          print(e);
        }
        if(_accountRes != null){
          if(_accountRes['status'] == 0){
            if(_accountRes['body'] != null){
              _phoneNo = _accountRes['body']['phoneNo'].toString();
              await jarvisSendSms(
                phoneNo: _phoneNo,
                body: "You have received Ksh.$amount from ${transactipTypeToMessage(transactionType)} $sender."
              );
            }
          }
        }
        

      } else{
        _successful = false;
      }
    }

    return _successful;
  }

  Future<bool> withdraw()async{
    bool _successful = false;
    final WalletModel _walletModel = WalletModel();
    final Map<String, dynamic> _dbres = await _walletModel.findAndModify(
      selector: where.eq("walletNo", sender).gt("balance", amount),
      modifier: modify.inc('balance', -amount)
      );
    if(_dbres['status'] == 0){
      if(_dbres['body'] != null){
        final double _balance = double.parse(_dbres['body']['balance'].toString());
        final WalletActivitiesModel _walletActivities = WalletActivitiesModel(
          amount: amount,
          balance: _balance,
          operation: WalletOperationType.send,
          secondPartNo: recipient,
          transactionType: TransactionType.walletTowallet,
          walletNo: sender
        );
        await _walletActivities.save();
        _successful = true;
      } else {
        _successful = false;
      }
    }

    return _successful;
    // return _dbres;
  }


}

enum WalletOperationType{
  send,
  recieve,
  nonDefined
}