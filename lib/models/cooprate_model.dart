import 'package:kite_bird/models/model.dart';
import 'package:kite_bird/models/utils/increment_counter.dart';
import 'package:kite_bird/utils/stringify_int.dart';
import 'package:random_string/random_string.dart';
export 'package:kite_bird/models/model.dart' show where, modify, ObjectId;

class CooprateModel extends Model{
  CooprateModel({
    this.name,
    this.code,
    this.consumerKey,
    this.secretKey,
  }) : super(dbUrl: databaseUrl, collectionName: cooprateCollection){

  super.document = asMap();

  }

  final String name;
  String code;
  String consumerKey;
  String secretKey;
  DateTime dateCreated;

  Map<String, dynamic> asMap(){
    return {
      'name': name,
      'code': code,
      'consumerKey': consumerKey,
      'secretKey': secretKey,
      'dateCreated': dateCreated.toString(),
    };
  }

  CooprateModel fromMap(Map<String, dynamic> obj){
    return CooprateModel(name: obj['name'].toString());
  }

  Future init()async{
    final int count = await databaseCounter ('companyCounter');
    code = code == null ? stringifyCount(count, 3) : code;
    secretKey = secretKey == null ? randomAlphaNumeric(10) : secretKey;
    consumerKey = consumerKey == null ? name+code : consumerKey;
    dateCreated = DateTime.now();

    super.document = asMap();
  }


}