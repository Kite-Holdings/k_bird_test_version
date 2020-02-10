import 'package:kite_bird/cooprates/models/cooprates_models.dart';
import 'package:kite_bird/cooprates/requests/cooprates_requests_manager.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';
import 'package:kite_bird/token/models/token_model.dart';

class CooprateTokenController extends ResourceController{
  final CooprateModel cooprateModel = CooprateModel();
  final TokenModel tokenModel = TokenModel();
  static int duration = 300; // 300 seconds for 5 mins
  final int _validTill = (DateTime.now().millisecondsSinceEpoch/1000 + duration).floor();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;

  @Operation.get()
  Future<Response> getCooprateToken()async{
    String _name;
    final Map<String, dynamic> _dbResUser = await cooprateModel.findById(request.authorization.clientID, fields: ['name']);
    if(_dbResUser['status'] == 0){
      _name  = _dbResUser['body']['name'].toString();
    }
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: _name,
      cooperateRequestsType: CooperateRequestsType.token,
      metadata: {
        "cooprateId": request.authorization.clientID
      }
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();

    const String _collection = cooprateCollection;
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
          
          "body": {
            "token": _tokenModel.token,
            "validTill": _validTill,
          }
        };
    } else {
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occured."};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);
    
  }  
    
}