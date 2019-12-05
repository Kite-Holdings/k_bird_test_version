import 'package:kite_bird/kite_bird.dart';

class PhoneNoVerificationSerializer extends Serializable {
  String phoneNo;

  @override
  Map<String, dynamic> asMap() {
    return {
      'phoneNo': phoneNo,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    phoneNo = object['phoneNo'].toString();
  }

}