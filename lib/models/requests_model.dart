import 'package:kite_bird/models/model.dart';
export 'package:kite_bird/models/model.dart' show ObjectId;

class RequestsModel extends Model{

  RequestsModel({
    this.id,
    this.url,
    this.requestType,
    this.account,
    this.metadata,
  }):super(dbUrl: databaseUrl, collectionName: requestsCollection){
    super.document = asMap();
  }

  final String url;
  final ObjectId id;
  final RequestType requestType;
  final String account;
  final dynamic metadata;



  Map<String, dynamic> asMap(){
    return{
      "_id": id,
      "url": url,
      "requestType": _stringRequestType,
      "account": account,
      "metadata": metadata,
    };
  }

  RequestsModel fromMap(Map<String, dynamic> object){
    return RequestsModel(
      url: object['url'].toString(),
      account: object['account'].toString(),
      requestType: _toRequestType(object['metadata'].toString()),
      metadata: object['metadata'],
    );
  }

  String _stringRequestType(){
    switch (requestType) {
      case RequestType.card:
        return 'card';
        break;
      case RequestType.mpesaStkPush:
        return 'mpesaStkPush';
        break;
      case RequestType.token:
        return 'token';
        break;
      case RequestType.baseUser:
        return 'baseUser';
        break;
      default:
        return 'notDefined';
    }
  }

  RequestType _toRequestType(String value){
    switch (value) {
      case 'card':
        return RequestType.card;
        break;
      case 'mpesaStkPush':
        return RequestType.mpesaStkPush;
        break;
      case 'token':
        return RequestType.token;
        break;
      case 'baseUser':
        return RequestType.baseUser;
        break;
      default:
        return RequestType.notDefined;
    }
  }
}

enum RequestType{
  card,
  mpesaStkPush,
  notDefined,
  token,
  baseUser
}
