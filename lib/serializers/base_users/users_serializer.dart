import 'package:kite_bird/kite_bird.dart';

class UsersSerializer extends Serializable {
  String email;
  String password;
  String role;

  @override
  Map<String, dynamic> asMap() {
    return {
      'email': email,
      'password': password,
      'role': role
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    email = object['email'].toString();
    password = object['password'].toString();
    role = object['role'].toString();
  }

}