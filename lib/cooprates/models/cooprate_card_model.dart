import 'package:kite_bird/models/model.dart';

class CooprateCardModel extends Model{
  CooprateCardModel({
    this.cooprateCode, 
    this.consumerKey, 
    this.consumerSecret,
  }): super(dbUrl: databaseUrl, collectionName: cooprateCardCollection){

  super.document = asMap();

  }

  final String cooprateCode;
  final String consumerKey;
  final String consumerSecret;

  Map<String, dynamic> asMap()=> {
    'cooprateCode': cooprateCode,
    'consumerKey': consumerKey,
    'consumerSecret': consumerSecret,
  };

  CooprateCardModel fromMap(dynamic object)=> CooprateCardModel(
    cooprateCode: object['cooprateCode'].toString(),
    consumerKey: object['consumerKey'].toString(),
    consumerSecret: object['consumerSecret'].toString(),
  );
}