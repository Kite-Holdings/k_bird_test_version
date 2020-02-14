
import 'package:kite_bird/cooprates/models/cooprates_models.dart' show CooprateBankModel, where;
import 'package:kite_bird/cooprates/requests/cooprates_requests_manager.dart';
import 'package:kite_bird/cooprates/serializers/cooprates_serializers.dart' show CooprateBankCreateSerilizer;
import 'package:kite_bird/cooprates/utils/cooprates_utils.dart' show getCooprateCodeById;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CooprateBankController extends ResourceController{
  CooprateBankModel cooprateBankModel = CooprateBankModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.cooperate;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;
  
  @Operation.post()
  Future<Response> create(
    @Bind.body(require: ['accountNumber', 'consumerKey', 'consumerSecret']) 
    CooprateBankCreateSerilizer cooprateBankCreateSerilizer) async{

      // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.createSettings,
      metadata: cooprateBankCreateSerilizer.asMap()
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();


      final String cooprateCode = await getCooprateCodeById(request.authorization.clientID);
      final CooprateBankModel _cooprateBankModel = CooprateBankModel(
        cooprateCode: cooprateCode,
        consumerKey: cooprateBankCreateSerilizer.consumerKey,
        consumerSecret: cooprateBankCreateSerilizer.consumerSecret,
        accountNumber: cooprateBankCreateSerilizer.accountNumber,
      );

      final Map<String, dynamic> _res = await _cooprateBankModel.save();

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
    CooprateBankCreateSerilizer cooprateBankCreateSerilizer) async{

      // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.updateSettings,
      metadata: cooprateBankCreateSerilizer.asMap()
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();


      final String cooprateCode = await getCooprateCodeById(request.authorization.clientID);
      final CooprateBankModel _cooprateBankModel = CooprateBankModel(
        cooprateCode: cooprateCode,
        consumerKey: cooprateBankCreateSerilizer.consumerKey,
        consumerSecret: cooprateBankCreateSerilizer.consumerSecret,
        accountNumber: cooprateBankCreateSerilizer.accountNumber,
      );

      final Map<String, dynamic> _res = await _cooprateBankModel.findAndModify(
        selector: where.eq('cooprateCode', cooprateCode),
        obj: _cooprateBankModel.asMap()
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