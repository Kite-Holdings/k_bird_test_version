import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/model.dart';
export 'package:kite_bird/models/model.dart' show ObjectId;

class ResponsesModel extends Model{

  ResponsesModel({
    this.requestId,
    this.responseType,
    this.responseBody,
    this.status,
  }):super(dbUrl: databaseUrl, collectionName: responsesCollection){
    timeStamp = DateTime.now().toString();
    super.document = asMap();
  }

  String timeStamp;
  String requestId;
  ResposeType responseType;
  ResponsesStatus status;
  dynamic responseBody;

  Map<String, dynamic> asMap(){
    final Map<String, dynamic> _responseBody = {};
    _responseBody['status'] = _stringResponsesModelStatus().code;
    _responseBody['body'] = responseBody == null ? null : responseBody['body'];
    return{
      "timeStamp": timeStamp,
      "requestId": requestId,
      "responseType": _stringReponseType(),
      "responseBody": _responseBody,
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

  Response sendResponse([Map<String, dynamic> ressBody]){
    final _responseBody ={};
    _responseBody['status'] = _stringResponsesModelStatus().code;
    _responseBody['body'] = ressBody != null ? ressBody['body'] : responseBody['body'];
    switch (status) {
      case ResponsesStatus.success:
        return Response.ok(_responseBody);
        break;
      case ResponsesStatus.failed:
        return Response.badRequest(body: _responseBody);
        break;
      case ResponsesStatus.error:
        return Response.serverError(body: _responseBody);
        break;
      case ResponsesStatus.warning:
        return Response.badRequest(body: _responseBody);
        break;
      default:
        return Response.serverError(body: _responseBody);
    }
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
      case ResponsesStatus.error: 
        return ResponsesStatusModel(code: 102, message: 'error');
        break;
      default:
        return ResponsesStatusModel(code: 999, message: 'notDefined');
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
    else if(int.parse(value['statusCode'].toString())== 102)
    {return ResponsesStatus.error;}
    else 
    {return ResponsesStatus.notDefined;}
  }


  String _stringReponseType(){
    switch (responseType) {
      case ResposeType.account:
        return 'account';
        break;
      case ResposeType.bankIft:
        return 'bankIft';
        break;
      case ResposeType.bankMpesa:
        return 'bankMpesa';
        break;
      case ResposeType.bankPesalink:
        return 'bankPesalink';
        break;
      
      case ResposeType.business:
        return 'business';
        break;
      case ResposeType.callBack:
        return 'callBack';
        break;
      case ResposeType.card:
        return 'card';
        break;
      case ResposeType.cooperate:
        return 'cooperate';
        break;
      case ResposeType.baseUser:
        return 'baseUser';
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
      case ResposeType.transactions:
        return 'transactions';
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
      case 'account':
        return ResposeType.account;
        break; 
      case 'bankIft':
        return ResposeType.bankIft;
        break; 
      case 'bankMpesa':
        return ResposeType.bankMpesa;
        break; 
      case 'bankPesalink':
        return ResposeType.bankPesalink;
        break; 
      
      case 'business':
        return ResposeType.business;
        break;
      case 'callBack':
        return ResposeType.callBack;
        break;
      case 'cooperate':
        return ResposeType.cooperate;
        break;
      case 'baseUser':
        return ResposeType.baseUser;
        break;
      case 'mpesaStkPush':
        return ResposeType.mpesaStkPush;
        break;
      case 'stkQuery':
        return ResposeType.stkQuery;
        break;
      case 'transactions':
        return ResposeType.transactions;
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
  account,
  bankIft,
  bankPesalink,
  bankMpesa,
  business,
  callBack,
  cooperate,
  baseUser,
  card,
  mpesaStkPush,
  stkQuery,
  transactions,
  token,
  notDefined
}

enum ResponsesStatus{
  success,
  error,
  information,
  warning,
  failed,
  notDefined
}