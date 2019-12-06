import 'package:kite_bird/models/model.dart';
export 'package:kite_bird/models/model.dart' show where;

class RegisterAccountVerificationModel extends Model{
  RegisterAccountVerificationModel({this.phoneNo, this.otp}) : super(dbUrl: databaseUrl, collectionName: registerPhoneverifivationCollection){
    super.document = asMap();
  }
  String phoneNo;
  int otp;
  int expireTime = (DateTime.now().millisecondsSinceEpoch/1000 + 3000).floor();


  Map<String, dynamic> asMap() {
    return {
      'phoneNo': phoneNo,
      'otp': otp,
      'expireTime': expireTime
    };
  }


  void readFromMap(Map<String, dynamic> object) {
    phoneNo = object['phoneNo'].toString();
    otp = int.parse(object['otp'].toString());
  }

  
}