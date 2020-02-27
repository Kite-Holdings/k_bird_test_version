import 'package:kite_bird/kite_bird.dart';

class CooprateMpesaCbCreateSerilizer extends Serializable{
  String shortCode;
  String consumerKey;
  String consumerSecret;
  String passKey;
  @override
  Map<String, dynamic> asMap()=> {
    'consumerKey': consumerKey,
    'consumerSecret': consumerSecret,
    'passKey': passKey,
    'shortCode': shortCode,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    consumerKey = object['consumerKey'].toString();
    consumerSecret = object['consumerSecret'].toString();
    passKey = object['passKey'].toString();
    shortCode = object['shortCode'].toString();
  }
  
}