import 'package:kite_bird/models/model.dart';

class MerchantWalletModel extends Model{
  MerchantWalletModel({
    this.accountId,
    this.shortCode,
    this.companyName,
    }):super(dbUrl: databaseUrl, collectionName: merchantWalletsCollection){
    super.document = asMap();
    }

  final String accountId;
  final String shortCode;
  final String companyName;
  double balance = 0;

  Map<String, dynamic> asMap(){
    return {
      "accountId": accountId,
      "shortCode": shortCode,
      "companyName": companyName,
      "balance": balance,
    };
  }

  MerchantWalletModel fromMap(Map<String, dynamic> object){
    return MerchantWalletModel(
      accountId: object['accountId'].toString(),
      shortCode: object['shortCode'].toString(),
      companyName: object['companyName'].toString(),
    );
  }
}