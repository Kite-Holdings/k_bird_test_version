
import 'package:kite_bird/models/model.dart';

class TransactionResult extends Model{

  TransactionResult({
    this.resultStatus,
    this.reqRef,
    this.transactionId,
    this.channel,
    this.paymentRef,
    this.receiptRef,
    this.amount,
    this.charges,
    this.receiverParty,
    this.senderAccount,
    this.receiptNo,
    this.completeDateTime,
    this.currentBalance,
    this.availableBalance,
  }): super(dbUrl: databaseUrl, collectionName: transactionResultCollection){
    resRef = ObjectId().toJson();
    document = asMap();
  }

  final TransactionResultStatus resultStatus;
  final String reqRef;
  String resRef;
  final String transactionId;
  final TransactionChannel channel;
  final String paymentRef;
  final String receiptRef;
  final String amount;
  final String charges;
  final String receiverParty;
  final String senderAccount;
  final String receiptNo;
  final String completeDateTime;
  final String currentBalance;
  final String availableBalance;

  Map<String, String> asMap(){
    return{
      "resultStatus": transactionResultStatusToString(),
      "reqRef": reqRef,
      "resRef": resRef,
      "transactionId": transactionId,
      "channel": transactionChannelToString(),
      "paymentRef": paymentRef,
      "receiptRef": receiptRef,
      "amount": amount,
      "charges": charges,
      "receiverParty": receiverParty,
      "senderAccount": senderAccount,
      "receiptNo": receiptNo,
      "completeDateTime": completeDateTime,
      "currentBalance": currentBalance,
      "availableBalance": availableBalance,
    };
  }
  String transactionChannelToString(){
    switch (channel) {
      case TransactionChannel.card:
        return 'card';
        break;
      case TransactionChannel.kiteBird:
        return 'kiteBird';
        break;
      case TransactionChannel.mpesa:
        return 'mpesa';
        break;
      default:
        return 'nonDefined';
    }
  }
  String transactionResultStatusToString(){
    switch (resultStatus) {
      case TransactionResultStatus.cancled:
        return 'cancled';
        break;
      case TransactionResultStatus.complete:
        return 'complete';
        break;
      case TransactionResultStatus.failed:
        return 'failed';
        break;
      default:
        return 'nonDefined';
    }
  }
}

enum TransactionChannel{
  card,
  kiteBird,
  mpesa,
  nonDefined
}

enum TransactionResultStatus{
  cancled,
  complete,
  failed,
  nonDefined
}