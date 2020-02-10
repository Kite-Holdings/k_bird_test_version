import 'package:kite_bird/kite_bird.dart';

class FlutterwaveCardSerializer extends Serializable{

  String cardNo;
  String cvv;
  String expiryMonth;
  String expiryYear;
  String amount;
  String email;
  String walletNo;
  String callbackUrl;


  @override
  Map<String, dynamic> asMap() {
    return {
      "cardNo": cardNo,
      "cvv": cvv,
      "expiryMonth": expiryMonth,
      "expiryYear": expiryYear,
      "amount": amount,
      "email": email,
      "walletNo": walletNo,
      "callbackUrl": callbackUrl,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    cardNo = object['cardNo'].toString();
    cvv = object['cvv'].toString();
    expiryMonth = object['expiryMonth'].toString();
    expiryYear = object['expiryYear'].toString();
    amount = object['amount'].toString();
    email = object['email'].toString();
    walletNo = object['walletNo'].toString();
    callbackUrl = object['callbackUrl'].toString();
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    Iterable<String> _reject;
    try {
      double.parse(object['amount'].toString());
      _reject = reject;
      if(double.parse(object['amount'].toString()) < 0){
        _reject = ['amount'];
      }
    } catch (e) {
      _reject = ['amount'];
    }
    super.read(object, ignore: ignore, reject: _reject, require: require);
  }

}