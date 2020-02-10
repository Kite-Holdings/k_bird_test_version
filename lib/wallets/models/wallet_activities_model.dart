import 'package:kite_bird/models/model.dart';
import 'package:kite_bird/transactions/models/transactions_models.dart' show
        TransactionType, transactionTypeToString, stringToTransactionType;
import 'package:kite_bird/wallets/modules/wallet_operations.dart' show WalletOperationType;



class WalletActivitiesModel extends Model{
  WalletActivitiesModel({
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

  WalletActivitiesModel fromMap(Map<String, dynamic> object)=> WalletActivitiesModel(
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

String transactipTypeToMessage(TransactionType __transactionType){
  switch (__transactionType) {
    case TransactionType.walletTowallet:
      return 'Kite Holdings account';
      break;
    case TransactionType.mpesaCb:
      return 'Mpesa account';
      break;
    case TransactionType.cardToWallet:
      return 'Card';
      break;
    default:
    return 'Account';
  }
}

