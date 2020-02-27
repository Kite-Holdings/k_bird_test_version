import 'package:kite_bird/cooprates/models/cooprates_models.dart' show CooprateMpesaCbModel, where;
import 'package:kite_bird/cooprates/requests/cooprates_requests_manager.dart';
import 'package:kite_bird/cooprates/serializers/cooprates_serializers.dart' show CooprateMpesaCbCreateSerilizer;
import 'package:kite_bird/cooprates/utils/cooprates_utils.dart' show getCooprateCodeById;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CooprateMpesaCbController extends ResourceController{
  CooprateMpesaCbModel cooprateMpesaModel = CooprateMpesaCbModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.cooperate;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;
  
  @Operation.post()
  Future<Response> create(
    @Bind.body(require: ['consumerKey', 'consumerSecret', 'passKey', 'shortCode']) 
    CooprateMpesaCbCreateSerilizer cooprateMpesaCbCreateSerilizer) async{

      // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.createSettings,
      metadata: cooprateMpesaCbCreateSerilizer.asMap()
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();


      final String cooprateCode = await getCooprateCodeById(request.authorization.clientID);
      final CooprateMpesaCbModel _cooprateMpesaModel = CooprateMpesaCbModel(
        cooprateCode: cooprateCode,
        consumerKey: cooprateMpesaCbCreateSerilizer.consumerKey,
        consumerSecret: cooprateMpesaCbCreateSerilizer.consumerSecret,
        passKey: cooprateMpesaCbCreateSerilizer.passKey,
        shortCode: cooprateMpesaCbCreateSerilizer.shortCode,
      );

      final Map<String, dynamic> _res = await _cooprateMpesaModel.save();

      if(_res['status'] != 0){
        if(_res['body']['code'] == 11000){
          _responseStatus = ResponsesStatus.warning;
          _responseBody = {"body": "settings exist"};
        }else{
          _responseStatus = ResponsesStatus.error;
          _responseBody = {"body": "an error occured"};
        }
      } else{
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "Settings saved"};
      }

      // Save response
    final ResponsesModel _responsesModel = ResponsesModel(responseBody: _responseBody, status: _responseStatus, requestId: _requestId, responseType: _responseType);
    await _responsesModel.save();
    return _responsesModel.sendResponse();
      
    }

    @Operation.put()
  Future<Response> update(
    @Bind.body(require: ['consumerKey', 'consumerSecret', 'passKey', 'shortCode']) 
    CooprateMpesaCbCreateSerilizer cooprateMpesaCbCreateSerilizer) async{

      // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.updateSettings,
      metadata: cooprateMpesaCbCreateSerilizer.asMap()
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();


      final String cooprateCode = await getCooprateCodeById(request.authorization.clientID);
      final CooprateMpesaCbModel _cooprateMpesaModel = CooprateMpesaCbModel(
        cooprateCode: cooprateCode,
        consumerKey: cooprateMpesaCbCreateSerilizer.consumerKey,
        consumerSecret: cooprateMpesaCbCreateSerilizer.consumerSecret,
        passKey: cooprateMpesaCbCreateSerilizer.passKey,
        shortCode: cooprateMpesaCbCreateSerilizer.shortCode,
      );

      final Map<String, dynamic> _res = await _cooprateMpesaModel.findAndModify(
        selector: where.eq('cooprateCode', cooprateCode),
        obj: _cooprateMpesaModel.asMap()
      );

      if(_res['status'] != 0){
        if(_res['body']['code'] == 11000){
          _responseStatus = ResponsesStatus.warning;
          _responseBody = {"body": "settings exist"};
        }else{
          _responseStatus = ResponsesStatus.error;
          _responseBody = {"body": "an error occured"};
        }
      } else{
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "Settings updated"};
      }

      // Save response
    final ResponsesModel _responsesModel = ResponsesModel(responseBody: _responseBody, status: _responseStatus, requestId: _requestId, responseType: _responseType);
    await _responsesModel.save();
    return _responsesModel.sendResponse();
      
    }

    
}