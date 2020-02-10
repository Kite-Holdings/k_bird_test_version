import 'package:kite_bird/models/model.dart';
export 'package:kite_bird/models/model.dart' show ObjectId;

class RequestsModel extends Model{

  RequestsModel({
    this.id,
    this.url,
    this.requestType,
    this.account,
    this.metadata,
    this.requestMethod = RequestMethod.getmethod
  }):super(dbUrl: databaseUrl, collectionName: requestsCollection){
    timeStamp = DateTime.now().toString();
    super.document = asMap();
  }

  String timeStamp;
  final String url;
  final ObjectId id;
  final RequestType requestType;
  final String account;
  final dynamic metadata;
  final RequestMethod requestMethod;



  Map<String, dynamic> asMap(){
    return {
      "_id": id,
      "timeStamp": timeStamp,
      "url": url,
      "requestType": _stringRequestType(),
      "requestMethod": _stringRequestMethod(),
      "account": account,
      "metadata": metadata,
    };
  }

  RequestsModel fromMap(Map<String, dynamic> object){
    return RequestsModel(
      url: object['url'].toString(),
      account: object['account'].toString(),
      requestType: _toRequestType(object['requestType'].toString()),
      requestMethod: _toRequestMethod(object['requestMethod'].toString()),
      metadata: object['metadata'],
    );
  }

  String _stringRequestType(){
    switch (requestType) {
      case RequestType.card:
        return 'card';
        break;
      case RequestType.account:
        return 'account';
        break;
      case RequestType.cooperate:
        return 'cooperate';
        break;
      case RequestType.mpesaStkPush:
        return 'mpesaStkPush';
        break;
      case RequestType.token:
        return 'token';
        break;
      case RequestType.wallet:
        return 'wallet';
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
      case 'account':
        return RequestType.account;
        break;
      case 'cooperate':
        return RequestType.cooperate;
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
      case 'wallet':
        return RequestType.wallet;
        break;
      default:
        return RequestType.notDefined;
    }
  }

  String _stringRequestMethod(){
    switch (requestMethod) {
      case RequestMethod.getmethod:
        return 'GET';
        break;
      case RequestMethod.postMethod:
        return 'POST';
        break;
      case RequestMethod.putMethod:
        return 'PUT';
        break;
      case RequestMethod.deleteMethod:
        return 'DELETE';
        break;
      default:
        return 'notDefined';
    }
  }

  RequestMethod _toRequestMethod(String value){
    switch (value) {
      case 'DELETE':
        return RequestMethod.deleteMethod;
        break;
      case 'GET':
        return RequestMethod.getmethod;
        break;
      case 'POST':
        return RequestMethod.postMethod;
        break;
      case 'PUT':
        return RequestMethod.putMethod;
        break;
      default:
        return RequestMethod.notDefined;
    }
  }

}

enum RequestType{
  account,
  business,
  card,
  cooperate,
  mpesaStkPush,
  notDefined,
  token,
  baseUser,
  wallet
}

enum RequestMethod{
  getmethod,
  postMethod,
  deleteMethod,
  putMethod,
  notDefined
}
