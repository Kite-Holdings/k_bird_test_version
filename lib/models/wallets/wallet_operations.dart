import 'package:kite_bird/models/model.dart';
import 'package:kite_bird/models/transaction/transaction_model.dart' show TransactionType, transactionTypeToString, stringToTransactionType;
import 'package:kite_bird/models/wallets/wallet_model.dart';

export 'package:kite_bird/models/transaction/transaction_model.dart' show TransactionType;

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
        final WalletActivities _walletActivities = WalletActivities(
          amount: amount,
          balance: _balance,
          operation: WalletOperationType.recieve,
          secondPartNo: sender,
          transactionType: transactionType,
          walletNo: recipient
        );
        await _walletActivities.save();
        _successful = true;
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
        final WalletActivities _walletActivities = WalletActivities(
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

class WalletActivities extends Model{
  WalletActivities({
    this.amount,
    this.balance,
    this.operation,
    this.secondPartNo,
    this.transactionType,
    this.walletNo
  }): super(dbUrl: databaseUrl, collectionName: walletsActivitiesCollection){
    timeStamp = DateTime.now().toString();
    super.document = asMap();
  }

  final String walletNo;
  final String secondPartNo;
  final TransactionType transactionType;
  final WalletOperationType operation;
  final double amount;
  final double balance;
  String timeStamp;

  Map<String, dynamic> asMap()=>{
    'amount': amount,
    'balance': balance,
    'operation': _walletOperationTypeToString(),
    'timeStamp': timeStamp,
    'transactionType': transactionTypeToString(transactionType),
    'secondPartNo': secondPartNo,
    'walletNo': walletNo,
  };

  WalletActivities fromMap(Map<String, dynamic> object)=> WalletActivities(
    amount: double.parse(object['amount'].toString()),
    balance: double.parse(object['balance'].toString()),
    operation: _walletOperationTypeFromString(object['operation'].toString()),
    secondPartNo: object['secondPartNo'].toString(),
    transactionType: stringToTransactionType(object['transactionType'].toString()),
    walletNo: object['walletNo'].toString(),
  );




  String _walletOperationTypeToString(){
    switch (operation) {
      case WalletOperationType.recieve:
        return 'receive';
        break;
      case WalletOperationType.send:
        return 'send';
        break;
      default:
      return 'nonDefined';
    }
  }

  WalletOperationType _walletOperationTypeFromString(String value){
    switch (value) {
      case 'receive':
        return WalletOperationType.recieve;
        break;
      case 'send':
        return WalletOperationType.send;
        break;
      default:
        return WalletOperationType.nonDefined;
    }
  }


}

enum WalletOperationType{
  send,
  recieve,
  nonDefined
}