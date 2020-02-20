import 'package:kite_bird/kite_bird.dart';

class AirtellBCSerializer extends Serializable{
  String customerNo;
  String merchantNo;
  double amount;
  String pin;
  @override
  Map<String, dynamic> asMap() {
    return {
      'customerNo': customerNo,
      'merchantNo': merchantNo,
      'amount': amount,
      'pin': pin,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    customerNo = object['customerNo'].toString();
    merchantNo = object['merchantNo'].toString();
    amount = double.parse(object['amount'].toString());
    pin = object['pin'].toString();
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    Iterable<String> _reject;
    try{
      double.parse(object['amount'].toString());
      _reject = reject;
    } catch (e){
      _reject = ['amount'];
    }

    super.read(object, ignore: ignore, reject: _reject, require: require);
  }

}