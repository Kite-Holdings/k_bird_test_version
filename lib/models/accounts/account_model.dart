import 'package:kite_bird/models/model.dart';
import 'package:password/password.dart';

class AccountModel extends Model{
  AccountModel({this.accountType, this.password, this.phoneNo, this.username}) : super(dbUrl: databaseUrl, collectionName: accountsCollection){
    super.document = asMap();
  }

  final AccountType accountType;
  final String phoneNo;
  final String password;
  final String username;

  

  Map<String, dynamic> asMap(){
    // hash password
    final String _hash = Password.hash(password.toString(), PBKDF2());
    return {
      'accountType': _accountTypeToString(),
      'password': _hash,
      'phoneNo': phoneNo,
      'username': username
    };
  }

  AccountModel fromMao(Map<String, dynamic> object){
    return AccountModel(
      accountType: _accountTypeFromString(object['accountType'].toString()),
      password: object['password'].toString(),
      phoneNo: object['phoneNo'].toString(),
      username: object['username'].toString(),
    );
  }



  String _accountTypeToString(){
    switch (accountType) {
      case AccountType.consumer:
        return 'consumer';
        break;
      case AccountType.merchant:
        return 'merchant';
        break;
      default:
        return 'undefined';
    }
  }

  AccountType _accountTypeFromString(String value){
    switch (value) {
      case 'consumer':
        return AccountType.consumer;
        break;
      case 'merchant':
        return AccountType.merchant;
        break;
      default:
        return AccountType.undefined;
    }
  }

  bool verifyPassword(String password, String hash){
    return Password.verify(password, hash);
  }
}

enum AccountType{
  consumer,
  merchant,
  undefined
}