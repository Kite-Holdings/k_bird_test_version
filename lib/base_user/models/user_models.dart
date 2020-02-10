import 'package:kite_bird/models/model.dart';
import 'package:password/password.dart';
export 'package:kite_bird/models/model.dart' show where, modify, ObjectId;

class UserModel extends Model{

  UserModel({
    this.email,
    this.password,
    this.role
  }):super(dbUrl: databaseUrl, collectionName: baseUserCollection){
    super.document = asMap();
  }

  final String email;
  final String password;
  final UserRole role;

  

  String get userRoleToString => _userRoleToString();

  Map<String, dynamic> asMap (){
    return {
      'email': email,
      'password': Password.hash(password != null ? password : '', PBKDF2()),
      'role': userRoleToString
    };
  }

  UserModel fromMap (Map object) => UserModel(
    email: object['email'].toString(),
    password: object['password'].toString(),
    role: userRoleFromString(object['role'].toString()),
  );

  bool verifyPassword(String password, String hash){
    return Password.verify(password, hash);
  }

  String _userRoleToString(){
    switch (role) {
      case UserRole.admin:
        return 'admin';
        break;
      case UserRole.moderator:
        return 'moderator';
        break;
      case UserRole.normal:
        return 'normal';
        break;
      case UserRole.guest:
        return 'guest';
        break;
      case UserRole.anonymous:
        return 'anonymous';
        break;
      default:
        return 'anonymous';
    }
  }

  UserRole userRoleFromString(String value){
    switch (value) {
      case 'admin':
        return UserRole.admin;
        break;
      case 'moderator':
        return UserRole.moderator;
        break;
      case 'normal':
        return UserRole.normal;
        break;
      case 'guest':
        return UserRole.guest;
        break;
      case 'anonymous':
        return UserRole.anonymous;
        break;
      default:
        return UserRole.anonymous;
    }
  }
}

enum UserRole{
  admin,
  moderator,
  normal,
  guest,
  anonymous,
}