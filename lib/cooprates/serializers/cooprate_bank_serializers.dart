import 'package:kite_bird/kite_bird.dart';

class CooprateBankCreateSerilizer extends Serializable{
  String accountNumber;
  String consumerKey;
  String consumerSecret;
  @override
  Map<String, dynamic> asMap()=> {
    'consumerKey': consumerKey,
    'consumerSecret': consumerSecret,
    'accountNumber': accountNumber,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    consumerKey = object['consumerKey'].toString();
    consumerSecret = object['consumerSecret'].toString();
    accountNumber = object['accountNumber'].toString();
  }
  
}