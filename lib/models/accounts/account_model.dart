import 'package:kite_bird/models/model.dart';
import 'package:kite_bird/models/wallet_model.dart';
import 'package:password/password.dart';

class AccountModel extends Model{
  AccountModel({
    this.accountType, 
    this.password, 
    this.phoneNo, 
    this.username, 
    this.cooprateCode,
    }) : super(dbUrl: databaseUrl, collectionName: accountsCollection){
    super.document = asMap();
  }

  final AccountType accountType;
  final String phoneNo;
  final String password;
  final String username;
  final String cooprateCode;
  ObjectId _id;

  

  Map<String, dynamic> asMap(){
    // hash password
    final String _hash = Password.hash(password.toString(), PBKDF2());
    _id = ObjectId();
    return {
      '_id': _id,
      'accountType': _accountTypeToString(),
      'password': _hash,
      'phoneNo': phoneNo,
      'username': username,
      'cooprateCode': cooprateCode,
    };
  }

  AccountModel fromMap(Map<String, dynamic> object){
    return AccountModel(
      accountType: _accountTypeFromString(object['accountType'].toString()),
      password: object['password'].toString(),
      phoneNo: object['phoneNo'].toString(),
      username: object['username'].toString(),
      cooprateCode: object['cooprateCode'].toString(),
    );
  }

  Future<bool> createWallet()async{
    final WalletModel _walletModel = WalletModel(
      cooprateCode: cooprateCode,
      ownerId: _id.toJson(),
      walletNo: phoneNo.substring(4),
      walletType: accountType == AccountType.consumer ? WalletType.consumer : WalletType.merchant
    );
    final Map<String, dynamic> _walletRes = await _walletModel.save();
    if(_walletRes['status'] == 0){
      return true;
    } else{
      return false;
    }
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