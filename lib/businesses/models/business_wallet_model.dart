import 'package:kite_bird/models/model.dart';

class BusinessWalletModel extends Model{

  BusinessWalletModel({
    this.businessId,
    this.shortCode
  }): super(dbUrl: databaseUrl, collectionName: businessWalletsCollection){
    id = ObjectId();
    super.document = asMap();
  }

  ObjectId id;
  final String businessId;
  final String shortCode;
  double balance = 0;

  Map<String, dynamic> asMap()=>{
    "_id": id,
    'balance': balance,
    'businessId': businessId,
    'shortCode': shortCode,
  };

  BusinessWalletModel fromMap(Map<String, dynamic> object){
    return BusinessWalletModel(
      businessId: object['businessId'].toString(),
      shortCode: object['shortCode'].toString(),
    );
  }

}