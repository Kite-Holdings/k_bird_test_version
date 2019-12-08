import 'package:kite_bird/kite_bird.dart';

class AccountSerializer extends Serializable{
  String username;
  String passord;
  @override
  Map<String, dynamic> asMap()=>{
    'username': username,
    'passord': passord
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    username = object['username'].toString();
    passord = object['passord'].toString();
  }

}