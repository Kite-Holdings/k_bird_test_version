import 'package:kite_bird/models/model.dart';

class CooprateBankModel extends Model{
  CooprateBankModel({
    this.cooprateCode, 
    this.accountNumber, 
    this.consumerKey, 
    this.consumerSecret,
  }): super(dbUrl: databaseUrl, collectionName: cooprateBankCollection){

  super.document = asMap();

  }

  final String cooprateCode;
  final String accountNumber;
  final String consumerKey;
  final String consumerSecret;

  Map<String, dynamic> asMap()=> {
    'cooprateCode': cooprateCode,
    'accountNumber': accountNumber,
    'consumerKey': consumerKey,
    'consumerSecret': consumerSecret,
  };

  CooprateBankModel fromMap(dynamic object)=> CooprateBankModel(
    cooprateCode: object['cooprateCode'].toString(),
    accountNumber: object['accountNumber'].toString(),
    consumerKey: object['consumerKey'].toString(),
    consumerSecret: object['consumerSecret'].toString(),
  );



}