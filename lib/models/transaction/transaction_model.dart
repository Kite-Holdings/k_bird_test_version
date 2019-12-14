import 'package:kite_bird/models/model.dart';

class TransactionModel extends Model{
  TransactionModel({
    this.amount,
    this.cost,
    this.recipientNo,
    this.senderNo,
    this.transactionType,
    this.state = TransactionState.processing
  }): super(dbUrl: databaseUrl, collectionName: transactionsCollection){
    id = ObjectId();
    total = cost + amount;
    timeStamp = DateTime.now().toString();

    document = asMap();
  }

  ObjectId id;
  final double amount;
  final double cost;
  String timeStamp;
  double total;
  final String senderNo;
  final String recipientNo;
  final TransactionState state;
  final TransactionType transactionType;

  Map<String, dynamic> asMap()=>{
    '_id': id,
    'amount': amount,
    'cost': cost,
    'timeStamp': timeStamp,
    'recipientNo': recipientNo,
    'senderNo': senderNo,
    'state': transactionStateToString(),
    'total': total,
    'transactionType': transactionTypeToString(transactionType)
  };

  TransactionModel fromMap(Map<String, dynamic> object)=> TransactionModel(
    amount: double.parse(object['amount'].toString()),
    cost: double.parse(object['cost'].toString()),
    recipientNo: object['recipientNo'].toString(),
    senderNo: object['senderNo'].toString(),
    transactionType: stringToTransactionType( object['transactionType'].toString()),
  );

  String transactionStateToString(){
    switch (state) {
      case TransactionState.processing:
        return "processing";        
        break;
      case TransactionState.complete:
        return "complete";        
        break;
      case TransactionState.failed:
        return "failed";        
        break;
      case TransactionState.cancled:
        return "cancled";        
        break;
      default:
        return "UnDefiened";
    }
  }

}

String transactionTypeToString(TransactionType _transactionType){
  switch (_transactionType) {
    case TransactionType.walletTowallet:
      return 'walletTowallet';
      break;
    case TransactionType.cardToWallet:
      return 'cardToWallet';
      break;
    case TransactionType.mpesaCb:
      return 'mpesaCb';
      break;
    default:
      return 'nonDefined';
  }
}

TransactionType stringToTransactionType(String _value){
  switch (_value) {
    case 'walletTowallet':
      return TransactionType.walletTowallet;
      break;
    case 'cardToWallet':
      return TransactionType.cardToWallet;
      break;
    case 'mpesaCb':
      return TransactionType.mpesaCb;
      break;
    default:
      return TransactionType.nonDefined;
  }
}


enum TransactionType{
  cardToWallet,
  mpesaCb,
  walletTowallet,
  nonDefined
}


enum TransactionState{
  processing,
  complete,
  failed,
  cancled,
}