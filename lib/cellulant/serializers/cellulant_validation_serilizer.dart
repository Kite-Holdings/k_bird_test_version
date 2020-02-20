import 'package:kite_bird/kite_bird.dart';

class CellulantValidationSerializer extends Serializable{
  String accountNumber;
  int serviceID;
  @override
  Map<String, dynamic> asMap()=> {
    'accountNumber': accountNumber,
    'serviceID': serviceID,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    accountNumber = object['accountNumber'].toString();
    serviceID = int.parse(object['serviceID'].toString());
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    Iterable<String> _reject;
    try {
      int.parse(object['serviceID'].toString());
      _reject = reject;
    } catch (e) {
      _reject = ['serviceID'];
    }


    super.read(object, ignore: ignore, reject: _reject, require: require);
  }

}