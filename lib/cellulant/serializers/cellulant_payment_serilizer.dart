import 'package:kite_bird/kite_bird.dart';

class CellulantPaymentSerializer extends Serializable{
  String accountNumber;
  String phoneNo;
  String amount;
  int serviceID;
  
  @override
  Map<String, dynamic> asMap()=> {
    'phoneNo': phoneNo,
    'accountNumber': accountNumber,
    'serviceID': serviceID,
    'amount': amount,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    amount = object['amount'].toString();
    phoneNo = object['phoneNo'].toString();
    accountNumber = object['accountNumber'].toString();
    serviceID = int.parse(object['serviceID'].toString());
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    Iterable<String> _reject;
    try {
      int.parse(object['serviceID'].toString());
      _reject = reject;
      final String _phoneNo = object['phoneNo'].toString();
      final RegExp _allAreNumbers = RegExp(r'(^[0-9]{12}$)');
      if(!_allAreNumbers.hasMatch(_phoneNo)){
        _reject = ['phoneNo'];
      }
    } catch (e) {
      _reject = ['serviceID'];
    }


    super.read(object, ignore: ignore, reject: _reject, require: require);
  }

}