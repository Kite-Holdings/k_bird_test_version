import 'package:kite_bird/base_user/models/base_user_models.dart';
import 'package:kite_bird/cooprates/models/cooprates_models.dart';
import 'package:kite_bird/cooprates/requests/cooprates_requests_manager.dart';
import 'package:kite_bird/cooprates/serializers/cooprates_serializers.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CooprateController extends ResourceController{
  CooprateModel cooprateModel = CooprateModel();
  final UserModel userModel = UserModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;


  @Operation.get()
  Future<Response> getAll()async{
    String _name;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _name  = _dbResUser['body']['email'].toString();
    }
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: _name,
      cooperateRequestsType: CooperateRequestsType.getAll,
      metadata: null
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();

    final Map<String, dynamic> _dbRes = await cooprateModel.find();
    if(_dbRes['status'] == 0){
      _responseStatus = ResponsesStatus.success;
      _responseBodyModel = {
        'body': _dbRes['status'] == 0 ? _dbRes['body'].length : _dbRes['body'],
      };
      _responseBody= _dbRes;
    } else{
      _responseStatus = ResponsesStatus.failed;
      _responseBody= {"body": "an error occured"};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);
  }

  @Operation.get('cooperateId')
  Future<Response> getOne(@Bind.path("cooperateId") String cooperateId)async{
    String _name;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _name  = _dbResUser['body']['email'].toString();
    }
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: _name,
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
      _responseBody= {"body": "an error occured"};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse();
  }

  @Operation.post()
  Future<Response> registerCompany(@Bind.body(require: ['name']) CoopratesSerializer coopratesSerializer)async{
    String _name;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _name  = _dbResUser['body']['email'].toString();
    }
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: _name,
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
        _responseStatus = ResponsesStatus.warning;
        _responseBody=  {'status': 1, 'body': "name exixts"};
      } else {
        _responseStatus = ResponsesStatus.error;
        _responseBody=  {'status': 1, 'body': 'An error occured!'};
      }
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse();
  }

  @Operation.delete('cooperateId')
  Future<Response> delete(@Bind.path("cooperateId") String cooperateId)async{
    String _name;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _name  = _dbResUser['body']['email'].toString();
    }
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: _name,
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
        _responseBody = {"body": "deleted successfully"};
      } else {
        _responseStatus = ResponsesStatus.failed;
        _responseBody=  {"body": "invalid id"};
      }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse();
  }


}