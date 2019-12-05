import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/token_model.dart';
import 'package:kite_bird/requests_managers/base_user_resquests.dart';
import 'package:kite_bird/requests_managers/cooperate_request.dart';
import 'package:pedantic/pedantic.dart';

class CooprateTokenController extends ResourceController{
  TokenModel tokenModel = TokenModel();
  static int duration = 300; // 300 seconds for 5 mins
  final int _validTill = (DateTime.now().millisecondsSinceEpoch/1000 + duration).floor();

  @Operation.get()
  Future<Response> getCooprateToken()async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.token,
      metadata: {
        "cooprateId": request.authorization.clientID
      }
    );
    _cooperateRequest.normalRequest();


    final String _collection = cooprateCollection;
    final String _ownerId = request.authorization.clientID;
    final TokenModel _tokenModel = TokenModel(
      collection: _collection,
      ownerId: _ownerId,
      validTill: _validTill,
    );

    final Map<String, dynamic> _dbRes = await _tokenModel.save();

    if(_dbRes['status'] == 0){
        return Response.ok({
          "status": 0,
          "body": {
            "token": _tokenModel.token,
            "validTill": _validTill,
          }
        });
    } else {
      return Response.badRequest(body: {"status": 1, "body": "an error occured."});
    }
    
  }  
    
}


class BaseUserTokenController extends ResourceController{
  TokenModel tokenModel = TokenModel();
  static int duration = 300; // 300 seconds for 5 mins
  final int _validTill = (DateTime.now().millisecondsSinceEpoch/1000 + duration).floor();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;

  @Operation.get()
  Future<Response> getBaseUserToken()async{
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: request.authorization != null ? request.authorization.clientID : null,
      baseUserRequestsType: BaseUserRequestsType.login,
      metadata: {
        "function": 'User login/ get token',
        "userId": request.authorization.clientID
      },
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();

    final String _collection = baseUserCollection;
    final String _ownerId = request.authorization.clientID;
    final TokenModel _tokenModel = TokenModel(
      collection: _collection,
      ownerId: _ownerId,
      validTill: _validTill,
    );

    final Map<String, dynamic> _dbRes = await _tokenModel.save();
    
    if(_dbRes['status'] == 0){
      _responseStatus = ResponsesStatus.success;
      _responseBody = {
          "status": 0,
          "body": {
            "token": _tokenModel.token,
            "validTill": _validTill,
          }
        };
    } else {
      _responseStatus = ResponsesStatus.failed;
      _responseBody = {"status": 1, "body": "an error occured."};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse(_responseBody);
  }
    
}

