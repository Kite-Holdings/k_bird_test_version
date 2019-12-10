import 'package:kite_bird/models/model.dart';

class TransactionModel extends Model{

}

String transactionTypeToString(TransactionType _transactionType){
  switch (_transactionType) {
    case TransactionType.walletTowallet:
      return 'walletTowallet';
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
    default:
      return TransactionType.nonDefined;
  }
}

enum TransactionType{
  walletTowallet,
  nonDefined
}