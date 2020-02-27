import 'package:kite_bird/models/model.dart';
export 'package:kite_bird/models/model.dart' show where, modify;

class CooprateMpesaBcModel extends Model{
  CooprateMpesaBcModel({
    this.cooprateCode, 
    this.shortCode, 
    this.consumerKey, 
    this.consumerSecret,
    this.initiatorName,
    this.securityCredential,
  }): super(dbUrl: databaseUrl, collectionName: cooprateMpesaBcCollection){

  super.document = asMap();

  }

  final String cooprateCode;
  final String shortCode;
  final String consumerKey;
  final String consumerSecret;
  final String initiatorName;
  final String securityCredential;

  Map<String, dynamic> asMap()=>{
    'cooprateCode': cooprateCode,
    'shortCode': shortCode,
    'consumerKey': consumerKey,
    'consumerSecret': consumerSecret,
    'initiatorName': initiatorName,
    'securityCredential': securityCredential,
  };

  CooprateMpesaBcModel fromMap(dynamic object)=>CooprateMpesaBcModel(
    cooprateCode: object['cooprateCode'].toString(),
    consumerKey: object['consumerKey'].toString(),
    consumerSecret: object['consumerSecret'].toString(),
    initiatorName: object['initiatorName'].toString(),
    shortCode: object['shortCode'].toString(),
    securityCredential: object['securityCredential'].toString(),
  );

  
}