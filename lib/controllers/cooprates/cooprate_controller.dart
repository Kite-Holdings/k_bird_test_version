import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/cooprate_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/requests_managers/cooperate_request.dart';
import 'package:kite_bird/serializers/cooprate/cooprate_serializer.dart';
import 'package:pedantic/pedantic.dart';

class CooprateController extends ResourceController{
  CooprateModel cooprateModel = CooprateModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;


  @Operation.get()
  Future<Response> getAll()async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.getAll,
      metadata: null
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();

    final Map<String, dynamic> _dbRes = await cooprateModel.find();
    if(_dbRes['status'] == 0){
      _responseStatus = ResponsesStatus.success;
      _responseBodyModel = _dbRes['status'] == 0 ? _dbRes['body'].length : _dbRes['body'];
      _responseBody= _dbRes;
    } else{
      _responseStatus = ResponsesStatus.failed;
      _responseBody= {"status": 1, "body": "an error occured"};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse(_responseBody);
  }

  @Operation.get('cooperateId')
  Future<Response> getOne(@Bind.path("cooperateId") String cooperateId)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.getByid,
      metadata: {
        "cooperateId": cooperateId
      }
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();


    final Map<String, dynamic> _dbRes = await cooprateModel.findById(cooperateId);
    if(_dbRes['status'] == 0){
      _responseStatus = ResponsesStatus.success;
      _responseBody= _dbRes;
    } else {
      _responseStatus = ResponsesStatus.failed;
      _responseBody= {"status": 1, "body": "an error occured"};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse();
  }

  @Operation.post()
  Future<Response> registerCompany(@Bind.body(require: ['name']) CoopratesSerializer coopratesSerializer)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.create,
      metadata: coopratesSerializer.asMap()
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();


    final CooprateModel _cooprateModel = CooprateModel(name: coopratesSerializer.name);
    await _cooprateModel.init();
    final Map<String, dynamic> _dbRes = await _cooprateModel.save();
    if(_dbRes['status'] == 0){
      _responseStatus = ResponsesStatus.success;
      _responseBody = {'status': 0, 'body': "Cooprate saved."};
    } else {
      if(_dbRes['body']['code'] == 11000){
        _responseStatus = ResponsesStatus.failed;
        _responseBody=  {'status': 1, 'body': "name exixts"};
      } else {
        _responseStatus = ResponsesStatus.error;
        _responseBody=  {'status': 1, 'body': 'An error occured!'};
      }
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse();
  }

  @Operation.delete('cooperateId')
  Future<Response> delete(@Bind.path("cooperateId") String cooperateId)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.delete,
      metadata: {
        "cooperateId": cooperateId
      }
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();

    final Map<String, dynamic> _dbRes = await cooprateModel.remove(where.id(ObjectId.parse(cooperateId)));
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"status": 0, "body": "deleted successfully"};
      } else {
        _responseStatus = ResponsesStatus.failed;
        _responseBody=  {"status": 1, "body": "invalid id"};
      }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse();
  }


}

class CooprateFindByController extends ResourceController{
  CooprateModel cooprateModel = CooprateModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;


  @Operation.get('cooprateName')
  Future<Response> getByNameSelector(@Bind.path("cooprateName") String cooprateName)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
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
        _responseBody = {"status": 1, "body": "invalid id"};
      }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse();
  }
  @Operation.get('cooprateCode')
  Future<Response> getByCodeSelector(@Bind.path("cooprateCode") String cooprateCode)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
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
        _responseBody = {"status": 1, "body": "invalid id"};
      }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse();
  }
}