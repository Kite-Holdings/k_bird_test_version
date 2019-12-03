import 'package:kite_bird/models/model.dart';
export 'package:kite_bird/models/model.dart' show ObjectId;

class ResponsesModel extends Model{

  ResponsesModel({
    this.requestId,
    this.responseType,
    this.responseBody,
    this.status,
  }):super(dbUrl: databaseUrl, collectionName: responsesCollection){
    super.document = asMap();
  }

  final String requestId;
  final ResposeType responseType;
  final ResponsesStatus status;
  final dynamic responseBody;

  Map<String, dynamic> asMap(){
    return{
      "requestId": requestId,
      "responseType": _stringReponseType(),
      "responseBody": responseBody,
      "status": {
        "statusCode": _stringResponsesModelStatus().code,
        "statusMessage": _stringResponsesModelStatus().message,
      }
    };
  }

  ResponsesModel fromMap(Map<String, dynamic> object){
    return ResponsesModel(
      requestId: object['requestId'].toString(),
      responseType: _toResponseType(object['responseType'].toString()),
      responseBody: object['responseBody'],
      status: _toResponseState(object['status']),
    );
  }


  ResponsesStatusModel _stringResponsesModelStatus(){
    switch (status) {
      case ResponsesStatus.success: 
        return ResponsesStatusModel(code: 0, message: 'success');
        break;
      case ResponsesStatus.information: 
        return ResponsesStatusModel(code: 1, message: 'information');
        break;
      case ResponsesStatus.warning: 
        return ResponsesStatusModel(code: 2, message: 'warning');
        break;
      case ResponsesStatus.failed: 
        return ResponsesStatusModel(code: 101, message: 'failed');
        break;
      default:
        return ResponsesStatusModel(code: 102, message: 'notDefined');
    }
  }

  ResponsesStatus _toResponseState(dynamic value){
    if(int.parse(value['statusCode'].toString())== 0)
    {return ResponsesStatus.success;}
    else if(int.parse(value['statusCode'].toString())== 1)
    {return ResponsesStatus.information;}
    else if(int.parse(value['statusCode'].toString())== 2)
    {return ResponsesStatus.warning;}
    else if(int.parse(value['statusCode'].toString())== 101)
    {return ResponsesStatus.failed;}
    else 
    {return ResponsesStatus.notDefined;}
  }


  String _stringReponseType(){
    switch (responseType) {
      case ResposeType.callBack:
        return 'callBack';
        break;
      case ResposeType.card:
        return 'card';
        break;
      case ResposeType.mpesaStkPush:
        return 'mpesaStkPush';
        break;
      case ResposeType.stkQuery:
        return 'stkQuery';
        break;
      case ResposeType.token:
        return 'token';
        break;
      default:
        return 'notDefined';
    }
  }

  ResposeType _toResponseType(String value){
    switch (value) {
      case 'card':
        return ResposeType.card;
        break;
      case 'callBack':
        return ResposeType.callBack;
        break;
      case 'mpesaStkPush':
        return ResposeType.mpesaStkPush;
        break;
      case 'stkQuery':
        return ResposeType.stkQuery;
        break;
      case 'token':
        return ResposeType.token;
        break;
      default:
        return ResposeType.notDefined;
    }
  }
}

class ResponsesStatusModel{
  ResponsesStatusModel({this.code, this.message});
  final int code;
  final String message;
}

enum ResposeType{
  callBack,
  card,
  mpesaStkPush,
  stkQuery,
  token,
  notDefined
}

enum ResponsesStatus{
  success,
  information,
  warning,
  failed,
  notDefined
}