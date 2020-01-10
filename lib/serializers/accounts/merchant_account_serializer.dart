import 'package:kite_bird/kite_bird.dart';

class MerchantAccountSerializer extends Serializable{
  String username;
  String companyName;
  String cooprateCode;
  String phoneNo;
  @override
  Map<String, dynamic> asMap()=>{
    'username': username,
    'companyName': companyName,
    'cooprateCode': cooprateCode,
    'phoneNo': phoneNo,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    username = object['username'].toString();
    companyName = object['companyName'].toString();
    cooprateCode = object['cooprateCode'].toString();
    phoneNo = object['phoneNo'].toString();
  }

}