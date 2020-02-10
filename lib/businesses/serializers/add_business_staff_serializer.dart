import 'package:kite_bird/kite_bird.dart';

class AddBusinessStaffSerializer extends Serializable{
  String phoneNo;
  String businessCode;
  String role;
  @override
  Map<String, dynamic> asMap() => {
    'phoneNo': phoneNo,
    'businessCode': businessCode,
    'role': role,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    phoneNo= object['phoneNo'].toString();
    businessCode= object['businessCode'].toString();
    role= object['role'].toString();
  }

}