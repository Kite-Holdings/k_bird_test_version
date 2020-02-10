import 'package:kite_bird/models/model.dart';
export 'package:kite_bird/models/model.dart' show ObjectId;

class BusinessModel extends Model{

  BusinessModel({
    this.name, 
    this.cooprateCode,
    this.uid,
    this.state = BusinessState.basic,
  }):super(dbUrl: databaseUrl, collectionName: businessesCollection){
    id = ObjectId();
    super.document = asMap();
  }

  ObjectId id;
  final String name;
  final String cooprateCode;
  final String uid;
  final BusinessState state;

  Map<String, dynamic> asMap()=>{
    "_id": id,
    "name": name,
    "uid": uid,
    "cooprateCode": cooprateCode,
    "state": stringBusinessState(),
  };

  BusinessModel fromMap(Map<String, String> object){
    return BusinessModel(
      name: object['name'],
      uid: object['uid'],
      cooprateCode: object['cooprateCode'],
      state: businessStateFromString(object['state'])
    );
  }


  String stringBusinessState(){
    switch (state) {
      case BusinessState.basic:
        return 'basic';
        break;
      case BusinessState.premium:
        return 'premium';
        break;
      default:
        return 'inactive';
    }
  }

  BusinessState businessStateFromString(String value){
    switch (value) {
      case 'basic':
        return BusinessState.basic;
        break;
      case 'premium':
        return BusinessState.premium;
        break;
      default:
        return BusinessState.inactive;
    }
  }
  
}

enum BusinessState{
  premium,
  basic,
  inactive,
}