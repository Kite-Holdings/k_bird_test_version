import 'package:kite_bird/kite_bird.dart';

class WalletToWalletSerializer extends Serializable{
  double amount;
  String recipientNo;
  @override
  Map<String, dynamic> asMap() {
    return {
      'amount': amount,
      'recipientNo': recipientNo
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    amount = double.parse(object['amount'].toString());
    recipientNo = object['recipientNo'].toString();
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