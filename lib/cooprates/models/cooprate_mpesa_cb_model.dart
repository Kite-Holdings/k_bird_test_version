import 'package:kite_bird/models/model.dart';
export 'package:kite_bird/models/model.dart' show where, modify;

class CooprateMpesaCbModel extends Model{
  CooprateMpesaCbModel({
    this.cooprateCode, 
    this.shortCode, 
    this.consumerKey, 
    this.consumerSecret, 
    this.passKey,
  }): super(dbUrl: databaseUrl, collectionName: cooprateMpesaCbCollection){

  super.document = asMap();

  }

  final String cooprateCode;
  final String shortCode;
  final String consumerKey;
  final String consumerSecret;
  final String passKey;

  Map<String, dynamic> asMap()=>{
    'cooprateCode': cooprateCode,
    'shortCode': shortCode,
    'consumerKey': consumerKey,
    'consumerSecret': consumerSecret,
    'passKey': passKey,
  };

  CooprateMpesaCbModel fromMap(dynamic object)=>CooprateMpesaCbModel(
    cooprateCode: object['cooprateCode'].toString(),
    consumerKey: object['consumerKey'].toString(),
    consumerSecret: object['consumerSecret'].toString(),
    passKey: object['passKey'].toString(),
    shortCode: object['shortCode'].toString(),
  );

  
}