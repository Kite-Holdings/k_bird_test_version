import 'package:kite_bird/models/model.dart';

class WalletModel extends Model{
  WalletModel({
    this.ownerId,
    this.cooprateCode,
    this.walletNo,
    this.walletType
  }):super(dbUrl: databaseUrl, collectionName: walletsCollection){
    super.document = asMap();
  }


  final WalletType walletType;
  final String ownerId;
  final String cooprateCode;
  final String walletNo;
  double balance = 0;

  Map<String, dynamic> asMap(){
    final String _walletNo = cooprateCode + 
    (walletType == WalletType.consumer ? '0' : '1') +
    walletNo;

    return {
      'balance': balance,
      'cooprateCode': cooprateCode,
      'ownerId': ownerId,
      'walletNo': _walletNo,
      'walletType': _stringWalletType(),
    };

  }

  WalletModel fromMap(Map<String, dynamic> object){
    return WalletModel(
      cooprateCode: object['cooprateCode'].toString(),
      ownerId: object['ownerId'].toString(),
      walletNo: object['walletNo'].toString(),
      walletType: _walletTypeFromString(object['walletType'].toString()),
    );
  }

  String _stringWalletType(){
    switch (walletType) {
      case WalletType.consumer:
        return 'consumer';
        break;
      case WalletType.cooprate:
        return 'cooprate';
        break;
      case WalletType.merchant:
        return 'merchant';
        break;
      default:
        return 'notDefined';
    }
  }

  WalletType _walletTypeFromString(String value){
    switch (value) {
      case 'consumer':
        return WalletType.consumer;
        break;
      case 'cooprate':
        return WalletType.cooprate;
        break;
      case 'merchant':
        return WalletType.merchant;
        break;
      default:
        return WalletType.notDefined;
    }
  }


}

enum WalletType{
  cooprate,
  consumer,
  merchant,
  notDefined
}