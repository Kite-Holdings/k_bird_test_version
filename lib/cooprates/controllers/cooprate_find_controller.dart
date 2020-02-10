import 'package:kite_bird/cooprates/models/cooprates_models.dart';
import 'package:kite_bird/cooprates/requests/cooprates_requests_manager.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CooprateFindByController extends ResourceController{
  CooprateModel cooprateModel = CooprateModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;


  @Operation.get('cooprateName')
  Future<Response> getByNameSelector(@Bind.path("cooprateName") String cooprateName)async{
    String _name;
    final Map<String, dynamic> _dbResUser = await cooprateModel.findById(request.authorization.clientID, fields: ['name']);
    if(_dbResUser['status'] == 0){
      _name  = _dbResUser['body']['name'].toString();
    }
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: _name,
      cooperateRequestsType: CooperateRequestsType.getByName,
      metadata: {
        "cooperateId": cooprateName
      }
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();


    final Map<String, dynamic> _dbRes = await cooprateModel.findBySelector(where.eq('name', cooprateName));
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = _dbRes;
      } else {
        _responseStatus = ResponsesStatus.failed;
        _responseBody = {"body": "invalid id"};
      }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse();
  }
  @Operation.get('cooprateCode')
  Future<Response> getByCodeSelector(@Bind.path("cooprateCode") String cooprateCode)async{
    String _name;
    final Map<String, dynamic> _dbResUser = await cooprateModel.findById(request.authorization.clientID, fields: ['name']);
    if(_dbResUser['status'] == 0){
      _name  = _dbResUser['body']['name'].toString();
    }
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: _name,
      cooperateRequestsType: CooperateRequestsType.getByCooprateCode,
      metadata: {
        "cooprateCode": cooprateCode
      }
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();


    final Map<String, dynamic> _dbRes = await cooprateModel.findBySelector(where.eq('code', cooprateCode));
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = _dbRes;
      } else {
        _responseStatus = ResponsesStatus.failed;
        _responseBody = {"body": "invalid id"};
      }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse();
  }
}