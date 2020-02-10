import 'package:kite_bird/kite_bird.dart';

class AccountSerializer extends Serializable{
  String username;
  String password;
  @override
  Map<String, dynamic> asMap()=>{
    'username': username,
    'password': password
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    username = object['username'].toString();
    password = object['password'].toString();
  }

}