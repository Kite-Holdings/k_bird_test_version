import 'package:kite_bird/kite_bird.dart';

class CooprateMpesaBcCreateSerilizer extends Serializable{
  String shortCode;
  String consumerKey;
  String initiatorName;
  String consumerSecret;
  String securityCredential;
  @override
  Map<String, dynamic> asMap()=> {
    'consumerKey': consumerKey,
    'consumerSecret': consumerSecret,
    'initiatorName': initiatorName,
    'securityCredential': securityCredential,
    'shortCode': shortCode,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    consumerKey = object['consumerKey'].toString();
    consumerSecret = object['consumerSecret'].toString();
    initiatorName = object['initiatorName'].toString();
    securityCredential = object['securityCredential'].toString();
    shortCode = object['shortCode'].toString();
  }
  
}