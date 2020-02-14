import 'package:kite_bird/kite_bird.dart';

class CooprateCardCreateSerilizer extends Serializable{
  String consumerKey;
  String consumerSecret;
  @override
  Map<String, dynamic> asMap()=> {
    'consumerKey': consumerKey,
    'consumerSecret': consumerSecret,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    consumerKey = object['consumerKey'].toString();
    consumerSecret = object['consumerSecret'].toString();
  }
  
}